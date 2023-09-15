import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pondrop/api/submission_api.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/features/store_submission/widgets/fields/required_view.dart';
import 'package:pondrop/features/styles/dims.dart';

import '../../bloc/store_submission_bloc.dart';

class PhotoFieldControl extends StatelessWidget {
  const PhotoFieldControl(
      {super.key, required this.field, this.readOnly = false});

  final StoreSubmissionField field;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SizedBox(
      height: 256,
      width: double.infinity,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Theme.of(context).cardColor.withOpacity(0.75),
        child: field.results.first.photoPathValue?.isNotEmpty == true
            ? Image.file(File(field.results.first.photoPathValue!))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    const Icon(
                      Icons.add_a_photo_outlined,
                      size: 48,
                    ),
                    const SizedBox(
                      height: Dims.large,
                    ),
                    ElevatedButton(
                      onPressed: !readOnly
                          ? () async {
                              await takePhoto(
                                  RepositoryProvider.of<CameraRepository>(
                                      context),
                                  context.read<StoreSubmissionBloc>(),
                                  field);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white),
                      child: Text(l10n.takePhoto),
                    ),
                    const SizedBox(
                      height: Dims.large,
                    ),
                    if (field.mandatory)
                      const RequiredView(
                        padding: EdgeInsets.zero,
                      )
                  ]),
      ),
    );
  }

  static Future<void> takePhoto(CameraRepository cameraRepository,
      StoreSubmissionBloc bloc, StoreSubmissionField field) async {
    if (field.fieldType == SubmissionFieldType.photo) {
      final image = await cameraRepository.takePhoto();
      if (image != null) {
        bloc.add(StoreSubmissionFieldResultEvent(
            stepId: field.stepId,
            fieldId: field.fieldId,
            result: StoreSubmissionFieldResult(photoPathValue: image.path)));
      }
    }
  }
}
