import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:rakwa/model/form_field.dart';

class GenericForm {
  String sectionName;
  int orderNumber;
  bool required;
  List<GenericFormField> fields;
  GenericForm({
    this.required = false,
    required this.sectionName,
    required this.orderNumber,
    required this.fields,
  });

  GenericForm copyWith({
    String? sectionName,
    int? orderNumber,
    List<GenericFormField>? fields,
  }) {
    return GenericForm(
      sectionName: sectionName ?? this.sectionName,
      orderNumber: orderNumber ?? this.orderNumber,
      fields: fields ?? this.fields,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    fields.forEach((element) {
     if(element.value.isNotEmpty) {
       map.putIfAbsent(
       element.apiKey, () =>
          element.value 
       );
     }
    });
    return map;
  }

  factory GenericForm.fromMap(Map<String, dynamic> map) {
    return GenericForm(
      sectionName: map['sectionName'] ?? '',
      orderNumber: map['orderNumber']?.toInt() ?? 0,
      fields: List<GenericFormField>.from(
          map['fields']?.map((x) => GenericFormField.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory GenericForm.fromJson(String source) =>
      GenericForm.fromMap(json.decode(source));

  @override
  String toString() =>
      'GenericForm(sectionName: $sectionName, orderNumber: $orderNumber, fields: $fields)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GenericForm &&
        other.sectionName == sectionName &&
        other.orderNumber == orderNumber &&
        listEquals(other.fields, fields);
  }

  @override
  int get hashCode =>
      sectionName.hashCode ^ orderNumber.hashCode ^ fields.hashCode;
}
