import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/screens/user/profile/profile_screen.dart';
import 'package:rakwa/views/header_back_btn.dart';

class ProfileHeader extends StatelessWidget {
  bool showEdit = false;
  ProfileHeader({Key? key, this.showEdit = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Stack(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          HeaderWithBackScren(
            title: "الملف الشخصي",
            menuEnabled: true,
            backEnabled: false,
            onClick: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          if (showEdit)
            ValueListenableBuilder(
                valueListenable: ProfileScreen.editable,
                builder: (BuildContext context, bool? editable, Widget? child) {
                  return Visibility(
                    visible: editable != false,
                    child: Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      child: TextButton(
                          style: TextButton.styleFrom(
                            primary: Colors.orange.shade200,
                            backgroundColor: Colors.transparent,
                            padding: EdgeInsets.symmetric(vertical: 4),
                          ),
                          onPressed: () {
                            ProfileScreen.editable.value = !(editable ?? false);
                          },
                          child: Container(
                            alignment: Alignment.topRight,
                            child: Text("تعديل",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(
                                      color: MyApp.resources.color.orange,
                                    )),
                          )),
                    ),
                  );
                }),
        ],
      ),
    );
  }
}
