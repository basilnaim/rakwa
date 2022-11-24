import 'dart:ui';

import 'package:flutter/material.dart';

import 'base_colors.dart';

class AppColors implements BaseColors {
  final Map<int, Color> _primary = const {
    50: Color.fromRGBO(00, 00, 00, 0.1),
    100: Color.fromRGBO(00, 00, 00, 0.2),
    200: Color.fromRGBO(00, 00, 00, 0.3),
    300: Color.fromRGBO(00, 00, 00, 0.4),
    400: Color.fromRGBO(00, 00, 00, 0.5),
    500:  Color.fromRGBO(00, 00, 00, 0.6),
    600: Color.fromRGBO(00, 00, 00, 0.7),
    700: Color.fromRGBO(00, 00, 00, 0.8),
    800: Color.fromRGBO(00, 00, 00, 0.9),
    900: Color.fromRGBO(00, 00, 00, 1.0),
  };

  @override
  MaterialColor get colorAccent => MaterialColor(0xffFD8F06, _primary);

  @override
  MaterialColor get colorPrimary => MaterialColor(0xff000000, _primary);

  @override
  Color get colorPrimaryText => Color(0xff49ABFF);

  @override
  Color get colorSecondaryText => Color(0xff3593FF);

  @override
  Color get colorBackground => Color(0xffF8F8F8);

  @override
  Color get blue => Color(0xff01002C);

  @override
  Color get textFieldBorderColor => const Color(0xffd2dcf9);

  @override
  Color get selectedTextFieldBorderColor => Color(0xffb3cffc);

  @override
  Color get colorText => Color(0xff323438);

  @override
  Color get darkColor => Color(0xff484848);

  @override
  Color get lightColor => Color(0xffF8F8F8);

  @override
  Color get darkLightColor => Color(0xff66A5F1);

  @override
  Color get black1 => Color(0xff1A1A1A);

  @override
  Color get black2 => Color(0xff0C0D34);
 @override
  Color get black3 => Color(0xff5B5B5E);

@override
  Color get black4 => Color(0xff414141);

  @override
  Color get orange => Color(0xffFD8F06);

  @override
  // TODO: implement grey1
  Color get grey1=> Color(0xffE8E8E8);


  @override
  Color get grey2=> Color(0xff323438);
  
  @override
  Color get grey3=> Color(0xffFBFBFB);

  
  Color get background => Color(0xffF8F8F8);

  @override
  Color get iconColor => Color(0xff4C4B4C);

  @override
  Color get borderColor => Color(0xffE8E8E8);

  @override
  Color get darkIconColor => Color(0xff484848);

  @override
  Color get dividerColor => Color(0xffD8D8D8);

  @override
  Color get darkGrey => Color(0xff1A1A1A);

  @override
  Color get hintColor => Color(0xff6E6E6E);

  @override
  Color get textColor => Color(0xff222B45);

  @override
  Color get topCategoriesColor => Color(0xff313131);

  @override
  Color get green => Color(0xff0FBF61);

  @override
  Color get lightGrey => Color(0xff9A9A9A);
  
  @override
  Color get clearBlue => Color(0xffF3F5F9);

  @override
  Color get blue2 => Color(0xffB7BCCD);
@override
  Color get blue3 => Color(0xff242134);

  @override
  Color get black5 =>Color(0xff343434);
  @override
  Color get blue4 =>Color(0xffEDF1F3);


}
