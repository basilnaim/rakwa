import 'package:flutter/material.dart';
import 'package:rakwa/res/images/MyImages.dart';

import '../../main.dart';

class MyTextField extends StatefulWidget {
  String hint;
  String initial;
  String? texthint;
  TextInputAction textInputAction;
  TextInputType textInputType;
  Widget? prefixWidget;
  GlobalKey<FormFieldState> formFieldeKey;
  final Function(String value)? onSubmit;
  final Function(String? value)? onSave;
  final Function(String? value)? validator;
  bool isReadOnly;

  int minLines;

  int maxLines;
  String? subHint;

  MyTextField({
    Key? key,
    this.hint = "",
    this.initial = "",
    this.texthint = "",
    this.onSubmit,
    this.minLines = 1,
    this.maxLines = 1,
    this.prefixWidget,
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    required this.formFieldeKey,
    this.validator,
    this.isReadOnly = false,
    required this.onSave,
    this.subHint,
  }) : super(key: key);

  @override
  State<MyTextField> createState() => MyTextFieldState();
}

class MyTextFieldState extends State<MyTextField> {
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
    borderSide: BorderSide(color: Colors.transparent, width: 0.0),
  );

  OutlineInputBorder focusBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide(color: Colors.transparent, width: 0.0),
  );
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            border: Border.all(
              color: (widget.formFieldeKey.currentState?.hasError == true)
                  ? Colors.red
                  : MyApp.resources.color.borderColor,
              width: 0.8,
            ),
          ),
          padding: EdgeInsets.only(left: 16, right: 16 , top: 16,bottom: 16),
          child: InkWell(
            onTap: () {
              requestFocus = true;
              setState(() {
                myFocusNode.requestFocus();
              });
            },
            child: Row(
              children: [
                if (widget.prefixWidget != null) widget.prefixWidget!,
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        widget.hint,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(color: MyApp.resources.color.darkColor),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        child: TextFormField(
                            readOnly: widget.isReadOnly,
                            //autovalidateMode: AutovalidateMode.onUserInteraction,
                            cursorColor: Colors.black,
                            onChanged: (String? value) {
                              widget.formFieldeKey.currentState?.validate();
                            },
                            key: widget.formFieldeKey,
                            obscureText: (widget.textInputType !=
                                        TextInputType.visiblePassword ||
                                    widget.isReadOnly)
                                ? false
                                : _isObscure
                                    ? true
                                    : false,
                            enableSuggestions: false,
                            autocorrect: false,
                            minLines: widget.minLines,
                            maxLines: widget.maxLines,
                            textInputAction: widget.textInputAction,
                            keyboardType: widget.textInputType,
                            focusNode: myFocusNode,
                            onFieldSubmitted: widget.onSubmit,
                            onSaved: widget.onSave,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                ?.copyWith(
                                  fontSize: 16,
                                    color: Colors.black
                                       ),
                            decoration: InputDecoration(
                                isDense: true,
                                errorBorder: border,
                                errorMaxLines: 1,
                                errorStyle: TextStyle(
                                    fontSize: 0.1, color: Colors.transparent),
                                focusedErrorBorder: border,
                                errorText: null,
                                hintText: (widget.texthint == null ||
                                        widget.texthint?.isEmpty == true)
                                    ? widget.hint
                                    : widget.texthint,
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    ?.copyWith(
                                        color: MyApp.resources.color.grey2
                                            .withOpacity(0.6)),
                                contentPadding: EdgeInsets.zero,
                                filled: true,
                                fillColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                disabledBorder: focusBorder,
                                focusedBorder: focusBorder,
                                enabledBorder: border,
                                border: focusBorder),
                            initialValue: widget.initial,
                            validator: (String? value) {
                              if (widget.validator == null) {
                                return null;
                              } else {
                                String? error = widget.validator!(value);
                                if (error != null && error.isNotEmpty)
                                  setState(() {});

                                if (error == null &&
                                    widget.formFieldeKey.currentState
                                            ?.hasError ==
                                        true) setState(() {});

                                return widget.validator!(value);
                              }
                            }),
                      ),
                    
                    ],
                  ),
                ),
                  if (widget.textInputType ==
                              TextInputType.visiblePassword &&
                          !widget.isReadOnly)
                        IconButton(
                            icon: Icon(
                              _isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: MyApp.resources.color.colorText,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            })
              ],
            ),
          ),
        ),
        if (widget.formFieldeKey.currentState?.hasError == true)
          Text(
            widget.formFieldeKey.currentState?.errorText ?? "",
            style: Theme.of(context)
                .textTheme
                .bodyText2
                ?.copyWith(color: Colors.red),
          )
      ],
    );
  }
}
