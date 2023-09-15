// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingListDto _$ShoppingListDtoFromJson(Map<String, dynamic> json) =>
    ShoppingListDto(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$ShoppingListTypeEnumMap, json['shoppingListType']),
      stores: (json['stores'] as List<dynamic>)
          .map((e) => ShoppingListStoreDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      sharedListShoppers: (json['sharedListShoppers'] as List<dynamic>)
          .map((e) => SharedShopperDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      listItemIds: (json['listItemIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      sortOrder: json['sortOrder'] as int,
      createdUtc: DateTime.parse(json['createdUtc'] as String),
      updatedUtc: DateTime.parse(json['updatedUtc'] as String),
    );

Map<String, dynamic> _$ShoppingListDtoToJson(ShoppingListDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'shoppingListType': _$ShoppingListTypeEnumMap[instance.type]!,
      'stores': instance.stores,
      'sharedListShoppers': instance.sharedListShoppers,
      'listItemIds': instance.listItemIds,
      'sortOrder': instance.sortOrder,
      'createdUtc': instance.createdUtc.toIso8601String(),
      'updatedUtc': instance.updatedUtc.toIso8601String(),
    };

const _$ShoppingListTypeEnumMap = {
  ShoppingListType.unknown: 'unknown',
  ShoppingListType.grocery: 'grocery',
};
