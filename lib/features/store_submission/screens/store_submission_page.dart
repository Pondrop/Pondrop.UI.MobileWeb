import 'dart:math' as math;

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pondrop/api/submission_api.dart';
import 'package:pondrop/features/app/app.dart';
import 'package:pondrop/features/dialogs/dialogs.dart';
import 'package:pondrop/features/global/global.dart';
import 'package:pondrop/features/store_submission/widgets/submission_summary_list_view.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/features/store_submission/widgets/camera_access_view.dart';
import 'package:pondrop/features/store_submission/widgets/submission_field_view.dart';
import 'package:pondrop/features/store_submission/widgets/submission_failed_view.dart';
import 'package:pondrop/features/store_submission/widgets/submission_success_view.dart';
import 'package:pondrop/features/styles/styles.dart';

import '../bloc/store_submission_bloc.dart';
import '../widgets/fields/fields.dart';
import '../widgets/focus_header_view.dart';

class StoreSubmissionPage extends StatelessWidget {
  const StoreSubmissionPage(
      {Key? key, required this.visit, required this.submission, this.campaign})
      : super(key: key);

  static const nextButtonKey = Key('StoreSubmissionPage_Next_Button');

  static Route route(
      {required StoreVisitDto visit,
      required StoreSubmission submission,
      CampaignDto? campaign}) {
    return MaterialPageRoute<void>(
        builder: (_) => StoreSubmissionPage(
              visit: visit,
              submission: submission,
              campaign: campaign,
            ));
  }

  final StoreVisitDto visit;
  final StoreSubmission submission;
  final CampaignDto? campaign;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider(
      create: (context) => StoreSubmissionBloc(
        visit: visit,
        submission: submission,
        submissionRepository:
            RepositoryProvider.of<SubmissionRepository>(context),
        cameraRepository: RepositoryProvider.of<CameraRepository>(context),
        locationRepository: RepositoryProvider.of<LocationRepository>(context),
      )..add(const StoreSubmissionNextEvent()),
      child: BlocListener<StoreSubmissionBloc, StoreSubmissionState>(
        listener: (context, state) async {
          final cameraRepository =
              RepositoryProvider.of<CameraRepository>(context);
          final bloc = context.read<StoreSubmissionBloc>();
          final navigator = Navigator.of(context);

          if (state.status == SubmissionStatus.submitting) {
            LoadingOverlay.of(context).show(l10n.itemEllipsis(l10n.submitting));
            bloc.add(const StoreSubmissionNextEvent());
            return;
          }

          LoadingOverlay.of(context).hide();

          if (state.status == SubmissionStatus.submitFailed) {
            await navigator.push(SubmissionFailedView.route());
            navigator.pop();
            return;
          } else if (state.status == SubmissionStatus.submitSuccess) {
            await navigator.push(SubmissionSuccessView.route());
            navigator.pop();
            return;
          }

          if (state.status == SubmissionStatus.cameraRejected) {
            await showDialog(
              context: context,
              builder: (_) => _cameraAccessPrompt(context),
            );
          } else if (state.status == SubmissionStatus.stepInstructions) {
            // the current step number
            // excludes and previous "focus" steps
            final currentStepNum = (state.currentStepIdx + 1) -
                (state.submission.steps
                    .take(math.max(0, state.currentStepIdx + 1))
                    .where((e) => e.isFocus)
                    .length);
            // the total number of steps
            // excludes all "focus" steps
            final totalStepNum = state.submission.steps.length -
                (state.submission.steps.where((e) => e.isFocus).length) -
                (state.lastStepHasMandatoryFields ? 0 : 1);

            final safeCodePoint = IconValidator.safeIconCodePoint(
                state.currentStep.instructionsIconFontFamily,
                state.currentStep.instructionsIconCodePoint);

            final okay =
                await navigator.push<bool?>(DialogPage.route(DialogConfig(
              title: state.currentStep.isFocus
                  ? ''
                  : l10n.itemOfItem(currentStepNum, totalStepNum),
              iconData: safeCodePoint.item2 > 0
                  ? IconData(safeCodePoint.item2,
                      fontFamily: safeCodePoint.item1)
                  : null,
              header: state.currentStep.title,
              body: state.currentStep.instructions,
              okayButtonText:
                  state.currentStep.instructionsContinueButton.isNotEmpty
                      ? state.currentStep.instructionsContinueButton
                      : l10n.okay,
              cancelButtonText: state.currentStep.instructionsSkipButton,
            )));

            bloc.add(const StoreSubmissionNextEvent());
            if (okay == null) {
              navigator.pop();
            } else if (okay == true) {
              await PhotoFieldControl.takePhoto(
                  cameraRepository, bloc, state.currentStep.fields.first);
            }
          }
        },
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: Dims.smallEdgeInsets,
                child: Stack(alignment: Alignment.center, children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      child: Text(
                        l10n.cancel,
                        style: PondropStyles.linkTextStyle,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  BlocBuilder<StoreSubmissionBloc, StoreSubmissionState>(
                    builder: (context, state) {
                      return Align(
                        alignment: Alignment.center,
                        child: Text(
                          state.currentStep.title.isNotEmpty
                              ? state.currentStep.title
                              : state.submission.title,
                          style: PondropStyles.popupTitleTextStyle,
                        ),
                      );
                    },
                  ),
                  BlocBuilder<StoreSubmissionBloc, StoreSubmissionState>(
                    builder: (context, state) {
                      if (!state.currentStep.isFocus) {
                        return Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                              key: nextButtonKey,
                              onPressed: state.currentStep.isComplete
                                  ? () {
                                      context.read<StoreSubmissionBloc>().add(
                                          const StoreSubmissionNextEvent());
                                    }
                                  : null,
                              child: Text(
                                state.isLastStep ? l10n.send : l10n.next,
                                style: PondropStyles.linkTextStyle.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: state.currentStep.isComplete
                                        ? null
                                        : Colors.grey),
                              )),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ]),
              ),
              Expanded(
                  child: BlocBuilder<StoreSubmissionBloc, StoreSubmissionState>(
                buildWhen: (previous, current) =>
                    current.status != SubmissionStatus.cameraRejected &&
                    current.status != SubmissionStatus.submitFailed &&
                    current.status != SubmissionStatus.submitSuccess,
                builder: (context, state) {
                  if (state.status == SubmissionStatus.cameraRequest) {
                    return const CameraAccessView();
                  }

                  if (state.currentStep.isSummary) {
                    return SubmissionSummaryListView(
                      submission: state.submission,
                      stepIdx: state.currentStepIdx,
                    );
                  }

                  if (state.currentStep.isFocus) {
                    final focusField = state.currentStep.fields.first;
                    if (campaign != null) {
                      context
                          .read<StoreSubmissionBloc>()
                          .add(StoreSubmissionFieldResultEvent(
                              stepId: focusField.stepId,
                              fieldId: focusField.fieldId,
                              result: StoreSubmissionFieldResult(
                                itemValue: StoreSubmissionFieldResultItem(
                                    itemId: campaign!.focusId,
                                    itemName: campaign!.focusName),
                              ),
                              resultIdx: focusField.maxValue ?? 0));
                      context
                          .read<StoreSubmissionBloc>()
                          .add(const StoreSubmissionNextEvent());
                      return const SizedBox.shrink();
                    }

                    return FocusFieldControl(
                        field: state.currentStep.fields.first);
                  }

                  final children = <Widget>[];

                  // get all previous "focus" steps
                  final focusSteps = state.submission.steps
                      .take(math.max(0, state.currentStepIdx))
                      .where((e) => e.isFocus);
                  if (focusSteps.isNotEmpty) {
                    // if any, then we want to display the "focus" header,
                    // which will be based on the most recent focus result
                    final focusStep = focusSteps.last;
                    children.add(FocusHeaderView(
                      title: focusStep.fields.first.toResultString(),
                      itemType: focusStep.fields.first.itemType ??
                          SubmissionFieldItemType.unknown,
                    ));
                  }

                  for (final i in state.currentStep.fields) {
                    children.add(Padding(
                      padding: Dims.largeBottomEdgeInsets,
                      child: SubmissionFieldView(
                        field: i,
                      ),
                    ));
                  }

                  return SingleChildScrollView(
                      controller: ModalScrollController.of(context),
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(Dims.medium,
                              Dims.small, Dims.medium, Dims.xxLarge),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: children,
                          )));
                },
              )),
            ],
          ),
        ),
      ),
    );
  }

  AlertDialog _cameraAccessPrompt(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.cameraAccessRequired),
      content: Text(l10n.pleaseEnableCameraAccess),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () {
            context
                .read<StoreSubmissionBloc>()
                .add(const StoreSubmissionNextEvent());
            Navigator.pop(context);
            AppSettings.openAppSettings();
          },
          child: Text(l10n.openSettings),
        ),
      ],
    );
  }
}
