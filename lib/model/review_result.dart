import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:rakwa/model/review.dart';

class ReviewResult {
  ListingDetail? listingDetails;
  List<Review>? reviews;
  ReviewResult({
    this.listingDetails,
    this.reviews,
  });

  ReviewResult copyWith({
    ListingDetail? listingDetails,
    List<Review>? reviews,
  }) {
    return ReviewResult(
      listingDetails: listingDetails ?? this.listingDetails,
      reviews: reviews ?? this.reviews,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(listingDetails != null){
      result.addAll({'listingDetails': listingDetails!.toMap()});
    }
    if(reviews != null){
      result.addAll({'reviews': reviews!.map((x) => x.toMap()).toList()});
    }
  
    return result;
  }

  factory ReviewResult.fromMap(Map<String, dynamic> map) {
    return ReviewResult(
      listingDetails: map['listingDetails'] != null ? ListingDetail.fromMap(map['listingDetails']) : null,
      reviews: map['reviews'] != null ? List<Review>.from(map['reviews']?.map((x) => Review.fromMap(x))) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewResult.fromJson(String source) => ReviewResult.fromMap(json.decode(source));

  @override
  String toString() => 'ReviewResult(listingDetails: $listingDetails, reviews: $reviews)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ReviewResult &&
      other.listingDetails == listingDetails &&
      listEquals(other.reviews, reviews);
  }

  @override
  int get hashCode => listingDetails.hashCode ^ reviews.hashCode;
}

class ListingDetail {
  String? image; 
  String? name; 
  int? rating;
  int? view;
  ListingDetail({
    this.image,
    this.name,
    this.rating,
    this.view,
  });

  ListingDetail copyWith({
    String? image,
    String? name,
    int? rating,
    int? view,
  }) {
    return ListingDetail(
      image: image ?? this.image,
      name: name ?? this.name,
      rating: rating ?? this.rating,
      view: view ?? this.view,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(image != null){
      result.addAll({'image': image});
    }
    if(name != null){
      result.addAll({'name': name});
    }
    if(rating != null){
      result.addAll({'rating': rating});
    }
    if(view != null){
      result.addAll({'view': view});
    }
  
    return result;
  }

  factory ListingDetail.fromMap(Map<String, dynamic> map) {
    return ListingDetail(
      image: map['image'],
      name: map['name'],
      rating: map['rating']?.toInt(),
      view: map['view']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ListingDetail.fromJson(String source) => ListingDetail.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ListingDetail(image: $image, name: $name, rating: $rating, view: $view)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ListingDetail &&
      other.image == image &&
      other.name == name &&
      other.rating == rating &&
      other.view == view;
  }

  @override
  int get hashCode {
    return image.hashCode ^
      name.hashCode ^
      rating.hashCode ^
      view.hashCode;
  }
}
