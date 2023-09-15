import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pondrop/features/global/ean_validator.dart';
import 'package:pondrop/features/barcode_scanner/screens/barcode_scanner_page.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/models/models.dart';

import '../../bloc/store_submission_bloc.dart';
import 'required_view.dart';

class BarcodeFieldControl extends StatefulWidget {
  const BarcodeFieldControl(
      {super.key, required this.field, this.readOnly = false});

  final StoreSubmissionField field;
  final bool readOnly;

  @override
  State<BarcodeFieldControl> createState() => _BarcodeFieldControlState();
}

class _BarcodeFieldControlState extends State<BarcodeFieldControl> {
  final _textController = TextEditingController();
  
   bool _isValid = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return TextField(
      key: Key(widget.field.fieldId),
      readOnly: widget.readOnly,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: widget.field.label,
        errorText: _isValid
            ? l10n.itemIsNotValid(l10n.barcode)
            : null,
        suffixIcon: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.field.mandatory && widget.field.results.first.isEmpty)
                const RequiredView(),
              IconButton(
                  tooltip: l10n.barcode,
                  focusColor: Colors.black,
                  color: Colors.black,
                  icon: SvgPicture.asset('assets/barcode_scanner.svg'),
                  onPressed: () async {
                    final bloc = context.read<StoreSubmissionBloc>();
                    final barcode = await Navigator.of(context)
                        .push(BarcodeScannerPage.route());
                    if (barcode?.isNotEmpty == true) {
                      _textController.text = barcode!;
                      _onValueChange(barcode, bloc);
                    }
                  }),
            ]),
      ),
      controller: _textController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(13)
      ],
      maxLines: 1,
      onChanged: (value) {
        final bloc = context.read<StoreSubmissionBloc>();
        _onValueChange(value, bloc);
      },
    );
  }

  void _onValueChange(String value, StoreSubmissionBloc bloc) {
    final result = StoreSubmissionFieldResult(
        stringValue: EanValidator.validChecksum(value) ? value : null);

    bloc.add(StoreSubmissionFieldResultEvent(
        stepId: widget.field.stepId,
        fieldId: widget.field.fieldId,
        result: result));

    setState(() {
      _isValid = _textController.text.isNotEmpty && !EanValidator.validChecksum(_textController.text);
    });
  }
}
