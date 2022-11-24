import 'dart:convert';

import 'package:flutter/foundation.dart';

class NoifictionData {
  String image;
  String title;
  String body;
  String type;
  Map<String, dynamic>? extraData;

  NoifictionData(
      {required this.image,
      required this.title,
      required this.body,
      required this.type,
      this.extraData});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'image': image});
    result.addAll({'title': title});
    result.addAll({'body': body});
    result.addAll({'type': type});
    if (extraData != null) {
      result.addAll({'extra_data': json.encode(extraData)});
    }

    return result;
  }

  factory NoifictionData.fromMap(Map<String, dynamic> map) {
    return NoifictionData(
        image: map['image'] ?? '',
        title: map['title'] ?? '',
        body: map['body'] ?? '',
        type: map['type'] ?? '',
        extraData: map.containsKey("extra_data")
            ? json.decode(map['extra_data'])
            : null);
  }

  String toJson() => json.encode(toMap());

  factory NoifictionData.fromJson(String source) =>
      NoifictionData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NoifictionData(image: $image, title: $title, body: $body, type: $type, extraData: $extraData)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NoifictionData &&
        other.image == image &&
        other.title == title &&
        other.body == body &&
        other.type == type &&
        mapEquals(other.extraData, extraData);
  }

  @override
  int get hashCode {
    return image.hashCode ^
        title.hashCode ^
        body.hashCode ^
        type.hashCode ^
        extraData.hashCode;
  }
}
