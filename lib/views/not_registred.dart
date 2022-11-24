import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:rakwa/main.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/screens/user/login/login.dart';
import 'package:rakwa/screens/user/signup/sigup.dart';

import 'bottom_btns.dart';

class RequireRegistreScreen extends StatelessWidget {
  Function postFunction;
  RequireRegistreScreen({Key? key, required this.postFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 32.0, right: 32, top: 16, bottom: 16),
      child: Column(
        children: [
          SvgPicture.asset(MyIcons.icNotFound),
          SizedBox(height: 32),
          Text(
            "للأسف، لم تقم بالتسجيل",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                ?.copyWith(color: MyApp.resources.color.black1),
          ),
          SizedBox(height: 10),
          Text(
            MyApp.resources.strings.notregistred,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText2?.copyWith(
                fontSize: 13.0,
                color: MyApp.resources.color.black1.withOpacity(0.8)),
          ),
          Spacer(),
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
                postFunction();
              },
              submitButtonClick: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginScreen(
                            fromHome: true,
                          )),
                );
                postFunction();
              }),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}
