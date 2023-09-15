import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pondrop/features/app/app.dart';
import 'package:pondrop/features/store_submission/widgets/submission_summary_list_view.dart';
import 'package:pondrop/features/styles/styles.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';

class StoreSubmissionSummaryPage extends StatefulWidget {
  const StoreSubmissionSummaryPage({Key? key, required this.submission})
      : super(key: key);

  static Route route(StoreSubmission submission) {
    return RouteTransitions.modalSlideRoute(
        pageBuilder: (_) => StoreSubmissionSummaryPage(submission: submission));
  }

  final StoreSubmission submission;

  @override
  State<StoreSubmissionSummaryPage> createState() =>
      _StoreSubmissionSummaryPageState();
}

class _StoreSubmissionSummaryPageState
    extends State<StoreSubmissionSummaryPage> {
  late SubmissionRepository _submissionRepository;
  late StoreSubmission _submission;

  late StreamSubscription<StoreSubmission> _storeSubmissionSubscription;

  @override
  void initState() {
    super.initState();
    _submissionRepository =
        RepositoryProvider.of<SubmissionRepository>(context);
    _submission = widget.submission;

    _storeSubmissionSubscription =
        _submissionRepository.submissions.listen((submission) {
      if (submission.submitted &&
          submission.store == _submission.store &&
          submission.templateId == _submission.templateId &&
          submission.campaignId == _submission.campaignId &&
          submission.dateCreated == _submission.dateCreated) {
        setState(() {
          _submission = submission;
        });
      }
    });
  }

  @override
  void dispose() {
    _storeSubmissionSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          title: Text(_submission.title,
              style: PondropStyles.appBarTitleTextStyle),
          centerTitle: true,
          leading: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              })),
      body: Column(
        children: [
          if (!_submission.submitted)
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: Dims.small, horizontal: Dims.large),
              child: Material(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                color: PondropColors.errorColor,
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: Dims.medium),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: Dims.large),
                            child: Icon(
                              Icons.warning_amber_outlined,
                              color: Colors.white,
                            )),
                        Expanded(
                            child: Text(
                                '${l10n.taskHasntBeenSumbitted}\n${l10n.tapSendToRetry}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ))),
                      ],
                    )),
              ),
            ),
          Expanded(
            child: SubmissionSummaryListView(
              submission: _submission,
              stepIdx: _submission.steps.length - 1,
              readOnly: true,
            ),
          )
        ],
      ),
      floatingActionButton: _submission.submitted
          ? null
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: PondropColors.primaryLightColor,
                  foregroundColor: Colors.black),
              onPressed: () async {
                final loadingOverlay = LoadingOverlay.of(context);
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                loadingOverlay.show(l10n.itemEllipsis(l10n.submitting));
                final success =
                    await _submissionRepository.submitResult(_submission);
                loadingOverlay.hide();

                scaffoldMessenger.showSnackBar(SnackBar(
                    content: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: Dims.smallEdgeInsets,
                      child: Icon(
                        success
                            ? Icons.check_circle_outlined
                            : Icons.warning_amber_outlined,
                        color:
                            success ? Colors.green : PondropColors.warningColor,
                      ),
                    ),
                    Expanded(
                        child: Text(
                      success
                          ? l10n.success
                          : l10n.itemFailedPleaseTryAgain(l10n.submitting),
                    ))
                  ],
                )));
              },
              child: Text(l10n.send),
            ),
    );
  }
}
