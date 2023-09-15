part of '../../search_items/bloc/search_items_bloc.dart';

abstract class SearchItemsEvent extends Equatable {
  @override
  List<Object> get props => [];
  
  const SearchItemsEvent();
}

class SearchFetched extends SearchItemsEvent {
  const SearchFetched();
}

class SearchRefreshed extends SearchItemsEvent {
  const SearchRefreshed();
}

class SearchTextChanged extends SearchItemsEvent {
  const SearchTextChanged({required this.text});

  final String text;

  @override
  List<Object> get props => [text];
}