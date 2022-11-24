import 'dart:convert';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'contact_message.dart';

class RoomContact {
  String roomId = "";
  int id = 0;
  // 0 : listing
  // 1 : classifield
  int type = 0;
  // user ids sender and receiver
  List<int> users;
  List<int> seenBy;

  ContactMessage? lastMessage;
  bool deleted = false;
  int unreadMessages = 0;
  RoomContact({
    this.roomId = "",
    this.users = const [],
    this.seenBy = const [],
    required this.id,
    this.lastMessage,
    required this.type ,
    this.deleted = false,
    this.unreadMessages = 0,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'roomId': roomId});
    result.addAll({'users': users});
    result.addAll({'id': id});
    result.addAll({'type': type});
    result.addAll({'seenBy': seenBy});
    if (lastMessage != null) {
      result.addAll({'lastMessage': lastMessage!.toMap()});
    }
    result.addAll({'deleted': deleted});
    result.addAll({'unreadMessages': unreadMessages});

    return result;
  }

  factory RoomContact.fromMapp(Map<String, dynamic> map) {
    return RoomContact(
      roomId: map['roomId'] ?? '',
      users: List<int>.from(map['users']),
      seenBy: List<int>.from(map['seenBy']),
      lastMessage: map['lastMessage'] != null
          ? ContactMessage.fromMap(map['lastMessage'])
          : null,
      deleted: map['deleted'] ?? false,
      unreadMessages: map['unreadMessages']?.toInt() ?? 0,
      id: map['id']?.toInt() ?? 0,
      type: map['type']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory RoomContact.fromJson(String source) =>
      RoomContact.fromMapp(json.decode(source));

  @override
  String toString() {
    return 'ContactRoom(id: $roomId, users: $users, seenBy: $seenBy, lastMessage: $lastMessage, deleted: $deleted, unreadMessages: $unreadMessages)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RoomContact &&
        other.roomId == roomId &&
        listEquals(other.users, users) &&
        listEquals(other.seenBy, seenBy) &&
        other.lastMessage == lastMessage &&
        other.deleted == deleted &&
        other.unreadMessages == unreadMessages;
  }

  @override
  int get hashCode {
    return roomId.hashCode ^
        users.hashCode ^
        seenBy.hashCode ^
        lastMessage.hashCode ^
        deleted.hashCode ^
        unreadMessages.hashCode;
  }
}
