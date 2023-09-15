import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pondrop/api/submission_api.dart';
import 'package:pondrop/features/global/global.dart';
import 'package:pondrop/models/models.dart';

import '../../bloc/store_submission_bloc.dart';
import 'required_view.dart';

class TextFieldControl extends StatelessWidget {
  const TextFieldControl(
      {super.key, required this.field, this.readOnly = false});

  final StoreSubmissionField field;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: Key(field.fieldId),
      enableInteractiveSelection: !readOnly,
      focusNode: readOnly ? AlwaysDisabledFocusNode() : null,
      readOnly: readOnly,
      initialValue: field.toResultString(),
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: field.label,
        suffixIcon: field.mandatory && field.results.first.isEmpty
            ? const RequiredView()
            : null,
      ),
      keyboardType: field.fieldType == SubmissionFieldType.multilineText
          ? TextInputType.multiline
          : TextInputType.text,
      maxLines: field.fieldType == SubmissionFieldType.multilineText ? 4 : 1,
      maxLength: field.maxValue,
      onChanged: (value) {
        final result = StoreSubmissionFieldResult(
            stringValue: value.isEmpty ? null : value);
        context.read<StoreSubmissionBloc>().add(StoreSubmissionFieldResultEvent(
            stepId: field.stepId, fieldId: field.fieldId, result: result));
      },
    );
  }
}
