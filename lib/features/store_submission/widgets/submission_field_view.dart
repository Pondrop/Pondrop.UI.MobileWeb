import 'package:flutter/material.dart';
import 'package:pondrop/api/submission_api.dart';
import 'package:pondrop/models/models.dart';

import '../widgets/fields/fields.dart';

class SubmissionFieldView extends StatelessWidget {
  SubmissionFieldView({required this.field, this.readOnly = false})
      : super(key: Key('SubmissionFieldView_${field.fieldId}'));

  final StoreSubmissionField field;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    switch (field.fieldType) {
      case SubmissionFieldType.barcode:
        return BarcodeFieldControl(
          field: field,
          readOnly: readOnly,
        );
      case SubmissionFieldType.photo:
        return PhotoFieldControl(
          field: field,
          readOnly: readOnly,
        );
      case SubmissionFieldType.text:
      case SubmissionFieldType.multilineText:
        return TextFieldControl(
          field: field,
          readOnly: readOnly,
        );
      case SubmissionFieldType.integer:
        return IntFieldControl(
          field: field,
          readOnly: readOnly,
        );
      case SubmissionFieldType.currency:
        return CurrencyFieldControl(
          field: field,
          readOnly: readOnly,
        );
      case SubmissionFieldType.picker:
        return PickerFieldControl(
          field: field,
          readOnly: readOnly,
        );
      case SubmissionFieldType.search:
        return SearchFieldControl(
          field: field,
          readOnly: readOnly,
        );
      case SubmissionFieldType.date:
        return DateFieldControl(
          field: field,
          readOnly: readOnly,
        );
      case SubmissionFieldType.focus:
      default:
        return const SizedBox.shrink();
    }
  }
}
