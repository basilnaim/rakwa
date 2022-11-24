import 'dart:convert';

class AddReview {
  String? listing_id;
  String? comment;
  int? rating;
  AddReview({
    this.listing_id,
    this.comment,
    this.rating,
  });

  AddReview copyWith({
    String? listing_id,
    String? comment,
    int? rating,
  }) {
    return AddReview(
      listing_id: listing_id ?? this.listing_id,
      comment: comment ?? this.comment,
      rating: rating ?? this.rating,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(listing_id != null){
      result.addAll({'listing_id': listing_id});
    }
    if(comment != null){
      result.addAll({'comment': comment});
    }
    if(rating != null){
      result.addAll({'rating': rating});
    }
  
    return result;
  }

  factory AddReview.fromMap(Map<String, dynamic> map) {
    return AddReview(
      listing_id: map['listing_id'],
      comment: map['comment'],
      rating: map['rating']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory AddReview.fromJson(String source) => AddReview.fromMap(json.decode(source));

  @override
  String toString() => 'AddReview(listing_id: $listing_id, comment: $comment, rating: $rating)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AddReview &&
      other.listing_id == listing_id &&
      other.comment == comment &&
      other.rating == rating;
  }

  @override
  int get hashCode => listing_id.hashCode ^ comment.hashCode ^ rating.hashCode;
}
