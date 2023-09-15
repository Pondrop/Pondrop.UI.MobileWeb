// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_template_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmissionTemplateDto _$SubmissionTemplateDtoFromJson(
        Map<String, dynamic> json) =>
    SubmissionTemplateDto(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      iconCodePoint: json['iconCodePoint'] as int,
      iconFontFamily: json['iconFontFamily'] as String,
      status: $enumDecode(_$SubmissionTemplateStatusEnumMap, json['status']),
      initiatedBy: $enumDecode(
          _$SubmissionTemplateinitiatedByEnumMap, json['initiatedBy']),
      steps: (json['steps'] as List<dynamic>)
          .map((e) =>
              SubmissionTemplateStepDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SubmissionTemplateDtoToJson(
        SubmissionTemplateDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'iconCodePoint': instance.iconCodePoint,
      'iconFontFamily': instance.iconFontFamily,
      'status': _$SubmissionTemplateStatusEnumMap[instance.status]!,
      'initiatedBy':
          _$SubmissionTemplateinitiatedByEnumMap[instance.initiatedBy]!,
      'steps': instance.steps.map((e) => e.toJson()).toList(),
    };

const _$SubmissionTemplateStatusEnumMap = {
  SubmissionTemplateStatus.unknown: 'unknown',
  SubmissionTemplateStatus.active: 'active',
  SubmissionTemplateStatus.inactive: 'inactive',
};

const _$SubmissionTemplateinitiatedByEnumMap = {
  SubmissionTemplateinitiatedBy.unknown: 'unknown',
  SubmissionTemplateinitiatedBy.shopper: 'shopper',
  SubmissionTemplateinitiatedBy.brand: 'brand',
  SubmissionTemplateinitiatedBy.pondrop: 'pondrop',
};
