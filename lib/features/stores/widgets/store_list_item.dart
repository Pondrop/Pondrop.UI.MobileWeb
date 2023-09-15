import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pondrop/features/stores/bloc/store_bloc.dart';
import 'package:pondrop/features/styles/styles.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/models/store.dart';
import 'package:pondrop/features/store_report/store_report.dart';

class StoreListItem extends StatelessWidget {
  const StoreListItem({super.key, required this.store});

  final Store store;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final distanceString = store.getDistanceDisplayString();

    return InkWell(
        onTap: () async {
          final bloc = context.read<StoreBloc>();
          final taskIdentifiers =
              await Navigator.of(context).push(StoreReportPage.route(store));
          bloc.add(
              StoreCompletedTasks(completedTasks: taskIdentifiers ?? const []));
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              Dims.large, Dims.medium, 0, Dims.xSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
              if (store.campaignCount > 0)
                Padding(
                  padding: Dims.xSmallTopEdgeInsets,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: PondropColors.badgeBgBlueColor,
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: Dims.xSmall, horizontal: Dims.small),
                      child: Text(
                          store.campaignCount == 1
                              ? l10n.itemTask(store.campaignCount)
                              : l10n.itemTasks(store.campaignCount),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: PondropColors.badgeFgBlueColor,
                          )),
                    ),
                  ),
                ),
              const SizedBox(height: Dims.small),
              Divider(
                thickness: 1,
                height: 1,
                color: Colors.grey[300],
              ),
            ],
          ),
        ));
  }
}
