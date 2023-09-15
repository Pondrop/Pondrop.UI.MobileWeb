import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'models.dart';

part 'submission_field_result_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class SubmissionFieldResultDto extends Equatable {
  SubmissionFieldResultDto({
    required this.templateFieldId,
    this.values = const [],
  });

  @JsonKey(name: 'templateFieldId')
  final String templateFieldId;
  @JsonKey(name: 'values')
  List<SubmissionFieldResultValueDto> values;

  static SubmissionFieldResultDto fromJson(Map<String, dynamic> json) =>
      _$SubmissionFieldResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SubmissionFieldResultDtoToJson(this);

  @override
  List<Object> get props => [
        templateFieldId,
        values,
      ];
}
