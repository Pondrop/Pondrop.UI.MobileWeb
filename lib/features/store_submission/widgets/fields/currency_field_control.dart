import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pondrop/models/models.dart';

import '../../bloc/store_submission_bloc.dart';
import 'required_view.dart';

class CurrencyFieldControl extends StatefulWidget {
  const CurrencyFieldControl(
      {super.key, required this.field, this.readOnly = false});

  final StoreSubmissionField field;
  final bool readOnly;

  @override
  State<CurrencyFieldControl> createState() => _CurrencyFieldControlState();
}

class _CurrencyFieldControlState extends State<CurrencyFieldControl> {
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
    return Focus(
      onFocusChange: (hasFocus) {
        if (hasFocus) {
          if (textController.text.isNotEmpty) {
            final doubleValue = NumberFormat.simpleCurrency()
                .parse(textController.text)
                .toDouble();
            textController.text = doubleValue.toStringAsFixed(2);
          }
        } else {
          final doubleValue = double.tryParse(textController.text);
          if (doubleValue != null) {
            textController.text =
                NumberFormat.simpleCurrency().format(doubleValue);
          }
        }
      },
      child: TextField(
          key: Key(widget.field.fieldId),
          readOnly: widget.readOnly,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: widget.field.label,
            suffixIcon: widget.field.mandatory && widget.field.results.first.isEmpty
                ? const RequiredView()
                : null,
          ),
          controller: textController,
          keyboardType: const TextInputType.numberWithOptions(
              decimal: true, signed: false),
          inputFormatters: [
            // Allow Decimal Number With Precision of 2 Only
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          maxLines: 1,
          onChanged: (value) {
            final bloc = context.read<StoreSubmissionBloc>();

            final doubleValue = double.tryParse(value);
            final result = StoreSubmissionFieldResult(doubleValue: doubleValue);

            bloc.add(StoreSubmissionFieldResultEvent(
                stepId: widget.field.stepId,
                fieldId: widget.field.fieldId,
                result: result));
          }),
    );
  }
}
