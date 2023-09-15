import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pondrop/api/submission_api.dart';
import 'package:pondrop/features/create_product/screens/create_product_page.dart';
import 'package:pondrop/features/global/global.dart';
import 'package:pondrop/features/search_items/bloc/search_items_bloc.dart';
import 'package:pondrop/features/search_items/search_items.dart';
import 'package:pondrop/features/styles/styles.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:tuple/tuple.dart';

import '../../bloc/store_submission_bloc.dart';

class SearchFieldControl extends StatelessWidget {
  const SearchFieldControl(
      {super.key, required this.field, this.readOnly = false});

  static Key getSearchButtonKey(String fieldId) {
    return Key('SearchFieldControl_SearchBtn_$fieldId');
  }

  static Key getClearButtonKey(String fieldId, int hashCode) {
    return Key('SearchFieldControl_ClearBtn_${fieldId}_$hashCode');
  }

  final StoreSubmissionField field;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final children = <Widget>[];

    for (final i in field.results.where((e) => !e.isEmpty)) {
      final idx = field.results.indexOf(i);
      children.add(TextFormField(
        key: Key('SearchFieldControl_Txt_${field.fieldId}_${i.hashCode}}'),
        initialValue: i.itemValue?.itemName ?? '',
        maxLines: 3,
        minLines: 1,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: field.label,
          suffixIcon: !readOnly
              ? IconButton(
                  key: SearchFieldControl.getClearButtonKey(
                      field.fieldId, i.hashCode),
                  icon: const Icon(Icons.cancel_outlined),
                  onPressed: () {
                    context.read<StoreSubmissionBloc>().add(
                        StoreSubmissionFieldResultEvent(
                            stepId: field.stepId,
                            fieldId: field.fieldId,
                            result: StoreSubmissionFieldResult(),
                            resultIdx: field.results.indexOf(i)));
                  },
                )
              : null,
        ),
        focusNode: AlwaysDisabledFocusNode(),
        readOnly: true,
      ));

      children.add(const SizedBox(
        height: Dims.medium,
      ));
    }

    if (children.isNotEmpty) {
      children.removeLast();
    }

    // Check number of results against max value (defaulting to 1)
    if (field.results.where((e) => !e.isEmpty).length < (field.maxValue ?? 1)) {
      if (children.isNotEmpty) {
        children.add(const SizedBox(
          height: Dims.small,
        ));
      }

      children.add(SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
            key: SearchFieldControl.getSearchButtonKey(field.fieldId),
            icon: const Icon(Icons.add),
            label: Text(l10n.addItem(l10n.product.toLowerCase())),
            onPressed: !readOnly && field.itemType != null
                ? () async {
                    final bloc = context.read<StoreSubmissionBloc>();
                    final nav = Navigator.of(context);

                    final result = await nav.push(SearchItemPage.route(
                        type: field.itemType!.toSearchItemType(),
                        excludeIds: field.results
                            .where(
                                (e) => e.itemValue?.itemName.isNotEmpty == true)
                            .map((e) => e.itemValue!.itemId)
                            .toList(),
                        actionButtonText:
                            field.itemType == SubmissionFieldItemType.product
                                ? l10n.createNewItem(l10n.product.toLowerCase())
                                : '',
                        actionButtonOnTap: field.itemType ==
                                SubmissionFieldItemType.product
                            ? (BuildContext context) async {
                                final searchBloc =
                                    context.read<SearchItemsBloc>();
                                final searchTerm =
                                    searchBloc.state.query.trim();

                                var name = '';
                                var barcode = '';

                                if (EanValidator.validChecksum(searchTerm)) {
                                  barcode = searchTerm;
                                } else {
                                  name = searchTerm;
                                }

                                final result =
                                    await showCupertinoModalBottomSheet<
                                        Tuple2<String, String>?>(
                                  context: context,
                                  builder: (context) => kDebugMode
                                      ? CreateProductPage(
                                          name: name.isEmpty
                                              ? 'Test product'
                                              : name,
                                          barcode: barcode.isEmpty
                                              ? '9323222999992'
                                              : barcode,
                                        )
                                      : CreateProductPage(
                                          name: name,
                                          barcode: barcode,
                                        ),
                                  enableDrag: false,
                                );

                                if (result?.item1.isNotEmpty == true &&
                                    result?.item2.isNotEmpty == true) {
                                  nav.pop([
                                    SearchItem(
                                        id: '',
                                        title: result!.item1,
                                        barcode: result.item2)
                                  ]);
                                }
                              }
                            : null,
                        productRepository:
                            RepositoryProvider.of<ProductRepository>(context)));

                    if (result?.isNotEmpty == true) {
                      _addResult(bloc, result!.first.id, result.first.title,
                          result.first.barcode);
                    }
                  }
                : null),
      ));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }

  void _addResult(
      StoreSubmissionBloc bloc, String id, String name, String? barcode) {
    bloc.add(StoreSubmissionFieldResultEvent(
        stepId: field.stepId,
        fieldId: field.fieldId,
        result: StoreSubmissionFieldResult(
            itemValue: StoreSubmissionFieldResultItem(
                itemId: id, itemName: name, itemBarcode: barcode)),
        // updated the first result if empty,
        // otherwise append a new result
        resultIdx: field.results.length == 1 && field.results.first.isEmpty
            ? 0
            : (field.maxValue ?? 0) + 1));
  }
}
