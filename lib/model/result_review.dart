import 'dart:convert';

class ResultReview {
  int? id;
  String? comment;
  int? user_id;
  String? user_name;
  String? user_pic;
  int? rating; 
  ResultReview({
    this.id,
    this.comment,
    this.user_id,
    this.user_name,
    this.user_pic,
    this.rating,
  });

  ResultReview copyWith({
    int? id,
    String? comment,
    int? user_id,
    String? user_name,
    String? user_pic,
    int? rating,
  }) {
    return ResultReview(
      id: id ?? this.id,
      comment: comment ?? this.comment,
      user_id: user_id ?? this.user_id,
      user_name: user_name ?? this.user_name,
      user_pic: user_pic ?? this.user_pic,
      rating: rating ?? this.rating,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(id != null){
      result.addAll({'id': id});
    }
    if(comment != null){
      result.addAll({'comment': comment});
    }
    if(user_id != null){
      result.addAll({'user_id': user_id});
    }
    if(user_name != null){
      result.addAll({'user_name': user_name});
    }
    if(user_pic != null){
      result.addAll({'user_pic': user_pic});
    }
    if(rating != null){
      result.addAll({'rating': rating});
    }
  
    return result;
  }

  factory ResultReview.fromMap(Map<String, dynamic> map) {
    return ResultReview(
      id: map['id']?.toInt(),
      comment: map['comment'],
      user_id: map['user_id']?.toInt(),
      user_name: map['user_name'],
      user_pic: map['user_pic'],
      rating: map['rating']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ResultReview.fromJson(String source) => ResultReview.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ResultReview(id: $id, comment: $comment, user_id: $user_id, user_name: $user_name, user_pic: $user_pic, rating: $rating)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ResultReview &&
      other.id == id &&
      other.comment == comment &&
      other.user_id == user_id &&
      other.user_name == user_name &&
      other.user_pic == user_pic &&
      other.rating == rating;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      comment.hashCode ^
      user_id.hashCode ^
      user_name.hashCode ^
      user_pic.hashCode ^
      rating.hashCode;
  }
}
