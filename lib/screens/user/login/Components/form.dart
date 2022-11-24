import 'package:flutter/material.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/model/login.dart';
import 'package:rakwa/model/user.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/screens/home_container/home_container_screen.dart';
import 'package:rakwa/screens/user/forget_password/forget_password.dart';
import 'package:rakwa/screens/user/signup/sigup.dart';
import 'package:rakwa/views/bottom_btns.dart';
import 'package:rakwa/views/progressing_button.dart';
import 'package:rakwa/views/text_field/email_text_field.dart';
import 'package:rakwa/views/text_field/password_text_field.dart';

import '../../../../main.dart';

class LoginForm extends StatefulWidget {
  bool fromHome;
  LoginForm({
    Key? key,
    required this.fromHome,
  }) : super(key: key);
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final login = Login(email: "", password: "");
  final GlobalKey<FormFieldState> _emailFieldState =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _passwordFieldState =
      GlobalKey<FormFieldState>();
  final GlobalKey<ProgressingButtonState> _progressingButton = GlobalKey();

  _onSubmitForm(context) async {
    if (!checkFields([_emailFieldState, _passwordFieldState])) {
      return;
    }
    //show progress
    _progressingButton.currentState!.showProgress(true);

    MyApp.userRepo.login(login).then((WebServiceResult<User> value) {
      _progressingButton.currentState?.showProgress(false);
      switch (value.status) {
        case WebServiceResultStatus.success:
          MyApp.isConnected = true;
          MyApp.token = value.data?.token ?? "";
          MyApp.userConnected = value.data;

          _navigateToHome(replace: true);
          break;
        case WebServiceResultStatus.error:
          mySnackBar(context,
              title: 'Login failed',
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
    if (widget.fromHome) {
      Navigator.pop(
        context,
      );
    } else {
      if (!replace) {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeContainerScreen()),
        );

        if (MyApp.isConnected) {
          Navigator.pop(context);
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeContainerScreen()),
        );
      }
    }
  }

  _navigateToSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        //  height: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                EmailTextField(
                  formFieldeKey: _emailFieldState,
                  onSave: (String? email) {
                    if (email != null) {
                      login.email = email;
                    }
                  },
                ),
                SizedBox(height: 8),
                PasswordTextField(
                    formFieldeKey: _passwordFieldState,
                    hint: MyApp.resources.strings.password,
                    onSubmit: (String? password) => _onSubmitForm(context),
                    onSave: (String? password) {
                      if (password != null) {
                        login.password = password;
                      }
                    },
                    textInputAction: TextInputAction.done),
                SizedBox(height: 20),
                TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.black,
                      backgroundColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(vertical: 4),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgetPasswordScreen()),
                      );
                    },
                    child: Container(
                      width: 130, // <-- set the sizing here
                      height: 20,
                      alignment: Alignment.center,
                      child: Text("هل نسيت كلمة المرور؟",
                          style:
                              Theme.of(context).textTheme.subtitle1?.copyWith(
                                    color: MyApp.resources.color.black1,
                                  )),
                    )),
              ],
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BottomButtons(
                      progressingButton: _progressingButton,
                      neutralButtonText: MyApp.resources.strings.skip,
                      submitButtonText: MyApp.resources.strings.login,
                      neutralButtonClick: () => _navigateToHome(),
                      submitButtonClick: () => _onSubmitForm(context)),
                  SizedBox(height: 12),
                  Flexible(
                    child: TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                          backgroundColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(vertical: 4),
                        ),
                        onPressed: () => _navigateToSignup(),
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
                                    text: "لا تمتلك حساب؟",
                                    style:
                                        Theme.of(context).textTheme.bodyText2),
                                TextSpan(
                                    text: ' تسجيل',
                                    style: Theme.of(context)
                                        .textTheme
                                        .button
                                        ?.copyWith(fontSize: 14)),
                              ],
                            )))),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
