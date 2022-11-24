import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/screens/user/login/login.dart';
import 'package:rakwa/screens/user/signup/sigup.dart';
import 'package:rakwa/views/bottom_btns.dart';

class NotRegistredDialog extends StatefulWidget {
  NotRegistredDialog({required this.postFunction});

  Function postFunction;

  @override
  State<NotRegistredDialog> createState() => _NotRegistredDialogState();
}

class _NotRegistredDialogState extends State<NotRegistredDialog> {
  @override
  Widget build(BuildContext context) {
    return notRegistredDialog();
  }

  Dialog notRegistredDialog() => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0)), //this right here
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 200.0,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "للأسف، لم تقم بالتسجيل",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(color: MyApp.resources.color.black2),
              ),
              Text(
                MyApp.resources.strings.notregistred,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: MyApp.resources.color.black4,
                    fontWeight: FontWeight.w400,
                    fontSize: 14),
              ),
              BottomButtons(
                  neutralButtonText: "تسجيل",
                  submitButtonText: MyApp.resources.strings.login,
                  neutralButtonClick: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignUpScreen(
                                fromHome: true,
                              )),
                    );
                    widget.postFunction();
                  },
                  submitButtonClick: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginScreen(
                                fromHome: true,
                              )),
                    );
                    widget.postFunction();
                  }),
            ],
          ),
        ),
      );
}
