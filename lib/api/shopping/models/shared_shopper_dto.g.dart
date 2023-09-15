// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_shopper_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SharedShopperDto _$SharedShopperDtoFromJson(Map<String, dynamic> json) =>
    SharedShopperDto(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: $enumDecode(
          _$SharedShopperListPrivilegeEnumMap, json['listPrivilege']),
    );

Map<String, dynamic> _$SharedShopperDtoToJson(SharedShopperDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'listPrivilege': _$SharedShopperListPrivilegeEnumMap[instance.type]!,
    };

const _$SharedShopperListPrivilegeEnumMap = {
  SharedShopperListPrivilege.unknown: 'unknown',
  SharedShopperListPrivilege.admin: 'admin',
  SharedShopperListPrivilege.editor: 'editor',
  SharedShopperListPrivilege.add: 'add',
  SharedShopperListPrivilege.view: 'view',
};
