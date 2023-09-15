import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/features/search_store/bloc/search_store_bloc.dart';
import 'package:tuple/tuple.dart';

import '../../../fake_data/fake_store.dart';

class MockLocationRepository extends Mock implements LocationRepository {}

class MockStoreRepository extends Mock implements StoreRepository {}

void main() {
  late LocationRepository locationRepository;
  late StoreRepository storeRepository;

  setUp(() {
    locationRepository = MockLocationRepository();
    storeRepository = MockStoreRepository();
  });

  group('SearchStoreBloc', () {
    test('initial state is Initial', () {
      expect(
          SearchStoreBloc(
            storeRepository: storeRepository,
            locationRepository: locationRepository,
          ).state,
          equals(const SearchStoreState()));
    });

    test('emit empty when Search Text is empty', () async {
      final bloc = SearchStoreBloc(
        storeRepository: storeRepository,
        locationRepository: locationRepository,
      );

      bloc.add(const TextChanged(text: ''));

      await bloc.stream.first;

      expect(bloc.state, equals(const SearchStoreState()));
    });

    test('emit stores when Search Text is changed', () async {
      const query = 'search term';
      final stores = [FakeStore.fakeStore()];

      when(() => locationRepository.getCurrentPosition())
          .thenAnswer((invocation) => Future.value(null));
      when(() => locationRepository.getLastKnownPosition())
          .thenAnswer((_) => Future.value(null));
      when(() => storeRepository.fetchStores(any(), any(), any()))
          .thenAnswer((invocation) => Future.value(Tuple2(stores, true)));

      final bloc = SearchStoreBloc(
        storeRepository: storeRepository,
        locationRepository: locationRepository,
      );

      bloc.add(const TextChanged(text: query));

      await bloc.stream.first;

      expect(bloc.state.query, query);
      expect(bloc.state.status, SearchStoreStatus.success);
      expect(bloc.state.stores, stores);
    });

    test('emit error when Search Text is throws', () async {
      const query = 'search term';

      when(() => locationRepository.getLastKnownOrCurrentPosition())
          .thenThrow(Exception());

      final bloc = SearchStoreBloc(
        storeRepository: storeRepository,
        locationRepository: locationRepository,
      );

      bloc.add(const TextChanged(text: query));

      await bloc.stream.first;

      expect(bloc.state.status, SearchStoreStatus.failure);
    });
  });
}
