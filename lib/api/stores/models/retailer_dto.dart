import 'package:json_annotation/json_annotation.dart';

part 'retailer_dto.g.dart';

@JsonSerializable()
class RetailerDto {
  const RetailerDto(
      {required this.name,});

  @JsonKey(name: 'name')
  final String? name;

  static RetailerDto fromJson(Map<String, dynamic> json) =>
    _$RetailerDtoFromJson(json);

  Map<String, dynamic> toJson() =>
    _$RetailerDtoToJson(this);
}