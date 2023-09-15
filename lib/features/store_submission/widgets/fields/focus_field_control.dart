import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pondrop/features/search_items/search_items.dart';
import 'package:pondrop/features/store_submission/bloc/store_submission_bloc.dart';
import 'package:pondrop/features/styles/styles.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/models/models.dart';

class FocusFieldControl extends StatelessWidget {
  const FocusFieldControl({super.key, required this.field});

  final StoreSubmissionField field;

  @override
  Widget build(BuildContext context) {
    return SearchBlocProvider(
        type: field.itemType!.toSearchItemType(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dims.small),
              child: Row(
                children: [
                  const Center(child: Icon(Icons.search_outlined)),
                  const SizedBox(
                    width: Dims.medium,
                  ),
                  Expanded(
                    child: SearchItemInput(
                        type: field.itemType!.toSearchItemType()),
                  )
                ],
              ),
            ),
            Expanded(
              child: SearchItemsList(
                  header: context.l10n.searchResults.toUpperCase(),
                  onTap: (context, item) {
                    context
                        .read<StoreSubmissionBloc>()
                        .add(StoreSubmissionFieldResultEvent(
                            stepId: field.stepId,
                            fieldId: field.fieldId,
                            result: StoreSubmissionFieldResult(
                              itemValue: StoreSubmissionFieldResultItem(
                                  itemId: item.id, itemName: item.title),
                            ),
                            resultIdx: field.maxValue ?? 0));
                    context
                        .read<StoreSubmissionBloc>()
                        .add(const StoreSubmissionNextEvent());
                  }),
            )
          ],
        ));
  }
}
