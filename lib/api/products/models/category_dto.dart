import 'package:json_annotation/json_annotation.dart';

part 'category_dto.g.dart';
part 'category_search_result_dto.dart';

@JsonSerializable()
class CategoryDto {
  const CategoryDto(
      {required this.searchScore,
      required this.id,
      required this.name,
      required this.updatedUtc,});

  @JsonKey(name: '@search.score')
  final double searchScore;

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'updatedUtc')
  final DateTime updatedUtc;

  static CategoryDto fromJson(Map<String, dynamic> json) =>
      _$CategoryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryDtoToJson(this);
}
