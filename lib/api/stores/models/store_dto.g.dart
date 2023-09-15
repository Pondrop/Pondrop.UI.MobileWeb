// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreDto _$StoreDtoFromJson(Map<String, dynamic> json) => StoreDto(
      searchScore: (json['@search.score'] as num).toDouble(),
      id: json['id'] as String,
      name: json['name'] as String,
      status: json['status'] as String,
      externalReferenceId: json['externalReferenceId'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      openHours: json['openHours'] as String?,
      retailerId: json['retailerId'] as String?,
      retailer: json['retailer'] == null
          ? null
          : RetailerDto.fromJson(json['retailer'] as Map<String, dynamic>),
      storeTypeId: json['storeTypeId'] as String?,
      addressLine1: json['addressLine1'] as String?,
      suburb: json['suburb'] as String?,
      state: json['state'] as String?,
      postcode: json['postcode'] as String?,
      country: json['country'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      isCommunityStore: json['isCommunityStore'] as bool,
    );

Map<String, dynamic> _$StoreDtoToJson(StoreDto instance) => <String, dynamic>{
      '@search.score': instance.searchScore,
      'id': instance.id,
      'externalReferenceId': instance.externalReferenceId,
      'name': instance.name,
      'status': instance.status,
      'phone': instance.phone,
      'openHours': instance.openHours,
      'retailerId': instance.retailerId,
      'retailer': instance.retailer,
      'storeTypeId': instance.storeTypeId,
      'email': instance.email,
      'addressLine1': instance.addressLine1,
      'suburb': instance.suburb,
      'state': instance.state,
      'postcode': instance.postcode,
      'country': instance.country,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'isCommunityStore': instance.isCommunityStore,
    };
