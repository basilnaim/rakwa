import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ContactMessage {
  String id = "";
  String content = "";
  DateTime created;
  String recipientName = "";
  int recipientID = 0;
  String recipientProfilePictureURL = "";
  String senderProfilePictureURL = "";
  String senderName = "";
  int senderID = 0;
  ContactMessage({
    required this.id,
    required this.content,
    required this.created,
    required this.recipientName,
    required this.recipientID,
    required this.recipientProfilePictureURL,
    required this.senderProfilePictureURL,
    required this.senderName,
    required this.senderID,
  });

  

  ContactMessage copyWith({
    String? id,
    String? content,
    DateTime? created,
    String? recipientName,
    int? recipientID,
    String? recipientProfilePictureURL,
    String? senderProfilePictureURL,
    String? senderName,
    int? senderID,
  }) {
    return ContactMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      created: created ?? this.created,
      recipientName: recipientName ?? this.recipientName,
      recipientID: recipientID ?? this.recipientID,
      recipientProfilePictureURL: recipientProfilePictureURL ?? this.recipientProfilePictureURL,
      senderProfilePictureURL: senderProfilePictureURL ?? this.senderProfilePictureURL,
      senderName: senderName ?? this.senderName,
      senderID: senderID ?? this.senderID,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'content': content});
    result.addAll({'created': Timestamp.fromDate(created)});
    result.addAll({'recipientName': recipientName});
    result.addAll({'recipientID': recipientID});
    result.addAll({'recipientProfilePictureURL': recipientProfilePictureURL});
    result.addAll({'senderProfilePictureURL': senderProfilePictureURL});
    result.addAll({'senderName': senderName});
    result.addAll({'senderID': senderID});
  
    return result;
  }

  factory ContactMessage.fromMap(Map<String, dynamic> map) {
    return ContactMessage(
      id: map['id'] ?? '',
      content: map['content'] ?? '',
      created: (map['created'] as Timestamp).toDate(),
      recipientName: map['recipientName'] ?? '',
      recipientID: map['recipientID']?.toInt() ?? 0,
      recipientProfilePictureURL: map['recipientProfilePictureURL'] ?? '',
      senderProfilePictureURL: map['senderProfilePictureURL'] ?? '',
      senderName: map['senderName'] ?? '',
      senderID: map['senderID']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ContactMessage.fromJson(String source) => ContactMessage.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ContactMessage(id: $id, content: $content, created: $created, recipientName: $recipientName, recipientID: $recipientID, recipientProfilePictureURL: $recipientProfilePictureURL, senderProfilePictureURL: $senderProfilePictureURL, senderName: $senderName, senderID: $senderID)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ContactMessage &&
      other.id == id &&
      other.content == content &&
      other.created == created &&
      other.recipientName == recipientName &&
      other.recipientID == recipientID &&
      other.recipientProfilePictureURL == recipientProfilePictureURL &&
      other.senderProfilePictureURL == senderProfilePictureURL &&
      other.senderName == senderName &&
      other.senderID == senderID;
  }

}
