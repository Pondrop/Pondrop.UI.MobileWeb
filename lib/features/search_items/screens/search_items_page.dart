import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pondrop/features/styles/styles.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/features/search_items/search_items.dart';

class SearchItemPage extends StatelessWidget {
  const SearchItemPage(
      {Key? key,
      required this.type,
      required this.enableBack,
      this.actionButtonIconData = Icons.add,
      this.actionButtonText = '',
      this.actionButtonOnTap,
      this.excludedIds = const [],
      this.productRepository})
      : super(key: key);

  static const searchTextFieldKey = Key('SearchItemPage_SearchText_Key');

  final SearchItemType type;
  final bool enableBack;

  final IconData actionButtonIconData;
  final String actionButtonText;
  final Function(BuildContext)? actionButtonOnTap;

  final List<String> excludedIds;

  final ProductRepository? productRepository;

  static Route<List<SearchItem>> route(
      {required SearchItemType type,
      bool enableBack = true,
      IconData actionButtonIconData = Icons.add,
      String actionButtonText = '',
      Function(BuildContext)? actionButtonOnTap,
      List<String> excludeIds = const [],
      ProductRepository? productRepository}) {
    return MaterialWithModalsPageRoute<List<SearchItem>>(
        builder: (_) => SearchItemPage(
              type: type,
              enableBack: enableBack,
              actionButtonIconData: actionButtonIconData,
              actionButtonText: actionButtonText,
              actionButtonOnTap: actionButtonOnTap,
              excludedIds: excludeIds,
              productRepository: productRepository,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return SearchBlocProvider(
        type: type,
        productRepository: productRepository,
        child: WillPopScope(
          onWillPop: () async => enableBack,
          child: Scaffold(
              appBar: AppBar(
                  leading: enableBack ? null : const Icon(Icons.search),
                  title: SearchItemInput(type: type)),
              body: Stack(
                children: [
                  SearchItemsList(
                      header: context.l10n.searchResults.toUpperCase(),
                      onTap: (BuildContext context, SearchItem item) async {
                        Navigator.of(context).pop([item]);
                      },
                      excludedIds: excludedIds),
                  if (actionButtonOnTap != null)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: Dims.xxLargeEdgeInsets,
                        child: Padding(
                          padding: Dims.largeBottomEdgeInsets,
                          child: SizedBox(
                            width: double.infinity,
                            child: Builder(
                              builder: (context) {
                                return ElevatedButton.icon(
                                    icon: Icon(actionButtonIconData),
                                    label: Text(actionButtonText),
                                    onPressed: () => actionButtonOnTap?.call(context));
                              }
                            ),
                          ),
                        ),
                      ),
                    )
                ],
              )),
        ));
  }
}
