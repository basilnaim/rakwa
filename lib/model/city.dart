import 'dart:convert';

class City {
  int id;
  String name;
  City({
    required this.id,
    required this.name,
  });

  City copyWith({
    int? id,
    String? name,
  }) {
    return City(
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

  factory City.fromMap(Map<String, dynamic> map) {
    return City(
      id:  (map['id'].toString().isNotEmpty)? map['id']?.toInt() ?? 0 : 0,
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory City.fromJson(String source) => City.fromMap(json.decode(source));

  @override
  String toString() => 'City(id: $id, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is City &&
      other.id == id &&
      other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
