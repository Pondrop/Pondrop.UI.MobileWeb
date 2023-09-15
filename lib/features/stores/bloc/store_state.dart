part of 'store_bloc.dart';

enum StoreStatus { initial, loading, success, failure }

class StoreState extends Equatable {
  const StoreState({
    this.status = StoreStatus.initial,
    this.stores = const <Store>[],
    this.position,
    this.hasReachedMax = false,
    this.communityStore,
    this.campaignCountsRefreshedMs = 0,
  });

  final StoreStatus status;
  final List<Store> stores;
  final Position? position;
  final bool hasReachedMax;

  final Store? communityStore;

  final int campaignCountsRefreshedMs;

  StoreState copyWith({
    StoreStatus? status,
    List<Store>? stores,
    Position? position,
    bool? hasReachedMax,
    Store? communityStore,
    int? campaignCountsRefreshedMs,
  }) {
    return StoreState(
      status: status ?? this.status,
      stores: stores ?? this.stores,
      position: position ?? this.position,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      communityStore: communityStore ?? this.communityStore,
      campaignCountsRefreshedMs:
          campaignCountsRefreshedMs ?? this.campaignCountsRefreshedMs,
    );
  }

  @override
  String toString() {
    return '''StoreState { status: $status, hasReachedMax: $hasReachedMax, stores: ${stores.length} }''';
  }

  @override
  List<Object?> get props => [
        status,
        stores,
        hasReachedMax,
        communityStore,
        campaignCountsRefreshedMs
      ];
}
