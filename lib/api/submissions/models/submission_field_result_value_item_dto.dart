import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'submission_template_field_dto.dart';

part 'submission_field_result_value_item_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class SubmissionFieldResultValueItemDto extends Equatable {
  SubmissionFieldResultValueItemDto({
    required this.itemId,
    required this.itemName,
    required this.itemType,
    this.itemBarcode,
  });

  @JsonKey(name: 'itemId')
  final String itemId;
  @JsonKey(name: 'itemName')
  final String itemName;

  @JsonKey(name: 'itemType')
  final SubmissionFieldItemType itemType;

  @JsonKey(name: 'itemBarcode')
  final String? itemBarcode;

  static SubmissionFieldResultValueItemDto fromJson(
          Map<String, dynamic> json) =>
      _$SubmissionFieldResultValueItemDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SubmissionFieldResultValueItemDtoToJson(this);

  @override
  List<Object?> get props => [
        itemId,
        itemName,
        itemType,
        itemBarcode,
      ];
}
