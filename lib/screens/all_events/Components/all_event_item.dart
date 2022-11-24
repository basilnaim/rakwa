import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:rakwa/main.dart';
import 'package:rakwa/model/event.dart';
import 'package:rakwa/model/listing/event_participant.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/res/images/MyImages.dart';
import 'package:rakwa/screens/events/create/create_event.dart';
import 'package:rakwa/utils/days.dart';

class AllEventItem extends StatefulWidget {
  AllEventItem({Key? key, required this.onDelete, required this.event})
      : super(key: key);
  Event event;
  Function(int id) onDelete;

  @override
  State<AllEventItem> createState() => _AllEventItemState();
}

class _AllEventItemState extends State<AllEventItem> {
  String month = "";
  String day = "";

  List<EventDescModel> eventDescList = [];

  @override
  void initState() {
    super.initState();
    initScreen();
  }

  initScreen() {
    String? formattedStartDate = (widget.event.startDate == null)
        ? null
        : DateFormat('dd-MM-yyyy').format(widget.event.startDate!);
    String? formattedEndDate = (widget.event.endDate == null)
        ? null
        : DateFormat('dd-MM-yyyy').format(widget.event.endDate!);
    String? formattedTimeStart = (widget.event.startTime == null)
        ? null
        : DateFormat('KK:mm a').format(nowTime(widget.event.startTime!));
    String? formattedTimeEnd = (widget.event.endTime == null)
        ? null
        : DateFormat('KK:mm a').format(nowTime(widget.event.endTime!));

    eventDescList.clear();
    eventDescList.add(EventDescModel(
        key: "STATUS",
        value: (widget.event.status == "D") ? "unavailable" : "available",
        color: (widget.event.status == "D") ? Colors.red : Colors.green,
        icon: MyIcons.icStatus));

    if (formattedStartDate != null) {
      eventDescList.add(EventDescModel(
          key: "Start Date", value: formattedStartDate, icon: MyIcons.icStart));
    }
    if (formattedTimeStart != null) {
      eventDescList.add(EventDescModel(
          key: "Start Time", value: formattedTimeStart, icon: MyIcons.icTime));
    }

    if (formattedEndDate != null) {
      eventDescList.add(EventDescModel(
          key: "End Date", value: formattedEndDate, icon: MyIcons.icHistory));
    }
    if (formattedTimeEnd != null) {
      eventDescList.add(EventDescModel(
          key: "End Time", value: formattedTimeEnd, icon: MyIcons.icTime));
    }
    if (widget.event.address.isNotEmpty) {
      eventDescList.add(EventDescModel(
          key: "Location",
          value: widget.event.address,
          icon: MyIcons.icMarker));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(width: 0.5, color: MyApp.resources.color.borderColor),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(16),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 180,
                    child: Stack(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          widget.event.image,
                          width: MediaQuery.of(context).size.width,
                          height: 160,
                          errorBuilder: (e, d, s) {
                            return ClipRRect(
                              child: Image.asset(
                                MyImages.errorImage,
                                width: MediaQuery.of(context).size.width,
                                height: 160,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            );
                          },
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.8),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        right: 12,
                        bottom: 12,
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        (widget.event.startDate?.day ?? 0)
                                            .toString()
                                            .padLeft(2, '0'),
                                        style: TextStyle(
                                            fontSize: 26,
                                            color: MyApp.resources.color.orange,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      Text(
                                        (widget.event.startDate != null)
                                            ? DateFormat.MMM()
                                                .format(widget.event.startDate!)
                                            : "",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ]),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: MyApp.resources.color.orange),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 3),
                                child: const Text(
                                  "Event",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.event.title,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white),
                              ),
                            ]),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 0.5,
                              color: MyApp.resources.color.borderColor),
                          color: MyApp.resources.color.background,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          )),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          primary: false,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: eventDescList.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 5,
                                  childAspectRatio: 2.2,
                                  crossAxisCount: 3),
                          itemBuilder: (_, int index) {
                            return EventDescItem(
                              eventDescModel: eventDescList[index],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    const Text(
                      "Attendees",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                    Flexible(
                      child: SizedBox(
                        height: 50,
                        child: getUsersWidgets(null),
                      ),
                    ),
                    Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          border: Border.all(
                              width: 0.5,
                              color: MyApp.resources.color.borderColor),
                          color: Colors.white),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          onTap: () {
                            AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.INFO,
                                    animType: AnimType.SCALE,
                                    title: "Delete event",
                                    desc: "You want to remove this event?",
                                    btnOkText: 'Delete',
                                    btnOkOnPress: () =>
                                        widget.onDelete(widget.event.id),
                                    btnCancelOnPress: () {},
                                    btnOkColor: Colors.orange,
                                    buttonsTextStyle: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        ?.copyWith(color: Colors.white),
                                    btnCancelColor: Colors.blueGrey,
                                    btnCancelText: 'Cancel')
                                .show();
                          },
                          child: Center(
                            child: SvgPicture.asset(
                              MyIcons.icDelete,
                              color: Colors.black,
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          border: Border.all(
                              width: 0.5,
                              color: MyApp.resources.color.borderColor),
                          color: MyApp.resources.color.orange),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateEventScreen(
                                        event: widget.event,
                                      )),
                            );

                            initScreen();
                            setState(() {});
                          },
                          child: Center(
                            child: Icon(
                              Icons.edit_outlined,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ]),
          ),
        ),
      ),
    );
  }
}

class EventDescItem extends StatelessWidget {
  const EventDescItem({Key? key, required this.eventDescModel})
      : super(key: key);
  final EventDescModel eventDescModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(children: [
        Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                  width: 0.5, color: MyApp.resources.color.borderColor)),
          child: Center(
            child: SvgPicture.asset(
              eventDescModel.icon,
              height: 18,
              width: 18,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    eventDescModel.key,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 9,
                        color: Colors.grey,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                const SizedBox(height: 2),
                Flexible(
                  child: Text(
                    eventDescModel.value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 10,
                        color: eventDescModel.color,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ]),
        ),
      ]),
    );
  }
}

Widget getUsersWidgets(EventParticipant? participants) {
  double pos = 8.0;
  List<Widget> list = <Widget>[];
  if (participants != null) {
    if (participants.count! < 5) {
      for (var i = 0; i < participants.count!; i++) {
        list.add(
          Positioned(
            right: pos,
            top: 0.0,
            bottom: 0.0,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 4, color: Colors.white)),
              child: CircleAvatar(
                radius: 40.0,
                backgroundImage:
                    NetworkImage(participants.users?[i].image ?? ""),
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
        );
      }
    } else {
      for (var i = 0; i < 5; i++) {
        if (i < 4) {
          list.add(
            Positioned(
              right: pos,
              top: 0.0,
              bottom: 0.0,
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 4, color: Colors.white)),
                child: CircleAvatar(
                  radius: 40.0,
                  backgroundImage: NetworkImage(participants.users![i].image),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
          );
        } else {
          list.add(
            Positioned(
              right: pos,
              top: 0.0,
              bottom: 0.0,
              child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: MyApp.resources.color.orange,
                      shape: BoxShape.circle,
                      border: Border.all(width: 4, color: Colors.white)),
                  child: Center(
                    child: Text(
                      ((participants.count ?? 0) > 4)
                          ? (participants.count ?? 0 - 4).toString()
                          : (participants.count ?? 0).toString(),
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  )),
            ),
          );
        }
        pos += 25;
      }
    }
  }
  return Stack(children: list);
}

class EventDescModel {
  String key;
  String value;
  Color color;
  String icon;
  EventDescModel({
    this.key = "",
    this.value = "",
    this.color = Colors.black,
    this.icon = "",
  });
}
