part of 'shopping_list_bloc.dart';

enum ShoppingListStatus { initial, loading, success, failure }

enum ShoppingListAction {
  none,
  refresh,
  create,
  delete,
  checked,
  reorder,
  categorySearch
}

class ShoppingListState extends Equatable {
  const ShoppingListState({
    this.status = ShoppingListStatus.initial,
    this.action = ShoppingListAction.none,
    required this.list,
    this.items = const [],
    this.categorySearchText = '',
    this.categoriesFiltered = const [],
  });

  final ShoppingListStatus status;
  final ShoppingListAction action;
  final ShoppingList list;

  final List<ShoppingListItem> items;

  final String categorySearchText;
  final List<Category> categoriesFiltered;

  ShoppingListState copyWith({
    ShoppingListStatus? status,
    ShoppingListAction? action,
    List<ShoppingListItem>? items,
    String? categorySearchText,
    List<Category>? categoriesFiltered,
  }) {
    return ShoppingListState(
      status: status ?? this.status,
      action: action ?? this.action,
      list: list,
      items: items ?? this.items,
      categorySearchText: categorySearchText ?? this.categorySearchText,
      categoriesFiltered: categoriesFiltered ?? this.categoriesFiltered,
    );
  }

  @override
  String toString() {
    return '''ShoppingListState { status: $status, lists: ${items.length} }''';
  }

  @override
  List<Object> get props =>
      [status, list, items, categorySearchText, categoriesFiltered];
}
