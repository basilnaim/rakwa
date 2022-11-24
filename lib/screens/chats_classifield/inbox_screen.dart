import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/classified.dart';
import 'package:rakwa/model/contact_room.dart';
import 'package:rakwa/model/error.dart';
import 'package:rakwa/model/user.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/screens/chats/components/messaging.dart';
import 'package:rakwa/screens/chats/components/send_message.dart';
import 'package:rakwa/screens/chats_classifield/components/header.dart';
import 'package:rakwa/screens/home/home.dart';
import 'package:rakwa/views/error_widget.dart';
import 'package:rakwa/views/header_back_btn.dart';

class ChatClassifieldScreen extends StatefulWidget {
  Classified classified;
  final User otherUser;

  ChatClassifieldScreen({
    Key? key,
    required this.classified,
    required this.otherUser,
  }) : super(key: key);

  @override
  State<ChatClassifieldScreen> createState() => ChatClassifieldScreenState();
}

class ChatClassifieldScreenState extends State<ChatClassifieldScreen> {
  bool progress = true;
  static ValueNotifier<String> roomId = ValueNotifier("");
  ErrorModel? errorModel;
  _fetchClassifield() {
    progressing(true);

    MyApp.classifiedRepo
        .getClassifieldById(widget.classified.id)
        .then((WebServiceResult<Classified> value) {
      switch (value.status) {
        case WebServiceResultStatus.success:
          widget.classified = value.data!;
          getRoomId();
          break;
        case WebServiceResultStatus.error:
          errorModel = ErrorModel(btnClickListener: () {});
          if (value.code == 1) {
            errorModel?.text = "This classifield has been removed";
            errorModel?.btnText = "Back to inboxes";
            errorModel?.btnClickListener = () {
              Navigator.pop(context);
            };
          } else {
            errorModel?.btnText = "Retry";
            errorModel?.text = value.message;
            errorModel?.btnClickListener = () {
              _fetchClassifield();
            };
          }

          break;
        case WebServiceResultStatus.loading:
          break;

        case WebServiceResultStatus.unauthorized:
          break;
      }
      progressing(false);
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
    progressing(true);

    MyApp.fireRepo.getRoomContactById(
        [widget.otherUser.id, MyApp.userConnected?.id ?? 0],
        widget.classified.id,
        1).then((QuerySnapshot querySnapshot) {
      progressing(false);

      if (querySnapshot.docs.isEmpty) {
        return createRoom();
      } else {
        RoomContact roomContact = querySnapshot.docs
            .map((QueryDocumentSnapshot e) =>
                RoomContact.fromMapp(e.data() as Map<String, dynamic>))
            .first;

        roomId.value = roomContact.roomId;
      }
    });
  }

  createRoom({bool first = true}) {
    if (first) {
      MyApp.fireRepo
          .createRoom(RoomContact(
              id: widget.classified.id,
              type: 1,
              users: [widget.otherUser.id, MyApp.userConnected?.id ?? 0]
                ..sort()))
          .then((value) => getRoomId(first: false))
          .onError((error, stackTrace) => null);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchClassifield();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyApp.resources.color.background,
      body: progress
          ? const Center(
              child: MyProgressIndicator(
              color: Colors.orange,
            ))
          : (errorModel != null
              ? MyErrorWidget(errorModel: errorModel!)
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
                              padding: const EdgeInsets.all(16.0),
                              child: HeaderWithBackScren(title: "Contact"),
                            ),
                            InboxHeader(classfield: widget.classified),
                            const SizedBox(
                              height: 8,
                            ),
                            Flexible(
                              child: ValueListenableBuilder(
                                  valueListenable: roomId,
                                  builder: (context, String room, w) {
                                    return MessagingScreen(
                                        roomId: room,
                                        userId: widget.classified.user_id ?? 0,
                                        listingId: widget.classified.id);
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
                                    roomId: roomId.value);
                              }),
                        ),
                      )
                    ],
                  ),
                )),
    );
  }
}
