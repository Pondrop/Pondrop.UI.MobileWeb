import 'package:json_annotation/json_annotation.dart';

part 'shopping_list_store_dto.g.dart';

@JsonSerializable()
class ShoppingListStoreDto {
  const ShoppingListStoreDto({
    required this.storeId,
    required this.name,
    required this.sortOrder,
  });

  @JsonKey(name: 'storeId')
  final String storeId;
  @JsonKey(name: 'storeTitle')
  final String name;

  @JsonKey(name: 'sortOrder')
  final int sortOrder;

  static ShoppingListStoreDto fromJson(Map<String, dynamic> json) =>
      _$ShoppingListStoreDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ShoppingListStoreDtoToJson(this);
}
