import 'package:flutter/material.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/features/styles/styles.dart';

class SubmissionFailedView extends StatelessWidget {
  const SubmissionFailedView({Key? key}) : super(key: key);

  static Route route() {
    return RouteTransitions.modalSlideRoute(
        pageBuilder: (_) => const SubmissionFailedView());
  }

  static const okayButtonKey = Key('SubmissionFailedView_Okay_Button');

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: Dims.xxLargeEdgeInsets,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            const Icon(
              Icons.warning_amber_outlined,
              color: PondropColors.warningColor,
              size: 128,
            ),
            const SizedBox(
              height: Dims.large,
            ),
            Text(
              l10n.submissionPending,
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(
              height: Dims.medium,
            ),
            Text(
              l10n.submissionPendingDescription,
              style:
                  Theme.of(context).textTheme.bodyText1!.copyWith(height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: Dims.xxLarge * 2,
            ),
            ElevatedButton(
                key: okayButtonKey,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(l10n.gotIt)),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
