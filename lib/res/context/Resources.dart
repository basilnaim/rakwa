import 'package:flutter/cupertino.dart';

import '../colors/app_colors.dart';
import '../strings/FrenchStrings.dart';
import '../strings/Strings.dart';

class Resources {
  BuildContext _context;

  Resources(this._context);

  Strings get strings {
    // It could be from the user preferences or even from the current locale
    return FrenchStrings();
  }

  AppColors get color {
    return AppColors();
  }

  static Resources of(BuildContext context) {
    return Resources(context);
  }
}
