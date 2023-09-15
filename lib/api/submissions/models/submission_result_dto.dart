import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'models.dart';

part 'submission_result_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class SubmissionResultDto extends Equatable {
  SubmissionResultDto({
    required this.submissionTemplateId,
    required this.storeVisitId,
    this.campaignId,
    this.latitude = 0,
    this.longitude = 0,
    required this.completedDate,
    required this.steps,
  });

  @JsonKey(name: 'submissionTemplateId')
  final String submissionTemplateId;

  @JsonKey(name: 'storeVisitId')
  final String storeVisitId;
  @JsonKey(name: 'campaignId')
  final String? campaignId;

  @JsonKey(name: 'latitude')
  final double latitude;
  @JsonKey(name: 'longitude')
  final double longitude;

  @JsonKey(name: 'completedDate')
  final DateTime completedDate;

  @JsonKey(name: 'steps')
  final List<SubmissionStepResultDto> steps;

  static SubmissionResultDto fromJson(Map<String, dynamic> json) =>
      _$SubmissionResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SubmissionResultDtoToJson(this);

  @override
  List<Object?> get props => [
        submissionTemplateId,
        storeVisitId,
        campaignId,
        latitude,
        longitude,
        steps
      ];
}
