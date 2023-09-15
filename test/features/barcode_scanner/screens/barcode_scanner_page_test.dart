import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pondrop/features/barcode_scanner/barcode_scanner.dart';

import '../../../helpers/helpers.dart';

void main() {
  setUp(() {
  });

  group('Barcode Scanner', () {
    test('is routable', () {
      expect(BarcodeScannerPage.route(), isA<PageRoute>());
    });

    testWidgets('renders a MobileScanner', (tester) async {
      await tester.pumpApp(const BarcodeScannerPage());
      expect(find.byType(MobileScanner), findsOneWidget);
    });

    testWidgets('renders a MobileScanner with auto return', (tester) async {
      await tester.pumpApp(const BarcodeScannerPage(automaticallyReturn: true,));
      expect(find.byIcon(Icons.check), findsNothing);
      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('renders a MobileScanner with manual return', (tester) async {
      await tester.pumpApp(const BarcodeScannerPage(automaticallyReturn: false,));
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });
  });
}
