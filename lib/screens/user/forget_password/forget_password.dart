import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/views/header_back_btn.dart';

import 'Components/form.dart';

class ForgetPasswordScreen extends StatefulWidget {
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyApp.resources.color.colorBackground,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(left:16, right: 16 , top: 21,bottom: 8),
          child: Column( children: [
            HeaderWithBackScren(title: "Reset Password" ),
           Expanded(child: Center(child: ForgetPasswordForm()),),
           SizedBox(height: 30)
          ]),
        ),
      ),
    );
  }
}
