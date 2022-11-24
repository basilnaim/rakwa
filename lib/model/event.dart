import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rakwa/utils/days.dart';

import 'listing/event_participant.dart';

class Event {
  int id;
  int listingId;
  String image;
  String title;
  String description;
  String category;
  String url;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  DateTime? startDate;
  DateTime? endDate;
  File? imageFile;
  String latitude;
  String longitude;
  String address;
  EventParticipant? participants;
  int? isParticipated;
  String? status;

//  Map<SocialMedia, String> socialMedia;

  Event(
      {this.id = 0,
      this.listingId = 0,
      this.image = "",
      //    this.socialMedia = const{},
      this.title = "",
      this.participants,
      this.isParticipated,
      this.address = "",
      this.imageFile,
      this.description = "",
      this.category = "",
      this.url = "",
      this.latitude = "",
      this.longitude = "",
      this.startTime,
      this.endTime,
      this.endDate,
      this.startDate,
      this.status});

  Event copyWith({
    int? id,
    String? image,
    String? title,
    String? description,
    String? category,
    String? url,
  }) {
    return Event(
      id: id ?? this.id,
      image: image ?? this.image,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'listing_id': listingId});
    result.addAll({'name': title});
    result.addAll({'description': description});
    result.addAll({'category': category});
    result.addAll({
      'start_time':
          (startTime == null) ? "" : DateFormat.Hm().format(nowTime(startTime!))
    });
    result.addAll({
      'end_time':
          (endTime == null) ? "" : DateFormat.Hm().format(nowTime(endTime!))
    });
    result.addAll({
      'start_date': (startDate == null) ? "" : formatDate.format(startDate!)
    });
    result.addAll(
        {'end_date': (endDate == null) ? "" : formatDate.format(endDate!)});
    result.addAll({'address': address});
    result.addAll({'latitude': latitude});
    result.addAll({'longitude': longitude});

    return result;
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
        id: map['id']?.toInt() ?? 0,
        image: map['image'] ?? '',
        title: map['title'] ?? '',
        isParticipated: map['is_participated']?.toInt(),
        participants: map['participants'] != null
            ? EventParticipant.fromMap(map['participants'])
            : null,
        description: map['description'] ?? '',
        category: map['category'] ?? '',
        url: map['url'] ?? '',
        status: map['status']);
  }

  factory Event.fromMyCollectionMap(Map<String, dynamic> map) {
    return Event(
      id: map['event_id']?.toInt() ?? 0,
      listingId:
          (map.containsKey('listing_id')) ? map['listing_id']?.toInt() ?? 0 : 0,
      image: map['image'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      url: map['internal-url'] ?? '',
      latitude: map['latitude'] ?? '',
      longitude: map['longitude'] ?? '',
      address: map['address'] ?? '',
      isParticipated: map['is_participated']?.toInt(),
      status: map.containsKey('status') ? map['status'] : null,
      participants: map['participants'] != null
          ? EventParticipant.fromMap(map['participants'])
          : null,
      startDate: (!map.containsKey('start-date'))
          ? null
          : formatDate
              .parse(EventDate.fromMap(map['start-date']).date.split(' ')[0]),
      startTime: (!map.containsKey('start-time'))
          ? null
          : getTimeWithSecondFromString(EventDate.fromMap(map['start-time'])
              .date
              .split(' ')[1]
              .split('.')[0]),
      endTime: (!map.containsKey('end-time'))
          ? null
          : getTimeWithSecondFromString(EventDate.fromMap(map['end-time'])
              .date
              .split(' ')[1]
              .split('.')[0]),
      endDate: (!map.containsKey('end-date'))
          ? null
          : formatDate
              .parse(EventDate.fromMap(map['end-date']).date.split(' ')[0]),
    );
  }

  String toJson() => json.encode(toMap());

  factory Event.fromJson(String source) => Event.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Event(id:  time $startTime $id, image: $image, title: $title, description: $description, category: $category, url: $url)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Event &&
        other.id == id &&
        other.image == image &&
        other.title == title &&
        other.description == description &&
        other.category == category &&
        other.url == url;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        image.hashCode ^
        title.hashCode ^
        description.hashCode ^
        category.hashCode ^
        url.hashCode;
  }
}

class EventDate {
  String date;
  EventDate({
    required this.date,
  });

  EventDate copyWith({
    String? date,
  }) {
    return EventDate(
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'date': date});

    return result;
  }

  factory EventDate.fromMap(Map<String, dynamic> map) {
    return EventDate(
      date: map['date'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory EventDate.fromJson(String source) =>
      EventDate.fromMap(json.decode(source));

  @override
  String toString() => 'EventDate(date: $date)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EventDate && other.date == date;
  }

  @override
  int get hashCode => date.hashCode;
}
