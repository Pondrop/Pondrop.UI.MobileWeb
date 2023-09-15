// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginationDto<T> _$PaginationDtoFromJson<T>(Map<String, dynamic> json) =>
    PaginationDto<T>(
      offset: json['offset'] as int,
      limit: json['limit'] as int,
      count: json['count'] as int,
    );

Map<String, dynamic> _$PaginationDtoToJson<T>(PaginationDto<T> instance) =>
    <String, dynamic>{
      'offset': instance.offset,
      'limit': instance.limit,
      'count': instance.count,
    };
