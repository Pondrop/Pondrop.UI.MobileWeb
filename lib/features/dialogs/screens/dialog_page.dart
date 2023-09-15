import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pondrop/features/styles/styles.dart';

class DialogConfig {
  const DialogConfig({
    this.title = '',
    this.iconData,
    this.header = '',
    this.body = '',
    required this.okayButtonText,
    this.cancelButtonText = '',
  });

  final String title;
  final IconData? iconData;
  final String header;
  final String body;
  final String okayButtonText;
  final String cancelButtonText;
}

class DialogPage extends StatelessWidget {
  const DialogPage({super.key});

  static Route<bool> route(DialogConfig config) {
    return RouteTransitions.modalTransparentDialogRoute<bool>(
        pageBuilder: (_) => const DialogPage(),
        settings: RouteSettings(arguments: config));
  }

  @override
  Widget build(BuildContext context) {
    final config = ModalRoute.of(context)!.settings.arguments as DialogConfig;

    final children = <Widget>[];
    const separator = SizedBox(
      height: Dims.medium,
    );

    if (config.title.isNotEmpty) {
      children.add(Text(
        config.title,
        style: Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
      ));
      children.add(separator);
    }

    if (config.iconData != null) {
      children.add(Padding(
        padding: Dims.smallEdgeInsets,
        child: Icon(
          config.iconData,
          color: Colors.white,
          size: 96,
        ),
      ));
      children.add(separator);
    }

    if (config.header.isNotEmpty) {
      children.add(Text(config.header,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: Colors.white, fontWeight: FontWeight.w600)));
      children.add(const SizedBox(
        height: Dims.small,
      ));
    }

    if (config.body.isNotEmpty) {
      children.add(Text(config.body,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: Colors.white,
              )));
      children.add(separator);
    }

    children.add(const SizedBox(
      height: Dims.xxLarge,
    ));
    children.add(ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop(true);
      },
      style: PondropStyles.whiteElevatedButtonStyle,
      child: Text(config.okayButtonText,
          style: PondropStyles.blackButtonTextStyle),
    ));
    children.add(separator);

    if (config.cancelButtonText.isNotEmpty) {
      children.add(TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(config.cancelButtonText,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: Colors.white,
                  ))));
    }

    return Container(
      color: Colors.black.withOpacity(0.5),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 2,
          sigmaY: 2,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dims.xLarge, vertical: Dims.xLarge),
          child: Center(
            child: SizedBox(
              width: double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                color: Colors.black.withOpacity(0.75),
                child: Stack(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dims.xLarge, vertical: Dims.large),
                    child: SingleChildScrollView(
                      child: Center(
                        child: Padding(
                          padding: Dims.smallEdgeInsets,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: children),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: Dims.medium,
                    top: Dims.medium,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop(null);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
