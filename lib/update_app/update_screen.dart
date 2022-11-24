import 'dart:io';

import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/home.dart';
import 'package:rakwa/views/progressing_button.dart';

import '../screens/home_container/home_container_screen.dart';
import '../screens/user/login/login.dart';

class UpdateAppScreen extends StatefulWidget {
  final bool isRequired;
  const UpdateAppScreen({Key? key, required this.isRequired}) : super(key: key);

  @override
  State<UpdateAppScreen> createState() => _UpdateAppScreenState();
}

class _UpdateAppScreenState extends State<UpdateAppScreen> {
  GlobalKey<ProgressingButtonState> progressingButton =
      GlobalKey<ProgressingButtonState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyApp.resources.color.colorBackground,
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
                Platform.isAndroid
                    ? "A new update is available on google play.\nPlease update the version"
                    : "A new update is available on app store.\nPlease update the version",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    ?.copyWith(color: Colors.black)),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 250,
            child: ProgressingButton(
              onSubmitForm: () {
                LaunchReview.launch(
                    writeReview: false,
                    androidAppId: "com.medianet.magic_skanes_tenis",
                    iOSAppId: "585027354");
              },
              buttonText: "Update",
              color: Colors.orange.shade700,
            ),
          ),
          if (!widget.isRequired)
            const SizedBox(
              height: 50,
            ),
          if (!widget.isRequired)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => (MyApp.isConnected)
                          ? const HomeContainerScreen()
                          : LoginScreen()));
                },
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: SizedBox(
                  width: 150,
                  height: 30,
                  child: Center(
                    child: Text("Ignore",
                        style: Theme.of(context)
                            .textTheme
                            .headline3
                            ?.copyWith(color: Colors.grey)),
                  ),
                ),
              ),
            )
        ],
      )),
    );
  }
}
