import 'dart:convert';

class CategorieModel {
  int id;
  String? title;
  String? icon;
  CategorieModel({
    required this.id,
    this.title,
    this.icon,
  });

  
  

  CategorieModel copyWith({
    int? id,
    String? title,
    String? icon,
  }) {
    return CategorieModel(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    if(title != null){
      result.addAll({'title': title});
    }
    if(icon != null){
      result.addAll({'icon': icon});
    }
  
    return result;
  }

  factory CategorieModel.fromMap(Map<String, dynamic> map) {
    return CategorieModel(
      id: map['id']?.toInt() ?? 0,
      title: map['title'],
      icon:(map.containsKey("icon"))? map['icon'] : "",
    );
  }

  String toJson() => json.encode(toMap());

  factory CategorieModel.fromJson(String source) => CategorieModel.fromMap(json.decode(source));

  @override
  String toString() => 'CategorieModel(id: $id, title: $title, icon: $icon)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CategorieModel &&
      other.id == id &&
      other.title == title &&
      other.icon == icon;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ icon.hashCode;
}
