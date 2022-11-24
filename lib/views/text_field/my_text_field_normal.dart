import 'package:flutter/material.dart';
import 'package:rakwa/res/images/MyImages.dart';

import '../../main.dart';

class MyNormalTextField extends StatefulWidget {
  String hint;
  String initial;
  String? texthint;
  TextInputAction textInputAction;
  TextInputType textInputType;
  Widget? prefixWidget;
  Widget? suffixWidget;
  GlobalKey<FormFieldState>? formFieldeKey;
  final Function(String value)? onSubmit;
  final Function(String? value)? onSave;
  final Function(String? value)? validator;
  final Function? onClick;
  bool isReadOnly;

  int minLines;

  int maxLines;

  bool isRequired = false;

  MyNormalTextField({
    Key? key,
    this.hint = "",
    this.initial = "",
    this.texthint,
    this.isRequired = false,
    this.onSubmit,
    this.suffixWidget,
    this.minLines = 1,
    this.maxLines = 1,
    this.prefixWidget,
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.formFieldeKey,
    this.validator,
    this.onClick,
    this.isReadOnly = false,
    required this.onSave,
  }) : super(key: key);

  @override
  State<MyNormalTextField> createState() => MyTextFieldState();
}

class MyTextFieldState extends State<MyNormalTextField> {
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
    borderSide: BorderSide(color: MyApp.resources.color.grey1, width: 1),
  );

  OutlineInputBorder focusBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide(color: MyApp.resources.color.grey1, width: 2),
  );
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.hint.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              widget.hint,
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontSize: 12, color: MyApp.resources.color.darkIconColor),
            ),
          ),
        if (widget.hint.isNotEmpty)
          SizedBox(
            height: 8,
          ),
        Material(
          child: InkWell(
            onTap: widget.onClick == null ? null : () => widget.onClick?.call(),
            child: TextFormField(
              enabled: !widget.isReadOnly,
              key: widget.formFieldeKey,
              enableSuggestions: false,
              autocorrect: false,
              readOnly: widget.isReadOnly,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              autofocus: false,
              textInputAction: widget.textInputAction,
              keyboardType: widget.textInputType,
              focusNode: myFocusNode,
              maxLines: widget.maxLines,
              minLines: widget.minLines,
              onFieldSubmitted: widget.onSubmit,
              initialValue: widget.initial,
              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                  color: MyApp.resources.color.grey2.withOpacity(0.7)),
              decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 8),
                    child: widget.prefixWidget,
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 8),
                    child: widget.suffixWidget,
                  ),
                  isDense: true,
                  suffixIconConstraints:
                      BoxConstraints(minWidth: 0, minHeight: 0),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
                  filled: true,
                  prefixIconConstraints:
                      BoxConstraints(minWidth: 0, minHeight: 0),
                  enabledBorder: border,
                  fillColor: Colors.white,
                  focusColor: MyApp.resources.color.grey1,
                  hintText: widget.texthint ?? widget.hint,
                  hintStyle: TextStyle(color: MyApp.resources.color.colorText),
                  disabledBorder: border,
                  focusedBorder: focusBorder,
                  border: border),
              validator: (widget.validator != null)
                  ? (String? value) => widget.validator!(value)
                  : widget.isRequired
                      ? (String? value) {
                          if (value?.isEmpty ?? false) {
                            return MyApp.resources.strings.mandatoryField;
                          }
                          return null;
                        }
                      : null,
              onSaved: widget.onSave,
            ),
          ),
        ),
      ],
    );
  }
}
