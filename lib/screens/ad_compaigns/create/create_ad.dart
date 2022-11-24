import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/createAds.dart';
import 'package:rakwa/screens/ad_compaigns/create/components/step1.dart';
import 'package:rakwa/screens/add_listing/components/header.dart';
import 'package:rakwa/utils/bottom_tab_nav.dart';
import 'package:rakwa/views/header_back_btn.dart';

class CreateAdCompaign extends StatefulWidget {
  AdCampaigns ads;

  CreateAdCompaign({Key? key, required this.ads}) : super(key: key);

  @override
  State<CreateAdCompaign> createState() => CreateAdCompaignState();
}

class CreateAdCompaignState extends State<CreateAdCompaign> {
  static late BottomTabNavigation bottomTabNavigation;

  final stepTitles = ["Select All Placement", "Payment method"];

  @override
  dispose() {
    bottomTabNavigation.onWidgetChangedListener.dispose();
    super.dispose();
  }

  Future<bool> _willPopCallback() async {
    return bottomTabNavigation.pop();
  }

  @override
  void initState() {
    super.initState();
    bottomTabNavigation = BottomTabNavigation(rootWidgets: [
      CreateAdStep1(
        ads: widget.ads,
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyApp.resources.color.colorBackground,
      body: SafeArea(
          child: WillPopScope(
              onWillPop: _willPopCallback,
              child: ValueListenableBuilder<int>(
                  valueListenable: bottomTabNavigation.onWidgetChangedListener,
                  builder: (context, selectedIndex, _) {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      padding: const EdgeInsets.only(top: 25),
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
                          child: HeaderWithBackScren(
                            title: "Create Ad",
                            backEnabled: true,
                            onClick: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        //  SizedBox(height: 8),
                        /*
                        ListingHeader(
                          steps: bottomTabNavigation.rootWidgets.length,
                          step: bottomTabNavigation.currentTab,
                          title: stepTitles[bottomTabNavigation.currentTab],
                        ),
                        */
                        SizedBox(height: 20),
                        Expanded(child: bottomTabNavigation.getCurrentWidget()),
                      ]),
                    );
                  }))),
    );
  }
}
