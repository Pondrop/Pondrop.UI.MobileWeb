import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/features/search_items/search_items.dart';
import 'package:pondrop/features/search_items/widgets/search_list_item.dart';
import 'package:tuple/tuple.dart';

import '../../../fake_data/fake_data.dart';
import '../../../helpers/helpers.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late ProductRepository productRepository;

  setUp(() {
    productRepository = MockProductRepository();
  });

  group('Search Product', () {
    test('is routable', () {
      expect(SearchItemPage.route(type: SearchItemType.product), isA<PageRoute>());
    });

    testWidgets('renders a SearchProductList', (tester) async {
      await tester.pumpApp(MultiRepositoryProvider(providers: [
        RepositoryProvider.value(value: productRepository),
      ], child: const SearchItemPage(type: SearchItemType.product, enableBack: false)));
      expect(find.byType(SearchItemsList), findsOneWidget);
    });

    testWidgets('renders a SearchProductListItem', (tester) async {
      const query = 'Flutter';

      when(() => productRepository.fetchProducts(query, 0))
          .thenAnswer((_) => Future.value(Tuple2([FakeProduct.fakeProduct()], true)));
      
      await tester.pumpApp(MultiRepositoryProvider(providers: [
        RepositoryProvider.value(value: productRepository),
      ], child: const SearchItemPage(type: SearchItemType.product, enableBack: false)));

      await tester.enterText(find.byKey(SearchItemPage.searchTextFieldKey), query);
      await tester.pump(const Duration(milliseconds: 350));

      verify(() => productRepository.fetchProducts(query, 0)).called(1);

      expect(find.byType(SearchItemsList), findsOneWidget);
      expect(find.byType(SearchListItem), findsOneWidget);
    });

    testWidgets('renders a SearchCategoryListItem', (tester) async {
      const query = 'Flutter';

      when(() => productRepository.fetchCategories(query, 0))
          .thenAnswer((_) => Future.value(Tuple2([FakeCategory.fakeCategory()], true)));
      
      await tester.pumpApp(MultiRepositoryProvider(providers: [
        RepositoryProvider.value(value: productRepository),
      ], child: const SearchItemPage(type: SearchItemType.category, enableBack: false)));

      await tester.enterText(find.byKey(SearchItemPage.searchTextFieldKey), query);
      await tester.pump(const Duration(milliseconds: 350));

      verify(() => productRepository.fetchCategories(query, 0)).called(1);

      expect(find.byType(SearchItemsList), findsOneWidget);
      expect(find.byType(SearchListItem), findsOneWidget);
      expect(find.byIcon(Icons.category_outlined), findsOneWidget);
    });

    testWidgets('renders a Empty list', (tester) async {
      const query = 'Flutter';

      when(() => productRepository.fetchProducts(query, 0))
          .thenAnswer((_) => Future.value(const Tuple2([], false)));
      
      await tester.pumpApp(MultiRepositoryProvider(providers: [
        RepositoryProvider.value(value: productRepository),
      ], child: const SearchItemPage(type: SearchItemType.product, enableBack: false)));

      await tester.enterText(find.byKey(SearchItemPage.searchTextFieldKey), query);
      await tester.pump(const Duration(milliseconds: 350));

      verify(() => productRepository.fetchProducts(query, 0)).called(1);

      expect(find.byType(SearchItemsList), findsOneWidget);
      expect(find.byType(NoResultsFound), findsOneWidget);
    });
  });
}
