import 'package:flutter/material.dart';
import 'package:rakwa/res/images/MyImages.dart';

import '../../main.dart';

class TextFieldNone extends StatefulWidget {
  String hint;
  String initial;
  String? texthint;
  TextInputAction textInputAction;
  TextInputType textInputType;
  Widget? suffixWidget;
  GlobalKey<FormFieldState> formFieldeKey;
  final Function(String value)? onSubmit;
  final Function(String? value)? onSave;
  final Function(String? value)? validator;
  bool isReadOnly;

  int minLines;

  int maxLines;

  TextFieldNone({
    Key? key,
    this.hint = "",
    this.initial = "",
    this.texthint = "",
    this.onSubmit,
    this.minLines = 1,
    this.maxLines = 1,
    this.suffixWidget,
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    required this.formFieldeKey,
    this.validator,
    this.isReadOnly = false,
    required this.onSave,
  }) : super(key: key);

  @override
  State<TextFieldNone> createState() => MyTextFieldState();
}

class MyTextFieldState extends State<TextFieldNone> {
  FocusNode myFocusNode = FocusNode();
  bool requestFocus = true;

 

  _focusListener() {
    setState(() {});
  }

  @override
  void initState() {
    myFocusNode.addListener(_focusListener);
    super.initState();
  }

  @override
  void dispose() {
    myFocusNode.removeListener(_focusListener);
    super.dispose();
  }


  bool _isObscure = true;
  OutlineInputBorder border = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide(color: MyApp.resources.color.grey1, width: 0.5),
  );

  OutlineInputBorder focusBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide(color: MyApp.resources.color.grey1, width: 0.5),
  );
  @override
  Widget build(BuildContext context) {
    return  TextFormField(
          enabled: !widget.isReadOnly,
          key: widget.formFieldeKey,
          enableSuggestions: false,
          autocorrect: false,
          readOnly: widget.isReadOnly,
              autofocus: false,
          textInputAction: widget.textInputAction,
          keyboardType: widget.textInputType,
          focusNode: myFocusNode,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          onFieldSubmitted: widget.onSubmit,
          initialValue: widget.initial,
          style: Theme.of(context)
              .textTheme
              .bodyText2
              ?.copyWith(color: MyApp.resources.color.grey2.withOpacity(0.7)),
          decoration: InputDecoration(
              suffix: widget.suffixWidget,
              contentPadding:
                  EdgeInsets.only(top: 8.0,bottom: 20, left: 20.0 , right: 20),
              filled: false,
              enabledBorder: border,
              fillColor: Colors.white,
              focusColor: MyApp.resources.color.grey1,
              hintText: widget.hint,
              hintStyle: TextStyle(color: MyApp.resources.color.colorText),
              disabledBorder: border,
              focusedBorder: focusBorder,
              border: border),
          validator: (widget.validator != null)
              ? (String? value) => widget.validator!(value)
              : null,
          onSaved: widget.onSave,
        );
  }
}
