import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/contact_room.dart';
import 'package:rakwa/screens/inbox/components/item_inbox.dart';
import 'package:rakwa/screens/inbox/inbox_screen.dart';
import 'package:rakwa/views/empty_content.dart';

class ListInboxScreen extends StatelessWidget {
  const ListInboxScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaginateFirestore(
      //item builder type is compulsory.
      itemBuilder: (context, documentSnapshots, index) {
        Map<String, dynamic> map =
            documentSnapshots[index].data() as Map<String, dynamic>;
        return InboxItem(
          room: RoomContact.fromMapp(map),
        );
      },
      listeners: [InboxScreen.query],
      onEmpty:  EmpyContentScreen(title: "Contact"),
      // orderBy is compulsory to enable pagination
      query: MyApp.fireRepo
          .getMessagingRoomsByUserId(MyApp.userConnected?.id ?? 0, InboxScreen.query.value),
      //itemsPerPage: 100,
      //Change types accordingly
      itemBuilderType: PaginateBuilderType.listView,
      // to fetch real-time data
      isLive: true,
    );
  }
}
