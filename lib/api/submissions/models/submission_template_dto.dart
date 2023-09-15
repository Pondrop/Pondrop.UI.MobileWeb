import 'package:json_annotation/json_annotation.dart';

import 'models.dart';

part 'submission_template_dto.g.dart';

enum SubmissionTemplateStatus { unknown, active, inactive }

enum SubmissionTemplateinitiatedBy { unknown, shopper, brand, pondrop }

@JsonSerializable(explicitToJson: true)
class SubmissionTemplateDto {
  SubmissionTemplateDto({
    required this.id,
    required this.title,
    required this.description,
    required this.iconCodePoint,
    required this.iconFontFamily,
    required this.status,
    required this.initiatedBy,
    required this.steps,
  });

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'iconCodePoint')
  final int iconCodePoint;
  @JsonKey(name: 'iconFontFamily')
  final String iconFontFamily;

  @JsonKey(name: 'status')
  final SubmissionTemplateStatus status;
  @JsonKey(name: 'initiatedBy')
  final SubmissionTemplateinitiatedBy initiatedBy;

  @JsonKey(name: 'steps')
  final List<SubmissionTemplateStepDto> steps;

  bool get manualEnabled =>
      status == SubmissionTemplateStatus.active &&
      initiatedBy == SubmissionTemplateinitiatedBy.shopper;

  static SubmissionTemplateDto fromJson(Map<String, dynamic> json) =>
      _$SubmissionTemplateDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SubmissionTemplateDtoToJson(this);
}
