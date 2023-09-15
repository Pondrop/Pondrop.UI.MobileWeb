// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_list_store_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingListStoreDto _$ShoppingListStoreDtoFromJson(
        Map<String, dynamic> json) =>
    ShoppingListStoreDto(
      storeId: json['storeId'] as String,
      name: json['storeTitle'] as String,
      sortOrder: json['sortOrder'] as int,
    );

Map<String, dynamic> _$ShoppingListStoreDtoToJson(
        ShoppingListStoreDto instance) =>
    <String, dynamic>{
      'storeId': instance.storeId,
      'storeTitle': instance.name,
      'sortOrder': instance.sortOrder,
    };
