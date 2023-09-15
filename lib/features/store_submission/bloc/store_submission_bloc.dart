import 'dart:developer' as dev;
import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:pondrop/api/submission_api.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';

part 'store_submission_event.dart';
part 'store_submission_state.dart';

class StoreSubmissionBloc
    extends Bloc<StoreSubmissionEvent, StoreSubmissionState> {
  StoreSubmissionBloc({
    required StoreVisitDto visit,
    required StoreSubmission submission,
    required SubmissionRepository submissionRepository,
    required CameraRepository cameraRepository,
    required LocationRepository locationRepository,
  })  : _submissionRepository = submissionRepository,
        _cameraRepository = cameraRepository,
        _locationRepository = locationRepository,
        super(StoreSubmissionState(visit: visit, submission: submission)) {
    on<StoreSubmissionNextEvent>(_onNext);
    on<StoreSubmissionFieldResultEvent>(_onResult);
  }

  final SubmissionRepository _submissionRepository;
  final CameraRepository _cameraRepository;
  final LocationRepository _locationRepository;

  void _onResult(StoreSubmissionFieldResultEvent event,
      Emitter<StoreSubmissionState> emit) {
    final newSubmission = state.submission.copyWith();
    final step = newSubmission.steps[state.currentStepIdx];
    final field = step.fields.firstWhere((e) => e.fieldId == event.fieldId);

    // Index is out-of-bounds, so append a new result
    if (event.resultIdx > field.results.length - 1) {
      field.results.add(event.result);
    } else {
      // Index is valid so updated existing result
      final resultToEdit = field.results[event.resultIdx];

      resultToEdit.stringValue = event.result.stringValue;
      resultToEdit.intValue = event.result.intValue;
      resultToEdit.doubleValue = event.result.doubleValue;
      resultToEdit.dateTimeValue = event.result.dateTimeValue;
      resultToEdit.photoPathValue = event.result.photoPathValue;
      resultToEdit.itemValue = event.result.itemValue;

      // Remove empty results (while maintaining 1 as the minimum array length)
      if (field.results.length > 1 && resultToEdit.isEmpty) {
        field.results.removeAt(event.resultIdx);
      }
    }

    emit(state.copyWith(submission: newSubmission));
  }

  Future<void> _onNext(StoreSubmissionNextEvent event,
      Emitter<StoreSubmissionState> emit) async {
    switch (state.status) {
      case SubmissionStatus.initial:
        {
          if (await _cameraRepository.isCameraEnabled()) {
            await _goToNextStep(emit);
          } else {
            emit(state.copyWith(action: SubmissionStatus.cameraRequest));
          }
        }
        break;
      case SubmissionStatus.cameraRequest:
        {
          if (await _cameraRepository.request()) {
            await _goToNextStep(emit);
          } else {
            emit(state.copyWith(action: SubmissionStatus.cameraRejected));
          }
        }
        break;
      case SubmissionStatus.cameraRejected:
        if (await _cameraRepository.isCameraEnabled()) {
          await _goToNextStep(emit);
        } else {
          emit(state.copyWith(action: SubmissionStatus.cameraRequest));
        }
        break;
      case SubmissionStatus.stepInstructions:
        emit(state.copyWith(action: SubmissionStatus.stepSubmission));
        break;
      case SubmissionStatus.stepSubmission:
      case SubmissionStatus.submitFailed:
        await _goToNextStep(emit);
        break;
      case SubmissionStatus.submitting:
        final position = await _locationRepository.getCurrentPosition();
        if (await _submissionRepository.submitResult(state.submission.copyWith(
            location:
                LatLng(position?.latitude ?? 0, position?.longitude ?? 0)))) {
          emit(state.copyWith(action: SubmissionStatus.submitSuccess));
        } else {
          emit(state.copyWith(action: SubmissionStatus.submitFailed));
        }
        break;
      default:
        break;
    }
  }

  Future<void> _goToNextStep(Emitter<StoreSubmissionState> emit) async {
    final nextStepIdx = state.currentStepIdx + 1;

    if (nextStepIdx < state.numOfSteps) {
      Position? lastKnown;

      try {
        lastKnown = await _locationRepository.getLastKnownPosition();
      } on Exception {
        dev.log('Unable to determine last know location');
      }

      final nextStep = state.submission.steps[nextStepIdx];

      nextStep.latitude = lastKnown?.latitude ?? 0;
      nextStep.longitude = lastKnown?.longitude ?? 0;
      nextStep.started = DateTime.now();

      if (nextStep.instructions.isNotEmpty) {
        emit(state.copyWith(
          action: SubmissionStatus.stepInstructions,
          currentStepIdx: nextStepIdx,
        ));
      } else {
        emit(state.copyWith(
          action: SubmissionStatus.stepSubmission,
          currentStepIdx: nextStepIdx,
        ));
      }
    } else {
      emit(state.copyWith(
        action: SubmissionStatus.submitting,
      ));
    }
  }
}
