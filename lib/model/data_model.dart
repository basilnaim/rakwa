import 'dart:convert';

class DataModel {
  String value;
  DataModel({
    required this.value,
  });

  DataModel copyWith({
    String? value,
  }) {
    return DataModel(
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'value': value});
  
    return result;
  }

  factory DataModel.fromMap(Map<String, dynamic> map) {
    return DataModel(
      value: map['value'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DataModel.fromJson(String source) => DataModel.fromMap(json.decode(source));

  @override
  String toString() => 'DataModel(value: $value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is DataModel &&
      other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
