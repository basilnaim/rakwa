import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/screens/add_listing/components/tamplate.dart';
import 'package:rakwa/views/bottom_btns.dart';
import 'package:rakwa/views/progressing_button.dart';
import 'package:rakwa/views/text_field/my_text_field_normal.dart';

import '../listing_screen.dart';

class ListingGeneralInfo extends StatefulWidget {
  Function(GlobalKey<ProgressingButtonState>) saveListing;

  ListingGeneralInfo({Key? key, required this.saveListing}) : super(key: key);

  @override
  State<ListingGeneralInfo> createState() => _ListingGeneralInfoState();
}

class _ListingGeneralInfoState extends State<ListingGeneralInfo> {
  GlobalKey<FormFieldState> establishedInFormField =
      GlobalKey<FormFieldState>();

  GlobalKey<FormFieldState> specialitiesFormField = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> ownerNameFormField = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> ownerEmailFormField = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> policiesFormField = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> buildingBridgeFormField =
      GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> overviewFormField = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> introductionFormField = GlobalKey<FormFieldState>();
  final GlobalKey<ProgressingButtonState> _progressingButton = GlobalKey();

  onNexClick() {
    if (!checkFields([
      ownerNameFormField,
      ownerEmailFormField,
     // policiesFormField,
     // buildingBridgeFormField,
      overviewFormField,
     // introductionFormField,
      //specialitiesFormField
    ])) {
      return;
    }
    if (!ListingScreenState.containGenericForm) {
      widget.saveListing(_progressingButton);
    } else {
      ListingScreenState.bottomTabNavigation.moveToNext();
    }
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showMonthYearPicker(
        context: context,
        locale: const Locale("en"),
        builder: (c, e) {
          return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: ColorScheme.light(
                    // change the border color
                    primary: MyApp.resources.color.grey2,
                    // change the text color
                    onSurface: Colors.black,
                    secondary: Colors.orange.withOpacity(0.7)),
                // button colors
                buttonTheme: const ButtonThemeData(
                  colorScheme: ColorScheme.light(
                    primary: Colors.black,
                  ),
                ),
              ),
              child: e!);
        },
        initialMonthYearPickerMode: MonthYearPickerMode.year,
        firstDate: DateTime(1900),
        initialDate: selectedDate,
        lastDate: DateTime.now());
    if (picked != null) {
      ChooseTemplateScreen.listingToAdd.establishedIn = picked.year.toString();
      establishedInFormField.currentState
          ?.didChange(ChooseTemplateScreen.listingToAdd.establishedIn);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 80,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  MyNormalTextField(
                      formFieldeKey: ownerNameFormField,
                      hint: "Owner Name",
                      initial: ChooseTemplateScreen.listingToAdd.ownerName,
                      maxLines: 1,
                      textInputType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      onSave: (String? title) {
                        ChooseTemplateScreen.listingToAdd.ownerName =
                            title ?? "";
                      }),
                  SizedBox(
                    height: 12,
                  ),
                  MyNormalTextField(
                      formFieldeKey: ownerEmailFormField,
                      hint: "Owner email",
                      initial: ChooseTemplateScreen.listingToAdd.ownerEmail,
                      maxLines: 1,
                      textInputType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onSave: (String? title) {
                        ChooseTemplateScreen.listingToAdd.ownerEmail =
                            title ?? "";
                      }),
                  /*
  SizedBox(
                    height: 12,
                  ),
                  MyNormalTextField(
                      isReadOnly: true,
                      formFieldeKey: establishedInFormField,
                      hint: "Established In",
                      onClick: () {
                        _selectDate(context);
                      },
                      initial: ChooseTemplateScreen.listingToAdd.establishedIn,
                      maxLines: 1,
                      textInputType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onSave: (String? title) {
                        ChooseTemplateScreen.listingToAdd.establishedIn =
                            title ?? "";
                      }),
                  SizedBox(
                    height: 12,
                  ),
                  MyNormalTextField(
                      formFieldeKey: specialitiesFormField,
                      hint: "Specialities",
                      initial: ChooseTemplateScreen.listingToAdd.specialities,
                      maxLines: 4,
                      minLines: 3,
                      textInputType: TextInputType.multiline,
                      textInputAction: TextInputAction.next,
                      onSave: (String? value) {
                        ChooseTemplateScreen.listingToAdd.specialities =
                            value ?? "";
                      }),
                  SizedBox(
                    height: 12,
                  ),
                  MyNormalTextField(
                      formFieldeKey: buildingBridgeFormField,
                      hint: "Building Bridge",
                      initial: ChooseTemplateScreen.listingToAdd.buildingBridge,
                      maxLines: 6,
                      minLines: 6,
                      textInputType: TextInputType.multiline,
                      textInputAction: TextInputAction.next,
                      onSave: (String? value) {
                        ChooseTemplateScreen.listingToAdd.buildingBridge =
                            value ?? "";
                      }),
                  SizedBox(
                    height: 12,
                  ),
                  MyNormalTextField(
                      formFieldeKey: policiesFormField,
                      hint: "Policies",
                      initial: ChooseTemplateScreen.listingToAdd.policies,
                      maxLines: 6,
                      minLines: 6,
                      textInputType: TextInputType.multiline,
                      textInputAction: TextInputAction.next,
                      onSave: (String? value) {
                        ChooseTemplateScreen.listingToAdd.policies =
                            value ?? "";
                      }),
                  const SizedBox(
                    height: 12,
                  ),
                  MyNormalTextField(
                      formFieldeKey: introductionFormField,
                      hint: "Introduction",
                      initial: ChooseTemplateScreen.listingToAdd.introduction,
                      maxLines: 6,
                      minLines: 6,
                      textInputType: TextInputType.multiline,
                      textInputAction: TextInputAction.next,
                      onSave: (String? value) {
                        ChooseTemplateScreen.listingToAdd.introduction =
                            value ?? "";
                      }),
                  
                */
                  SizedBox(
                    height: 12,
                  ),
                  MyNormalTextField(
                      formFieldeKey: overviewFormField,
                      hint: "Overview",
                      initial: ChooseTemplateScreen.listingToAdd.overview,
                      maxLines: 6,
                      minLines: 6,
                      textInputType: TextInputType.multiline,
                      textInputAction: TextInputAction.done,
                      onSave: (String? value) {
                        ChooseTemplateScreen.listingToAdd.overview =
                            value ?? "";
                      }),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 80,
            color: Colors.white,
            padding: EdgeInsets.only(left: 40, right: 40, top: 16, bottom: 16),
            //  width: double.infinity,
            child: BottomButtons(
                progressingButton: _progressingButton,
                neutralButtonText: "Previous",
                submitButtonText:
                    ListingScreenState.containGenericForm ? "Next" : "Save",
                neutralButtonClick: () {
                  Navigator.maybePop(context);
                },
                submitButtonClick: () {
                  onNexClick();
                }),
          ),
        ),
      ],
    );
  }
}
