import 'package:flutter/material.dart';
import 'package:pondrop/l10n/l10n.dart';

class RequiredView extends StatelessWidget {
  const RequiredView(
      {super.key,
      this.mainAxisAlignment = MainAxisAlignment.center,
      this.crossAxisAlignment = CrossAxisAlignment.end,
      this.padding = const EdgeInsets.fromLTRB(0, 0, 12, 0)});

  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Padding(
          padding: padding,
          child: Text(l10n.fieldRequired,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(fontStyle: FontStyle.italic)),
        ),
      ],
    );
  }
}
