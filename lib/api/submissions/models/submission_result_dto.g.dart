// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmissionResultDto _$SubmissionResultDtoFromJson(Map<String, dynamic> json) =>
    SubmissionResultDto(
      submissionTemplateId: json['submissionTemplateId'] as String,
      storeVisitId: json['storeVisitId'] as String,
      campaignId: json['campaignId'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      completedDate: DateTime.parse(json['completedDate'] as String),
      steps: (json['steps'] as List<dynamic>)
          .map((e) =>
              SubmissionStepResultDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SubmissionResultDtoToJson(
        SubmissionResultDto instance) =>
    <String, dynamic>{
      'submissionTemplateId': instance.submissionTemplateId,
      'storeVisitId': instance.storeVisitId,
      'campaignId': instance.campaignId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'completedDate': instance.completedDate.toIso8601String(),
      'steps': instance.steps.map((e) => e.toJson()).toList(),
    };
