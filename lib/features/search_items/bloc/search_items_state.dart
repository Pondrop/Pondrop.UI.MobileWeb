part of '../../search_items/bloc/search_items_bloc.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchItemsState extends Equatable {
  const SearchItemsState({
    this.status = SearchStatus.initial,
    required this.type,
    this.query = '',
    this.items = const <SearchItem>[],
    this.hasReachedMax = false,
  });

  final SearchStatus status;
  final SearchItemType type;

  final String query;
  final List<SearchItem> items;
  final bool hasReachedMax;

  SearchItemsState copyWith({
    SearchStatus? status,
    String? query,
    List<SearchItem>? items,
    bool? hasReachedMax,
  }) {
    return SearchItemsState(
      status: status ?? this.status,
      type: type,
      query: query ?? this.query,
      items: items ?? this.items,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''SearchItemsState { status: $status, type: $type, items: ${items.length} }''';
  }

  @override
  List<Object> get props => [status, type, query, items, hasReachedMax];
}
