import 'dart:async';

import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';

class LocationRepository {
  LocationRepository({
    required GeoCode geoCode,
  }) : _geoCode = geoCode;

  static const emptyPosition = Position(
      longitude: 0,
      latitude: 0,
      timestamp: null,
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0);

  final GeoCode _geoCode;

  Future<bool> isLocationServiceEnabled() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    return true;
  }

  Future<bool> checkAndRequestPermissions() async {
    final serviceEnabled = await isLocationServiceEnabled();

    if (serviceEnabled) {
      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      return permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    }

    return false;
  }

  Future<Position?> getLastKnownPosition() async {
    if (await checkAndRequestPermissions()) {
      return Geolocator.getLastKnownPosition();
    }

    return null;
  }

  Future<Position?> getCurrentPosition() async {
    if (await checkAndRequestPermissions()) {
      return Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(milliseconds: 6500));
    }

    return null;
  }

  Future<Position?> getLastKnownOrCurrentPosition(
      [Duration? maxLastKnownAge]) async {
    if (await checkAndRequestPermissions()) {
      final lastKnownPosition = await getLastKnownPosition();
      if (lastKnownPosition != null) {
        final isTooOld = maxLastKnownAge != null &&
            lastKnownPosition.timestamp != null &&
            DateTime.now().difference(lastKnownPosition.timestamp!) <
                maxLastKnownAge;

        if (!isTooOld) {
          return lastKnownPosition;
        }
      }

      return getCurrentPosition();
    }

    return null;
  }

  Future<Address> getAddress(Position position) async {
    return _geoCode.reverseGeocoding(
        latitude: position.latitude, longitude: position.longitude);
  }
}
