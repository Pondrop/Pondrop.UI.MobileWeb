import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pondrop/features/shopping_list/shopping_list.dart';
import 'package:pondrop/features/styles/styles.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/models/models.dart';

import '../bloc/shopping_bloc.dart';

class ListItem extends StatelessWidget {
  const ListItem({super.key, required this.list});

  final ShoppingList list;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return InkWell(
        onTap: () async {
          final bloc = context.read<ShoppingBloc>();
          final list = await Navigator.of(context)
              .push(ShoppingListPage.route(this.list.copyWith()));
          if (list?.id.isNotEmpty == true) {
            bloc.add(ListUpdated(list: list!));
          }
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              Dims.xLarge, Dims.medium, 0, Dims.xSmall),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, Dims.large, 0),
                      child: Container(
                        padding: Dims.mediumEdgeInsets,
                        decoration: BoxDecoration(
                            color: PondropColors.primaryLightColor,
                            borderRadius: BorderRadius.circular(100)),
                        child: Icon(
                          IconData(list.iconCodePoint,
                              fontFamily: list.iconFontFamily),
                          color: Colors.black,
                        ),
                      )),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(list.name,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: Dims.small),
                        Text(
                          list.itemCount == 1
                              ? l10n.itemItem(list.itemCount)
                              : l10n.itemItems(list.itemCount),
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Dims.small),
              Divider(
                indent: Dims.xxLarge * 2.5,
                thickness: 1,
                height: 1,
                color: Colors.grey[300],
              ),
            ],
          ),
        ));
  }
}
