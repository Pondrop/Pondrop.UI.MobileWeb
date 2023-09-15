import 'package:pondrop/api/products/product_api.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:tuple/tuple.dart';

class ProductRepository {
  ProductRepository(
      {required UserRepository userRepository, ProductApi? productApi})
      : _userRepository = userRepository,
        _productApi = productApi ?? ProductApi();

  final UserRepository _userRepository;
  final ProductApi _productApi;

  Future<Tuple2<List<Product>, bool>> fetchProducts(
      String keyword, int skipIdx) async {
    final user = await _userRepository.getUser();

    if (user?.accessToken.isNotEmpty == true) {
      final searchResult = await _productApi.searchProducts(user!.accessToken,
          keyword: keyword, skipIdx: skipIdx);

      final products = searchResult.value
          .map((e) => Product(
                id: e.id,
                barcode: e.barcodeNumber,
                name: e.name,
              ))
          .toList();

      return Tuple2(products, searchResult.odataNextLink.isNotEmpty);
    }

    return const Tuple2([], false);
  }

  Future<Map<String, Product>> fetchProductsById(Set<String> ids) async {
    final user = await _userRepository.getUser();

    if (user?.accessToken.isNotEmpty == true && ids.isNotEmpty) {
      final searchResult =
          await _productApi.searchProductsById(user!.accessToken, ids);

      final products = {
        for (final i in searchResult.value)
          i.id: Product(
            id: i.id,
            barcode: i.barcodeNumber,
            name: i.name,
          )
      };

      return products;
    }

    return const {};
  }

  Future<Tuple2<List<Category>, bool>> fetchCategories(
      String keyword, int skipIdx) async {
    final user = await _userRepository.getUser();

    if (user?.accessToken.isNotEmpty == true) {
      final searchResult = await _productApi.searchCategories(user!.accessToken,
          keyword: keyword, skipIdx: skipIdx);

      final categories = searchResult.value
          .map((e) => Category(
                id: e.id,
                name: e.name,
              ))
          .toList();

      return Tuple2(categories, searchResult.odataNextLink.isNotEmpty);
    }

    return const Tuple2([], false);
  }

  Future<Map<String, Category>> fetchCategoriesById(Set<String> ids) async {
    final user = await _userRepository.getUser();

    if (user?.accessToken.isNotEmpty == true && ids.isNotEmpty) {
      final searchResult =
          await _productApi.searchCategoriesById(user!.accessToken, ids);

      final categories = {
        for (final i in searchResult.value)
          i.id: Category(id: i.id, name: i.name)
      };

      return categories;
    }

    return const {};
  }
}
