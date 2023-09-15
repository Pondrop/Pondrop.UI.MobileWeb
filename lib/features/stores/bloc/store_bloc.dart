import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';

part 'store_event.dart';
part 'store_state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  StoreBloc(
      {required StoreRepository storeRepository,
      required SubmissionRepository submissionRepository,
      required LocationRepository locationRepository})
      : _storeRepository = storeRepository,
        _submissionRepository = submissionRepository,
        _locationRepository = locationRepository,
        super(const StoreState()) {
    on<StoreFetched>(_onStoreFetched);
    on<StoreRefreshed>(_onStoreRefresh);
    on<StoreCompletedTasks>(_onStoreCompletedTasks);
    on<StoreCampaignCountsRefreshed>(_onStoreCampaignCountsRefresh);
  }

  final StoreRepository _storeRepository;
  final SubmissionRepository _submissionRepository;
  final LocationRepository _locationRepository;

  Future<void> _onStoreFetched(
    StoreFetched event,
    Emitter<StoreState> emit,
  ) async {
    if (state.hasReachedMax || state.status == StoreStatus.loading) {
      return;
    }

    try {
      emit(state.copyWith(status: StoreStatus.loading));

      final position = state.stores.isEmpty
          ? await _locationRepository.getCurrentPosition() ??
              await _locationRepository.getLastKnownPosition()
          : state.position;
      final storesResult =
          await _storeRepository.fetchStores('', state.stores.length, position);

      emit(
        state.copyWith(
          status: StoreStatus.success,
          stores: List.of(state.stores)..addAll(storesResult.item1),
          position: position,
          hasReachedMax: !storesResult.item2,
        ),
      );

      final storeIds = storesResult.item1.map((i) => i.id).toList();
      add(StoreCampaignCountsRefreshed(storeIds: storeIds));
    } catch (ex) {
      log(ex.toString());
      emit(state.copyWith(status: StoreStatus.failure));
    }
  }

  Future<void> _onStoreRefresh(
    StoreRefreshed event,
    Emitter<StoreState> emit,
  ) async {
    if (state.status == StoreStatus.loading) {
      return;
    }

    emit(state.copyWith(status: StoreStatus.loading));

    try {
      final position = await _locationRepository.getCurrentPosition() ??
          await _locationRepository.getLastKnownPosition();

      final fetchStores = _storeRepository.fetchStores('', 0, position);
      final fetchCommunityStores =
          _storeRepository.fetchCommunityStores('', 0, position, top: 1);

      await Future.wait([fetchStores, fetchCommunityStores]);

      final storesResult = await fetchStores;
      final communityStoresResult = await fetchCommunityStores;

      emit(
        state.copyWith(
            status: StoreStatus.success,
            stores: storesResult.item1,
            position: position,
            hasReachedMax: !storesResult.item2,
            communityStore: communityStoresResult.item1.firstOrNull),
      );

      final storeIds = storesResult.item1.map((i) => i.id).toList();
      add(StoreCampaignCountsRefreshed(storeIds: storeIds));
    } catch (ex) {
      log(ex.toString());
      emit(state.copyWith(status: StoreStatus.failure));
    }
  }

  Future<void> _onStoreCompletedTasks(
    StoreCompletedTasks event,
    Emitter<StoreState> emit,
  ) async {
    if (event.completedTasks.isEmpty) return;

    try {
      final stores = List.of(state.stores);
      final submissionMap =
          groupBy(event.completedTasks, (TaskIdentifier i) => i.storeId);

      for (final i in submissionMap.entries) {
        final idx = stores.indexWhere((e) => e.id == i.key);
        if (idx >= 0) {
          stores[idx] = stores[idx].copyWith(
            categoryCampaigns: List.of(stores[idx].categoryCampaigns)
              ..removeWhere((e) => i.value.contains(e)),
            productCampaigns: List.of(stores[idx].productCampaigns)
              ..removeWhere((e) => i.value.contains(e)),
          );
        }
      }

      emit(state.copyWith(stores: stores));
    } catch (ex) {
      log(ex.toString());
    }
  }

  Future<void> _onStoreCampaignCountsRefresh(
    StoreCampaignCountsRefreshed event,
    Emitter<StoreState> emit,
  ) async {
    if (event.storeIds.isEmpty) return;

    try {
      final categoryCampaignsTask =
          _submissionRepository.fetchCategoryCampaigns(event.storeIds);
      final productCampaignsTask =
          _submissionRepository.fetchProductCampaigns(event.storeIds);

      await Future.wait([categoryCampaignsTask, productCampaignsTask]);

      final categoryCounts = groupBy(
          (await categoryCampaignsTask)
              .map((e) => TaskIdentifier.fromCampaignDto(e)),
          (TaskIdentifier i) => i.storeId);
      final productCounts = groupBy(
          (await productCampaignsTask)
              .map((e) => TaskIdentifier.fromCampaignDto(e)),
          (TaskIdentifier i) => i.storeId);

      final stores = List.of(state.stores);

      for (final s
          in state.stores.where((i) => event.storeIds.contains(i.id))) {
        final idx = stores.indexOf(s);
        stores[idx] = stores[idx].copyWith(
          categoryCampaigns: categoryCounts[s.id] ?? const [],
          productCampaigns: productCounts[s.id] ?? const [],
        );
      }

      emit(
        state.copyWith(
          stores: stores,
          campaignCountsRefreshedMs: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    } catch (ex) {
      log(ex.toString());
    }
  }
}
