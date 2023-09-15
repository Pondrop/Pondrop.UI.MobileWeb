import 'package:flutter/material.dart';
import 'package:pondrop/features/styles/styles.dart';

class BottomLoader extends StatelessWidget {
  const BottomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: Dims.smallEdgeInsets,
        child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
              strokeWidth: 1.5
            ),
        ),
      ),
    );
  }
}