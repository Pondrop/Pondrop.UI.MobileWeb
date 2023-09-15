// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_template_field_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmissionTemplateFieldDto _$SubmissionTemplateFieldDtoFromJson(
        Map<String, dynamic> json) =>
    SubmissionTemplateFieldDto(
      id: json['id'] as String,
      label: json['label'] as String,
      mandatory: json['mandatory'] as bool,
      fieldType: $enumDecode(_$SubmissionFieldTypeEnumMap, json['fieldType']),
      maxValue: json['maxValue'] as int?,
      defaultValue: json['defaultValue'] as String?,
      pickerValues: (json['pickerValues'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      itemType: $enumDecodeNullable(
          _$SubmissionFieldItemTypeEnumMap, json['itemType']),
    );

Map<String, dynamic> _$SubmissionTemplateFieldDtoToJson(
        SubmissionTemplateFieldDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'mandatory': instance.mandatory,
      'fieldType': _$SubmissionFieldTypeEnumMap[instance.fieldType]!,
      'maxValue': instance.maxValue,
      'defaultValue': instance.defaultValue,
      'pickerValues': instance.pickerValues,
      'itemType': _$SubmissionFieldItemTypeEnumMap[instance.itemType],
    };

const _$SubmissionFieldTypeEnumMap = {
  SubmissionFieldType.unknown: 'unknown',
  SubmissionFieldType.photo: 'photo',
  SubmissionFieldType.text: 'text',
  SubmissionFieldType.multilineText: 'multilineText',
  SubmissionFieldType.integer: 'integer',
  SubmissionFieldType.currency: 'currency',
  SubmissionFieldType.picker: 'picker',
  SubmissionFieldType.search: 'search',
  SubmissionFieldType.focus: 'focus',
  SubmissionFieldType.date: 'date',
  SubmissionFieldType.barcode: 'barcode',
};

const _$SubmissionFieldItemTypeEnumMap = {
  SubmissionFieldItemType.unknown: 'unknown',
  SubmissionFieldItemType.product: 'product',
  SubmissionFieldItemType.category: 'category',
};
