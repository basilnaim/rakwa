import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/classified.dart';
import 'package:rakwa/model/contact_message.dart';
import 'package:rakwa/model/contact_room.dart';
import 'package:rakwa/model/listing.dart';
import 'package:rakwa/model/user.dart';
import 'package:rakwa/res/images/MyImages.dart';
import 'package:rakwa/screens/chats/inbox_screen.dart';
import 'package:rakwa/screens/chats_classifield/inbox_screen.dart';
import 'package:rakwa/utils/days.dart';

class InboxItem extends StatefulWidget {
  RoomContact room;

  InboxItem({Key? key, required this.room}) : super(key: key);

  @override
  State<InboxItem> createState() => _InboxItemState();
}

class _InboxItemState extends State<InboxItem> {
  @override
  Widget build(BuildContext context) {
    User otherUser = User();

    if (MyApp.userConnected?.id == widget.room.lastMessage?.senderID) {
      otherUser.id = widget.room.lastMessage?.recipientID ?? 0;
      otherUser.firstname = widget.room.lastMessage?.recipientName ?? "";
      otherUser.image =
          widget.room.lastMessage?.recipientProfilePictureURL ?? "";
    } else {
      otherUser.id = widget.room.lastMessage?.senderID ?? 0;
      otherUser.firstname = widget.room.lastMessage?.senderName ?? "";
      otherUser.image = widget.room.lastMessage?.senderProfilePictureURL ?? '';
    }

    bool seenMessages =
        widget.room.seenBy.contains(MyApp.userConnected?.id ?? 0);
    return Container(
      margin: const EdgeInsets.only(top: 8, left: 16, right: 16),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        color: Colors.white,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          onTap: () async {
            if (widget.room.type == 0) {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(
                          loadListing: true,
                          otherUser: otherUser,
                          listing: Listing(id: widget.room.id),
                        )),
              );
            } else {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatClassifieldScreen(
                          otherUser: otherUser,
                          classified: Classified(
                            id: widget.room.id,
                          ),
                        )),
              );
            }
            setState(() {});
          },
          child: Container(
            padding: EdgeInsets.only(left: 16, top: 10, bottom: 10, right: 12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                border: Border.all(
                    color: MyApp.resources.color.borderColor, width: 0.6)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 55,
                  height: 55,
                  child: ClipOval(
                    child: SizedBox.fromSize(
                        size: Size.fromRadius(48), // Image radius
                        child: Image.network(
                          otherUser.image,

                          fit: BoxFit.cover,
                          //color: Colors.blueGrey,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(MyImages.profilePic);
                          },
                        )),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        otherUser.firstname,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            ?.copyWith(color: MyApp.resources.color.colorText),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        widget.room.lastMessage?.content ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.caption?.copyWith(
                            color: MyApp.resources.color.colorText,
                            fontSize: 11),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                Column(
                  children: [
                    Text(
                      format.format(
                          widget.room.lastMessage?.created ?? DateTime.now()),
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          ?.copyWith(color: Color(0xffBBBBBB), fontSize: 12),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!seenMessages && widget.room.unreadMessages > 0)
                          Container(
                            width: 20,
                            height: 20,
                            child: Center(
                                child: Text(
                              (widget.room.unreadMessages).toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 11),
                            )),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: MyApp.resources.color.orange),
                          ),
                        if (!seenMessages && widget.room.unreadMessages > 0)
                          SizedBox(
                            width: 8,
                          ),
                        /**
                        *  Material(
                          color: Colors.white,
                          child: InkWell(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16)),
                            onTap: () {},
                            child: SizedBox(
                              child: Icon(
                                Icons.more_horiz,
                                color: Color(0xff202020),
                                size: 26,
                              ),
                            ),
                          ),
                        )
                        */
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
