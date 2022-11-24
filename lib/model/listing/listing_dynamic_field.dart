import 'dart:convert';

import 'package:flutter/foundation.dart';

class DynamicFields {
  String? label;
  String? type;
  String? data;
  List<String>? checkData;
  DynamicFields({
    this.label,
    this.type,
    this.data,
    this.checkData,
  });

  DynamicFields copyWith({
    String? labes,
    String? type,
    String? data,
    List<String>? checkData,
  }) {
    return DynamicFields(
      label: labes ?? this.label,
      type: type ?? this.type,
      data: data ?? this.data,
      checkData: checkData ?? this.checkData,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (label != null) {
      result.addAll({'label': label});
    }
    if (type != null) {
      result.addAll({'type': type});
    }
    if (data != null) {
      result.addAll({'data': data});
    }
    if (checkData != null) {
      result.addAll({'check_data': checkData});
    }

    return result;
  }

  factory DynamicFields.fromMap(Map<String, dynamic> map) {
    return DynamicFields(
        label: map['label'],
        type: map['type'],
        data: map['data'] != null
            ? (map['data'].toString().startsWith("["))
                ? null
                : map['data']
            : null,
        checkData: map['check_data'] != null
            ? List<String>.from(map['check_data'])
            : (map['data'].toString().startsWith("["))
                ? List<String>.from(map['data'])
                : null);
  }

  String toJson() => json.encode(toMap());

  factory DynamicFields.fromJson(String source) =>
      DynamicFields.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DynamicFields(label: $label, type: $type, data: $data, checkData: $checkData)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DynamicFields &&
        other.label == label &&
        other.type == type &&
        other.data == data &&
        listEquals(other.checkData, checkData);
  }

  @override
  int get hashCode {
    return label.hashCode ^ type.hashCode ^ data.hashCode ^ checkData.hashCode;
  }
}
