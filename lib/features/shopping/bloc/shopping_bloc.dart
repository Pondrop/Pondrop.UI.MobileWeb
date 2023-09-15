import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';

part 'shopping_event.dart';
part 'shopping_state.dart';

class ShoppingBloc extends Bloc<ShoppingEvent, ShoppingState> {
  ShoppingBloc(
      {required ShoppingRepository shoppingRepository,
      required ProductRepository productRepository,
      required StoreRepository storeRepository,
      required LocationRepository locationRepository})
      : _shoppingRepository = shoppingRepository,
        _productRepository = productRepository,
        _storeRepository = storeRepository,
        _locationRepository = locationRepository,
        super(const ShoppingState()) {
    on<ListRefreshed>(_onListRefreshed);
    on<ListCreated>(_onListCreated);
    on<ListUpdated>(_onListUpdated);
    on<ListDeleted>(_onListDeleted);
    on<ListReordered>(_onListReordered);
  }

  final ShoppingRepository _shoppingRepository;
  final ProductRepository _productRepository;
  final StoreRepository _storeRepository;
  final LocationRepository _locationRepository;

  Future<void> _onListRefreshed(
    ListRefreshed event,
    Emitter<ShoppingState> emit,
  ) async {
    if (state.status == ShoppingStatus.loading) {
      return;
    }

    emit(state.copyWith(
        status: ShoppingStatus.loading, action: ShoppingAction.refresh));

    try {
      final lists = await _shoppingRepository.fetchLists();
      emit(state.copyWith(lists: lists, status: ShoppingStatus.success));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(
          status: ShoppingStatus.failure, action: ShoppingAction.refresh));
    }
  }

  Future<void> _onListCreated(
    ListCreated event,
    Emitter<ShoppingState> emit,
  ) async {
    if (state.status == ShoppingStatus.loading || event.name.isEmpty) {
      return;
    }

    emit(state.copyWith(
        status: ShoppingStatus.loading, action: ShoppingAction.create));

    try {
      final newList =
          await _shoppingRepository.createList(event.name, event.sortOrder);

      if (newList != null) {
        final newLists = List<ShoppingList>.from(state.lists)
          ..insert(event.sortOrder, newList);

        for (var i = 0; i < newLists.length; i++) {
          newLists[i] = newLists[i].copyWith(sortOrder: i);
        }

        await _shoppingRepository.updateLists(newLists);
        emit(state.copyWith(lists: newLists, status: ShoppingStatus.success));
      } else {
        emit(state.copyWith(
            status: ShoppingStatus.failure, action: ShoppingAction.create));
      }
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(
          status: ShoppingStatus.failure, action: ShoppingAction.create));
    }
  }

  Future<void> _onListUpdated(
    ListUpdated event,
    Emitter<ShoppingState> emit,
  ) async {
    if (event.list.id.isEmpty) {
      return;
    }

    try {
      final idx = state.lists.indexWhere((e) => e.id == event.list.id);
      if (idx >= 0) {
        emit(state.copyWith(
            lists: (List<ShoppingList>.from(state.lists)..[idx] = event.list)));
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _onListDeleted(
    ListDeleted event,
    Emitter<ShoppingState> emit,
  ) async {
    if (event.id.isEmpty) {
      return;
    }

    var success = false;

    final idx = state.lists.indexWhere((e) => e.id == event.id);

    if (idx >= 0) {
      final orig = List<ShoppingList>.from(state.lists);

      final list = orig[idx];
      final newLists = List<ShoppingList>.from(state.lists)..removeAt(idx);

      try {
        emit(state.copyWith(lists: newLists, status: ShoppingStatus.success));
        success = await _shoppingRepository.deleteList(list.id, list.shopperId);
      } catch (e) {
        log(e.toString());
      }

      if (!success) {
        emit(state.copyWith(
            lists: orig,
            status: ShoppingStatus.failure,
            action: ShoppingAction.delete));
      }
    }
  }

  Future<void> _onListReordered(
    ListReordered event,
    Emitter<ShoppingState> emit,
  ) async {
    final orig = List<ShoppingList>.from(state.lists);

    final newLists = List<ShoppingList>.from(state.lists);
    final list = newLists.removeAt(event.oldIdx);
    newLists.insert(
        event.newIdx > event.oldIdx ? event.newIdx - 1 : event.newIdx, list);

    for (var i = 0; i < newLists.length; i++) {
      final l = newLists[i];
      newLists[i] = l.copyWith(sortOrder: i);
    }

    var success = false;

    try {
      emit(state.copyWith(lists: newLists, status: ShoppingStatus.success));
      final toUpdate = List<ShoppingList>.from(newLists);
      toUpdate.removeWhere((e) => orig.contains(e));
      success = await _shoppingRepository.updateLists(toUpdate);
    } catch (e) {
      log(e.toString());
    }

    if (!success) {
      emit(state.copyWith(
          lists: orig,
          status: ShoppingStatus.failure,
          action: ShoppingAction.reorder));
    }
  }
}
