import 'package:equatable/equatable.dart';
import 'package:pondrop/api/submissions/models/models.dart';

class TaskIdentifier extends Equatable {
  const TaskIdentifier({
    required this.templateId,
    required this.storeId,
  })  : campaignId = '',
        focusId = '',
        focusType = CampaignFocusType.unknown;

  const TaskIdentifier.campaign({
    required this.templateId,
    required this.storeId,
    required this.campaignId,
    required this.focusId,
    required this.focusType,
  });

  TaskIdentifier.fromCampaignDto(CampaignDto campaignDto)
      : templateId = campaignDto.submissionTemplateId,
        storeId = campaignDto.storeId,
        campaignId = campaignDto.id,
        focusId = campaignDto.focusId,
        focusType = campaignDto.focusType;

  final String templateId;
  final String storeId;

  final String campaignId;
  final String focusId;
  final CampaignFocusType focusType;

  bool get isCampaign => campaignId.isNotEmpty;

  @override
  List<Object> get props =>
      [templateId, storeId, campaignId, focusId, focusType];
}
