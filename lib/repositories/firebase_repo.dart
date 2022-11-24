import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/contact_message.dart';
import 'package:rakwa/model/contact_room.dart';
import 'package:http/http.dart' as http;

class FirebaseRepo {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  getVersion() {
    return firestore.collection("params").doc("version").get();
  }

  loginUserFcm(int id, {bool login = true}) async {
    final imei = await FirebaseMessaging.instance.getToken() ?? "";

    final tokens = firestore.collection("tokens").doc("user_id_$id");

    tokens.get().then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        if (login) {
          tokens.update({
            'fcm': FieldValue.arrayUnion([imei])
          });
        } else {
          tokens.update({
            'fcm': FieldValue.arrayRemove([imei])
          });
        }
      } else {
        if (login) {
          tokens.set({
            "id": id,
            "fcm": [imei]
          });
        }
      }
    });
  }

  //type : 0 listing ; 1 classified
  getRoomContactById(List<int> usersIDs, int id, int type) {
    return firestore
        .collection("rooms")
        .where(
          "users",
          isEqualTo: usersIDs..sort(),
        )
        .where(
          "id",
          isEqualTo: id,
        )
        .where(
          "type",
          isEqualTo: type,
        )
        .get();
  }

  getMessagingRoom(String id) {
    return firestore
        .collection("rooms")
        .doc(id)
        .collection("chats")
        .orderBy("created", descending: true);
  }

  getMessagingRoomsByUserId(int id, String query) {
    return firestore.collection("rooms").where(
      "users",
      arrayContainsAny: [id],
    ).orderBy("lastMessage.created", descending: true);
  }

  Future sendMessage(ContactMessage message, String roomId) {
    final ref = firestore.collection("rooms").doc(roomId);

    message.id = firestore.collection("rooms").doc().id;
    ref.collection("chats").doc(message.id).set(message.toMap());

    return firestore
        .runTransaction((transaction) async {
          // Get the document
          DocumentSnapshot snapshot = await transaction.get(ref);

          if (!snapshot.exists) {
            throw Exception("Not exist");
          }

          RoomContact room =
              RoomContact.fromMapp(snapshot.data() as Map<String, dynamic>);

          sendNotification(message, room.id, room.type);

          room.lastMessage = message;

          if (message.senderID == room.lastMessage?.senderID) {
            room.unreadMessages = room.unreadMessages + 1;
          } else {
            room.unreadMessages = 1;
          }

          room.seenBy = [message.senderID];

          transaction.update(ref, {'seenBy': room.seenBy});

          transaction.update(ref, {'unreadMessages': room.unreadMessages});

          transaction.update(ref, {'lastMessage': message.toMap()});

          return room.toMap();
        })
        .then((value) => print("room updated to $value"))
        .catchError((error) => print("room couldn't update: $error"));
  }

  sendNotification(ContactMessage message, int srcId, int type) {
    if (message.senderID != message.recipientID) {
      final userTokens =
          firestore.collection("tokens").doc("user_id_${message.recipientID}");
      userTokens.get().then((DocumentSnapshot value) {
        List<String> tokens = List<String>.from(value["fcm"]);
        //  for (var token in tokens) {
        http
            .post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                'key=AAAAzSpXY5w:APA91bHWeBH9-v9HNRX5pfPDAsmuJIcrM5U1OP3y6Za1hOlexvlrdQrrjOjudWEEkqXHsSvzXsNItByQQR_UxvM6m2kZZuXh0xo0QNPj6Ct4ZAfFFFwmoOFM1vW_5WMRJ1UGIs0efpmC',
          },
          body: constructFCMPayload(tokens, message, srcId, type),
        )
            .then((value) {
          print("body " + value.body);
        });
        //  }
      });
    }
  }

  String constructFCMPayload(
      List<String> token, ContactMessage msg, int srcId, int type) {
    return jsonEncode({
      'priority': 'high',
      'registration_ids': token,
      'data': {
        'title': 'New Message From ' + msg.senderName,
        'body': msg.content,
        'type': "2",
        'extra_data': {
          'id': srcId,
          'user_id': msg.senderID,
          'type': type,
          'user_name': msg.senderName,
          'user_image': msg.senderProfilePictureURL
        },
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'image': msg.senderProfilePictureURL
      },
      'notification': {
        'title': 'New Message From ' + msg.senderName,
        'body': msg.content,
      },
    });
  }

  Future createRoom(RoomContact room) {
    room.roomId = firestore.collection("rooms").doc().id;
    return firestore.collection("rooms").doc(room.roomId).set(room.toMap());
  }

  Future messageSeen(String roomId) {
    final ref = firestore.collection("rooms").doc(roomId);

    return firestore
        .runTransaction((transaction) async {
          // Get the document
          DocumentSnapshot snapshot = await transaction.get(ref);

          if (!snapshot.exists) {
            throw Exception("Not exist");
          }

          RoomContact room =
              RoomContact.fromMapp(snapshot.data() as Map<String, dynamic>);

          int id = MyApp.userConnected?.id ?? 0;
          if (!room.seenBy.contains(id)) {
            ref.update({"unreadMessages": 0});
            ref.update({
              'seenBy': FieldValue.arrayUnion([id])
            });
          }

          return room.toMap();
        })
        .then((value) => print("room updated to $value"))
        .catchError((error) => print("room couldn't update: $error"));
  }
}
