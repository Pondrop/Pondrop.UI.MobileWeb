import 'package:geolocator/geolocator.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pondrop/api/stores/models/models.dart';
import 'package:pondrop/api/stores/models/retailer_dto.dart';

part 'store_dto.g.dart';
part 'store_search_result_dto.dart';

@JsonSerializable()
class StoreDto {
  const StoreDto(
      {required this.searchScore,
      required this.id,
      required this.name,
      required this.status,
      required this.externalReferenceId,
      required this.phone,
      required this.email,
      required this.openHours,
      required this.retailerId,
      required this.retailer,
      required this.storeTypeId,
      required this.addressLine1,
      required this.suburb,
      required this.state,
      required this.postcode,
      required this.country,
      required this.latitude,
      required this.longitude,
      required this.isCommunityStore});

  @JsonKey(name: '@search.score')
  final double searchScore;
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'externalReferenceId')
  final String? externalReferenceId;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'phone')
  final String? phone;
  @JsonKey(name: 'openHours')
  final String? openHours;
  @JsonKey(name: 'retailerId')
  final String? retailerId;
  @JsonKey(name: 'retailer')
  final RetailerDto? retailer;
  @JsonKey(name: 'storeTypeId')
  final String? storeTypeId;
  @JsonKey(name: 'email')
  final String? email;
  @JsonKey(name: 'addressLine1')
  final String? addressLine1;
  @JsonKey(name: 'suburb')
  final String? suburb;
  @JsonKey(name: 'state')
  final String? state;
  @JsonKey(name: 'postcode')
  final String? postcode;
  @JsonKey(name: 'country')
  final String? country;
  @JsonKey(name: 'latitude')
  final double latitude;
  @JsonKey(name: 'longitude')
  final double longitude;
  @JsonKey(name: 'isCommunityStore')
  final bool isCommunityStore;

  double distanceInMeters(Position? position) {
    if (position == null) {
      return -1;
    }

    return Geolocator.distanceBetween(
        position.latitude, position.longitude, latitude, longitude);
  }

  static StoreDto fromJson(Map<String, dynamic> json) =>
      _$StoreDtoFromJson(json);

  Map<String, dynamic> toJson() => _$StoreDtoToJson(this);
}
