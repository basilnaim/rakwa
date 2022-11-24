import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/contact_room.dart';
import 'package:rakwa/model/listing.dart';
import 'package:rakwa/model/user.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/screens/chats/components/header.dart';
import 'package:rakwa/screens/chats/components/messaging.dart';
import 'package:rakwa/screens/chats/components/send_message.dart';
import 'package:rakwa/screens/home/home.dart';
import 'package:rakwa/views/header_back_btn.dart';
import 'package:rakwa/views/not_registred.dart';

class ChatScreen extends StatefulWidget {
  Listing listing;
  bool loadListing = false;
  User otherUser;

  ChatScreen({
    Key? key,
    this.loadListing = false,
    required this.listing,
    required this.otherUser,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  bool progress = true;
  final ValueNotifier<String> roomId = ValueNotifier("");

  _fetchDetail(String token) {
    progressing(true);

    MyApp.listingRepo
        .detail(widget.listing.id.toString(), token)
        .then((WebServiceResult<Listing> value) {
      switch (value.status) {
        case WebServiceResultStatus.success:
          widget.listing = value.data!;
          getRoomId();
          break;
        case WebServiceResultStatus.error:
          String title = value.message;
          if (value.code == 1) {
            title = "This listing has been removed";
          }
          progressing(false);
          print("22222222");

          Navigator.of(context).pop();
          mySnackBar(context,
              title: 'Listing', message: title, status: SnackBarStatus.error);

          break;
        case WebServiceResultStatus.loading:
          break;

        case WebServiceResultStatus.unauthorized:
          break;
      }
    });
  }

  progressing(progress) {
    if (progress != this.progress) {
      setState(() {
        this.progress = progress;
      });
    }
  }

  getRoomId({bool first = true}) {
    MyApp.fireRepo.getRoomContactById(
        [widget.otherUser.id, MyApp.userConnected?.id ?? 0],
        widget.listing.id,
        0).then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        return createRoom(first: first);
      } else {
        RoomContact roomContact = querySnapshot.docs
            .map((QueryDocumentSnapshot e) =>
                RoomContact.fromMapp(e.data() as Map<String, dynamic>))
            .first;

        roomId.value = roomContact.roomId;
      }
      progressing(false);
    });
  }

  createRoom({bool first = true}) {
    print("widget.listing.id" + widget.listing.id.toString());
    print("widget.otherUser.id" + widget.otherUser.id.toString());
    print(
        "MyApp.userConnected?.id" + (MyApp.userConnected?.id ?? "").toString());

    if (first) {
      MyApp.fireRepo
          .createRoom(RoomContact(
              id: widget.listing.id,
              type: 0,
              users: [widget.otherUser.id, MyApp.userConnected?.id ?? 0]
                ..sort()))
          .then((value) => getRoomId(first: false))
          .onError((error, stackTrace) {
        mySnackBar(context,
            title: 'Listing Detail',
            message: "We cannot find the listing",
            status: SnackBarStatus.error);
        progressing(false);
      });
    }
  }

  @override
  initState() {
    super.initState();
    print("1111111111");

    if (widget.loadListing) {
      print("gggggggg");
      _fetchDetail(MyApp.token);
    } else {
      getRoomId();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyApp.resources.color.background,
      body: !MyApp.isConnected
          ? Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: HeaderWithBackScren(
                    title: 'Contact',
                  ),
                ),
                Flexible(
                    child: Align(
                        alignment: Alignment.center,
                        child: RequireRegistreScreen(
                          postFunction: () {
                            if (widget.loadListing) {
                              _fetchDetail(MyApp.token);
                            } else {
                              getRoomId();
                            }
                          },
                        ))),
              ],
            )
          : progress
              ? const Center(
                  child: MyProgressIndicator(
                  color: Colors.orange,
                ))
              : SafeArea(
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 110,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16, top: 13, bottom: 16),
                              child: HeaderWithBackScren(title: "Contact"),
                            ),
                            InboxHeader(listing: widget.listing),
                            const SizedBox(
                              height: 8,
                            ),
                            Flexible(
                              child: ValueListenableBuilder(
                                  valueListenable: roomId,
                                  builder: (context, String room, w) {
                                    return MessagingScreen(
                                        roomId: room,
                                        userId: widget.listing.accountId,
                                        listingId: widget.listing.id);
                                  }),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: ValueListenableBuilder(
                              valueListenable: roomId,
                              builder: (context, String room, w) {
                                return SendMessage(
                                    otherUser: widget.otherUser,
                                    roomId: room);
                              }),
                        ),
                      )
                    ],
                  ),
                ),
    );
  }
}
