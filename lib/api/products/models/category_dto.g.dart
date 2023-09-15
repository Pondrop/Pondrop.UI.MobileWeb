// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryDto _$CategoryDtoFromJson(Map<String, dynamic> json) => CategoryDto(
      searchScore: (json['@search.score'] as num).toDouble(),
      id: json['id'] as String,
      name: json['name'] as String,
      updatedUtc: DateTime.parse(json['updatedUtc'] as String),
    );

Map<String, dynamic> _$CategoryDtoToJson(CategoryDto instance) =>
    <String, dynamic>{
      '@search.score': instance.searchScore,
      'id': instance.id,
      'name': instance.name,
      'updatedUtc': instance.updatedUtc.toIso8601String(),
    };
