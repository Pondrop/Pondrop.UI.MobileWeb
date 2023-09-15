// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaign_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryCampaignDto _$CategoryCampaignDtoFromJson(Map<String, dynamic> json) =>
    CategoryCampaignDto(
      id: json['id'] as String,
      campaignType: $enumDecode(_$CampaignTypeEnumMap, json['campaignType']),
      campaignStatus:
          $enumDecode(_$CampaignStatusEnumMap, json['campaignStatus']),
      submissionTemplateId: json['submissionTemplateId'] as String,
      storeId: json['storeId'] as String,
      requiredSubmissions: json['requiredSubmissions'] as int,
      submissionCount: json['submissionCount'] as int,
      campaignPublishedDate:
          DateTime.parse(json['campaignPublishedDate'] as String),
      campaignEndDate: DateTime.parse(json['campaignEndDate'] as String),
      campaignStartDate: DateTime.parse(json['campaignStartDate'] as String),
      focusCategoryId: json['focusCategoryId'] as String,
      focusCategoryName: json['focusCategoryName'] as String,
    );

Map<String, dynamic> _$CategoryCampaignDtoToJson(
        CategoryCampaignDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'campaignType': _$CampaignTypeEnumMap[instance.campaignType]!,
      'campaignStatus': _$CampaignStatusEnumMap[instance.campaignStatus]!,
      'submissionTemplateId': instance.submissionTemplateId,
      'storeId': instance.storeId,
      'requiredSubmissions': instance.requiredSubmissions,
      'submissionCount': instance.submissionCount,
      'campaignPublishedDate': instance.campaignPublishedDate.toIso8601String(),
      'campaignStartDate': instance.campaignStartDate.toIso8601String(),
      'campaignEndDate': instance.campaignEndDate.toIso8601String(),
      'focusCategoryId': instance.focusCategoryId,
      'focusCategoryName': instance.focusCategoryName,
    };

const _$CampaignTypeEnumMap = {
  CampaignType.unknown: 'unknown',
  CampaignType.task: 'task',
  CampaignType.orchestration: 'orchestration',
};

const _$CampaignStatusEnumMap = {
  CampaignStatus.unknown: 'unknown',
  CampaignStatus.draft: 'draft',
  CampaignStatus.live: 'live',
};

ProductCampaignDto _$ProductCampaignDtoFromJson(Map<String, dynamic> json) =>
    ProductCampaignDto(
      id: json['id'] as String,
      campaignType: $enumDecode(_$CampaignTypeEnumMap, json['campaignType']),
      campaignStatus:
          $enumDecode(_$CampaignStatusEnumMap, json['campaignStatus']),
      submissionTemplateId: json['submissionTemplateId'] as String,
      storeId: json['storeId'] as String,
      requiredSubmissions: json['requiredSubmissions'] as int,
      submissionCount: json['submissionCount'] as int,
      campaignPublishedDate:
          DateTime.parse(json['campaignPublishedDate'] as String),
      campaignStartDate: DateTime.parse(json['campaignStartDate'] as String),
      campaignEndDate: DateTime.parse(json['campaignEndDate'] as String),
      focusProductId: json['focusProductId'] as String,
      focusProductName: json['focusProductName'] as String,
    );

Map<String, dynamic> _$ProductCampaignDtoToJson(ProductCampaignDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'campaignType': _$CampaignTypeEnumMap[instance.campaignType]!,
      'campaignStatus': _$CampaignStatusEnumMap[instance.campaignStatus]!,
      'submissionTemplateId': instance.submissionTemplateId,
      'storeId': instance.storeId,
      'requiredSubmissions': instance.requiredSubmissions,
      'submissionCount': instance.submissionCount,
      'campaignPublishedDate': instance.campaignPublishedDate.toIso8601String(),
      'campaignStartDate': instance.campaignStartDate.toIso8601String(),
      'campaignEndDate': instance.campaignEndDate.toIso8601String(),
      'focusProductId': instance.focusProductId,
      'focusProductName': instance.focusProductName,
    };
