part of 'store_submission_bloc.dart';

enum SubmissionStatus {
  initial,
  cameraRequest,
  cameraRejected,
  stepInstructions,
  stepSubmission,
  submitting,
  submitFailed,
  submitSuccess,
}

class StoreSubmissionState extends Equatable {
  const StoreSubmissionState({
    this.previousAction = SubmissionStatus.initial,
    this.status = SubmissionStatus.initial,
    required this.visit,
    required this.submission,
    this.currentStepIdx = -1,
  });
  
  final SubmissionStatus previousAction;
  final SubmissionStatus status;

  final StoreVisitDto visit;
  final StoreSubmission submission;
  final int currentStepIdx;

  int get numOfSteps =>
    submission.steps.length;
  StoreSubmissionStep get currentStep =>
    submission.steps[math.min(math.max(0, currentStepIdx), numOfSteps - 1)];
  bool get currentStepComplete =>
    currentStep.isComplete;
  bool get isLastStep =>
    currentStepIdx == numOfSteps - 1;
  bool get lastStepHasMandatoryFields =>
    submission.steps.last.fields.any((e) => e.mandatory);

  bool get hasAnyResults =>
    submission.steps.any((step) => step.fields.any((field) => field.results.every((e) => !e.isEmpty)));

  StoreSubmissionState copyWith({
    SubmissionStatus? action,
    StoreSubmission? submission,
    int? currentStepIdx,
  }) {
    return StoreSubmissionState(
      previousAction: status,
      visit: visit,
      status: action ?? status,
      submission: submission ?? this.submission,
      currentStepIdx : currentStepIdx ?? this.currentStepIdx,
    );
  }

  @override
  List<Object> get props => [
    status,
    submission,
    currentStepIdx,
  ];
}
