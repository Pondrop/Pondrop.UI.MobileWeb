part of 'shopping_list.dart';

class ShoppingListStore extends Equatable {
  const ShoppingListStore({
    required this.storeId,
    required this.name,
    required this.sortOrder,
  });

  final String storeId;
  final String name;
  final int sortOrder;

  ShoppingListStore copyWith({
    String? name,
    int? sortOrder,
  }) {
    return ShoppingListStore(
      storeId: storeId,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  List<Object> get props => [storeId, name, sortOrder];
}
