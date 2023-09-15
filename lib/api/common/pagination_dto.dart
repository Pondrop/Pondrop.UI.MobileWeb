import 'package:json_annotation/json_annotation.dart';

part 'pagination_dto.g.dart';

@JsonSerializable()
class PaginationDto<T> {
  PaginationDto(
      {required this.offset, required this.limit, required this.count});

  @JsonKey(name: 'offset')
  final int offset;
  @JsonKey(name: 'limit')
  final int limit;
  @JsonKey(name: 'count')
  final int count;

  @JsonKey(ignore: true)
  final List<T> items = <T>[];

  static PaginationDto<T> fromJson<T>(Map<String, dynamic> json,
      T Function(Map<String, dynamic> json) itemFromJson) {
    final page = _$PaginationDtoFromJson<T>(json);

    if (json['items'] != null) {
      json['items'].forEach((v) {
        final item = itemFromJson(v);
        page.items.add(item);
      });
    }

    return page;
  }

  Map<String, dynamic> toJson(
      Map<String, dynamic> Function(T item) itemToJson) {
    final map = _$PaginationDtoToJson(this);
    final itemsMap = <Map<String, dynamic>>[];

    for (var v in items) {
      itemsMap.add(itemToJson(v));
    }

    map["items"] = itemsMap;
    return map;
  }
}
