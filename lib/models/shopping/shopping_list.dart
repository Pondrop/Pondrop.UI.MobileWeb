import 'package:equatable/equatable.dart';

part 'shopping_list_item.dart';
part 'shopping_list_store.dart';

class ShoppingList extends Equatable {
  const ShoppingList({
    required this.id,
    required this.shopperId,
    required this.name,
    this.iconCodePoint = 0xf37f,
    this.iconFontFamily = 'MaterialIcons',
    this.items = const [],
    this.stores = const [],
    this.itemCount = 0,
    this.sortOrder = 0,
  });

  final String id;
  final String shopperId;
  final String name;

  final int iconCodePoint;
  final String iconFontFamily;

  final List<ShoppingListItem> items;
  final int itemCount;

  final List<ShoppingListStore> stores;

  final int sortOrder;

  ShoppingList copyWith({
    String? name,
    List<ShoppingListItem>? items,
    int? itemCount,
    List<ShoppingListStore>? stores,
    int? sortOrder,
  }) {
    return ShoppingList(
      id: id,
      shopperId: shopperId,
      name: name ?? this.name,
      iconCodePoint: iconCodePoint,
      iconFontFamily: iconFontFamily,
      items: items ?? this.items,
      itemCount: itemCount ?? this.itemCount,
      stores: stores ?? this.stores,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  List<Object> get props => [
        id,
        shopperId,
        name,
        iconCodePoint,
        iconFontFamily,
        items,
        stores,
        sortOrder
      ];
}
