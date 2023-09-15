import 'dart:math';

import 'package:pondrop/api/products/models/models.dart';
import 'package:pondrop/models/models.dart';
import 'package:uuid/uuid.dart';

class FakeProduct {
  static Product fakeProduct() {
    return Product(
      id: const Uuid().v4(),
      barcode: '0123456789',
      name: 'Super food 250g',
    );
  }

  static List<ProductDto> fakeProductDtos({int length = 3}) {
    final rng = Random();
    final items = <ProductDto>[];

    for (var i = 0; i < length; i++) {
      items.add(ProductDto(
          searchScore: 1,
          id: const Uuid().v4(),
          name: 'Product Name ${i + 1}',
          brandId: const Uuid().v4(),
          externalReferenceId: const Uuid().v4(),
          variant: '',
          altName: '',
          shortDescription: 'Description ${i + 1}',
          netContent: rng.nextDouble() * 250,
          netContentUom: 'G',
          possibleCategories: '',
          publicationLifecycleId: '',
          barcodeNumber: '978020137962',
          categoryNames: 'Cat 1,Cat 2'));
    }

    return items;
  }
}
