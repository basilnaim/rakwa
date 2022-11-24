import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/contact_message.dart';
import 'package:rakwa/screens/chats/components/item_message.dart';
import 'package:rakwa/screens/home/home.dart';

class MessagingScreen extends StatelessWidget {
  int userId;
  int listingId;
  String roomId;

  MessagingScreen({
    Key? key,
    required this.roomId,
    required this.userId,
    required this.listingId,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return roomId.isEmpty
        ? const Center(
            child: MyProgressIndicator(
            color: Colors.orange,
          ))
        : PaginateFirestore(
            key: ValueKey(MyApp.fireRepo.getMessagingRoom(roomId)),

            //item builder type is compulsory.
            itemBuilder: (context, documentSnapshots, index) {
              Map<String, dynamic> map =
                  documentSnapshots[index].data() as Map<String, dynamic>;
              return ItemMessage(
                message: ContactMessage.fromMap(map),
              );
            },
            onLoaded: (l) {
              MyApp.fireRepo.messageSeen(roomId);
            },
            // orderBy is compulsory to enable pagination
            query: MyApp.fireRepo.getMessagingRoom(roomId),
            itemsPerPage: 100,
            //Change types accordingly
            itemBuilderType: PaginateBuilderType.listView,
            onEmpty: Center(
              child: Text(
                "Start a conversation ...",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.copyWith(color: MyApp.resources.color.darkColor),
              ),
            ),
            // to fetch real-time data
            isLive: true,
            reverse: true,
          );
  }
}
