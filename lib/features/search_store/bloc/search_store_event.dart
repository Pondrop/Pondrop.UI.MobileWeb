part of 'search_store_bloc.dart';

abstract class SearchStoreEvent extends Equatable {
  @override
  List<Object> get props => [];
  
  const SearchStoreEvent();
}

class TextChanged extends SearchStoreEvent {
  const TextChanged({required this.text});

  final String text;

  @override
  List<Object> get props => [text];
}