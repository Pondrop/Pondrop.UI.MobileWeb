import 'package:json_annotation/json_annotation.dart';
import 'package:pondrop/api/submissions/models/models.dart';

part 'campaign_dto.g.dart';

enum CampaignType { unknown, task, orchestration }

enum CampaignStatus { unknown, draft, live }

enum CampaignFocusType { unknown, product, category }

extension CampaignFocusTypeX on CampaignFocusType {
  SubmissionFieldItemType toSubmissionFieldItemType() {
    switch (this) {
      case CampaignFocusType.unknown:
        return SubmissionFieldItemType.unknown;
      case CampaignFocusType.product:
        return SubmissionFieldItemType.product;
      case CampaignFocusType.category:
        return SubmissionFieldItemType.category;
    }
  }
}

class CampaignDto {
  CampaignDto({
    required this.id,
    required this.campaignType,
    required this.campaignStatus,
    required this.submissionTemplateId,
    required this.storeId,
    required this.requiredSubmissions,
    required this.submissionCount,
    required this.campaignPublishedDate,
    required this.campaignStartDate,
    required this.campaignEndDate,
    required this.focusId,
    required this.focusName,
    required this.focusType,
  });

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'campaignType')
  final CampaignType campaignType;
  @JsonKey(name: 'campaignStatus')
  final CampaignStatus campaignStatus;
  @JsonKey(name: 'submissionTemplateId')
  final String submissionTemplateId;

  @JsonKey(name: 'storeId')
  final String storeId;

  @JsonKey(name: 'requiredSubmissions')
  final int requiredSubmissions;
  @JsonKey(name: 'submissionCount')
  final int submissionCount;

  @JsonKey(name: 'campaignPublishedDate')
  final DateTime campaignPublishedDate;
  @JsonKey(name: 'campaignStartDate')
  final DateTime campaignStartDate;
  @JsonKey(name: 'campaignEndDate')
  final DateTime campaignEndDate;

  @JsonKey(ignore: true)
  final String focusId;
  @JsonKey(ignore: true)
  final String focusName;
  @JsonKey(ignore: true)
  final CampaignFocusType focusType;

  bool get isValid =>
      campaignStatus == CampaignStatus.live &&
      submissionTemplateId.isNotEmpty &&
      focusId.isNotEmpty &&
      focusName.isNotEmpty &&
      submissionCount < requiredSubmissions &&
      campaignPublishedDate.isBefore(DateTime.now()) &&
      campaignStartDate.isBefore(DateTime.now()) &&
      campaignEndDate.isAfter(DateTime.now());
}

@JsonSerializable(explicitToJson: true)
class CategoryCampaignDto extends CampaignDto {
  CategoryCampaignDto({
    required String id,
    required CampaignType campaignType,
    required CampaignStatus campaignStatus,
    required String submissionTemplateId,
    required String storeId,
    required int requiredSubmissions,
    required int submissionCount,
    required DateTime campaignPublishedDate,
    required DateTime campaignEndDate,
    required DateTime campaignStartDate,
    required this.focusCategoryId,
    required this.focusCategoryName,
  }) : super(
            id: id,
            campaignType: campaignType,
            campaignStatus: campaignStatus,
            submissionTemplateId: submissionTemplateId,
            storeId: storeId,
            requiredSubmissions: requiredSubmissions,
            submissionCount: submissionCount,
            campaignPublishedDate: campaignPublishedDate,
            campaignStartDate: campaignStartDate,
            campaignEndDate: campaignEndDate,
            focusId: focusCategoryId,
            focusName: focusCategoryName,
            focusType: CampaignFocusType.category);

  @JsonKey(name: 'focusCategoryId')
  final String focusCategoryId;
  @JsonKey(name: 'focusCategoryName')
  final String focusCategoryName;

  static CategoryCampaignDto fromJson(Map<String, dynamic> json) =>
      _$CategoryCampaignDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryCampaignDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ProductCampaignDto extends CampaignDto {
  ProductCampaignDto({
    required String id,
    required CampaignType campaignType,
    required CampaignStatus campaignStatus,
    required String submissionTemplateId,
    required String storeId,
    required int requiredSubmissions,
    required int submissionCount,
    required DateTime campaignPublishedDate,
    required DateTime campaignStartDate,
    required DateTime campaignEndDate,
    required this.focusProductId,
    required this.focusProductName,
  }) : super(
            id: id,
            campaignType: campaignType,
            campaignStatus: campaignStatus,
            submissionTemplateId: submissionTemplateId,
            storeId: storeId,
            requiredSubmissions: requiredSubmissions,
            submissionCount: submissionCount,
            campaignPublishedDate: campaignPublishedDate,
            campaignStartDate: campaignStartDate,
            campaignEndDate: campaignEndDate,
            focusId: focusProductId,
            focusName: focusProductName,
            focusType: CampaignFocusType.product);

  @JsonKey(name: 'focusProductId')
  final String focusProductId;
  @JsonKey(name: 'focusProductName')
  final String focusProductName;

  static ProductCampaignDto fromJson(Map<String, dynamic> json) =>
      _$ProductCampaignDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductCampaignDtoToJson(this);
}
