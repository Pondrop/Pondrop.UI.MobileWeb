import 'package:flutter/widgets.dart';

class RouteTransitions {
  static Route<T> modalTransparentDialogRoute<T>(
      {required Widget Function(BuildContext context) pageBuilder,
      RouteSettings? settings}) {
    return PageRouteBuilder<T>(
        opaque: false,
        pageBuilder: (context, __, ___) => pageBuilder(context),
        settings: settings);
  }

  static Route<T> modalSlideRoute<T>(
      {required Widget Function(BuildContext context) pageBuilder,
      RouteSettings? settings,
      Duration transitionDuration = const Duration(milliseconds: 300),
      Duration reverseTransitionDuration = Duration.zero}) {
    return PageRouteBuilder<T>(
        pageBuilder: (context, __, ___) => pageBuilder(context),
        settings: settings,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0, 1);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end);
          final offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        transitionDuration: transitionDuration,
        reverseTransitionDuration: reverseTransitionDuration);
  }
}
