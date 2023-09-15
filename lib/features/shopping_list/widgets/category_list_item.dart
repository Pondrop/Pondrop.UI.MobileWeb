import 'package:flutter/material.dart';
import 'package:pondrop/features/styles/styles.dart';
import 'package:pondrop/models/models.dart';

class CategoryListItem extends StatelessWidget {
  const CategoryListItem({super.key, required this.item, this.onTap});

  final Category item;
  final Function(BuildContext, Category)? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          onTap?.call(context, item);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dims.xxLarge, vertical: Dims.small),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(vertical: Dims.large),
                          child: Text(item.name,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Dims.small),
              Divider(
                thickness: 1,
                height: 1,
                color: Colors.grey[400],
              ),
            ],
          ),
        ));
  }
}
