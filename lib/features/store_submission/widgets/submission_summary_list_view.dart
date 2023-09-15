import 'dart:io';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pondrop/extensions/extensions.dart';
import 'package:pondrop/api/submission_api.dart';
import 'package:pondrop/features/store_submission/widgets/focus_header_view.dart';
import 'package:pondrop/models/store_submission.dart';
import 'package:pondrop/features/styles/styles.dart';

import 'submission_field_view.dart';

class SubmissionSummaryListView extends StatelessWidget {
  const SubmissionSummaryListView(
      {super.key,
      required this.submission,
      required this.stepIdx,
      this.readOnly = false});

  final StoreSubmission submission;
  final int stepIdx;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final step = submission.steps[stepIdx];
    final fields = step.fields;

    assert(step.isSummary,
        '"SubmissionSummaryListView" invalid state, current step must be summary');

    final listViewLength = stepIdx + fields.length + 1;

    return ListView.builder(
        padding: const EdgeInsets.fromLTRB(
            Dims.large, Dims.small, Dims.large, Dims.xLarge),
        controller: ModalScrollController.of(context),
        itemBuilder: (BuildContext context, int index) {
          if (index == listViewLength - 1) {
            if (submission.result?.completedDate != null) {
              return Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                      padding: Dims.xSmallEdgeInsets,
                      child: Text(submission.result!.completedDate
                          .toLocal()
                          .toShortString(context))));
            }

            return const SizedBox.shrink();
          }

          if (index < stepIdx) {
            if (submission.steps[index].isEmpty) {
              return const SizedBox.shrink();
            }

            return Column(
              children: [
                if (index > 0 && !submission.steps[index - 1].isFocus)
                  Divider(
                      indent: Dims.large,
                      height: Dims.small,
                      thickness: 1,
                      color: Colors.grey[400]),
                _stepItem(context, submission.steps[index])
              ],
            );
          }

          final field = fields[index - stepIdx];
          return Column(
            children: [
              if (index == stepIdx)
                Padding(
                  padding: Dims.xLargeBottomEdgeInsets,
                  child: Divider(
                      indent: Dims.large,
                      height: Dims.small,
                      thickness: 1,
                      color: Colors.grey[400]),
                ),
              _summaryFieldItem(context, field)
            ],
          );
        },
        itemCount: listViewLength);
  }

  Widget _stepItem(BuildContext context, StoreSubmissionStep step) {
    if (step.isFocus) {
      return FocusHeaderView(
        title: step.fields.first.toResultString(),
        itemType: step.fields.first.itemType ?? SubmissionFieldItemType.unknown,
      );
    }

    final photoWidgets = <Widget>[];
    final textWidgets = <Widget>[];

    for (final i in step.fields.where((e) => !e.results.first.isEmpty)) {
      if (i.fieldType == SubmissionFieldType.photo) {
        photoWidgets.add(_photoCard(Image.file(
          File(i.results.first.photoPathValue!),
          fit: BoxFit.cover,
          width: 72,
          height: 72,
        )));
      } else {
        textWidgets.add(Text(
          i.label,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.grey, fontWeight: FontWeight.w400),
        ));
        textWidgets.add(const SizedBox(
          height: Dims.xSmall,
        ));
        textWidgets.add(Text(
            i.toResultString(
                separator: '\n',
                locale: Localizations.localeOf(context).toString()),
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(fontWeight: FontWeight.w400)));
        textWidgets.add(const SizedBox(
          height: Dims.small,
        ));
      }
    }

    if (photoWidgets.isEmpty) {
      photoWidgets.add(_photoCard(const SizedBox(
        width: 72,
        height: 72,
        child: Center(child: Icon(Icons.no_photography_outlined)),
      )));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dims.small),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            step.title.toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: Dims.small,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: photoWidgets,
              ),
              const SizedBox(
                width: Dims.small,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: textWidgets,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _photoCard(Widget child) {
    return Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: child);
  }

  Widget _summaryFieldItem(BuildContext context, StoreSubmissionField field) {
    return Padding(
        padding: Dims.largeBottomEdgeInsets,
        child: SubmissionFieldView(
          field: field,
          readOnly: readOnly,
        ));
  }
}
