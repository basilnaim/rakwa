import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/classified.dart';
import 'package:rakwa/model/contact_message.dart';
import 'package:rakwa/model/contact_room.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/res/images/MyImages.dart';
import 'package:rakwa/screens/classifieds/classified_location.dart';
import 'package:rakwa/screens/home/home.dart';

import 'Components/header.dart';

class ClassifiedDetail extends StatefulWidget {
  ClassifiedDetail({Key? key, this.isMine = false, this.classifiedId})
      : super(key: key);
  bool isMine;
  final int? classifiedId;

  @override
  State<ClassifiedDetail> createState() => _ClassifiedDetailState();
}

class _ClassifiedDetailState extends State<ClassifiedDetail> {
  Classified? item;
  TextEditingController controller = TextEditingController();
  bool isLoading = false;
  static ValueNotifier<String> roomId = ValueNotifier("");

  progressing(bool isLoading) {
    if (this.isLoading != isLoading) {
      setState(() {
        this.isLoading = isLoading;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  _fetchDetail() {
    print('fetch classified data started');
    progressing(true);

    MyApp.classifiedRepo
        .detailClassified(widget.classifiedId!)
        .then((WebServiceResult<Classified> value) {
      switch (value.status) {
        case WebServiceResultStatus.success:
          item = value.data!;
          if (item?.user_id == MyApp.userConnected?.id) {
            widget.isMine = true;
            progressing(false);
          } else {
            getRoomId();
          }
          break;
        case WebServiceResultStatus.error:
          progressing(false);

          mySnackBar(context,
              title: 'fetch classified failed',
              message: value.message,
              status: SnackBarStatus.error);

          break;
        case WebServiceResultStatus.loading:
          break;

        case WebServiceResultStatus.unauthorized:
          break;
      }
    });
  }

  getRoomId() {
    if (item?.user_id == null) {
      widget.isMine = true;
      progressing(false);
    } else {
      MyApp.fireRepo.getRoomContactById(
          [item?.user_id ?? 0, MyApp.userConnected?.id ?? 0],
          item?.id ?? 0,
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
  }

  createRoom() {
    MyApp.fireRepo
        .createRoom(RoomContact(
            id: item?.id ?? 0,
            type: 1,
            users: [item?.user_id ?? 0, MyApp.userConnected?.id ?? 0]))
        .then((value) => getRoomId())
        .onError((error, stackTrace) => null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyApp.resources.color.background,
        body: SafeArea(
          child: (isLoading)
              ? MyProgressIndicator(
                  color: MyApp.resources.color.orange,
                )
              : Stack(children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: FadeInImage.assetNetwork(
                      placeholder: 'lib/res/images/loader.gif',
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      image: item?.image ?? "",
                      fit: BoxFit.cover,
                      imageErrorBuilder: (BuildContext context,
                          Object exception, StackTrace? stackTrace) {
                        return Image.asset(
                          MyImages.errorImage,
                          width: MediaQuery.of(context).size.width,
                          height: 300,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  Positioned.fill(
                    child: SingleChildScrollView(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Header(
                              isDetail: true,
                            ),
                            const SizedBox(height: 156),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 20),
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    width: 0.5,
                                    color: MyApp.resources.color.borderColor,
                                  ),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      item?.title ?? "",
                                      style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(
                                            MyIcons.icMarker,
                                            width: 14,
                                            height: 14,
                                            color: Colors.black,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            item?.location?.city?.name ?? "",
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ])
                                  ]),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 0.5,
                                      color: MyApp.resources.color.borderColor),
                                  borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                HtmlParser.parseHTML(item?.description ?? "")
                                    .text,
                                //  parse(item?.description ?? "").outerHtml ,
                                style: const TextStyle(
                                    height: 1.4,
                                    fontSize: 13,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 0.5,
                                      color: MyApp.resources.color.borderColor),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ClassifiedLocationScreen(
                                                  item: item)),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SvgPicture.asset(
                                            MyIcons.icMarker,
                                            color: Colors.black,
                                            width: 24,
                                            height: 24,
                                          ),
                                          const SizedBox(width: 24),
                                          Expanded(
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Location",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 4),
                                                    child: Text(
                                                      item?.location?.address ??
                                                          "",
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: MyApp.resources
                                                              .color.orange,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ),
                                                ]),
                                          ),
                                          Container(
                                            height: 56,
                                            width: 56,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(12)),
                                                border: Border.all(
                                                    width: 1,
                                                    color: MyApp.resources.color
                                                        .borderColor),
                                                color: Colors.white),
                                            child: Center(
                                              child: Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                color: MyApp
                                                    .resources.color.iconColor,
                                                size: 24,
                                              ),
                                            ),
                                          ),
                                        ]),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ]),
                    ),
                  ),
                  /*  Positioned(
              right: 32,
              top: 220,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 0.5,
                        color: MyApp.resources.color.borderColor),
                    color: Colors.white,
                    borderRadius:
                        const BorderRadius.all(Radius.circular(12))),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius:
                        const BorderRadius.all(Radius.circular(12)),
                    onTap: () {
                      // _AddToFavorite();
                    },
                    child: Center(
                      child:
                          SvgPicture.asset("lib/res/icons/ic_heart.svg",
                              width: 20,
                              height: 20,
                              color: // (listing.isFavorite == 1)
                                  Colors.red
                              // : MyApp.resources.color.borderColor,
                              ),
                    ),
                  ),
                ),
              ),
                ),
                Positioned(
              right: 88,
              top: 220,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 0.5,
                        color: MyApp.resources.color.borderColor),
                    color: Colors.white,
                    borderRadius:
                        const BorderRadius.all(Radius.circular(12))),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius:
                        const BorderRadius.all(Radius.circular(12)),
                    onTap: () {
                      /*   showBottomSheetShare(
                    context, listing.socialLinks!, listing.listingUrl);*/
                    },
                    child: Center(
                      child: SvgPicture.asset(
                        MyIcons.icShape,
                        width: 20,
                        height: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
                )*/
                  if (!widget.isMine && MyApp.isConnected)
                    Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              showBottomSheetMessage(context, controller);
                            },
                            child: const Text(
                              'Send A Message',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(
                                  MediaQuery.of(context).size.width - 32, 55),
                              primary: MyApp.resources.color.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12), // <-- Radius
                              ),
                            ),
                          ),
                        ))
                ]),
        ));
  }

  sendMessage() {
    if (controller.value.text.isNotEmpty) {
      MyApp.fireRepo
          .sendMessage(
              ContactMessage(
                  content: controller.value.text,
                  created: DateTime.now(),
                  recipientName: item?.title ?? "",
                  recipientID: item?.user_id ?? 0,
                  recipientProfilePictureURL: item?.image ?? "",
                  senderProfilePictureURL: MyApp.userConnected?.image ?? "",
                  senderName:
                      "${MyApp.userConnected?.firstname ?? ""} ${MyApp.userConnected?.lastname ?? ""}",
                  senderID: MyApp.userConnected?.id ?? 0,
                  id: ''),
              roomId.value)
          .then((value) {
        mySnackBar(context,
            title: 'Success',
            message: "Message sent successfully",
            status: SnackBarStatus.success);
        controller.clear();
      }).onError((error, stackTrace) => mySnackBar(context,
              title: 'failed',
              message: 'An error has been occurred ,try again',
              status: SnackBarStatus.error));
    }
  }

  void showBottomSheetMessage(
      BuildContext context, TextEditingController controller) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(16),
              color: MyApp.resources.color.background,
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Send A Message",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        height: 55,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: MyApp.resources.color.borderColor,
                            ),
                            borderRadius: BorderRadius.circular(12)),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Expanded(
                            child: TextField(
                              controller: controller,
                              autofocus: true,
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Type Something...',
                                  hintStyle: TextStyle(
                                      color: MyApp.resources.color.hintColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            height: 36,
                            decoration: BoxDecoration(
                                color: MyApp.resources.color.orange,
                                border: Border.all(
                                  width: 0.5,
                                  color: MyApp.resources.color.borderColor,
                                ),
                                borderRadius: BorderRadius.circular(24)),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(24),
                                onTap: () {
                                  Navigator.pop(context);
                                  sendMessage();
                                },
                                child: Center(
                                    child: Row(
                                  children: const [
                                    SizedBox(width: 12),
                                    Text(
                                      'Send',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 10),
                                  ],
                                )),
                              ),
                            ),
                          )
                        ]),
                      )
                    ]),
              ),
            ));
  }
}
