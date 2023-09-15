part of 'shopping_list.dart';

class ShoppingListItem extends Equatable {
  const ShoppingListItem({
    required this.id,
    required this.listId,
    required this.categoryId,
    required this.name,
    this.storeId,
    this.checked = false,
    this.sortOrder = 0,
  });

  final String id;
  final String listId;
  final String name;

  final String categoryId;
  final String? storeId;

  final bool checked;

  final int sortOrder;

  ShoppingListItem copyWith({
    bool? checked,
    int? sortOrder,
  }) {
    return ShoppingListItem(
      id: id,
      listId: listId,
      categoryId: categoryId,
      storeId: storeId,
      name: name,
      checked: checked ?? this.checked,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  List<Object?> get props => [
        id,
        listId,
        name,
        categoryId,
        storeId,
        checked,
        sortOrder,
      ];
}
