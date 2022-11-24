import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/model/user.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/screens/home_container/home_container_screen.dart';
import 'package:rakwa/screens/user/login/login.dart';
import 'package:rakwa/views/bottom_btns.dart';
import 'package:rakwa/views/dialogs/default_dialog.dart';
import 'package:rakwa/views/text_field/email_text_field.dart';
import 'package:rakwa/views/text_field/password_text_field.dart';
import 'package:rakwa/views/progressing_button.dart';
import 'package:rakwa/views/text_field/required_text_field.dart';

import '../../../../main.dart';

class SignupForm extends StatefulWidget {
  bool fromHome;
  SignupForm({
    Key? key,
    this.fromHome = false,
  }) : super(key: key);
  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final user = User();
  final GlobalKey<FormFieldState> _firstNameFieldState =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _lastNameFieldState =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _emailFieldState =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _passwordFieldState =
      GlobalKey<FormFieldState>();
  final GlobalKey<ProgressingButtonState> _progressingButton = GlobalKey();

  _onSubmitForm(context) async {
    if (!checkFields([
      _firstNameFieldState,
      _lastNameFieldState,
      _emailFieldState,
      _passwordFieldState
    ])) {
      return;
    }
    //show progress
    _progressingButton.currentState!.showProgress(true);

    MyApp.userRepo.register(user).then((WebServiceResult<String> value) {
      _progressingButton.currentState?.showProgress(false);
      switch (value.status) {
        case WebServiceResultStatus.success:
          showDialog(
              context: context,
              builder: (BuildContext context) => defaultDialog(
                      context, "Notice", value.data ?? "", "Login", () {
                    if (widget.fromHome) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginScreen(
                                  fromHome: widget.fromHome,
                                )),
                      );
                    } else {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }
                  }));

          break;
        case WebServiceResultStatus.error:
          mySnackBar(context,
              title: 'Signup failed',
              message: value.message,
              status: SnackBarStatus.error);

          break;
        case WebServiceResultStatus.loading:
          break;
        case WebServiceResultStatus.unauthorized:
          break;
      }
    });
  }

  _navigateToHome({bool replace = false}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeContainerScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        //  height: MediaQuery.of(context).size.width * 0.9,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          RequiredTextField(
                              prefixWidget: SvgPicture.asset(MyIcons.icPerson),
                              formFieldeKey: _firstNameFieldState,
                              hint: "الإسم الأول",
                              onSave: (String? firstname) {
                                if (firstname != null) {
                                  user.firstname = firstname;
                                }
                              },
                              textInputAction: TextInputAction.done),
                          SizedBox(height: 8),
                          RequiredTextField(
                              prefixWidget: SvgPicture.asset(MyIcons.icPerson),
                              formFieldeKey: _lastNameFieldState,
                              hint: "الإسم الأخير",
                              onSave: (String? text) {
                                if (text != null) {
                                  user.lastname = text;
                                }
                              },
                              textInputAction: TextInputAction.done),
                          SizedBox(height: 8),
                          EmailTextField(
                            formFieldeKey: _emailFieldState,
                            onSave: (String? email) {
                              if (email != null) {
                                user.username = email;
                              }
                            },
                          ),
                          SizedBox(height: 8),
                          PasswordTextField(
                              formFieldeKey: _passwordFieldState,
                              hint: MyApp.resources.strings.password,
                              onSubmit: (String? password) =>
                                  _onSubmitForm(context),
                              onSave: (String? password) {
                                if (password != null) {
                                  user.password = password;
                                }
                              },
                              textInputAction: TextInputAction.done),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BottomButtons(
                        progressingButton: _progressingButton,
                        neutralButtonText: MyApp.resources.strings.skip,
                        submitButtonText: "تسجيل",
                        neutralButtonClick: () => _navigateToHome(),
                        submitButtonClick: () => _onSubmitForm(context)),
                    SizedBox(height: 12),
                    TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                          backgroundColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(vertical: 4),
                        ),
                        onPressed: () {
                          if (widget.fromHome) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen(
                                        fromHome: widget.fromHome,
                                      )),
                            );
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                            height: 20,
                            alignment: Alignment.center,
                            child: RichText(
                                text: TextSpan(
                              // Note: Styles for TextSpans must be explicitly defined.
                              // Child text spans will inherit styles from parent
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: "هل يوجد لديك حساب بالفعل؟",
                                    style:
                                        Theme.of(context).textTheme.bodyText2),
                                TextSpan(
                                    text: ' تسجيل الدخول',
                                    style: Theme.of(context)
                                        .textTheme
                                        .button
                                        ?.copyWith(fontSize: 14)),
                              ],
                            )))),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
