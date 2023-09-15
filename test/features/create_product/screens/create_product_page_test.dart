import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pondrop/features/create_product/screens/create_product_page.dart';

import '../../../helpers/helpers.dart';

void main() {
  setUp(() {});

  group('Search Store', () {
    test('is routable', () {
      expect(CreateProductPage.route(), isA<MaterialPageRoute>());
    });

    testWidgets('renders a CreateProductPage', (tester) async {
      await tester.pumpApp(const CreateProductPage());

      expect(find.byKey(CreateProductPage.nameTextKey), findsOneWidget);
      expect(find.byKey(CreateProductPage.barcodeTextKey), findsOneWidget);
    });

    testWidgets('edit product name', (tester) async {
      const name = 'test product';

      await tester.pumpApp(const CreateProductPage());

      await tester.enterText(find.byKey(CreateProductPage.nameTextKey), name);
      expect(find.text(name), findsOneWidget);
    });

    testWidgets('intial name and barcode', (tester) async {
      const name = 'test product';
      const barcode = 'test barcode';

      await tester.pumpApp(const CreateProductPage(
        name: name,
        barcode: barcode,
      ));

      expect(find.text(name), findsOneWidget);
      expect(find.text(barcode), findsOneWidget);
    });
  });
}
