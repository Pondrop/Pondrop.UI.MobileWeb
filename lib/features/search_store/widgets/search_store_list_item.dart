import 'package:flutter/material.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/features/store_report/store_report.dart';
import 'package:pondrop/features/styles/styles.dart';

class SearchStoreListItem extends StatelessWidget {
  const SearchStoreListItem({super.key, required this.store});

  final Store store;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final distanceString = store.getDistanceDisplayString();

    return InkWell(
        onTap: () async {
          await Navigator.of(context).push(StoreReportPage.route(store));
        },
        child: Padding(
            padding: const EdgeInsets.fromLTRB(
                Dims.xSmall, Dims.medium, 0, Dims.xSmall),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dims.medium),
                  child: Icon(
                    Icons.search,
                    size: 22,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(store.displayName,
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: Dims.small),
                      Text(
                        distanceString.isNotEmpty
                            ? l10n.itemHyphenItem(distanceString, store.address)
                            : store.address,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.caption,
                      ),
                      const SizedBox(height: Dims.small),
                      Divider(
                        thickness: 1,
                        height: 1,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}
