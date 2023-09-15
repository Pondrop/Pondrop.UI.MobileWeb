import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/features/search_items/search_items.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/features/search_items/bloc/search_items_bloc.dart';
import 'package:tuple/tuple.dart';

import '../../../fake_data/fake_data.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late ProductRepository productRepository;

  setUp(() {
    productRepository = MockProductRepository();
  });

  group('SearchProductBloc', () {
    test('initial state is Initial', () {
      expect(
          SearchItemsBloc(
            type: SearchItemType.category,
            productRepository: productRepository,
          ).state,
          equals(const SearchItemsState(type: SearchItemType.category)));
    });

    test('emit products when Fetched', () async {
      final products = [FakeProduct.fakeProduct()];

      when(() => productRepository.fetchProducts(any(), any()))
          .thenAnswer((invocation) => Future.value(Tuple2(products, true)));

      final bloc = SearchItemsBloc(
        type: SearchItemType.product,
        productRepository: productRepository,
      );

      bloc.add(const SearchTextChanged(text: 'search term'));
      bloc.add(const SearchFetched());

      await bloc.stream.firstWhere((e) => e.status == SearchStatus.success);

      expect(bloc.state.status, SearchStatus.success);
      expect(bloc.state.items.map((e) => e.id).toList(), products.map((e) => e.id).toList());
    });

    test('emit products when Refreshed', () async {
      final products = [FakeProduct.fakeProduct()];

      when(() => productRepository.fetchProducts(any(), any()))
          .thenAnswer((invocation) => Future.value(Tuple2(products, true)));

      final bloc = SearchItemsBloc(
        type: SearchItemType.product,
        productRepository: productRepository,
      );

      bloc.add(const SearchTextChanged(text: 'search term'));
      bloc.add(const SearchRefreshed());

      await bloc.stream.firstWhere((e) => e.status == SearchStatus.success);

      expect(bloc.state.status, SearchStatus.success);
      expect(bloc.state.items.map((e) => e.id).toList(), products.map((e) => e.id).toList());
    });

    test('emit empty when Search Text is empty', () async {
      final bloc = SearchItemsBloc(
        type: SearchItemType.product,
        productRepository: productRepository,
      );

      bloc.add(const SearchTextChanged(text: ''));

      await bloc.stream.first;

      expect(bloc.state, equals(const SearchItemsState(type: SearchItemType.product)));
    });

    test('emit products when Search Text is changed', () async {
      const query = 'search term';
      final products = [FakeProduct.fakeProduct()];

      when(() => productRepository.fetchProducts(any(), any()))
          .thenAnswer((invocation) => Future.value(Tuple2(products, true)));

      final bloc = SearchItemsBloc(
        type: SearchItemType.product,
        productRepository: productRepository,
      );

      bloc.add(const SearchTextChanged(text: query));

      await bloc.stream.firstWhere((e) => e.items.isNotEmpty);

      expect(bloc.state.query, query);
      expect(bloc.state.status, SearchStatus.success);
      expect(bloc.state.items.map((e) => e.id).toList(), products.map((e) => e.id).toList());
    });

    test('emit error when Search Text is throws', () async {
      const query = 'search term';

      when(() => productRepository.fetchProducts(any(), any()))
          .thenThrow(Exception());

      final bloc = SearchItemsBloc(
        type: SearchItemType.product,
        productRepository: productRepository,
      );

      bloc.add(const SearchTextChanged(text: query));

      await bloc.stream.firstWhere((e) => e.status == SearchStatus.failure);

      expect(bloc.state.status, SearchStatus.failure);
    });
  });
}
