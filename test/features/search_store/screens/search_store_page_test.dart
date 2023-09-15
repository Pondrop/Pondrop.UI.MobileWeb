import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/features/search_store/search_store.dart';
import 'package:pondrop/features/search_store/widgets/search_store_list.dart';
import 'package:pondrop/features/search_store/widgets/search_store_list_item.dart';
import 'package:tuple/tuple.dart';

import '../../../fake_data/fake_data.dart';
import '../../../helpers/helpers.dart';

class MockLocationRepository extends Mock implements LocationRepository {}

class MockStoreRepository extends Mock implements StoreRepository {}

void main() {
  late LocationRepository locationRepository;
  late StoreRepository storeRepository;

  setUp(() {
    locationRepository = MockLocationRepository();
    storeRepository = MockStoreRepository();
  });

  group('Search Store', () {
    test('is routable', () {
      expect(SearchStorePage.route(), isA<MaterialPageRoute>());
    });

    testWidgets('renders a SearchStoresList', (tester) async {
      await tester.pumpApp(MultiRepositoryProvider(providers: [
        RepositoryProvider.value(value: storeRepository),
        RepositoryProvider.value(value: locationRepository),
      ], child: const SearchStorePage()));
      expect(find.byType(SearchStoreList), findsOneWidget);
    });

    testWidgets('renders a SearchStoreListItem', (tester) async {
      const query = 'Flutter';

      when(() => locationRepository.getCurrentPosition())
          .thenAnswer((invocation) => Future.value(null));
      when(() => locationRepository.getLastKnownPosition())
          .thenAnswer((_) => Future.value(null));
      when(() => storeRepository.fetchStores(query, 0, any())).thenAnswer(
          (_) => Future.value(Tuple2([FakeStore.fakeStore()], true)));

      await tester.pumpApp(MultiRepositoryProvider(providers: [
        RepositoryProvider.value(value: storeRepository),
        RepositoryProvider.value(value: locationRepository),
      ], child: const SearchStorePage()));

      await tester.enterText(
          find.byKey(SearchStorePage.searchTextFieldKey), query);
      await tester.pumpAndSettle();

      verify(() => storeRepository.fetchStores(query, 0, any())).called(1);

      expect(find.byType(SearchStoreList), findsOneWidget);
      expect(find.byType(SearchStoreListItem), findsOneWidget);
    });

    testWidgets('renders a Empty list', (tester) async {
      const query = 'Flutter';

      when(() => locationRepository.getCurrentPosition())
          .thenAnswer((_) => Future.value(null));
      when(() => locationRepository.getLastKnownPosition())
          .thenAnswer((_) => Future.value(null));
      when(() => storeRepository.fetchStores(query, 0, any()))
          .thenAnswer((_) => Future.value(const Tuple2([], false)));

      await tester.pumpApp(MultiRepositoryProvider(providers: [
        RepositoryProvider.value(value: storeRepository),
        RepositoryProvider.value(value: locationRepository),
      ], child: const SearchStorePage()));

      await tester.enterText(
          find.byKey(SearchStorePage.searchTextFieldKey), query);
      await tester.pumpAndSettle();

      verify(() => storeRepository.fetchStores(query, 0, any())).called(1);

      expect(find.byType(SearchStoreList), findsOneWidget);
      expect(find.byType(NoResultsFound), findsOneWidget);
    });
  });
}
