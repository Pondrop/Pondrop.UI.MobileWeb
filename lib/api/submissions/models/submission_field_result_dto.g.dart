// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_field_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmissionFieldResultDto _$SubmissionFieldResultDtoFromJson(
        Map<String, dynamic> json) =>
    SubmissionFieldResultDto(
      templateFieldId: json['templateFieldId'] as String,
      values: (json['values'] as List<dynamic>?)
              ?.map((e) => SubmissionFieldResultValueDto.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SubmissionFieldResultDtoToJson(
        SubmissionFieldResultDto instance) =>
    <String, dynamic>{
      'templateFieldId': instance.templateFieldId,
      'values': instance.values.map((e) => e.toJson()).toList(),
    };
