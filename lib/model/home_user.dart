import 'dart:convert';

class HomeUser {
  String name;
  int id;
  String image;
  HomeUser({
    required this.name,
    required this.id,
    required this.image,
  });

  

  HomeUser copyWith({
    String? name,
    int? id,
    String? image,
  }) {
    return HomeUser(
      name: name ?? this.name,
      id: id ?? this.id,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'name': name});
    result.addAll({'id': id});
    result.addAll({'image': image});
  
    return result;
  }

  factory HomeUser.fromMap(Map<String, dynamic> map) {
    return HomeUser(
      name: map['name'] ?? '',
      id: map['id']?.toInt() ?? 0,
      image: map['image'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory HomeUser.fromJson(String source) => HomeUser.fromMap(json.decode(source));

  @override
  String toString() => 'HomeUser(name: $name, id: $id, image: $image)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is HomeUser &&
      other.name == name &&
      other.id == id &&
      other.image == image;
  }

  @override
  int get hashCode => name.hashCode ^ id.hashCode ^ image.hashCode;
}
