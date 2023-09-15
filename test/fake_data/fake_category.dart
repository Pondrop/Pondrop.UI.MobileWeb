import 'package:pondrop/api/products/models/models.dart';
import 'package:pondrop/models/models.dart';
import 'package:uuid/uuid.dart';

class FakeCategory {
  static Category fakeCategory() {
    return Category(
      id: const Uuid().v4(),
      name: 'Mock Category',
    );
  }

  static List<CategoryDto> fakeCategoryDtos({int length = 3}) {
    final items = <CategoryDto>[];

    for (var i = 0; i < length; i++) {
      items.add(CategoryDto(
          searchScore: 1,
          id: const Uuid().v4(),
          name: 'Category Name ${i + 1}',
          updatedUtc: DateTime.now()));
    }

    return items;
  }
}
