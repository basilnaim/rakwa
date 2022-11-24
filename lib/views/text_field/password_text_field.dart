import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/res/icons/my_icons.dart';

import 'my_text_field.dart';

class PasswordTextField extends MyTextField {
  GlobalKey<FormFieldState> formFieldeKey;
  final Function(String value)? onSubmit;
  final Function(String? value)? onSave;
  final Function(String? value)? pwdValidator;
  TextInputAction textInputAction;
  String hint;
  String initial;
  bool isReadOnly;
  PasswordTextField(
      {this.textInputAction = TextInputAction.next,
      this.onSave,
      required this.hint,
      this.pwdValidator,
      this.initial = '',
      this.isReadOnly = false,
      required this.formFieldeKey,
      this.onSubmit})
      : super(
            prefixWidget: SvgPicture.asset(MyIcons.icLock),
            formFieldeKey: formFieldeKey,
            validator: pwdValidator ??
                (String? pwd) {
                  if ((pwd?.length ?? 0) < 8) {
                    return MyApp.resources.strings.validePwd;
                  }
                  return null;
                },
            isReadOnly: isReadOnly,
            onSave: onSave,
            texthint: "********",
            onSubmit: onSubmit,
            textInputAction: textInputAction,
            textInputType: TextInputType.visiblePassword,
            hint: hint);
}
