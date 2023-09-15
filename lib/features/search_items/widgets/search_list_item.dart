import 'package:flutter/material.dart';
import 'package:pondrop/features/styles/styles.dart';

import '../models/models.dart';

class SearchListItem extends StatelessWidget {
  const SearchListItem({super.key, required this.item, this.onTap});

  final SearchItem item;
  final Function(BuildContext, SearchItem)? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onTap?.call(context, item),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              Dims.xLarge, Dims.medium, 0, Dims.xSmall),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (item.iconData != null)
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, Dims.large, 0),
                        child: Container(
                          padding: Dims.mediumEdgeInsets,
                          decoration: BoxDecoration(
                              color: PondropColors.primaryLightColor,
                              borderRadius: BorderRadius.circular(100)),
                          child: Icon(
                            item.iconData,
                            color: Colors.black,
                          ),
                        )),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.title,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium),
                        if (item.subtitle.isNotEmpty) ...[
                          const SizedBox(height: Dims.small),
                          Text(
                            item.subtitle,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Dims.small),
              Divider(
                indent: item.iconData != null ? Dims.xxLarge * 2.5 : null,
                thickness: 1,
                height: 1,
                color: Colors.grey[300],
              ),
            ],
          ),
        ));
  }
}
