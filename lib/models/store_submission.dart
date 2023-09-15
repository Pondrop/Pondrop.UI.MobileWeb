import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:pondrop/api/submissions/models/models.dart';
import 'package:pondrop/models/models.dart';

extension SubmissionTemplateDtoMapping on SubmissionTemplateDto {
  StoreSubmission toStoreSubmission(
      {required StoreVisitDto storeVisit,
      required Store store,
      required String? campaignId}) {
    final now = DateTime.now();
    return StoreSubmission(
      storeVisit: storeVisit,
      store: store,
      templateId: id,
      campaignId: campaignId,
      title: title,
      description: description,
      steps: steps
          .map((step) => StoreSubmissionStep(
                templateId: id,
                stepId: step.id,
                title: step.title,
                started: DateTime.now(),
                instructions: step.instructions,
                instructionsContinueButton: step.instructionsContinueButton,
                instructionsSkipButton: step.instructionsSkipButton,
                instructionsIconCodePoint: step.instructionsIconCodePoint,
                instructionsIconFontFamily: step.instructionsIconFontFamily,
                isSummary: step.isSummary,
                fields: step.fields
                    .map((field) => StoreSubmissionField(
                        templateId: id,
                        stepId: step.id,
                        fieldId: field.id,
                        label: field.label,
                        mandatory: field.mandatory,
                        fieldType: field.fieldType,
                        maxValue: field.maxValue,
                        pickerValues: field.pickerValues,
                        itemType: field.itemType,
                        results: [StoreSubmissionFieldResult()]))
                    .toList(),
              ))
          .toList(),
      dateCreated: now,
      dateUpdated: now,
    );
  }

  SubmissionFieldItemType? getFocusItemType() {
    return steps
        .expand((i) => i.fields)
        .where((i) =>
            i.fieldType == SubmissionFieldType.focus &&
            i.itemType != null &&
            i.itemType != SubmissionFieldItemType.unknown)
        .firstOrNull
        ?.itemType;
  }
}

extension StoreSubmissionResultMapping on StoreSubmission {
  SubmissionResultDto toSubmissionResultDto() {
    return SubmissionResultDto(
      submissionTemplateId: templateId,
      campaignId: campaignId,
      storeVisitId: storeVisit.id,
      latitude: latitude,
      longitude: longitude,
      completedDate: DateTime.now().toUtc(),
      steps: steps
          .map((step) => SubmissionStepResultDto(
                templateStepId: step.stepId,
                latitude: step.latitude,
                longitude: step.longitude,
                startedUtc: step.started.toUtc(),
                fields: step.fields
                    .map((field) => SubmissionFieldResultDto(
                        templateFieldId: field.fieldId,
                        values: field.results
                            .where((e) => !e.isEmpty)
                            .map((e) => SubmissionFieldResultValueDto(
                                  stringValue: e.stringValue,
                                  intValue: e.intValue,
                                  doubleValue: e.doubleValue,
                                  dateTimeValue: e.dateTimeValue,
                                  photoPathValue: e.photoPathValue,
                                  itemValue: field.itemType != null &&
                                          e.itemValue != null
                                      ? SubmissionFieldResultValueItemDto(
                                          itemId: e.itemValue!.itemId,
                                          itemName: e.itemValue!.itemName,
                                          itemBarcode: e.itemValue!.itemBarcode,
                                          itemType: field.itemType!,
                                        )
                                      : null,
                                ))
                            .toList()))
                    .toList(),
              ))
          .toList(),
    );
  }

  int photoCount() {
    return steps
        .expand((e) => e.fields
            .where((e) => e.results.first.photoPathValue?.isNotEmpty == true))
        .length;
  }

  String? getFocusId() {
    return steps
        .expand((i) => i.fields)
        .where((i) =>
            i.fieldType == SubmissionFieldType.focus &&
            i.itemType != null &&
            i.itemType != SubmissionFieldItemType.unknown)
        .firstOrNull
        ?.results
        .firstOrNull
        ?.itemValue
        ?.itemId;
  }

  SubmissionFieldItemType? getFocusItemType() {
    return steps
        .expand((i) => i.fields)
        .where((i) =>
            i.fieldType == SubmissionFieldType.focus &&
            i.itemType != null &&
            i.itemType != SubmissionFieldItemType.unknown)
        .firstOrNull
        ?.itemType;
  }

  String toFocusString({String separator = ', '}) {
    return steps
        .expand((e) => e.fields
            .where((e) => e.fieldType == SubmissionFieldType.focus)
            .map((e) => e.toResultString()))
        .where((e) => e.isNotEmpty)
        .join(separator);
  }

  TaskIdentifier toTaskIdentifier(String storeId) {
    return campaignId?.isNotEmpty == true
        ? TaskIdentifier.campaign(
            templateId: templateId,
            storeId: storeId,
            campaignId: campaignId!,
            focusId: getFocusId()!,
            focusType: getFocusItemType()!.toCampaignFocusType())
        : TaskIdentifier(templateId: templateId, storeId: storeId);
  }
}

class StoreSubmission extends Equatable {
  const StoreSubmission({
    required this.storeVisit,
    required this.store,
    required this.templateId,
    required this.campaignId,
    required this.title,
    required this.description,
    this.latitude = 0,
    this.longitude = 0,
    required this.steps,
    required this.dateCreated,
    required this.dateUpdated,
    this.result,
    this.submittedDate,
  });

  final StoreVisitDto storeVisit;
  final Store store;

  final String templateId;
  final String? campaignId;
  final String title;
  final String description;

  final double latitude;
  final double longitude;

  final List<StoreSubmissionStep> steps;

  final DateTime dateCreated;
  final DateTime dateUpdated;

  final SubmissionResultDto? result;
  final DateTime? submittedDate;

  bool get submitted => result != null && submittedDate != null;

  StoreSubmission copyWith(
      {LatLng? location,
      SubmissionResultDto? result,
      DateTime? submittedDate}) {
    return StoreSubmission(
      storeVisit: storeVisit,
      store: store,
      templateId: templateId,
      campaignId: campaignId,
      title: title,
      latitude: location?.latitude ?? latitude,
      longitude: location?.longitude ?? longitude,
      description: description,
      steps: steps.map((e) => e.copy()).toList(),
      dateCreated: dateCreated,
      dateUpdated: DateTime.now(),
      result: result ?? this.result,
      submittedDate: submittedDate ?? this.submittedDate,
    );
  }

  @override
  List<Object?> get props => [
        storeVisit,
        store,
        templateId,
        campaignId,
        title,
        description,
        steps,
        submitted,
        dateCreated
      ];
}

class StoreSubmissionStep extends Equatable {
  StoreSubmissionStep({
    required this.templateId,
    required this.stepId,
    required this.title,
    this.latitude = 0,
    this.longitude = 0,
    required this.started,
    required this.instructions,
    required this.instructionsContinueButton,
    required this.instructionsSkipButton,
    required this.instructionsIconCodePoint,
    required this.instructionsIconFontFamily,
    required this.fields,
    required this.isSummary,
  });

  final String templateId;
  final String stepId;

  final String title;

  double latitude;
  double longitude;

  DateTime started;

  final String instructions;
  final String instructionsContinueButton;
  final String instructionsSkipButton;
  final int instructionsIconCodePoint;
  final String instructionsIconFontFamily;

  final bool isSummary;

  final List<StoreSubmissionField> fields;

  bool get isEmpty =>
      fields.isEmpty || fields.every((e) => e.results.every((e) => e.isEmpty));

  bool get isComplete =>
      (!isEmpty || isSummary) &&
      fields.every((e) => !e.mandatory || e.results.every((e) => !e.isEmpty));

  bool get isFocus =>
      fields.isNotEmpty && fields[0].fieldType == SubmissionFieldType.focus;

  StoreSubmissionStep copy() {
    return StoreSubmissionStep(
        templateId: templateId,
        stepId: stepId,
        title: title,
        latitude: latitude,
        longitude: longitude,
        started: started,
        instructions: instructions,
        instructionsContinueButton: instructionsContinueButton,
        instructionsSkipButton: instructionsSkipButton,
        instructionsIconCodePoint: instructionsIconCodePoint,
        instructionsIconFontFamily: instructionsIconFontFamily,
        isSummary: isSummary,
        fields: fields.map((e) => e.copy()).toList());
  }

  @override
  List<Object?> get props => [
        stepId,
        title,
        instructions,
        instructionsContinueButton,
        instructionsSkipButton,
        instructionsIconCodePoint,
        instructionsIconFontFamily,
        isSummary,
        fields
      ];
}

class StoreSubmissionField extends Equatable {
  const StoreSubmissionField(
      {required this.templateId,
      required this.stepId,
      required this.fieldId,
      required this.label,
      required this.mandatory,
      required this.fieldType,
      this.maxValue,
      this.pickerValues,
      this.itemType,
      this.results = const []});

  final String templateId;
  final String stepId;
  final String fieldId;
  final String label;
  final bool mandatory;
  final SubmissionFieldType fieldType;

  final int? maxValue;
  final List<String>? pickerValues;
  final SubmissionFieldItemType? itemType;

  final List<StoreSubmissionFieldResult> results;

  String toResultString({String separator = ', ', String locale = 'en'}) {
    return results.map((e) {
      switch (fieldType) {
        case SubmissionFieldType.photo:
          return e.photoPathValue ?? '';
        case SubmissionFieldType.text:
        case SubmissionFieldType.multilineText:
        case SubmissionFieldType.picker:
        case SubmissionFieldType.barcode:
          return e.stringValue ?? '';
        case SubmissionFieldType.currency:
          return NumberFormat.simpleCurrency().format(e.doubleValue ?? 0);
        case SubmissionFieldType.integer:
          return e.intValue?.toString() ?? '';
        case SubmissionFieldType.search:
        case SubmissionFieldType.focus:
          return e.itemValue?.itemName ?? '';
        case SubmissionFieldType.date:
          return e.dateTimeValue != null
              ? DateFormat.yMd(locale).format(e.dateTimeValue!)
              : '';
        default:
          return '';
      }
    }).join(separator);
  }

  StoreSubmissionField copy() {
    return StoreSubmissionField(
        templateId: templateId,
        stepId: stepId,
        fieldId: fieldId,
        label: label,
        mandatory: mandatory,
        fieldType: fieldType,
        maxValue: maxValue,
        pickerValues: pickerValues,
        itemType: itemType,
        results: results.map((e) => e.copy()).toList());
  }

  @override
  List<Object?> get props => [
        fieldId,
        label,
        mandatory,
        fieldType,
        maxValue,
        pickerValues,
        itemType,
        results,
      ];
}

class StoreSubmissionFieldResult extends Equatable {
  StoreSubmissionFieldResult({
    this.stringValue,
    this.intValue,
    this.doubleValue,
    this.dateTimeValue,
    this.photoPathValue,
    this.itemValue,
  });

  String? stringValue;
  int? intValue;
  double? doubleValue;
  DateTime? dateTimeValue;
  String? photoPathValue;

  StoreSubmissionFieldResultItem? itemValue;

  bool get isEmpty =>
      stringValue == null &&
      intValue == null &&
      doubleValue == null &&
      dateTimeValue == null &&
      photoPathValue == null &&
      (itemValue == null || itemValue!.isEmpty);

  StoreSubmissionFieldResult copy() {
    return StoreSubmissionFieldResult(
      stringValue: stringValue,
      intValue: intValue,
      doubleValue: doubleValue,
      dateTimeValue: dateTimeValue,
      photoPathValue: photoPathValue,
      itemValue: itemValue?.copy(),
    );
  }

  @override
  List<Object?> get props => [
        stringValue,
        intValue,
        doubleValue,
        dateTimeValue,
        photoPathValue,
        itemValue,
      ];
}

class StoreSubmissionFieldResultItem extends Equatable {
  StoreSubmissionFieldResultItem({
    this.itemId = '',
    this.itemName = '',
    this.itemBarcode,
  });

  String itemId;
  String itemName;
  String? itemBarcode;

  bool get isEmpty =>
      itemId.isEmpty &&
      itemName.isEmpty &&
      (itemBarcode == null || itemBarcode!.isEmpty);

  StoreSubmissionFieldResultItem copy() {
    return StoreSubmissionFieldResultItem(
      itemId: itemId,
      itemName: itemName,
      itemBarcode: itemBarcode,
    );
  }

  @override
  List<Object?> get props => [
        itemId,
        itemName,
        itemBarcode,
      ];
}
