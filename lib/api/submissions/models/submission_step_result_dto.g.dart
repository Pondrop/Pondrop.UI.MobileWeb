// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_step_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmissionStepResultDto _$SubmissionStepResultDtoFromJson(
        Map<String, dynamic> json) =>
    SubmissionStepResultDto(
      templateStepId: json['templateStepId'] as String,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      startedUtc: DateTime.parse(json['startedUtc'] as String),
      fields: (json['fields'] as List<dynamic>)
          .map((e) =>
              SubmissionFieldResultDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SubmissionStepResultDtoToJson(
        SubmissionStepResultDto instance) =>
    <String, dynamic>{
      'templateStepId': instance.templateStepId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'startedUtc': instance.startedUtc.toIso8601String(),
      'fields': instance.fields.map((e) => e.toJson()).toList(),
    };
