import 'package:flutter/material.dart';

enum FontFamily { light , regular, medium, semibold, bold, heavy }

extension FontFamilyExt on FontFamily {
  FontWeight fontWeight() {
    switch (this) {
       case FontFamily.light:
       return FontWeight.w400;
       
      case FontFamily.regular:
        return FontWeight.w500;

      case FontFamily.medium:
        return FontWeight.w600;

      case FontFamily.semibold:
        return FontWeight.w700;

      case FontFamily.bold:
        return FontWeight.w800;

      case FontFamily.heavy:
        return FontWeight.w900;
     

    }
  }
}
