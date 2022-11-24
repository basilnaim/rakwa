import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/notification.dart' as notif;
import 'package:rakwa/res/icons/my_icons.dart';

import '../../views/header_back_btn.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final notifs = [
      notif.Notification(
          title: 'Notification title',
          description: "notification description published"),
      notif.Notification(
          title: 'Notification title',
          description: "notification description published"),
      notif.Notification(
          title: 'Notification title',
          description: "notification description published"),
      notif.Notification(
          title: 'Notification title',
          description: "notification description published"),
      notif.Notification(
          title: 'Notification title',
          description: "notification description published"),
      notif.Notification(
          title: 'Notification title',
          description: "notification description published"),
    ];
    return Scaffold(
      backgroundColor: MyApp.resources.color.background,
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24, top: 26),
            child: HeaderWithBackScren(title: 'Notification'),
          ),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: notifs.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      margin: EdgeInsets.only(left: 16, right: 16, bottom: 6),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: MyApp.resources.color.borderColor,
                              width: 0.8),
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 0, left: 20, right: 20, bottom: 0),
                        child: Center(
                          child: ListTile(
                            leading: SizedBox(
                              width: 32,
                              height: double.maxFinite,
                              child: Center(
                                child: Container(
                                    width: 32,
                                    height: 32,
                                    child: Center(
                                      child: SvgPicture.asset(
                                        MyIcons.icLike,
                                        color: MyApp.resources.color.black1,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        color: Color(0xffF9F9F9),
                                        border: Border.all(
                                            color:
                                                MyApp.resources.color.borderColor,
                                            width: 0.8),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)))),
                              ),
                            ),
                            title: Text(notifs[index].title,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    ?.copyWith(
                                      fontSize: 12,
                                      color:
                                          MyApp.resources.color.darkIconColor,
                                    )),
                            subtitle: Text(
                              notifs[index].title,
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  ?.copyWith(
                                    fontSize: 11,
                                    color: MyApp.resources.color.darkIconColor,
                                  ),
                            ),
                          ),
                        ),
                      ));
                }),
          )
        ],
      )),
    );
  }
}
