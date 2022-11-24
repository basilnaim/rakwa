import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:rakwa/model/user.dart';

class EventParticipant {
  int? count;
  List<User>? users;
  EventParticipant({
    this.count,
    this.users,
  });

  EventParticipant copyWith({
    int? count,
    List<User>? users,
  }) {
    return EventParticipant(
      count: count ?? this.count,
      users: users ?? this.users,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(count != null){
      result.addAll({'count': count});
    }
    if(users != null){
      result.addAll({'users': users!.map((x) => x.toMap()).toList()});
    }
  
    return result;
  }

  factory EventParticipant.fromMap(Map<String, dynamic> map) {
    return EventParticipant(
      count: map['count']?.toInt(),
      users: map['users'] != null ? List<User>.from(map['users']?.map((x) => User.fromMap(x))) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EventParticipant.fromJson(String source) => EventParticipant.fromMap(json.decode(source));

  @override
  String toString() => 'EventParticipant(count: $count, users: $users)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is EventParticipant &&
      other.count == count &&
      listEquals(other.users, users);
  }

  @override
  int get hashCode => count.hashCode ^ users.hashCode;
}
