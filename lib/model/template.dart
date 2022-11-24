import 'dart:convert';

class Template {
  String title;
  int id;
  bool status;
  Template({
     this.title="",
     this.id=0,
     this.status=false,
  });



  Template copyWith({
    String? title,
    int? id,
    bool? status,
  }) {
    return Template(
      title: title ?? this.title,
      id: id ?? this.id,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'title': title});
    result.addAll({'id': id});
    result.addAll({'status': status});
  
    return result;
  }

  factory Template.fromMap(Map<String, dynamic> map) {
    return Template(
      title: map['title'] ?? '',
      id: map['id']?.toInt() ?? 0,
      status: (map['status'] == 'enabled') ,
    );
  }

  String toJson() => json.encode(toMap());

  factory Template.fromJson(String source) => Template.fromMap(json.decode(source));

  @override
  String toString() => 'Template(title: $title, id: $id, status: $status)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Template &&
      other.title == title &&
      other.id == id &&
      other.status == status;
  }

  @override
  int get hashCode => title.hashCode ^ id.hashCode ^ status.hashCode;
}
