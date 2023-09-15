import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pondrop/features/global/global.dart';
import 'package:pondrop/features/styles/styles.dart';
import 'package:pondrop/models/models.dart';

import '../../bloc/store_submission_bloc.dart';
import 'required_view.dart';

class DateFieldControl extends StatefulWidget {
  const DateFieldControl(
      {super.key, required this.field, this.readOnly = false});

  final StoreSubmissionField field;
  final bool readOnly;

  @override
  State<DateFieldControl> createState() => _DateFieldControlState();
}

class _DateFieldControlState extends State<DateFieldControl> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: Key(widget.field.fieldId),
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: widget.field.label,
          suffixIcon: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.field.mandatory && widget.field.results.first.isEmpty)
                const RequiredView(),
              const Icon(Icons.calendar_month_outlined),
              const SizedBox(
                width: Dims.small,
              ),
            ],
          )),
      controller: textController,
      focusNode: AlwaysDisabledFocusNode(),
      readOnly: true,
      onTap: !widget.readOnly
          ? () async {
              final currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                FocusManager.instance.primaryFocus?.unfocus();
              }

              final bloc = context.read<StoreSubmissionBloc>();
              final locale = Localizations.localeOf(context);

              final initialDate =
                  widget.field.results.first.dateTimeValue ?? DateTime.now();

              final dateValue = await showDatePicker(
                  context: context,
                  initialDate: initialDate,
                  firstDate: initialDate.add(const Duration(days: -60)),
                  lastDate: initialDate.add(const Duration(days: 365 * 5)),
                  locale: locale);

              bloc.add(StoreSubmissionFieldResultEvent(
                  stepId: widget.field.stepId,
                  fieldId: widget.field.fieldId,
                  result:
                      StoreSubmissionFieldResult(dateTimeValue: dateValue)));

              textController.text = dateValue != null
                  ? DateFormat.yMd(locale.toString()).format(dateValue)
                  : '';
            }
          : null,
    );
  }
}
