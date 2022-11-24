import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rakwa/model/data_model.dart';
import 'package:rakwa/screens/add_listing/components/generic_field_container.dart';

class GenericFormField {
  String apiKey;
  String label;
  GenericFormFieldType? type;
  bool isRequired;
  List<DataModel> data;
  String value; 
   GlobalKey<GenericFieldContainerState>? key;
  GenericFormField({
    required this.apiKey,
    required this.label,
    required this.type,
    required this.isRequired,
    required this.data,
    this.value ="" 
  });


 

  Map<String, dynamic> toMap() {
    return {
      'apiKey': apiKey,
      'label': label,
      'type': type.toString().split(".")[1] ,
      'isRequired': isRequired,
      'data': data,
    };
  }

  factory GenericFormField.fromMap(Map<String, dynamic> map) {
    return GenericFormField(
      apiKey: map['ApiKey'] ?? '',
      label: map['label'] ?? '',
      type: GenericFormFieldTypeExt.fromString(map['type']),
      isRequired: map['isRequired'] ?? false,
      data: List<DataModel>.from(map['data']?.map((x) => DataModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory GenericFormField.fromJson(String source) => GenericFormField.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GenericFormField(apiKey: $apiKey, label: $label, isRequired: $isRequired, data: $data)';
  }

  

  @override
  int get hashCode {
    return apiKey.hashCode ^
      label.hashCode ^
      isRequired.hashCode ^
      data.hashCode;
  }
}


enum GenericFormFieldType{
  url , checkbox , range , textarea , dropdown ,text
}


extension GenericFormFieldTypeExt on GenericFormFieldType{

static GenericFormFieldType? fromString(String type){
    switch(type){
     case "url": return GenericFormFieldType.url;
     case "checkbox": return GenericFormFieldType.checkbox;
     case "textarea": return GenericFormFieldType.textarea;
     case "range": return GenericFormFieldType.range;
     case "dropdown": return GenericFormFieldType.dropdown;
     case "text": return GenericFormFieldType.text;
     default  : return null; 
    }
  }
}
  //url checkbox range textarea dropdown
