import 'package:json_annotation/json_annotation.dart';

part 'store_visit_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class StoreVisitDto {
  StoreVisitDto({
    required this.id,
    required this.storeId,
    required this.userId,
    required this.latitude,
    required this.longitude,
  });

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'storeId')
  final String storeId;
  @JsonKey(name: 'userId')
  final String userId;

  @JsonKey(name: 'latitude')
  final double latitude;
  @JsonKey(name: 'longitude')
  final double longitude;
  
  static StoreVisitDto fromJson(Map<String, dynamic> json) =>
    _$StoreVisitDtoFromJson(json);

  Map<String, dynamic> toJson() =>
    _$StoreVisitDtoToJson(this);
}
