import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/screens/home/Components/drawer.dart';
import 'package:rakwa/views/dialogs/default_dialog.dart';
import 'package:rakwa/views/text_field/email_text_field.dart';
import 'package:rakwa/views/progressing_button.dart';

import '../../../../main.dart';

class ForgetPasswordForm extends StatefulWidget {
  @override
  State<ForgetPasswordForm> createState() => _ForgetPasswordFormState();
}

class _ForgetPasswordFormState extends State<ForgetPasswordForm> {
  String email = "";
  final GlobalKey<FormFieldState> _emailFieldState =
      GlobalKey<FormFieldState>();

  final GlobalKey<ProgressingButtonState> _progressingButton = GlobalKey();

  _onSubmitForm(context) async {
    if (!checkFields([_emailFieldState])) {
      return;
    }

    //show progress
    _progressingButton.currentState?.showProgress(true);

    MyApp.userRepo.forgetPwd(email).then((value) {
      _progressingButton.currentState?.showProgress(false);
      switch (value.status) {
        case WebServiceResultStatus.success:
          showDialog(
              context: context,
              builder: (BuildContext context) => defaultDialog(
                      context, "Notice", value.data ?? "", "login", () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }));
          break;
        case WebServiceResultStatus.error:
          mySnackBar(context,
              title: 'Recovery link failed',
              message: value.message,
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
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(child: SvgPicture.asset(MyIcons.icForgetPwd)),
            SizedBox(height: 40),
            Text(
              "Forget Password",
              style: Theme.of(context)
                  .textTheme
                  .headline1
                  ?.copyWith(color: MyApp.resources.color.black1),
            ),
            SizedBox(height: 12),
            Text(
              "Please enter your registered email to reset your password",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.copyWith(color: MyApp.resources.color.black4),
            ),
            SizedBox(height: 12),
            EmailTextField(
              formFieldeKey: _emailFieldState,
              onSave: (String? email) {
                if (email != null) {
                  this.email = email;
                }
              },
            ),
            SizedBox(height: 12),
            ProgressingButton(
                key: _progressingButton,
                buttonText: "Send new password",
                onSubmitForm: () => _onSubmitForm(context),
                color: MyApp.resources.color.orange),
          ],
        ),
      ),
    );
  }
}
