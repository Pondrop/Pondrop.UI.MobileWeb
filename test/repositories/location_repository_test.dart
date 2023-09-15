import 'package:flutter_test/flutter_test.dart';
import 'package:geocode/geocode.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/repositories/repositories.dart';

class MockGeoCode extends Mock implements GeoCode {}

void main() {
  late MockGeoCode geoCode;

  setUp(() {
    geoCode = MockGeoCode();
  });

  group('LocationRepository', () {
    test('Construct an instance', () {
      expect(LocationRepository(geoCode: geoCode), isA<LocationRepository>());
    });

    test('Empty position', () {
      const emptyPosition = LocationRepository.emptyPosition;

      expect(
        emptyPosition.longitude,
        0,
      );
      expect(emptyPosition.latitude, 0);
      expect(emptyPosition.timestamp, null);
      expect(emptyPosition.accuracy, 0);
      expect(emptyPosition.altitude, 0);
      expect(emptyPosition.heading, 0);
      expect(emptyPosition.speed, 0);
      expect(emptyPosition.speedAccuracy, 0);
    });
  });
}
