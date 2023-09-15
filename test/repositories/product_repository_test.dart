import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/api/products/models/category_dto.dart';
import 'package:pondrop/api/products/models/product_dto.dart';
import 'package:pondrop/api/products/product_api.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:uuid/uuid.dart';

import '../fake_data/fake_data.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockProductApi extends Mock implements ProductApi {}

void main() {
  final User user = User(email: 'me@email.com', accessToken: const Uuid().v4());

  late UserRepository userRepository;
  late ProductApi productApi;

  bool testProductDtoMapping(List<Product> objects, List<ProductDto> dtos) {
    if (objects.length != dtos.length) {
      return false;
    }

    for (var i = 0; i < objects.length; i++) {
      final dto = dtos[i];
      final obj = objects[i];

      if (dto.id != obj.id ||
          dto.name != obj.name ||
          dto.barcodeNumber != obj.barcode) {
        return false;
      }
    }

    return true;
  }

  bool testCategoryDtoMapping(List<Category> objects, List<CategoryDto> dtos) {
    if (objects.length != dtos.length) {
      return false;
    }

    for (var i = 0; i < objects.length; i++) {
      final dto = dtos[i];
      final obj = objects[i];

      if (dto.id != obj.id || dto.name != obj.name) {
        return false;
      }
    }

    return true;
  }

  setUp(() {
    userRepository = MockUserRepository();
    productApi = MockProductApi();

    when(() => userRepository.getUser())
        .thenAnswer((invocation) => Future<User?>.value(user));
  });

  group('ProductRepository', () {
    test('Construct an instance', () {
      expect(
          ProductRepository(
              userRepository: userRepository, productApi: productApi),
          isA<ProductRepository>());
    });
  });

  group('ProductRepository Products', () {
    test('Get products from API', () async {
      const query = 'search term';
      final dtos = FakeProduct.fakeProductDtos();

      when(() => productApi.searchProducts(user.accessToken,
              keyword: query, skipIdx: 0))
          .thenAnswer((invocation) => Future.value(ProductSearchResultDto(
              value: dtos, odataNextLink: '', odataContext: '')));

      final repo = ProductRepository(
          userRepository: userRepository, productApi: productApi);

      final result = await repo.fetchProducts(query, 0);

      assert(testProductDtoMapping(result.item1, dtos) == true);
      expect(result.item2, false);
    });

    test('Get products from API (more results)', () async {
      const query = 'search term';
      final dtos = FakeProduct.fakeProductDtos(length: 20);

      when(() => productApi.searchProducts(user.accessToken,
              keyword: query, skipIdx: 0))
          .thenAnswer((invocation) => Future.value(ProductSearchResultDto(
              value: dtos, odataNextLink: 'another page', odataContext: '')));

      final repo = ProductRepository(
          userRepository: userRepository, productApi: productApi);

      final result = await repo.fetchProducts(query, 0);

      assert(testProductDtoMapping(result.item1, dtos) == true);
      expect(result.item2, true);
    });

    test('Get products by ID from API', () async {
      final dtos = FakeProduct.fakeProductDtos();
      final ids = dtos.map((e) => e.id).toSet();

      when(() => productApi.searchProductsById(user.accessToken, ids))
          .thenAnswer((invocation) => Future.value(ProductSearchResultDto(
              value: dtos, odataNextLink: '', odataContext: '')));

      final repo = ProductRepository(
          userRepository: userRepository, productApi: productApi);

      final result = await repo.fetchProductsById(ids);

      assert(testProductDtoMapping(result.values.toList(), dtos) == true);
    });
  });

  group('ProductRepository Categories', () {
    test('Get categories from API', () async {
      const query = 'search term';
      final dtos = FakeCategory.fakeCategoryDtos();

      when(() => productApi.searchCategories(user.accessToken,
              keyword: query, skipIdx: 0))
          .thenAnswer((invocation) => Future.value(CategorySearchResultDto(
              value: dtos, odataNextLink: '', odataContext: '')));

      final repo = ProductRepository(
          userRepository: userRepository, productApi: productApi);

      final result = await repo.fetchCategories(query, 0);

      assert(testCategoryDtoMapping(result.item1, dtos) == true);
      expect(result.item2, false);
    });

    test('Get categories from API (more results)', () async {
      const query = 'search term';
      final dtos = FakeCategory.fakeCategoryDtos(length: 20);

      when(() => productApi.searchCategories(user.accessToken,
              keyword: query, skipIdx: 0))
          .thenAnswer((invocation) => Future.value(CategorySearchResultDto(
              value: dtos, odataNextLink: 'another page', odataContext: '')));

      final repo = ProductRepository(
          userRepository: userRepository, productApi: productApi);

      final result = await repo.fetchCategories(query, 0);

      assert(testCategoryDtoMapping(result.item1, dtos) == true);
      expect(result.item2, true);
    });

    test('Get categories by ID from API', () async {
      final dtos = FakeCategory.fakeCategoryDtos();
      final ids = dtos.map((e) => e.id).toSet();

      when(() => productApi.searchCategoriesById(user.accessToken, ids))
          .thenAnswer((invocation) => Future.value(CategorySearchResultDto(
              value: dtos, odataNextLink: '', odataContext: '')));

      final repo = ProductRepository(
          userRepository: userRepository, productApi: productApi);

      final result = await repo.fetchCategoriesById(ids);

      assert(testCategoryDtoMapping(result.values.toList(), dtos) == true);
    });
  });
}
