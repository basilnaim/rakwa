import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';

import 'my_text_field.dart';

class RequiredTextField extends MyTextField {
  GlobalKey<FormFieldState> formFieldeKey;
  final Function(String value)? onSubmit;
  final Function(String? value)? onSave;
  TextInputAction textInputAction;
  String hint;
  String initial;
  String? texthint;
  Widget? prefixWidget;
  TextInputType? inputType;
  bool isReadOnly;
  RequiredTextField(
      {Key? key,
      this.textInputAction = TextInputAction.next,
      this.onSave,
      required this.hint,
      this.texthint,
      this.inputType,
      this.isReadOnly = false ,
      this.initial = "",
      required this.formFieldeKey,
      this.prefixWidget,
      this.onSubmit})
      : super(
            key: key,
            texthint: texthint,
            isReadOnly : isReadOnly,
            prefixWidget: prefixWidget,
            formFieldeKey: formFieldeKey,
            validator: (String? value) {
              if (value?.isEmpty ?? false) {
                return MyApp.resources.strings.mandatoryField;
              }

               if (value?.startsWith(" ") == true || value?.endsWith(" ")== true) {
                return "Please verify this field";
              }
              return null;
            },
            onSave: onSave,
            onSubmit: onSubmit,
            textInputAction: textInputAction,
            textInputType: (inputType == null) ? TextInputType.text : inputType,
            hint: hint);
}
