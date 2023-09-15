part of 'search_store_bloc.dart';

enum SearchStoreStatus { initial, success, failure }

class SearchStoreState extends Equatable {
  const SearchStoreState({
    this.status = SearchStoreStatus.initial,
    this.query = '',
    this.stores = const <Store>[],
    this.position,
  });

  final SearchStoreStatus status;
  final String query;
  final List<Store> stores;
  final Position? position;

  SearchStoreState copyWith({
    SearchStoreStatus? status,
    String? query,
    List<Store>? stores,
    Position? position,
  }) {
    return SearchStoreState(
      status: status ?? this.status,
      query: query ?? this.query,
      stores: stores ?? this.stores,
      position: position ?? this.position,
    );
  }

  @override
  String toString() {
    return '''StoreState { status: $status, stores: ${stores.length} }''';
  }

  @override
  List<Object> get props => [status, stores];
}
