import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pondrop/features/global/global.dart';
import 'package:pondrop/models/models.dart';

import '../../bloc/store_submission_bloc.dart';
import 'required_view.dart';

class PickerFieldControl extends StatefulWidget {
  const PickerFieldControl(
      {super.key, required this.field, this.readOnly = false});

  final StoreSubmissionField field;
  final bool readOnly;

  @override
  State<PickerFieldControl> createState() => _PickerFieldControlState();
}

class _PickerFieldControlState extends State<PickerFieldControl> {
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
        suffixIcon: widget.field.mandatory && widget.field.results.first.isEmpty
            ? const RequiredView()
            : null,
      ),
      controller: textController,
      focusNode: AlwaysDisabledFocusNode(),
      readOnly: true,
      onTap: !widget.readOnly
          ? () {
              final currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                FocusManager.instance.primaryFocus?.unfocus();
              }

              if (widget.field.pickerValues != null) {
                final items = [const Center(child: Text(' - '))];
                items.addAll(widget.field.pickerValues!.map((e) => Center(
                        child: Text(
                      e,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ))));
                final currentIdx =
                    widget.field.results.first.stringValue?.isNotEmpty == true
                        ? widget.field.pickerValues!.indexOf(
                                widget.field.results.first.stringValue!) +
                            1
                        : 0;

                showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext builder) {
                    return Container(
                        height: MediaQuery.of(context).copyWith().size.height *
                            0.25,
                        color: Colors.white,
                        child: CupertinoPicker(
                          onSelectedItemChanged: (value) {
                            final stringValue = value == 0
                                ? null
                                : widget.field.pickerValues![value - 1];
                            final bloc = context.read<StoreSubmissionBloc>();
                            bloc.add(StoreSubmissionFieldResultEvent(
                                stepId: widget.field.stepId,
                                fieldId: widget.field.fieldId,
                                result: StoreSubmissionFieldResult(
                                    stringValue: stringValue)));
                            textController.text = stringValue ?? '';
                          },
                          itemExtent: 36,
                          scrollController: FixedExtentScrollController(
                              initialItem: currentIdx),
                          children: items,
                        ));
                  },
                );
              }
            }
          : null,
    );
  }
}
