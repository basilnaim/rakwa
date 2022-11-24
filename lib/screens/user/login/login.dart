import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:rakwa/main.dart';
import 'package:rakwa/views/header_back_btn.dart';

import 'Components/form.dart';

class LoginScreen extends StatefulWidget {
  bool fromHome;
  LoginScreen({
    Key? key,
    this.fromHome = false,
  }) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyApp.resources.color.colorBackground,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(left: 16, right: 16, top: 41, bottom: 8),
          child: Column(children: [
            HeaderWithBackScren(
                title: "تسجيل الدخول", backEnabled: widget.fromHome),
            SizedBox(height: 20),
            Expanded(
                child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: LoginForm(fromHome: widget.fromHome))),
          ]),
        ),
      ),
    );
  }
}
