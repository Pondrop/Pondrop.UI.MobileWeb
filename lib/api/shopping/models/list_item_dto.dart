import 'package:json_annotation/json_annotation.dart';

part 'list_item_dto.g.dart';

@JsonSerializable()
class ListItemDto {
  const ListItemDto({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.selectedProductId,
    required this.storeId,
    required this.checked,
    required this.preferenceIds,
    required this.sortOrder,
    required this.createdUtc,
    required this.updatedUtc,
  });

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'itemTitle')
  final String name;

  @JsonKey(name: 'selectedCategoryId')
  final String categoryId;
  @JsonKey(name: 'selectedProductId')
  final String? selectedProductId;
  @JsonKey(name: 'storeId')
  final String? storeId;

  @JsonKey(name: 'checked')
  final bool checked;

  @JsonKey(name: 'selectedPreferenceIds')
  final List<String> preferenceIds;

  @JsonKey(name: 'sortOrder')
  final int sortOrder;

  @JsonKey(name: 'createdUtc')
  final DateTime createdUtc;
  @JsonKey(name: 'updatedUtc')
  final DateTime updatedUtc;

  static ListItemDto fromJson(Map<String, dynamic> json) =>
      _$ListItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ListItemDtoToJson(this);
}
