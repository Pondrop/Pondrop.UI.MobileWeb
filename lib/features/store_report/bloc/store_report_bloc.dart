import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:pondrop/api/submission_api.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';

part 'store_report_event.dart';
part 'store_report_state.dart';

class StoreReportBloc extends Bloc<StoreReportEvent, StoreReportState> {
  StoreReportBloc(
      {required Store store,
      required SubmissionRepository submissionRepository,
      required LocationRepository locationRepository})
      : _submissionRepository = submissionRepository,
        _locationRepository = locationRepository,
        super(StoreReportState(store: store)) {
    on<StoreReportRefreshed>(_onStoreReportRefreshed);
    on<StoreReportSubmitted>(_onStoreReportSubmitted);
    on<StoreReportRetryPending>(_onStoreReportRetryPending);

    _storeSubmissionSubscription = _submissionRepository.submissions.listen(
      (submission) => add(StoreReportSubmitted(submission: submission)),
    );

    _locationRepository
        .getLastKnownPosition()
        .then((value) => add(StoreReportRefreshed(position: value)));
  }

  final SubmissionRepository _submissionRepository;
  final LocationRepository _locationRepository;

  late StreamSubscription<StoreSubmission> _storeSubmissionSubscription;

  void _onStoreReportRefreshed(
    StoreReportRefreshed event,
    Emitter<StoreReportState> emit,
  ) async {
    if (state.status == StoreReportStatus.loading) {
      return;
    }

    emit(state.copyWith(status: StoreReportStatus.loading));

    if (state.visit == null) {
      try {
        final visitTask = _submissionRepository.startStoreVisit(
            state.store.id,
            LatLng(
                event.position?.latitude ?? 0, event.position?.longitude ?? 0));
        final templatesTask = _submissionRepository.fetchTemplates();

        await Future.wait([visitTask, templatesTask]);

        emit(state.copyWith(
            visit: await visitTask, templates: await templatesTask));
      } catch (e) {
        log(e.toString());
      }
    }

    if (state.visit != null) {
      try {
        final categoryCampaignsTask =
            _submissionRepository.fetchCategoryCampaigns([state.store.id]);
        final productCampaignsTask =
            _submissionRepository.fetchProductCampaigns([state.store.id]);

        await Future.wait([categoryCampaignsTask, productCampaignsTask]);

        final campaigns = [
          ...(await categoryCampaignsTask),
          ...(await productCampaignsTask)
        ].where((c) => c.isValid).toList();

        emit(state.copyWith(campaigns: campaigns));
      } catch (e) {
        log(e.toString());
      }
    }

    emit(state.copyWith(
        status: state.visit != null
            ? StoreReportStatus.loaded
            : StoreReportStatus.failed));
  }

  Future<void> _onStoreReportSubmitted(
    StoreReportSubmitted event,
    Emitter<StoreReportState> emit,
  ) async {
    final campaigns = List<CampaignDto>.from(state.campaigns);

    if (event.submission.campaignId != null) {
      campaigns.removeWhere((e) =>
          e.id == event.submission.campaignId &&
          e.focusId == event.submission.getFocusId());
    }

    final submissions = List<StoreSubmission>.from(state.submissions);
    final idx = submissions.indexWhere((e) =>
        e.storeVisit == event.submission.storeVisit &&
        e.templateId == event.submission.templateId &&
        e.dateCreated == event.submission.dateCreated);

    if (idx >= 0) {
      submissions[idx] = event.submission;
    } else {
      submissions.add(event.submission);
    }

    emit(state.copyWith(submissions: submissions, campaigns: campaigns));
  }

  Future<void> _onStoreReportRetryPending(
    StoreReportRetryPending event,
    Emitter<StoreReportState> emit,
  ) async {
    if (state.pendingState.submitting) return;

    final pending = state.pendingSubmissions;

    if (pending.isEmpty) return;

    emit(state.copyWith(
        pendingState: state.pendingState.copyWith(
            submitting: true,
            currentCount: 1,
            totalCount: pending.length,
            submittedCount: 0,
            popOnComplete: event.popOnComplete)));

    for (final submission in pending) {
      final success = await _submissionRepository.submitResult(submission);
      emit(state.copyWith(
          pendingState: state.pendingState.copyWith(
        currentCount: state.pendingState.currentCount + 1,
        submittedCount: state.pendingState.submittedCount + (success ? 1 : 0),
      )));
    }

    emit(state.copyWith(
        pendingState: state.pendingState.copyWith(
      submitting: false,
    )));
  }

  @override
  Future<void> close() async {
    _storeSubmissionSubscription.cancel();

    try {
      if (state.visit != null) {
        final position = await _locationRepository.getLastKnownPosition();
        await _submissionRepository.endStoreVisit(state.visit!.id,
            LatLng(position?.latitude ?? 0, position?.longitude ?? 0));
      }
    } catch (e) {
      log(e.toString());
    }

    await super.close();
  }
}
