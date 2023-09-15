import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pondrop/features/styles/styles.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/models/models.dart';

import '../bloc/shopping_list_bloc.dart';

class ListItem extends StatelessWidget {
  const ListItem({super.key, required this.item});

  final ShoppingListItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              Dims.small, Dims.medium, 0, Dims.xSmall),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: Dims.mediumEdgeInsets,
                    child: Checkbox(
                      value: item.checked,
                      onChanged: (value) {
                        final bloc = context.read<ShoppingListBloc>();
                        bloc.add(
                            ItemChecked(id: item.id, checked: value ?? false));
                      },
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: item.checked
                                ? Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: Colors.grey[600],
                                        decoration: TextDecoration.lineThrough)
                                : Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: Dims.mediumEdgeInsets,
                    child: Icon(Icons.drag_indicator),
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
