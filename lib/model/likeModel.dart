import 'dart:convert';

class LikeModel {

  int? listing;
  int? reaction;
  LikeModel({
    this.listing,
    this.reaction,
  });
  

  LikeModel copyWith({
    int? listing,
    int? reaction,
  }) {
    return LikeModel(
      listing: listing ?? this.listing,
      reaction: reaction ?? this.reaction,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(listing != null){
      result.addAll({'listing': listing});
    }
    if(reaction != null){
      result.addAll({'reaction': reaction});
    }
  
    return result;
  }

  factory LikeModel.fromMap(Map<String, dynamic> map) {
    return LikeModel(
      listing: map['listing']?.toInt(),
      reaction: map['reaction']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory LikeModel.fromJson(String source) => LikeModel.fromMap(json.decode(source));

  @override
  String toString() => 'LikeModel(listing: $listing, reaction: $reaction)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is LikeModel &&
      other.listing == listing &&
      other.reaction == reaction;
  }

  @override
  int get hashCode => listing.hashCode ^ reaction.hashCode;
}

class LikeResponse {
  int? like;
  LikeResponse({
    this.like,
  });



  LikeResponse copyWith({
    int? like,
  }) {
    return LikeResponse(
      like: like ?? this.like,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(like != null){
      result.addAll({'like': like});
    }
  
    return result;
  }

  factory LikeResponse.fromMap(Map<String, dynamic> map) {
    return LikeResponse(
      like: map['like']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory LikeResponse.fromJson(String source) => LikeResponse.fromMap(json.decode(source));

  @override
  String toString() => 'LikeResponse(like: $like)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is LikeResponse &&
      other.like == like;
  }

  @override
  int get hashCode => like.hashCode;
}
