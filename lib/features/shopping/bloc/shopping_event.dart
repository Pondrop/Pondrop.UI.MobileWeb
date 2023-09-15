part of 'shopping_bloc.dart';

abstract class ShoppingEvent extends Equatable {
  const ShoppingEvent();

  @override
  List<Object> get props => [];
}

class ListRefreshed extends ShoppingEvent {
  const ListRefreshed();
}

class ListCreated extends ShoppingEvent {
  const ListCreated({required this.name, required this.sortOrder});

  final String name;
  final int sortOrder;
}

class ListUpdated extends ShoppingEvent {
  const ListUpdated({required this.list});

  final ShoppingList list;
}

class ListDeleted extends ShoppingEvent {
  const ListDeleted({required this.id});

  final String id;
}

class ListReordered extends ShoppingEvent {
  const ListReordered({required this.oldIdx, required this.newIdx});

  final int oldIdx;
  final int newIdx;
}
