import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/api/submissions/models/models.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/features/stores/bloc/store_bloc.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

import '../../../fake_data/fake_data.dart';

class MockLocationRepository extends Mock implements LocationRepository {}

class MockStoreRepository extends Mock implements StoreRepository {}

class MockSubmissionRepository extends Mock implements SubmissionRepository {}

void main() {
  late LocationRepository locationRepository;
  late StoreRepository storeRepository;
  late SubmissionRepository submissionRepository;

  setUp(() {
    locationRepository = MockLocationRepository();
    storeRepository = MockStoreRepository();
    submissionRepository = MockSubmissionRepository();
  });

  group('StoreBloc', () {
    test('initial state is Initial', () {
      expect(
          StoreBloc(
            storeRepository: storeRepository,
            submissionRepository: submissionRepository,
            locationRepository: locationRepository,
          ).state,
          equals(const StoreState()));
    });

    test('emit stores when StoreFetched', () async {
      final stores = [FakeStore.fakeStore()];

      when(() => locationRepository.getCurrentPosition())
          .thenAnswer((invocation) => Future.value(null));
      when(() => locationRepository.getLastKnownPosition())
          .thenAnswer((_) => Future.value(null));
      when(() => storeRepository.fetchStores(any(), any(), any()))
          .thenAnswer((invocation) => Future.value(Tuple2(stores, true)));

      final bloc = StoreBloc(
        storeRepository: storeRepository,
        submissionRepository: submissionRepository,
        locationRepository: locationRepository,
      );

      bloc.add(const StoreFetched());

      await bloc.stream.firstWhere((e) => e.status != StoreStatus.loading);

      expect(bloc.state.status, StoreStatus.success);
      expect(bloc.state.stores, stores);
      expect(bloc.state.hasReachedMax, false);
    });

    test('emit stores when StoreFetched set hasReachedMax', () async {
      final stores = [FakeStore.fakeStore()];

      when(() => locationRepository.getCurrentPosition())
          .thenAnswer((invocation) => Future.value(null));
      when(() => locationRepository.getLastKnownPosition())
          .thenAnswer((_) => Future.value(null));
      when(() => storeRepository.fetchStores(any(), any(), any()))
          .thenAnswer((invocation) => Future.value(Tuple2(stores, true)));

      final bloc = StoreBloc(
        storeRepository: storeRepository,
        submissionRepository: submissionRepository,
        locationRepository: locationRepository,
      );

      bloc.add(const StoreFetched());
      await bloc.stream.firstWhere((e) => e.status != StoreStatus.loading);

      when(() => storeRepository.fetchStores(any(), any(), any()))
          .thenAnswer((invocation) => Future.value(const Tuple2([], false)));

      bloc.add(const StoreFetched());
      await bloc.stream.firstWhere((e) => e.status != StoreStatus.loading);

      verify(() => storeRepository.fetchStores(any(), any(), any())).called(2);

      expect(bloc.state.status, StoreStatus.success);
      expect(bloc.state.stores, stores);
      expect(bloc.state.hasReachedMax, true);
    });

    test('emit failure when StoreFetched throws', () async {
      final stores = [FakeStore.fakeStore()];

      when(() => locationRepository.getLastKnownOrCurrentPosition(any()))
          .thenAnswer((invocation) => Future<Position?>.value(null));
      when(() => storeRepository.fetchStores(any(), any(), any()))
          .thenThrow(Exception());

      final bloc = StoreBloc(
        storeRepository: storeRepository,
        submissionRepository: submissionRepository,
        locationRepository: locationRepository,
      );

      bloc.add(const StoreFetched());
      await bloc.stream.firstWhere((e) => e.status != StoreStatus.loading);

      expect(bloc.state.status, StoreStatus.failure);
    });

    test('emit stores when StoreRefreshed', () async {
      final stores = [FakeStore.fakeStore()];

      when(() => locationRepository.getCurrentPosition())
          .thenAnswer((invocation) => Future.value(null));
      when(() => locationRepository.getLastKnownPosition())
          .thenAnswer((_) => Future.value(null));
      when(() => storeRepository.fetchStores(any(), any(), any()))
          .thenAnswer((invocation) => Future.value(Tuple2(stores, true)));
      when(() =>
              storeRepository.fetchCommunityStores(any(), any(), any(), top: 1))
          .thenAnswer((invocation) => Future.value(const Tuple2([], true)));

      final bloc = StoreBloc(
        storeRepository: storeRepository,
        submissionRepository: submissionRepository,
        locationRepository: locationRepository,
      );

      bloc.add(const StoreRefreshed());
      await bloc.stream.firstWhere((e) => e.status != StoreStatus.loading);

      expect(bloc.state.status, StoreStatus.success);
      expect(bloc.state.stores, stores);
      expect(bloc.state.hasReachedMax, false);
    });

    test('emit failure when StoreRefreshed throws', () async {
      when(() => locationRepository.getLastKnownOrCurrentPosition(any()))
          .thenAnswer((invocation) => Future<Position?>.value(null));
      when(() => storeRepository.fetchStores(any(), any(), any()))
          .thenThrow(Exception());

      final bloc = StoreBloc(
        storeRepository: storeRepository,
        submissionRepository: submissionRepository,
        locationRepository: locationRepository,
      );

      bloc.add(const StoreRefreshed());
      await bloc.stream.firstWhere((e) => e.status != StoreStatus.loading);

      expect(bloc.state.status, StoreStatus.failure);
    });

    test('emit stores with task counts', () async {
      final stores = [FakeStore.fakeStore()];
      final storeIds = stores.map((e) => e.id).toList();
      final categoryCampaigns = FakeCampaign.fakeCategoryCampaignDtos(
              storeId: storeIds.first, length: 1)
          .whereType<CategoryCampaignDto>()
          .toList();
      final productCampaigns = FakeCampaign.fakeProductCampaignDtos(
              storeId: storeIds.first, length: 1)
          .whereType<ProductCampaignDto>()
          .toList();

      when(() => locationRepository.getCurrentPosition())
          .thenAnswer((invocation) => Future.value(null));
      when(() => locationRepository.getLastKnownPosition())
          .thenAnswer((_) => Future.value(null));
      when(() => storeRepository.fetchStores(any(), any(), any()))
          .thenAnswer((invocation) => Future.value(Tuple2(stores, true)));
      when(() =>
              storeRepository.fetchCommunityStores(any(), any(), any(), top: 1))
          .thenAnswer((invocation) => Future.value(const Tuple2([], true)));
      when(() => submissionRepository.fetchCategoryCampaigns(storeIds))
          .thenAnswer((invocation) => Future.value(categoryCampaigns));
      when(() => submissionRepository.fetchProductCampaigns(storeIds))
          .thenAnswer((invocation) => Future.value(productCampaigns));

      final bloc = StoreBloc(
        storeRepository: storeRepository,
        submissionRepository: submissionRepository,
        locationRepository: locationRepository,
      );

      bloc.add(const StoreRefreshed());

      final nowMs = DateTime.now().millisecondsSinceEpoch;
      await bloc.stream.firstWhere((e) => e.campaignCountsRefreshedMs > nowMs);

      expect(bloc.state.stores.first.categoryCampaigns.length, 1);
      expect(bloc.state.stores.first.productCampaigns.length, 1);
      expect(bloc.state.stores.first.campaignCount, 2);
    });

    test('reduce campaign task count', () async {
      final stores = [FakeStore.fakeStore()];
      final storeIds = stores.map((e) => e.id).toList();
      final categoryCampaigns = FakeCampaign.fakeCategoryCampaignDtos(
              storeId: storeIds.first, length: 1)
          .whereType<CategoryCampaignDto>()
          .toList();
      final productCampaigns = FakeCampaign.fakeProductCampaignDtos(
              storeId: storeIds.first, length: 1)
          .whereType<ProductCampaignDto>()
          .toList();

      when(() => locationRepository.getCurrentPosition())
          .thenAnswer((invocation) => Future.value(null));
      when(() => locationRepository.getLastKnownPosition())
          .thenAnswer((_) => Future.value(null));
      when(() => storeRepository.fetchStores(any(), any(), any()))
          .thenAnswer((invocation) => Future.value(Tuple2(stores, true)));
      when(() =>
              storeRepository.fetchCommunityStores(any(), any(), any(), top: 1))
          .thenAnswer((invocation) => Future.value(const Tuple2([], true)));
      when(() => submissionRepository.fetchCategoryCampaigns(storeIds))
          .thenAnswer((invocation) => Future.value(categoryCampaigns));
      when(() => submissionRepository.fetchProductCampaigns(storeIds))
          .thenAnswer((invocation) => Future.value(productCampaigns));

      final bloc = StoreBloc(
        storeRepository: storeRepository,
        submissionRepository: submissionRepository,
        locationRepository: locationRepository,
      );

      bloc.add(const StoreRefreshed());

      final nowMs = DateTime.now().millisecondsSinceEpoch;
      await bloc.stream.firstWhere((e) => e.campaignCountsRefreshedMs > nowMs);

      final taskIdentifiers = [
        TaskIdentifier.fromCampaignDto(categoryCampaigns.first),
        TaskIdentifier(templateId: const Uuid().v4(), storeId: storeIds.first),
      ];

      bloc.add(StoreCompletedTasks(completedTasks: taskIdentifiers));
      await bloc.stream.first;

      expect(bloc.state.stores.first.categoryCampaigns.length, 0);
      expect(bloc.state.stores.first.productCampaigns.length, 1);
      expect(bloc.state.stores.first.campaignCount, 1);
    });
  });
}
