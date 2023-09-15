part of 'store_bloc.dart';

abstract class StoreEvent extends Equatable {
  const StoreEvent();

  @override
  List<Object> get props => [];
}

class StoreFetched extends StoreEvent {
  const StoreFetched();
}

class StoreRefreshed extends StoreEvent {
  const StoreRefreshed();
}

class StoreCompletedTasks extends StoreEvent {
  const StoreCompletedTasks({
    required this.completedTasks,
  });

  final List<TaskIdentifier> completedTasks;
}

class StoreCampaignCountsRefreshed extends StoreEvent {
  const StoreCampaignCountsRefreshed({
    required this.storeIds,
  });

  final List<String> storeIds;
}
