// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductDto _$ProductDtoFromJson(Map<String, dynamic> json) => ProductDto(
      searchScore: (json['@search.score'] as num).toDouble(),
      id: json['id'] as String,
      name: json['name'] as String,
      brandId: json['brandId'] as String,
      externalReferenceId: json['externalReferenceId'] as String,
      variant: json['variant'] as String,
      altName: json['altName'] as String,
      shortDescription: json['shortDescription'] as String,
      netContent: (json['netContent'] as num).toDouble(),
      netContentUom: json['netContentUom'] as String,
      possibleCategories: json['possibleCategories'] as String,
      publicationLifecycleId: json['publicationLifecycleId'] as String,
      barcodeNumber: json['barcodeNumber'] as String,
      categoryNames: json['categoryNames'] as String,
    );

Map<String, dynamic> _$ProductDtoToJson(ProductDto instance) =>
    <String, dynamic>{
      '@search.score': instance.searchScore,
      'id': instance.id,
      'name': instance.name,
      'brandId': instance.brandId,
      'externalReferenceId': instance.externalReferenceId,
      'variant': instance.variant,
      'altName': instance.altName,
      'shortDescription': instance.shortDescription,
      'netContent': instance.netContent,
      'netContentUom': instance.netContentUom,
      'possibleCategories': instance.possibleCategories,
      'publicationLifecycleId': instance.publicationLifecycleId,
      'barcodeNumber': instance.barcodeNumber,
      'categoryNames': instance.categoryNames,
    };
