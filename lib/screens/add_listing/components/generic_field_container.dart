import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';

import 'package:rakwa/model/form_field.dart';
import 'package:rakwa/views/text_field/my_text_field.dart';
import 'package:rakwa/views/text_field/my_text_field_normal.dart';

class GenericFieldContainer extends StatefulWidget {
  GenericFormField field;

  GenericFieldContainer({
    Key? key,
    required this.field,
  }) : super(key: key);

  @override
  State<GenericFieldContainer> createState() => GenericFieldContainerState();
}

class GenericFieldContainerState extends State<GenericFieldContainer> {
  GlobalKey<FormFieldState> formFieldeKey = GlobalKey<FormFieldState>();

  bool error = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        children: [generateFieldContainer(context)],
      ),
    );
  }

  String? save() {
    switch (widget.field.type) {
      case GenericFormFieldType.url:
        if (!checkFields([formFieldeKey])) {
          return "";
        }
        break;
      case GenericFormFieldType.textarea:
        if (!checkFields([formFieldeKey])) {
          return "";
        }
        break;
      case GenericFormFieldType.checkbox:
        if (widget.field.value.isEmpty && widget.field.isRequired) {
          return '${widget.field.label} is required';
        }
        break;
      case GenericFormFieldType.range:
        if (widget.field.value.isEmpty && widget.field.isRequired) {
          return '${widget.field.label} is required';
        }
        break;
      case GenericFormFieldType.dropdown:
        if (widget.field.value.isEmpty && widget.field.isRequired) {
          return '${widget.field.label} is required';
        }
        break;

      default:
        return null;
    }
    return null;
  }

  Widget generateFieldContainer(context) {
    return generateField(context);
  }

  Widget generateField(context) {
    switch (widget.field.type) {
      case GenericFormFieldType.url:
        return MyNormalTextField(
          initial: widget.field.value,
          hint: widget.field.label,
          maxLines: 1,
          validator: (String? value) {
            if (widget.field.isRequired && (value?.isEmpty ?? true)) {
              return MyApp.resources.strings.mandatoryField;
            }
            return null;
          },
          textInputType: TextInputType.url,
          formFieldeKey: formFieldeKey,
          onSave: (String? value) {
            if (value != null) widget.field.value = value;
          },
        );

      case GenericFormFieldType.text:
        return MyNormalTextField(
          initial: widget.field.value,
          hint: widget.field.label,
          maxLines: 1,
          validator: (String? value) {
            if (widget.field.isRequired && (value?.isEmpty ?? true)) {
              return MyApp.resources.strings.mandatoryField;
            }
            return null;
          },
          textInputType: TextInputType.text,
          formFieldeKey: formFieldeKey,
          onSave: (String? value) {
            if (value != null) widget.field.value = value;
          },
        );

      case GenericFormFieldType.textarea:
        return MyNormalTextField(
          initial: widget.field.value,
          hint: widget.field.label,
          minLines: 3,
          maxLines: 6,
          validator: (String? value) {
            if (widget.field.isRequired && (value?.isEmpty ?? true)) {
              return MyApp.resources.strings.mandatoryField;
            }
            return null;
          },
          textInputType: TextInputType.multiline,
          formFieldeKey: formFieldeKey,
          onSave: (String? value) {
            if (value != null) widget.field.value = value;
          },
        );
      case GenericFormFieldType.checkbox:
        return InkWell(
          onTap: () {
            setState(() {
              widget.field.value =
                  (widget.field.value.isEmpty) ? widget.field.label : "";
            });
          },
          splashColor: Colors.orange,
          child: Row(
            children: [
              Theme(
                data: Theme.of(context).copyWith(
                  unselectedWidgetColor: Colors.grey,
                ),
                child: Checkbox(
                  activeColor: Colors.transparent,
                  checkColor: Colors.orange,
                  onChanged: (value) {
                    setState(() {
                      widget.field.value =
                          (value == true) ? widget.field.label : "";
                    });
                  },
                  value: widget.field.value == widget.field.label,
                ),
              ),
              SizedBox(width: 8),
              Text(
                widget.field.label,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.copyWith(color: MyApp.resources.color.black2),
              )
            ],
          ),
        );
      case GenericFormFieldType.range:
        return wrapWithContziner(
          RatingBar.builder(
            initialRating: widget.field.value.isEmpty
                ? 0
                : double.parse(widget.field.value),
            glowColor: Colors.amber,
            minRating: 0,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 35,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              widget.field.value = "$rating";
            },
          ),
        );

      case GenericFormFieldType.dropdown:
        return wrapWithContziner(
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            width: double.maxFinite,
            height: 50,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: widget.field.value.isEmpty
                    ? (widget.field.data.isEmpty
                        ? null
                        : widget.field.data[0].value)
                    : widget.field.value,
                icon: const Icon(Icons.keyboard_arrow_down),
                onChanged: (String? newValue) {
                  setState(() {
                    widget.field.value = newValue ?? "";
                  });
                },
                items: widget.field.data
                    .map((e) => e.value)
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(color: MyApp.resources.color.colorText),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      default:
        return Container();
    }
  }

  wrapWithContziner(child) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.field.label,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                fontSize: 12, color: MyApp.resources.color.darkIconColor),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          height: 56,
          width: double.maxFinite,
          child: Center(
            child: child,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            border: Border.all(
              color: error ? Colors.red : MyApp.resources.color.borderColor,
              width: 0.8,
            ),
          ),
        )
      ]);
}
