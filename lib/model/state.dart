import 'dart:convert';

class StateLocation {
  int id;
  String name;
  StateLocation({
    required this.id,
    required this.name,
  });

  StateLocation copyWith({
    int? id,
    String? name,
  }) {
    return StateLocation(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'name': name});
  
    return result;
  }

  factory StateLocation.fromMap(Map<String, dynamic> map) {
    return StateLocation(
      id: (map['id'].toString().isNotEmpty)? map['id']?.toInt() ?? 0 : 0,
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory StateLocation.fromJson(String source) => StateLocation.fromMap(json.decode(source));

  @override
  String toString() => 'State(id: $id, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is StateLocation &&
      other.id == id &&
      other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
