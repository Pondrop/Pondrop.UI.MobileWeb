import 'dart:math';

import 'package:pondrop/api/submissions/models/campaign_dto.dart';
import 'package:uuid/uuid.dart';

class FakeCampaign {
  static List<CampaignDto> fakeCategoryCampaignDtos(
      {String storeId = '', String submissionTemplateId = '', int length = 3}) {
    final rng = Random();
    final items = <CampaignDto>[];

    for (var i = 0; i < length; i++) {
      items.add(CategoryCampaignDto(
          id: const Uuid().v4(),
          campaignType: CampaignType.task,
          campaignStatus: CampaignStatus.live,
          submissionTemplateId: submissionTemplateId.isEmpty
              ? const Uuid().v4()
              : submissionTemplateId,
          storeId: storeId.isEmpty ? const Uuid().v4() : storeId,
          requiredSubmissions: rng.nextInt(9) + 1,
          submissionCount: 0,
          campaignPublishedDate: DateTime.now().add(const Duration(days: -7)),
          campaignStartDate: DateTime.now().add(const Duration(days: -7)),
          campaignEndDate: DateTime.now().add(const Duration(days: 7)),
          focusCategoryId: const Uuid().v4(),
          focusCategoryName: 'Focus Category ${i + 1}'));
    }

    return items;
  }

  static List<CampaignDto> fakeProductCampaignDtos(
      {String storeId = '', String submissionTemplateId = '', int length = 3}) {
    final rng = Random();
    final items = <CampaignDto>[];

    for (var i = 0; i < length; i++) {
      items.add(ProductCampaignDto(
          id: const Uuid().v4(),
          campaignType: CampaignType.task,
          campaignStatus: CampaignStatus.live,
          submissionTemplateId: submissionTemplateId.isEmpty
              ? const Uuid().v4()
              : submissionTemplateId,
          storeId: storeId.isEmpty ? const Uuid().v4() : storeId,
          requiredSubmissions: rng.nextInt(9) + 1,
          submissionCount: 0,
          campaignPublishedDate: DateTime.now().add(const Duration(days: -7)),
          campaignStartDate: DateTime.now().add(const Duration(days: -7)),
          campaignEndDate: DateTime.now().add(const Duration(days: 7)),
          focusProductId: const Uuid().v4(),
          focusProductName: 'Focus Product ${i + 1}'));
    }

    return items;
  }
}
