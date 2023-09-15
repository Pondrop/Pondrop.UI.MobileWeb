import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class IconValidator {
  static Tuple2<String, int> safeIconCodePoint(
      String fontFamily, int codePoint) {
    if (fontFamily.isNotEmpty) {
      try {
        String.fromCharCode(codePoint);
        return Tuple2(fontFamily, codePoint);
      } catch (e) {
        log(e.toString());
      }
    }

    return Tuple2('MaterialIcons', Icons.inventory_outlined.codePoint);
  }
}
