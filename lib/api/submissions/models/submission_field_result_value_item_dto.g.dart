// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_field_result_value_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmissionFieldResultValueItemDto _$SubmissionFieldResultValueItemDtoFromJson(
        Map<String, dynamic> json) =>
    SubmissionFieldResultValueItemDto(
      itemId: json['itemId'] as String,
      itemName: json['itemName'] as String,
      itemType: $enumDecode(_$SubmissionFieldItemTypeEnumMap, json['itemType']),
      itemBarcode: json['itemBarcode'] as String?,
    );

Map<String, dynamic> _$SubmissionFieldResultValueItemDtoToJson(
        SubmissionFieldResultValueItemDto instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'itemType': _$SubmissionFieldItemTypeEnumMap[instance.itemType]!,
      'itemBarcode': instance.itemBarcode,
    };

const _$SubmissionFieldItemTypeEnumMap = {
  SubmissionFieldItemType.unknown: 'unknown',
  SubmissionFieldItemType.product: 'product',
  SubmissionFieldItemType.category: 'category',
};
