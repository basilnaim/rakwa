import 'dart:convert';

class ListingCity {
  int id;
  String title;
  ListingCity({
    required this.id,
    required this.title,
  });

  ListingCity copyWith({
    int? id,
    String? title,
  }) {
    return ListingCity(
      id: id ?? this.id,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'title': title});

    return result;
  }

  factory ListingCity.fromMap(Map<String, dynamic> map) {
    return ListingCity(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? map['name'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory ListingCity.fromJson(String source) =>
      ListingCity.fromMap(json.decode(source));

  @override
  String toString() => 'ListingCity(id: $id, title: $title)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ListingCity && other.id == id && other.title == title;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode;
}
