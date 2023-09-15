import 'package:flutter/material.dart';
import 'package:pondrop/api/submissions/models/submission_template_field_dto.dart';
import 'package:pondrop/features/styles/styles.dart';

class FocusHeaderView extends StatelessWidget {
  const FocusHeaderView({Key? key, required this.title, required this.itemType})
      : super(key: key);

  final String title;
  final SubmissionFieldItemType itemType;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: Dims.mediumEdgeInsets,
          decoration: BoxDecoration(
              color: PondropColors.primaryLightColor,
              borderRadius: BorderRadius.circular(100)),
          child: Icon(
            _getItemIconData(),
            color: Colors.black,
            size: Dims.xxLarge * 1.25,
          ),
        ),
        const SizedBox(
          height: Dims.small,
        ),
        Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        const SizedBox(
          height: Dims.medium,
        )
      ],
    );
  }

  IconData _getItemIconData() {
    switch (itemType) {
      case SubmissionFieldItemType.product:
        return Icons.inventory_2_outlined;
      case SubmissionFieldItemType.category:
        return Icons.category_outlined;
      default:
        return Icons.question_mark_outlined;
    }
  }
}
