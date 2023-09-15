import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pondrop/features/barcode_scanner/barcode_scanner.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/features/search_items/bloc/search_items_bloc.dart';
import 'package:pondrop/features/search_items/search_items.dart';

class SearchItemInput extends StatefulWidget {
  const SearchItemInput({Key? key, required this.type}) : super(key: key);

  static const searchTextFieldKey = Key('SearchTextBox_SearchText_Key');

  final SearchItemType type;

  @override
  State<SearchItemInput> createState() => _SearchItemInputState();
}

class _SearchItemInputState extends State<SearchItemInput> {
  final _searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final l10n = context.l10n;
      return TextField(
        key: SearchItemPage.searchTextFieldKey,
        autofocus: true,
        style: const TextStyle(fontSize: 20, color: Colors.black),
        controller: _searchTextController,
        decoration: InputDecoration(
            suffixIcon: BlocBuilder<SearchItemsBloc, SearchItemsState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (state.query.isNotEmpty)
                      IconButton(
                        tooltip: l10n.clear,
                        focusColor: Colors.black,
                        color: Colors.black,
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchTextController.clear();
                          context
                              .read<SearchItemsBloc>()
                              .add(const SearchTextChanged(text: ''));
                        },
                      ),
                    if (widget.type == SearchItemType.product)
                      IconButton(
                        tooltip: l10n.barcode,
                        focusColor: Colors.black,
                        color: Colors.black,
                        icon: SvgPicture.asset('assets/barcode_scanner.svg'),
                        onPressed: () async {
                          final bloc = context.read<SearchItemsBloc>();
                          final barcode = await Navigator.of(context)
                              .push(BarcodeScannerPage.route());
                          if (barcode?.isNotEmpty == true) {
                            _searchTextController.text = barcode!;
                            bloc.add(SearchTextChanged(text: barcode));
                          }
                        },
                      )
                  ],
                );
              },
            ),
            hintText: getHintText(context),
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey[500]),
            border: InputBorder.none,
            focusedBorder: InputBorder.none),
        onChanged: (text) {
          context.read<SearchItemsBloc>().add(SearchTextChanged(text: text));
        },
      );
    });
  }

  String getHintText(BuildContext context) {
    final l10n = context.l10n;
    switch (widget.type) {
      case SearchItemType.category:
        return l10n.searchCategoryName;
      case SearchItemType.product:
        return l10n.searchProductNameOrBarcode;
    }
  }
}
