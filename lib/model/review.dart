import 'dart:convert';

class Review {
  int id; 
  String? comment;
  int? user_id;
  String? user_pic;
  String? user_name;
  int? rating;
  Review({
    required this.id,
    this.comment,
    this.user_id,
    this.user_pic,
    this.user_name,
    this.rating,
  });

  Review copyWith({
    int? id,
    String? comment,
    int? user_id,
    String? user_pic,
    String? user_name,
    int? rating,
  }) {
    return Review(
      id: id ?? this.id,
      comment: comment ?? this.comment,
      user_id: user_id ?? this.user_id,
      user_pic: user_pic ?? this.user_pic,
      user_name: user_name ?? this.user_name,
      rating: rating ?? this.rating,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    if(comment != null){
      result.addAll({'comment': comment});
    }
    if(user_id != null){
      result.addAll({'user_id': user_id});
    }
    if(user_pic != null){
      result.addAll({'user_pic': user_pic});
    }
    if(user_name != null){
      result.addAll({'user_name': user_name});
    }
    if(rating != null){
      result.addAll({'rating': rating});
    }
  
    return result;
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id']?.toInt() ?? 0,
      comment: map['comment'],
      user_id: map['user_id']?.toInt(),
      user_pic: map['user_pic'],
      user_name: map['user_name'],
      rating: map['rating']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Review.fromJson(String source) => Review.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Review(id: $id, comment: $comment, user_id: $user_id, user_pic: $user_pic, user_name: $user_name, rating: $rating)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Review &&
      other.id == id &&
      other.comment == comment &&
      other.user_id == user_id &&
      other.user_pic == user_pic &&
      other.user_name == user_name &&
      other.rating == rating;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      comment.hashCode ^
      user_id.hashCode ^
      user_pic.hashCode ^
      user_name.hashCode ^
      rating.hashCode;
  }
}
