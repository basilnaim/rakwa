import 'package:flutter/material.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/screens/add_listing/components/header.dart';
import 'package:rakwa/screens/add_listing/components/step2.dart';
import 'package:rakwa/screens/add_listing/components/tamplate.dart';
import 'package:rakwa/views/bottom_btns.dart';
import 'package:rakwa/views/progressing_button.dart';
import 'package:rakwa/views/text_field/my_text_field_normal.dart';

import '../listing_screen.dart';

class AddListingStep1 extends StatefulWidget {
  AddListingStep1({Key? key}) : super(key: key);

  @override
  State<AddListingStep1> createState() => _AddListingStep1State();
}

class _AddListingStep1State extends State<AddListingStep1> {
  GlobalKey<FormFieldState> titleFormField = GlobalKey<FormFieldState>();

  GlobalKey<FormFieldState> descriptionFormField = GlobalKey<FormFieldState>();

  onNexClick() {
    if (!checkFields([titleFormField, descriptionFormField])) {
      return;
    }
    ListingScreenState.bottomTabNavigation.moveToNext();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          bottom: 80,
          left: 16,
          right: 16,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                MyNormalTextField(
                    formFieldeKey: titleFormField,
                    hint: "Listing title",
                    initial: ChooseTemplateScreen.listingToAdd.title,
                    maxLines: 1,
                    textInputAction: TextInputAction.next,
                    validator: (String? value) {
                      return (value == null || value.isEmpty)
                          ? "Fill your listing title please"
                          : null;
                    },
                    onSave: (String? title) {
                      ChooseTemplateScreen.listingToAdd.title = title ?? "";
                    }),
                SizedBox(height: 14),
                MyNormalTextField(
                    formFieldeKey: descriptionFormField,
                    hint: "List description",
                    initial: ChooseTemplateScreen.listingToAdd.description,
                    maxLines: 6,
                    minLines: 4,
                      validator: (String? value) {
                      return (value == null || value.isEmpty)
                          ? "Fill your listing description please"
                          : null;
                    },
                    onSubmit: (String value) => onNexClick(),
                    textInputAction: TextInputAction.done,
                    onSave: (String? description) {
                      ChooseTemplateScreen.listingToAdd.description =
                          description ?? "";
                    }),
                SizedBox(height: 22),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 40, right: 40, top: 16, bottom: 16),
            //  width: double.infinity,
            child: BottomButtons(
                neutralButtonText: "Previous",
                submitButtonText: "Next",
                neutralButtonClick: () {
                  Navigator.maybePop(context);
                },
                submitButtonClick: () => onNexClick()),
          ),
        ),
      ],
    );
  }
}
