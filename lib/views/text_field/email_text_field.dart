import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/res/images/MyImages.dart';
import 'my_text_field.dart';

class EmailTextField extends MyTextField {
  GlobalKey<FormFieldState> formFieldeKey;
  final Function(String value)? onSubmit;
  final Function(String? value)? onSave;
  TextInputAction textInputAction;
  String? initialValue;
  bool isReadOnly;

  EmailTextField(
      {this.textInputAction = TextInputAction.next,
      this.onSave,
      this.initialValue,
      this.isReadOnly = false,
      required this.formFieldeKey,
      this.onSubmit})
      : super(
          isReadOnly: isReadOnly,
          texthint: "example@example.com",
          initial: initialValue ?? "",
          formFieldeKey: formFieldeKey,
          prefixWidget: Image.asset(MyImages.icEmail),
          validator: (String? email) {
            if (email?.isEmpty == true) {
              return "الرجاء إدخال البريد الإلكتروني";
            }
            if (!RegExp(
                    r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(email!)) {
              return MyApp.resources.strings.validEmailText;
            }
            return null;
          },
          onSave: onSave,
          onSubmit: onSubmit,
          textInputAction: textInputAction,
          textInputType: TextInputType.emailAddress,
          hint: MyApp.resources.strings.email,
        );
}
