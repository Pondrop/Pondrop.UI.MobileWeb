import 'package:flutter_test/flutter_test.dart';
import 'package:pondrop/repositories/repositories.dart';

void main() {
  setUp(() {});

  group('CameraRepository', () {
    test('Construct an instance', () {
      expect(const CameraRepository(), isA<CameraRepository>());
    });
  });
}
