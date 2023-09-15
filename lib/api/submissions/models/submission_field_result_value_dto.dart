import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pondrop/api/submissions/models/models.dart';

part 'submission_field_result_value_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class SubmissionFieldResultValueDto extends Equatable {
  SubmissionFieldResultValueDto(
      {this.stringValue,
      this.intValue,
      this.doubleValue,
      this.dateTimeValue,
      this.photoPathValue,
      this.itemValue});

  @JsonKey(name: 'stringValue')
  final String? stringValue;
  @JsonKey(name: 'intValue')
  final int? intValue;
  @JsonKey(name: 'doubleValue')
  final double? doubleValue;
  @JsonKey(name: 'dateTimeValue')
  final DateTime? dateTimeValue;

  @JsonKey(name: 'itemValue')
  final SubmissionFieldResultValueItemDto? itemValue;

  @JsonKey(ignore: true)
  final String? photoPathValue;
  @JsonKey(name: 'photoFileName')
  String? photoFileName;
  @JsonKey(name: 'photoBase64')
  String? photoBase64;

  static SubmissionFieldResultValueDto fromJson(Map<String, dynamic> json) =>
      _$SubmissionFieldResultValueDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SubmissionFieldResultValueDtoToJson(this);

  @override
  List<Object?> get props => [
        stringValue,
        intValue,
        doubleValue,
        dateTimeValue,
        itemValue,
        photoPathValue,
        photoFileName,
        photoBase64,
      ];
}
