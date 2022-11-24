import 'package:flutter/material.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/update_pwd.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/screens/home/Components/drawer.dart';
import 'package:rakwa/screens/user/profile/profile_screen.dart';
import 'package:rakwa/views/progressing_button.dart';
import 'package:rakwa/views/text_field/password_text_field.dart';

class UpdatePasswordScreen extends StatefulWidget {
  UpdatePasswordScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<UpdatePasswordScreen> createState() => UpdatePasswordScreenState();
}

UpdatePassword updatePassword = UpdatePassword();

class UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final GlobalKey<FormFieldState> _currentPassword =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _newPassword = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _confirmPassword =
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
      _currentPassword,
      _newPassword,
      _confirmPassword,
    ])) {
      return;
    }
    //show progress
    _progressingButton.currentState?.showProgress(true);
    MyApp.userRepo
        .updatePassword(ProfileScreenState.token, updatePassword)
        .then((result) {
      _progressingButton.currentState?.showProgress(false);
      switch (result.status) {
        case WebServiceResultStatus.success:
          _currentPassword.currentState?.didChange("");
          _newPassword.currentState?.didChange("");
          _confirmPassword.currentState?.didChange("");

          mySnackBar(context,
              title: 'Update password',
              message: "Password updated",
              status: SnackBarStatus.success);

          break;
        case WebServiceResultStatus.error:
          mySnackBar(context,
              title: 'Update password',
              message: "Failed to update your password!",
              status: SnackBarStatus.error);

          break;
        case WebServiceResultStatus.loading:
          break;
        case WebServiceResultStatus.unauthorized:
          DrawerPageState.disconnect(context);

          break;
      }
    });
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
                PasswordTextField(
                    isReadOnly: readOnly,
                    formFieldeKey: _currentPassword,
                    hint: "كلمة المرور القديمة",
                    onSave: (String? text) {
                      if (text != null) {
                        updatePassword.currentPwd = text;
                      }
                    },
                    textInputAction: TextInputAction.next),
                SizedBox(height: 8),
                PasswordTextField(
                    isReadOnly: readOnly,
                    formFieldeKey: _newPassword,
                    hint: "كلمة المرور الجديدة",
                    onSave: (String? text) {
                      if (text != null) {
                        updatePassword.newPwd = text;
                      }
                    },
                    textInputAction: TextInputAction.next),
                SizedBox(height: 8),
                PasswordTextField(
                  hint: "تأكيد كلمة المرور الجديدة",
                  isReadOnly: readOnly,
                  textInputAction: TextInputAction.next,
                  formFieldeKey: _confirmPassword,
                  pwdValidator: (String? pwd) {
                    if (pwd == null || pwd.isEmpty) {
                      return MyApp.resources.strings.validePwd;
                    } else if (pwd !=
                        (_newPassword.currentState?.value ?? "")) {
                      return "The two passwords entered do not match. Please try again.";
                    }
                    return null;
                  },
                  onSave: (String? text) {
                    if (text != null) {
                      updatePassword.confirmPwd = text;
                    }
                  },
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
          //  SizedBox(height: 12),
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
                    buttonText: "تغيير كلمة المرور",
                    onSubmitForm: () => _onSubmitForm(context),
                    color: MyApp.resources.color.orange),
              ),
            ),
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }
}
