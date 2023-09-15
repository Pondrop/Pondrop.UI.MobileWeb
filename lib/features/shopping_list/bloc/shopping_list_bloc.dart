import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:stream_transform/stream_transform.dart';

part 'shopping_list_event.dart';
part 'shopping_list_state.dart';

const throttleDuration = Duration(milliseconds: 300);

EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class ShoppingListBloc extends Bloc<ShoppingListEvent, ShoppingListState> {
  ShoppingListBloc({
    required ShoppingList list,
    required ShoppingRepository shoppingRepository,
    required ProductRepository productRepository,
    required StoreRepository storeRepository,
    required LocationRepository locationRepository,
    this.minQueryLength = 3,
  })  : _shoppingRepository = shoppingRepository,
        _productRepository = productRepository,
        _storeRepository = storeRepository,
        _locationRepository = locationRepository,
        super(ShoppingListState(list: list, items: list.items)) {
    on<ItemRefreshed>(_onItemRefreshed);
    on<ItemAdded>(_onItemAdded);
    on<ItemDeleted>(_onItemDeleted);
    on<ItemChecked>(_onItemChecked);
    on<ItemReordered>(_onItemReordered);
    on<ItemCategorySearchTextChanged>(_onItemCategorySearchTextChanged,
        transformer: debounce(throttleDuration));
  }

  final int minQueryLength;

  final ShoppingRepository _shoppingRepository;
  final ProductRepository _productRepository;
  final StoreRepository _storeRepository;
  final LocationRepository _locationRepository;

  Future<void> _onItemRefreshed(
    ItemRefreshed event,
    Emitter<ShoppingListState> emit,
  ) async {
    if (state.status == ShoppingListStatus.loading) {
      return;
    }

    emit(state.copyWith(
        status: ShoppingListStatus.loading,
        action: ShoppingListAction.refresh));

    try {
      final items = await _shoppingRepository.fetchListItems(state.list.id);
      emit(state.copyWith(items: items, status: ShoppingListStatus.success));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(
          status: ShoppingListStatus.failure,
          action: ShoppingListAction.refresh));
    }
  }

  Future<void> _onItemAdded(
    ItemAdded event,
    Emitter<ShoppingListState> emit,
  ) async {
    if (state.status == ShoppingListStatus.loading ||
        event.categoryId.isEmpty ||
        event.name.isEmpty) {
      return;
    }

    emit(state.copyWith(
        status: ShoppingListStatus.loading, action: ShoppingListAction.create));

    try {
      final newItem = await _shoppingRepository.addItemToList(
          state.list.id, event.categoryId, event.name, event.sortOrder);

      if (newItem != null) {
        emit(state.copyWith(
            items: List<ShoppingListItem>.of(state.items)..insert(0, newItem),
            status: ShoppingListStatus.success));
      } else {
        emit(state.copyWith(
            status: ShoppingListStatus.failure,
            action: ShoppingListAction.create));
      }
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(
          status: ShoppingListStatus.failure,
          action: ShoppingListAction.create));
    }
  }

  Future<void> _onItemDeleted(
    ItemDeleted event,
    Emitter<ShoppingListState> emit,
  ) async {
    if (event.id.isEmpty) {
      return;
    }

    var success = false;

    final idx = state.items.indexWhere((e) => e.id == event.id);

    if (idx >= 0) {
      final orig = List<ShoppingListItem>.from(state.items);

      final newItems = List<ShoppingListItem>.from(state.items)
        ..removeWhere((e) => e.id == event.id);

      try {
        emit(state.copyWith(
            items: newItems, status: ShoppingListStatus.success));
        success =
            await _shoppingRepository.deleteListItem(state.list.id, event.id);
      } catch (e) {
        log(e.toString());
      }

      if (!success) {
        emit(state.copyWith(
            items: orig,
            status: ShoppingListStatus.failure,
            action: ShoppingListAction.delete));
      }
    }
  }

  Future<void> _onItemChecked(
    ItemChecked event,
    Emitter<ShoppingListState> emit,
  ) async {
    if (event.id.isEmpty) {
      return;
    }

    var success = false;

    final idx = state.items.indexWhere((e) => e.id == event.id);

    if (idx >= 0) {
      final orig = List<ShoppingListItem>.from(state.items);

      final item = state.items[idx].copyWith(checked: event.checked);
      final newItems = List<ShoppingListItem>.from(state.items)
        ..replaceRange(idx, idx + 1, [item]);

      try {
        emit(state.copyWith(
            items: newItems, status: ShoppingListStatus.success));
        success =
            await _shoppingRepository.updateListItems(state.list.id, [item]);
      } catch (e) {
        log(e.toString());
      }

      if (!success) {
        emit(state.copyWith(
            items: orig,
            status: ShoppingListStatus.failure,
            action: ShoppingListAction.checked));
      }
    }
  }

  Future<void> _onItemReordered(
    ItemReordered event,
    Emitter<ShoppingListState> emit,
  ) async {
    final orig = List<ShoppingListItem>.from(state.items);

    final newItems = List<ShoppingListItem>.from(state.items);
    final list = newItems.removeAt(event.oldIdx);
    newItems.insert(
        event.newIdx > event.oldIdx ? event.newIdx - 1 : event.newIdx, list);

    for (var i = 0; i < newItems.length; i++) {
      final l = newItems[i];
      newItems[i] = l.copyWith(sortOrder: i);
    }

    var success = false;

    try {
      emit(state.copyWith(items: newItems, status: ShoppingListStatus.success));
      final toUpdate = List<ShoppingListItem>.from(newItems);
      toUpdate.removeWhere((e) => orig.contains(e));
      success =
          await _shoppingRepository.updateListItems(state.list.id, toUpdate);
    } catch (e) {
      log(e.toString());
    }

    if (!success) {
      emit(state.copyWith(
          items: orig,
          status: ShoppingListStatus.failure,
          action: ShoppingListAction.reorder));
    }
  }

  Future<void> _onItemCategorySearchTextChanged(
      ItemCategorySearchTextChanged event,
      Emitter<ShoppingListState> emit) async {
    emit(state.copyWith(categorySearchText: event.text));

    if (event.text.length < minQueryLength) {
      emit(state.copyWith(
          status: ShoppingListStatus.success, categoriesFiltered: const []));
    }

    if (event.text.length < minQueryLength ||
        state.status == ShoppingListStatus.loading) {
      return;
    }

    emit(state.copyWith(
        status: ShoppingListStatus.loading,
        action: ShoppingListAction.categorySearch));

    try {
      final categories =
          await _productRepository.fetchCategories(event.text, 0);

      emit(
        state.copyWith(
          status: ShoppingListStatus.success,
          categoriesFiltered: categories.item1,
        ),
      );
    } catch (ex) {
      log(ex.toString());
      emit(state.copyWith(
          status: ShoppingListStatus.failure,
          action: ShoppingListAction.categorySearch,
          categoriesFiltered: const []));
    }
  }
}
