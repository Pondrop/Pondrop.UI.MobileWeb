import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pondrop/features/dialogs/dialogs.dart';

import '../../../helpers/helpers.dart';

void main() {

  setUp(() {
  });

  group('DialogPage', () {
    test('is routable', () {
      expect(DialogPage.route(const DialogConfig(okayButtonText: 'OK')), isA<PageRoute>());
    });

    testWidgets('renders a Dialog', (tester) async {
      await tester.pumpAppWithRoute((settings) {
        return DialogPage.route(const DialogConfig(okayButtonText: 'OK'));
      });

      await tester.pumpAndSettle();

      expect(find.byType(DialogPage), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
    });

    testWidgets('renders a Dialog with cancel button', (tester) async {
      const cancelText = 'Close me';

      await tester.pumpAppWithRoute((settings) {
        return DialogPage.route(const DialogConfig(okayButtonText: 'OK', cancelButtonText: cancelText));
      });

      await tester.pumpAndSettle();

      expect(find.text(cancelText), findsOneWidget);
    });

    testWidgets('renders a Dialog with title', (tester) async {
      const titleText = 'A dialog title';

      await tester.pumpAppWithRoute((settings) {
        return DialogPage.route(const DialogConfig(okayButtonText: 'OK', title: titleText));
      });

      await tester.pumpAndSettle();

      expect(find.text(titleText), findsOneWidget);
    });

    testWidgets('renders a Dialog with header', (tester) async {
      const headerText = 'A dialog header';

      await tester.pumpAppWithRoute((settings) {
        return DialogPage.route(const DialogConfig(okayButtonText: 'OK', header: headerText));
      });

      await tester.pumpAndSettle();

      expect(find.text(headerText), findsOneWidget);
    });

    testWidgets('renders a Dialog with body', (tester) async {
      const bodyText = 'A dialog body';

      await tester.pumpAppWithRoute((settings) {
        return DialogPage.route(const DialogConfig(okayButtonText: 'OK', body: bodyText));
      });

      await tester.pumpAndSettle();

      expect(find.text(bodyText), findsOneWidget);
    });

    testWidgets('renders a Dialog with icon', (tester) async {
      const iconData = Icons.shopping_bag;

      await tester.pumpAppWithRoute((settings) {
        return DialogPage.route(const DialogConfig(okayButtonText: 'OK', iconData: iconData));
      });

      await tester.pumpAndSettle();

      expect(find.byIcon(iconData), findsOneWidget);
    });
  });
}
