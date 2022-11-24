import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/profile.dart';
import 'package:rakwa/model/user.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/screens/user/profile/profile_screen.dart';
import 'package:rakwa/views/progressing_button.dart';
import 'package:rakwa/views/text_field/email_text_field.dart';
import 'package:rakwa/views/text_field/my_text_field.dart';
import 'package:rakwa/views/text_field/required_text_field.dart';

class BasicInfoScreen extends StatefulWidget {
  Function(GlobalKey<ProgressingButtonState> progressingButton) updateProfile;
  BasicInfoScreen({
    Key? key,
    required this.updateProfile,
  }) : super(key: key);

  @override
  State<BasicInfoScreen> createState() => BasicInfoScreenFormState();
}

class BasicInfoScreenFormState extends State<BasicInfoScreen> {
  final GlobalKey<FormFieldState> _firstNameFieldState =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _lastNameFieldState =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _emailFieldState =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _phoneFieldState =
      GlobalKey<FormFieldState>();
  final GlobalKey<ProgressingButtonState> _progressingButton = GlobalKey();

  bool readOnly = ProfileScreen.editable.value ?? true;

  editableForm(bool editable) {
    setState(() {
      readOnly = editable;
    });
  }

  _onSubmitForm(context) async {
    if (!checkFields([
      _firstNameFieldState,
      _lastNameFieldState,
      _emailFieldState,
      _phoneFieldState
    ])) {
      return;
    }

    //show progress
    _progressingButton.currentState!.showProgress(true);
    widget.updateProfile(_progressingButton);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              children: [
                RequiredTextField(
                    isReadOnly: readOnly,
                    initial: ProfileScreenState.user.firstname,
                    prefixWidget: SvgPicture.asset(MyIcons.icPerson),
                    formFieldeKey: _firstNameFieldState,
                    hint: "الإسم الأول",
                    onSave: (String? firstname) {
                      if (firstname != null) {
                        ProfileScreenState.user.firstname = firstname;
                        print(
                            "object $firstname  ${ProfileScreenState.user.firstname}");
                      }
                    },
                    textInputAction: TextInputAction.next),
                SizedBox(height: 8),
                RequiredTextField(
                    isReadOnly: readOnly,
                    initial: ProfileScreenState.user.lastname,
                    prefixWidget: SvgPicture.asset(MyIcons.icPerson),
                    formFieldeKey: _lastNameFieldState,
                    hint: "الإسم الأخير",
                    onSave: (String? text) {
                      if (text != null) {
                        ProfileScreenState.user.lastname = text;
                      }
                    },
                    textInputAction: TextInputAction.next),
                SizedBox(height: 8),
                EmailTextField(
                  textInputAction: TextInputAction.next,
                  isReadOnly: readOnly,
                  initialValue: ProfileScreenState.user.email,
                  formFieldeKey: _emailFieldState,
                  onSave: (String? email) {
                    if (email != null) {
                      ProfileScreenState.user.email = email;
                    }
                  },
                ),
                SizedBox(height: 8),
                MyTextField(
                    initial: ProfileScreenState.user.phone,
                    isReadOnly: readOnly,
                    textInputType: TextInputType.phone,
                    formFieldeKey: _phoneFieldState,
                    prefixWidget: Icon(Icons.phone_outlined),
                    hint: "رقم الهاتف",
                    onSubmit: (String? text) => _onSubmitForm(context),
                    onSave: (String? text) {
                      if (text != null) {
                        ProfileScreenState.user.phone = text;
                      }
                    },
                    textInputAction: TextInputAction.done),
                SizedBox(height: 12),
              ],
            ),
          ),
          SizedBox(height: 12),
          Visibility(
            visible: !readOnly,
            child: Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              alignment: Alignment.bottomCenter,
              child: Container(
                color: MyApp.resources.color.background,
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ProgressingButton(
                    key: _progressingButton,
                    textColor: Colors.white,
                    buttonText: "حفظ",
                    onSubmitForm: () => _onSubmitForm(context),
                    color: MyApp.resources.color.orange),
              ),
            ),
          ),
          if (!readOnly) SizedBox(height: 24),
        ],
      ),
    );
  }
}
