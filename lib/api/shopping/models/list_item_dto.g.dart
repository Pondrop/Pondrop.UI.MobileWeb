// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListItemDto _$ListItemDtoFromJson(Map<String, dynamic> json) => ListItemDto(
      id: json['id'] as String,
      name: json['itemTitle'] as String,
      categoryId: json['selectedCategoryId'] as String,
      selectedProductId: json['selectedProductId'] as String?,
      storeId: json['storeId'] as String?,
      checked: json['checked'] as bool,
      preferenceIds: (json['selectedPreferenceIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      sortOrder: json['sortOrder'] as int,
      createdUtc: DateTime.parse(json['createdUtc'] as String),
      updatedUtc: DateTime.parse(json['updatedUtc'] as String),
    );

Map<String, dynamic> _$ListItemDtoToJson(ListItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'itemTitle': instance.name,
      'selectedCategoryId': instance.categoryId,
      'selectedProductId': instance.selectedProductId,
      'storeId': instance.storeId,
      'checked': instance.checked,
      'selectedPreferenceIds': instance.preferenceIds,
      'sortOrder': instance.sortOrder,
      'createdUtc': instance.createdUtc.toIso8601String(),
      'updatedUtc': instance.updatedUtc.toIso8601String(),
    };
