import 'package:flutter/material.dart';
import 'package:pondrop/api/submission_api.dart';
import 'package:pondrop/features/global/global.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/features/styles/styles.dart';

class StoreTaskListItem extends StatelessWidget {
  const StoreTaskListItem(
      {super.key,
      required this.submissionTemplate,
      this.submissionResult,
      this.onTap});

  final SubmissionTemplateDto submissionTemplate;
  final StoreSubmission? submissionResult;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    var photoCount = 0;
    var focusName = '';

    if (submissionResult?.steps.isNotEmpty == true) {
      photoCount = submissionResult!.steps
          .expand((e) => e.fields
              .where((e) => e.results.first.photoPathValue?.isNotEmpty == true))
          .length;
      focusName = submissionResult!.steps
          .expand((e) => e.fields
              .where((e) => e.fieldType == SubmissionFieldType.focus)
              .map((e) => e.toResultString()))
          .where((e) => e.isNotEmpty)
          .join(', ');
    }

    final safeCodePoint = IconValidator.safeIconCodePoint(
        submissionTemplate.iconFontFamily, submissionTemplate.iconCodePoint);

    return InkWell(
        onTap: () {
          onTap?.call();
        },
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Dims.small),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: Dims.large),
                        child: Container(
                          padding: Dims.mediumEdgeInsets,
                          decoration: BoxDecoration(
                              color: PondropColors.primaryLightColor,
                              borderRadius: BorderRadius.circular(100)),
                          child: Icon(
                            IconData(safeCodePoint.item2,
                                fontFamily: safeCodePoint.item1),
                            color: Colors.black,
                          ),
                        )),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(submissionTemplate.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                          const SizedBox(height: Dims.small),
                          Text(
                            focusName.isEmpty
                                ? submissionTemplate.description
                                : focusName,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                    if (photoCount > 0)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                            Dims.small, 0, Dims.medium, 0),
                        child: Row(
                          children: [
                            const Icon(Icons.photo_library_outlined),
                            const SizedBox(
                              width: 2,
                            ),
                            Text('$photoCount'),
                          ],
                        ),
                      )
                  ],
                ),
                const SizedBox(height: Dims.small),
                Divider(
                  indent: 72,
                  thickness: 1,
                  height: 1,
                  color: Colors.grey[300],
                ),
              ],
            )));
  }
}
