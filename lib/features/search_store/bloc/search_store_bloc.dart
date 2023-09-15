import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:stream_transform/stream_transform.dart';

part 'search_store_event.dart';
part 'search_store_state.dart';

class SearchStoreBloc extends Bloc<SearchStoreEvent, SearchStoreState> {
  SearchStoreBloc(
      {required StoreRepository storeRepository,
      required LocationRepository locationRepository})
      : _storeService = storeRepository,
        _locationRepository = locationRepository,
        super(const SearchStoreState()) {
    on<TextChanged>(_onSearchStore,
        transformer: _debounce(const Duration(milliseconds: 300)));
  }

  final StoreRepository _storeService;
  final LocationRepository _locationRepository;

  Future<void> _onSearchStore(
      TextChanged event, Emitter<SearchStoreState> emit) async {
    final searchTerm = event.text;

    if (searchTerm.isEmpty) {
      emit(const SearchStoreState());
      return;
    }

    try {
      final position = await _locationRepository.getCurrentPosition() ??
          await _locationRepository.getLastKnownPosition();
      final stores = await _storeService.fetchStores(searchTerm, 0, position);

      emit(
        state.copyWith(
          status: SearchStoreStatus.success,
          query: searchTerm,
          stores: stores.item1,
          position: position,
        ),
      );
    } catch (ex) {
      emit(state.copyWith(status: SearchStoreStatus.failure));
    }
  }
}

EventTransformer<Event> _debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}
