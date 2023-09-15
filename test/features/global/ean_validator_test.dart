import 'package:flutter_test/flutter_test.dart';
import 'package:pondrop/features/global/global.dart';

void main() {
  setUp(() {});

group('invalid length', () {
    test('zero length', () {
      const input = '';

      final isValid = EanValidator.validChecksum(input);

      expect(isValid, equals(false));
    });

    test('too short', () {
      const input = '1234';

      final isValid = EanValidator.validChecksum(input);

      expect(isValid, equals(false));
    });

    test('too long', () {
      const barcode = '0000000000000000';

      final isValid = EanValidator.validChecksum(barcode);

      expect(isValid, equals(false));
    });
  });

  group('ean8', () {
    test('valid ean8 - 96385074', () {
      const ean8 = '96385074';

      final isValid = EanValidator.validChecksum(ean8);

      expect(isValid, equals(true));
    });

    test('valid ean8 - 94184600', () {
      const ean8 = '94184600';

      final isValid = EanValidator.validChecksum(ean8);

      expect(isValid, equals(true));
    });

    test('valid ean8 - 65833254', () {
      const ean8 = '65833254';

      final isValid = EanValidator.validChecksum(ean8);

      expect(isValid, equals(true));
    });

    test('invalid ean8 - 65833252', () {
      const ean8 = '65833252';

      final isValid = EanValidator.validChecksum(ean8);

      expect(isValid, equals(false));
    });
  });

  group('ean13', () {
    test('valid ean13 - 9323222999992', () {
      const ean13 = '9323222999992';

      final isValid = EanValidator.validChecksum(ean13);

      expect(isValid, equals(true));
    });

    test('valid ean13 - 2109876543210', () {
      const ean13 = '2109876543210';

      final isValid = EanValidator.validChecksum(ean13);

      expect(isValid, equals(true));
    });

    test('valid ean13 - 5901234123457', () {
      const ean13 = '5901234123457';

      final isValid = EanValidator.validChecksum(ean13);

      expect(isValid, equals(true));
    });

    test('invalid ean13 - 5901234123450', () {
      const ean13 = '5901234123450';

      final isValid = EanValidator.validChecksum(ean13);

      expect(isValid, equals(false));
    });
  });
}
