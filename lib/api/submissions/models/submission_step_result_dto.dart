import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'models.dart';

part 'submission_step_result_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class SubmissionStepResultDto extends Equatable {
  SubmissionStepResultDto({
    required this.templateStepId,
    this.latitude = 0,
    this.longitude = 0,
    required this.startedUtc,
    required this.fields,
  });

  @JsonKey(name: 'templateStepId')
  final String templateStepId;

  @JsonKey(name: 'latitude')
  final double latitude;
  @JsonKey(name: 'longitude')
  final double longitude;

  @JsonKey(name: 'startedUtc')
  final DateTime startedUtc;

  @JsonKey(name: 'fields')
  final List<SubmissionFieldResultDto> fields;

  static SubmissionStepResultDto fromJson(Map<String, dynamic> json) =>
      _$SubmissionStepResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SubmissionStepResultDtoToJson(this);

  @override
  List<Object> get props =>
      [templateStepId, latitude, longitude, latitude, startedUtc, fields];
}
