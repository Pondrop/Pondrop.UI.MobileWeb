part of 'store_submission_bloc.dart';

abstract class StoreSubmissionEvent extends Equatable {
  const StoreSubmissionEvent();

  @override
  List<Object> get props => [];
}

class StoreSubmissionNextEvent extends StoreSubmissionEvent {
  const StoreSubmissionNextEvent();
}

class StoreSubmissionFieldResultEvent extends StoreSubmissionEvent {
  const StoreSubmissionFieldResultEvent({
    required this.stepId,
    required this.fieldId,
    required this.result,
    this.resultIdx = 0,
  });

  final String stepId;
  final String fieldId;
  final StoreSubmissionFieldResult result;

  /// The StoreSubmissionFieldResult index to update
  /// 
  /// If set to a value greater than the current length of results,
  /// a new result is appended.
  final int resultIdx;
}
