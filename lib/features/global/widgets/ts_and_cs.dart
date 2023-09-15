import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pondrop/features/global/global.dart';
import 'package:pondrop/features/styles/styles.dart';
import 'package:pondrop/l10n/l10n.dart';

class TsAndCs extends StatelessWidget {
  const TsAndCs({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
        child: Padding(
      padding: Dims.smallBottomEdgeInsets,
      child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                  text: l10n.termsAndConditions,
                  style: _linkStyle(context: context),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.of(context).push(LocalWebPage.route(
                          l10n.termsAndConditions, 'assets/terms.html'));
                    }),
              const TextSpan(text: '\n\n'),
              TextSpan(
                  text: l10n.privacyPolicy,
                  style: _linkStyle(context: context),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.of(context).push(LocalWebPage.route(
                          l10n.privacyPolicy, 'assets/privacy.html'));
                    }),
            ],
          )),
    ));
  }

  TextStyle _linkStyle({required BuildContext context}) {
    return Theme.of(context).textTheme.caption!.copyWith(
        color: PondropColors.linkColor,
        decoration: TextDecoration.underline,
        fontSize: 10,
        fontWeight: FontWeight.w600);
  }
}
