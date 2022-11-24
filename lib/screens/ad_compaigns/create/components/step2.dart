import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/createAds.dart';
import 'package:rakwa/views/bottom_btns.dart';

class CreateAdStep2 extends StatefulWidget {
  AdCampaigns ads;
  CreateAdStep2({Key? key, required this.ads}) : super(key: key);

  @override
  State<CreateAdStep2> createState() => _CreateAdStep2State();
}

class _CreateAdStep2State extends State<CreateAdStep2> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
          top: 0,
          left: 16,
          right: 16,
          bottom: 100,
          child: SingleChildScrollView(
              child: Column(children: [
            Text(
              "Summary",
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.copyWith(color: MyApp.resources.color.colorText),
            ),
          ]))),
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 40, right: 40, top: 16, bottom: 16),
          //  width: double.infinity,
          child: BottomButtons(
              neutralButtonText: "Back",
              submitButtonText: "Save",
              neutralButtonClick: () {
                Navigator.pop(context);
              },
              submitButtonClick: () {
                print("object");
              }),
        ),
      ),
    ]);
  }
}
