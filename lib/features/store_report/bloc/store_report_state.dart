part of 'store_report_bloc.dart';

enum StoreReportStatus { unknown, loading, loaded, failed }

class StoreReportState extends Equatable {
  const StoreReportState({
    required this.store,
    this.status = StoreReportStatus.unknown,
    this.visit,
    this.campaigns = const [],
    this.templates = const [],
    this.submissions = const [],
    this.pendingState = const RetryPendingState(),
  });

  final Store store;
  final StoreReportStatus status;
  final StoreVisitDto? visit;

  final List<CampaignDto> campaigns;
  final List<SubmissionTemplateDto> templates;

  final List<StoreSubmission> submissions;

  final RetryPendingState pendingState;

  List<StoreSubmission> get pendingSubmissions =>
      submissions.where((e) => !e.submitted).toList();
  int get pendingSubmissionCount => pendingSubmissions.length;
  bool get hasPendingSubmissions => pendingSubmissionCount > 0;

  StoreReportState copyWith({
    StoreReportStatus? status,
    StoreVisitDto? visit,
    List<CampaignDto>? campaigns,
    List<SubmissionTemplateDto>? templates,
    List<StoreSubmission>? submissions,
    RetryPendingState? pendingState,
  }) {
    return StoreReportState(
      store: store,
      status: status ?? this.status,
      visit: visit ?? this.visit,
      campaigns: campaigns ?? this.campaigns,
      templates: templates ?? this.templates,
      submissions: submissions ?? this.submissions,
      pendingState: pendingState ?? this.pendingState,
    );
  }

  @override
  List<Object?> get props =>
      [store, status, visit, campaigns, templates, submissions, pendingState];
}

class RetryPendingState extends Equatable {
  const RetryPendingState({
    this.submitting = false,
    this.currentCount = 0,
    this.totalCount = 0,
    this.submittedCount = 0,
    this.popOnComplete = true,
  });

  final bool submitting;

  final int currentCount;
  final int totalCount;

  final int submittedCount;

  final bool popOnComplete;

  bool get retrySuccessful => submittedCount == totalCount;

  RetryPendingState copyWith({
    bool? submitting,
    int? currentCount,
    int? totalCount,
    int? submittedCount,
    bool? popOnComplete,
  }) {
    return RetryPendingState(
      submitting: submitting ?? this.submitting,
      currentCount: currentCount ?? this.currentCount,
      totalCount: totalCount ?? this.totalCount,
      submittedCount: submittedCount ?? this.submittedCount,
      popOnComplete: popOnComplete ?? this.popOnComplete,
    );
  }

  @override
  List<Object> get props =>
      [submitting, currentCount, totalCount, submittedCount, popOnComplete];
}
