part of 'shopping_bloc.dart';

enum ShoppingStatus { initial, loading, success, failure }

enum ShoppingAction { none, refresh, create, delete, reorder }

class ShoppingState extends Equatable {
  const ShoppingState({
    this.status = ShoppingStatus.initial,
    this.action = ShoppingAction.none,
    this.lists = const <ShoppingList>[],
  });

  final ShoppingStatus status;
  final ShoppingAction action;
  final List<ShoppingList> lists;

  ShoppingState copyWith({
    ShoppingStatus? status,
    ShoppingAction? action,
    List<ShoppingList>? lists,
  }) {
    return ShoppingState(
      status: status ?? this.status,
      action: action ?? this.action,
      lists: lists ?? this.lists,
    );
  }

  @override
  String toString() {
    return '''ShoppingStatus { status: $status, lists: ${lists.length} }''';
  }

  @override
  List<Object> get props => [status, lists];
}
