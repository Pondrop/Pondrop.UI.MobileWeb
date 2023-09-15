import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:pondrop/models/models.dart';

class Store extends Equatable {
  const Store({
    required this.id,
    required this.retailer,
    required this.name,
    required this.displayName,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.communityStore,
    required this.lastKnowDistanceMetres,
    this.categoryCampaigns = const [],
    this.productCampaigns = const [],
  });

  final String id;
  final String retailer;
  final String name;
  final String displayName;
  final String address;
  final double latitude;
  final double longitude;
  final bool communityStore;
  final double lastKnowDistanceMetres;

  final List<TaskIdentifier> categoryCampaigns;
  final List<TaskIdentifier> productCampaigns;

  int get campaignCount => categoryCampaigns.length + productCampaigns.length;

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

  Store copyWith({
    double? lastKnowDistanceMetres,
    List<TaskIdentifier>? categoryCampaigns,
    List<TaskIdentifier>? productCampaigns,
  }) {
    return Store(
      id: id,
      retailer: retailer,
      name: name,
      displayName: displayName,
      address: address,
      latitude: latitude,
      longitude: longitude,
      communityStore: communityStore,
      lastKnowDistanceMetres:
          lastKnowDistanceMetres ?? this.lastKnowDistanceMetres,
      categoryCampaigns: categoryCampaigns ?? this.categoryCampaigns,
      productCampaigns: productCampaigns ?? this.productCampaigns,
    );
  }

  @override
  List<Object> get props => [
        id,
        retailer,
        name,
        address,
        latitude,
        longitude,
        communityStore,
        lastKnowDistanceMetres,
        categoryCampaigns,
        productCampaigns
      ];
}
