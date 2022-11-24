import 'package:flutter/material.dart';

import 'package:rakwa/main.dart';
import 'package:rakwa/views/header_back_btn.dart';
import 'Components/form.dart';

class SignUpScreen extends StatefulWidget {
  bool fromHome;
  SignUpScreen({
    Key? key,
    this.fromHome = false,
  }) : super(key: key);
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyApp.resources.color.colorBackground,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            //  height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(left: 16, right: 16, top: 41, bottom: 8),
            child: Column(children: [
              HeaderWithBackScren(
                title: "تسجيل عضوية",
              ),
              SizedBox(height: 20),
              Expanded(
                  child: SignupForm(
                fromHome: widget.fromHome,
              )),
            ]),
          ),
        ),
      ),
    );
  }
}
