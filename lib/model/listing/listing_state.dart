import 'dart:convert';

class ListingState {
  int id;
  String title;
  ListingState({
    required this.id,
    required this.title,
  });

  ListingState copyWith({
    int? id,
    String? title,
  }) {
    return ListingState(
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

  factory ListingState.fromMap(Map<String, dynamic> map) {
    return ListingState(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ListingState.fromJson(String source) => ListingState.fromMap(json.decode(source));

  @override
  String toString() => 'ListingState(id: $id, title: $title)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ListingState &&
      other.id == id &&
      other.title == title;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode;
}
