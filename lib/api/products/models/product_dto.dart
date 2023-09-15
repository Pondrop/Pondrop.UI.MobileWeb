import 'package:json_annotation/json_annotation.dart';

part 'product_dto.g.dart';
part 'product_search_result_dto.dart';

@JsonSerializable()
class ProductDto {
  const ProductDto(
      {required this.searchScore,
      required this.id,
      required this.name,
      required this.brandId,
      required this.externalReferenceId,
      required this.variant,
      required this.altName,
      required this.shortDescription,
      required this.netContent,
      required this.netContentUom,
      required this.possibleCategories,
      required this.publicationLifecycleId,
      required this.barcodeNumber,
      required this.categoryNames});

  @JsonKey(name: '@search.score')
  final double searchScore;
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'brandId')
  final String brandId;
  @JsonKey(name: 'externalReferenceId')
  final String externalReferenceId;

  @JsonKey(name: 'variant')
  final String variant;
  @JsonKey(name: 'altName')
  final String altName;
  @JsonKey(name: 'shortDescription')
  final String shortDescription;
  @JsonKey(name: 'netContent')
  final double netContent;
  @JsonKey(name: 'netContentUom')
  final String netContentUom;

  @JsonKey(name: 'possibleCategories')
  final String possibleCategories;

  @JsonKey(name: 'publicationLifecycleId')
  final String publicationLifecycleId;

  @JsonKey(name: 'barcodeNumber')
  final String barcodeNumber;
  @JsonKey(name: 'categoryNames')
  final String categoryNames;
  
  static ProductDto fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDtoToJson(this);
}
