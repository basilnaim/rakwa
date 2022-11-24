import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:rakwa/main.dart';
import 'package:rakwa/model/listing/event_participant.dart';
import 'package:rakwa/model/listing/listing_event.dart';
import 'package:rakwa/res/icons/my_icons.dart';

class ListingEventItem extends StatefulWidget {
  const ListingEventItem({Key? key, this.event, this.onParticipate})
      : super(key: key);
  final ListingEvent? event;
  final Function(bool participated)? onParticipate;

  @override
  State<ListingEventItem> createState() => _ListingEventItemState();
}

class _ListingEventItemState extends State<ListingEventItem> {
  String month = "";
  String day = "";

  bool participated = false;
  List<EventDescModel> eventDescList = [];
  List months = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC'
  ];
  @override
  void initState() {
    super.initState();
    var startDate = DateTime.parse(widget.event?.startDate?.date ?? "");
    var endDate = DateTime.parse(widget.event?.endDate?.date ?? "");

    var mon = startDate.month;
    day = startDate.day.toString();
    month = months[mon - 1];
    String formattedStartDate = DateFormat('dd-MM-yyyy').format(startDate);
    String formattedEndDate = DateFormat('dd-MM-yyyy').format(endDate);
    String formattedTimeStart = DateFormat('KK:mm a').format(startDate);
    String formattedTimeEnd = DateFormat('KK:mm a').format(endDate);

    eventDescList.add(EventDescModel(
        key: "STATUS",
        value: (widget.event?.status == "D") ? "unavailable" : "available",
        color: (widget.event?.status == "D") ? Colors.red : Colors.green,
        icon: MyIcons.icStatus));
    eventDescList.add(EventDescModel(
        key: "Start Date", value: formattedStartDate, icon: MyIcons.icStart));
    eventDescList.add(EventDescModel(
        key: "Start Time", value: formattedTimeStart, icon: MyIcons.icTime));
    eventDescList.add(EventDescModel(
        key: "End Date", value: formattedEndDate, icon: MyIcons.icHistory));
    eventDescList.add(EventDescModel(
        key: "End Time", value: formattedTimeEnd, icon: MyIcons.icTime));
    eventDescList.add(EventDescModel(
        key: "Location",
        value: widget.event?.address ?? "",
        icon: MyIcons.icMarker));

    if (widget.event?.participants?.users != null &&
        widget.event!.participants!.users!.isNotEmpty) {
      for (int i = 0; i < widget.event!.participants!.users!.length; i++) {
        if (widget.event!.participants!.users![i].id ==
            MyApp.userConnected?.id) {
          participated = true;
        }
      }
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
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
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
                    height: 160,
                    child: Stack(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          widget.event?.image ?? "",
                          width: MediaQuery.of(context).size.width,
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 160,
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
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color:
                                                MyApp.resources.color.orange),
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
                                        widget.event?.title ?? "",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white),
                                      ),
                                    ]),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
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
                                        day,
                                        style: TextStyle(
                                            fontSize: 26,
                                            color: MyApp.resources.color.orange,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      Text(
                                        month,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ]),
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
                          fontWeight: FontWeight.w700),
                    ),
                    Flexible(
                      child: SizedBox(
                        height: 50,
                        child: getUsersWidgets(widget.event!.participants),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16)),
                          color: MyApp.resources.color.orange),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            widget.onParticipate!(!participated);
                          },
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              (participated) ? "I Am Out" : "I Am Going",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700),
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
  const EventDescItem({Key? key, this.eventDescModel}) : super(key: key);
  final EventDescModel? eventDescModel;

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
              eventDescModel?.icon ?? "",
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
                    eventDescModel?.key ?? "",
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
                    eventDescModel?.value ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 10,
                        color: (eventDescModel?.color != null)
                            ? eventDescModel?.color
                            : Colors.black,
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
                  backgroundImage:
                      NetworkImage(participants.users?[i].image ?? ""),
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
                      (participants.count! - 4).toString(),
                      style: const TextStyle(
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
  String? key;
  String? value;
  Color? color;
  String? icon;
  EventDescModel({
    this.key,
    this.value,
    this.color,
    this.icon,
  });

  EventDescModel copyWith({
    String? key,
    String? value,
    Color? color,
    String? icon,
  }) {
    return EventDescModel(
      key: key ?? this.key,
      value: value ?? this.value,
      color: color ?? this.color,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (key != null) {
      result.addAll({'key': key});
    }
    if (value != null) {
      result.addAll({'value': value});
    }
    if (color != null) {
      result.addAll({'color': color!.value});
    }
    if (icon != null) {
      result.addAll({'icon': icon});
    }

    return result;
  }

  factory EventDescModel.fromMap(Map<String, dynamic> map) {
    return EventDescModel(
      key: map['key'],
      value: map['value'],
      color: map['color'] != null ? Color(map['color']) : null,
      icon: map['icon'],
    );
  }

  String toJson() => json.encode(toMap());

  factory EventDescModel.fromJson(String source) =>
      EventDescModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'EventDescModel(key: $key, value: $value, color: $color, icon: $icon)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EventDescModel &&
        other.key == key &&
        other.value == value &&
        other.color == color &&
        other.icon == icon;
  }

  @override
  int get hashCode {
    return key.hashCode ^ value.hashCode ^ color.hashCode ^ icon.hashCode;
  }
}
