import 'package:json_annotation/json_annotation.dart';

part 'shared_shopper_dto.g.dart';

enum SharedShopperListPrivilege { unknown, admin, editor, add, view }

@JsonSerializable()
class SharedShopperDto {
  const SharedShopperDto({
    required this.id,
    required this.userId,
    required this.type,
  });

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'userId')
  final String userId;
  @JsonKey(name: 'listPrivilege')
  final SharedShopperListPrivilege type;

  static SharedShopperDto fromJson(Map<String, dynamic> json) =>
      _$SharedShopperDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SharedShopperDtoToJson(this);
}
