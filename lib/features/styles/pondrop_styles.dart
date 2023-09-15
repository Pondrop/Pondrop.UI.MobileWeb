import 'package:flutter/material.dart';
import 'package:pondrop/features/styles/styles.dart';

class PondropStyles {
  static const appBarTitleTextStyle =
      TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500);

  static final whiteElevatedButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.white, foregroundColor: Colors.black);
  static const blackButtonTextStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.w500);

  static const titleTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static const popupTitleTextStyle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w500,
  );

  static const linkTextStyle =
      TextStyle(fontSize: 17, color: PondropColors.linkColor);
}
