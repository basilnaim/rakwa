import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/contact_message.dart';
import 'package:rakwa/utils/days.dart';

class ItemMessage extends StatelessWidget {
  ContactMessage message;

  ItemMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool sender = message.senderID == MyApp.userConnected?.id;
    final margin = MediaQuery.of(context).size.width * 0.2;
    return Column(
      crossAxisAlignment:
          sender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: !sender
              ? EdgeInsets.only(right: margin, left: 24, bottom: 8, top: 8)
              : EdgeInsets.only(left: margin, right: 24, bottom: 8, top: 8),
          padding: EdgeInsets.only(top: 8, left: 16, right: 8, bottom: 8),
          decoration: BoxDecoration(
            color: !sender ? Colors.white : MyApp.resources.color.orange,
            borderRadius: BorderRadius.all(Radius.circular(12)),
            border: Border.all(
                color: MyApp.resources.color.borderColor, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment:
                sender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                message.content,
                textAlign: sender ? TextAlign.end : TextAlign.start,
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    color: !sender
                        ? MyApp.resources.color.darkColor
                        : Colors.white),
              ),
              SizedBox(height: 6),
              Container(
                height: 20,
                width: 58,
                child: Center(
                    child: Text(
                  format.format(message.created),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      ?.copyWith(fontSize: 9, color: Color(0xff7D7D7D)),
                )),
                decoration: BoxDecoration(
                    color: MyApp.resources.color.grey3,
                    border: Border.all(
                        color: MyApp.resources.color.borderColor, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(12))),
              )
            ],
          ),
        ),
      ],
    );
  }
}
