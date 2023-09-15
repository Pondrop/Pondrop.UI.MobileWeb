// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_visit_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreVisitDto _$StoreVisitDtoFromJson(Map<String, dynamic> json) =>
    StoreVisitDto(
      id: json['id'] as String,
      storeId: json['storeId'] as String,
      userId: json['userId'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$StoreVisitDtoToJson(StoreVisitDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'storeId': instance.storeId,
      'userId': instance.userId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
