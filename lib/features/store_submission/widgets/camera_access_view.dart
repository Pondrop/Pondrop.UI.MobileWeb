import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/features/styles/styles.dart';

import '../bloc/store_submission_bloc.dart';

class CameraAccessView extends StatelessWidget {
  const CameraAccessView({Key? key}) : super(key: key);

  static const okayButtonKey = Key('CameraAccessView_Okay_Button');

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: Dims.xxLargeEdgeInsets,
      child: Column(
        children: [
          const Spacer(),
          SvgPicture.asset('assets/camera_access.svg'),
          const SizedBox(
            height: Dims.large,
          ),
          Text(
            l10n.accessCamera,
            style: Theme.of(context).textTheme.headline5,
          ),
          const SizedBox(
            height: Dims.medium,
          ),
          Text(
            l10n.accessCameraDescription,
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: Dims.xxLarge * 2,
          ),
          ElevatedButton(
              key: okayButtonKey,
              onPressed: () {
                context
                    .read<StoreSubmissionBloc>()
                    .add(const StoreSubmissionNextEvent());
              },
              child: Text(l10n.okay)),
          const SizedBox(
            height: Dims.medium,
          ),
          TextButton(
            child: Text(l10n.notNow),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
