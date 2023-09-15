import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pondrop/features/search_items/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:tuple/tuple.dart';

part '../../search_items/bloc/search_items_event.dart';
part '../../search_items/bloc/search_items_state.dart';

const throttleDuration = Duration(milliseconds: 300);

EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class SearchItemsBloc extends Bloc<SearchItemsEvent, SearchItemsState> {
  SearchItemsBloc({
    required ProductRepository productRepository,
    required SearchItemType type,
    this.minQueryLength = 3,
  })
      : _productRepository = productRepository,
        super(SearchItemsState(type: type)) {
    on<SearchFetched>(_onFetched);
    on<SearchRefreshed>(_onRefresh);
    on<SearchTextChanged>(_onSearch, transformer: debounce(throttleDuration));

    add(const SearchRefreshed());
  }

  final int minQueryLength;

  final ProductRepository _productRepository;

  Future<void> _onFetched(
    SearchFetched event,
    Emitter<SearchItemsState> emit,
  ) async {
    if (state.query.length < minQueryLength || state.hasReachedMax || state.status == SearchStatus.loading) {
      return;
    }

    try {
      emit(state.copyWith(status: SearchStatus.loading));

      final items = await fetchItems(state.query, 0);

      emit(
        state.copyWith(
          status: SearchStatus.success,
          items: List.of(state.items)..addAll(items.item1),
          hasReachedMax: !items.item2,
        ),
      );
    } catch (ex) {
      log(ex.toString());
      emit(state.copyWith(status: SearchStatus.failure));
    }
  }

  Future<void> _onRefresh(
    SearchRefreshed event,
    Emitter<SearchItemsState> emit,
  ) async {
    if (state.query.length < minQueryLength || state.status == SearchStatus.loading) {
      return;
    }

    emit(state.copyWith(status: SearchStatus.loading));

    try {
      final items = await fetchItems(state.query, 0);

      emit(
        state.copyWith(
          status: SearchStatus.success,
          items: items.item1,
          hasReachedMax: !items.item2,
        ),
      );
    } catch (ex) {
      log(ex.toString());
      emit(state.copyWith(status: SearchStatus.failure));
    }
  }

  Future<void> _onSearch(
      SearchTextChanged event, Emitter<SearchItemsState> emit) async {
    emit(SearchItemsState(type: state.type).copyWith(query: event.text));

    if (state.query.length < minQueryLength) {
      return;
    }

    add(const SearchRefreshed());
  }

  Future<Tuple2<List<SearchItem>, bool>> fetchItems(String query, int skipIdx) async {
    switch (state.type) {
      case SearchItemType.category:
        final categories = await _productRepository.fetchCategories(query, skipIdx);
        return Tuple2(categories.item1.map((e) => SearchItem(id: e.id, title: e.name, iconData: Icons.category_outlined)).toList(), categories.item2);
      case SearchItemType.product:
        final products = await _productRepository.fetchProducts(query, skipIdx);
        return Tuple2(products.item1.map((e) => SearchItem(id: e.id, title: e.name, subtitle: e.barcode, barcode: e.barcode)).toList(), products.item2);
    }
  }
}
