import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class Address extends Equatable {
  const Address(
      {required this.addressLine1,
      required this.addressLine2,
      required this.suburb,
      required this.state,
      required this.postcode,
      required this.country,
      required this.latitude,
      required this.longitude,
      required this.lastKnowDistanceMetres});

  final String addressLine1;
  final String addressLine2;
  final String suburb;
  final String state;
  final String postcode;
  final String country;
  final double latitude;
  final double longitude;
  final double lastKnowDistanceMetres;
  

  String getDistanceDisplayString() {
    if (lastKnowDistanceMetres < 0) {
      return '';
    }

    if (lastKnowDistanceMetres >= 1000000) {
      return '${NumberFormat('#,##0').format(lastKnowDistanceMetres / 1000)}km';
    } else {
      return lastKnowDistanceMetres >= 1000
          ? '${NumberFormat('#,##0.0').format(lastKnowDistanceMetres / 1000)}km'
          : '${lastKnowDistanceMetres.toStringAsFixed(0)}m';
    }
  }

  @override
  List<Object> get props =>
      [addressLine1, addressLine2, suburb, state, postcode, country, latitude, longitude, lastKnowDistanceMetres];
}