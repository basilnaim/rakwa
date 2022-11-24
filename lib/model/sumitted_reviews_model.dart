import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:rakwa/model/listing.dart';


class SubmittedReviewsModel {
  int? listing_id;
  String? listing_image;
  List<SubmittedReviewItemModel>? reviews;
  Listing? listing;
  SubmittedReviewsModel({
    this.listing_id,
    this.listing_image,
    this.reviews,
    this.listing,
  });


  SubmittedReviewsModel copyWith({
    int? listing_id,
    String? listing_image,
    List<SubmittedReviewItemModel>? reviews,
    Listing? listing,
  }) {
    return SubmittedReviewsModel(
      listing_id: listing_id ?? this.listing_id,
      listing_image: listing_image ?? this.listing_image,
      reviews: reviews ?? this.reviews,
      listing: listing ?? this.listing,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(listing_id != null){
      result.addAll({'listing_id': listing_id});
    }
    if(listing_image != null){
      result.addAll({'listing_image': listing_image});
    }
    if(reviews != null){
      result.addAll({'reviews': reviews!.map((x) => x.toMap()).toList()});
    }
    if(listing != null){
      result.addAll({'listing': listing!.toMap()});
    }
  
    return result;
  }

  factory SubmittedReviewsModel.fromMap(Map<String, dynamic> map) {
    return SubmittedReviewsModel(
      listing_id: map['listing_id']?.toInt(),
      listing_image: map['listing_image'],
      reviews: map['reviews'] != null ? List<SubmittedReviewItemModel>.from(map['reviews']?.map((x) => SubmittedReviewItemModel.fromMap(x))) : null,
      listing: map['listing'] != null ? Listing.fromMap(map['listing']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubmittedReviewsModel.fromJson(String source) => SubmittedReviewsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SubmittedReviewsModel(listing_id: $listing_id, listing_image: $listing_image, reviews: $reviews, listing: $listing)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is SubmittedReviewsModel &&
      other.listing_id == listing_id &&
      other.listing_image == listing_image &&
      listEquals(other.reviews, reviews) &&
      other.listing == listing;
  }

  @override
  int get hashCode {
    return listing_id.hashCode ^
      listing_image.hashCode ^
      reviews.hashCode ^
      listing.hashCode;
  }
}

class SubmittedReviewItemModel {
  int? review_id;
  String? reviewer_name;
  String? reviewer_image;
  String? message;
  int? rating;
  int? status;
  SubmittedReviewItemModel({
    this.review_id,
    this.reviewer_name,
    this.reviewer_image,
    this.message,
    this.rating,
    this.status,
  });


  SubmittedReviewItemModel copyWith({
    int? review_id,
    String? reviewer_name,
    String? reviewer_image,
    String? message,
    int? rating,
    int? status,
  }) {
    return SubmittedReviewItemModel(
      review_id: review_id ?? this.review_id,
      reviewer_name: reviewer_name ?? this.reviewer_name,
      reviewer_image: reviewer_image ?? this.reviewer_image,
      message: message ?? this.message,
      rating: rating ?? this.rating,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(review_id != null){
      result.addAll({'review_id': review_id});
    }
    if(reviewer_name != null){
      result.addAll({'reviewer_name': reviewer_name});
    }
    if(reviewer_image != null){
      result.addAll({'reviewer_image': reviewer_image});
    }
    if(message != null){
      result.addAll({'message': message});
    }
    if(rating != null){
      result.addAll({'rating': rating});
    }
    if(status != null){
      result.addAll({'status': status});
    }
  
    return result;
  }

  factory SubmittedReviewItemModel.fromMap(Map<String, dynamic> map) {
    return SubmittedReviewItemModel(
      review_id: map['review_id']?.toInt(),
      reviewer_name: map['reviewer_name'],
      reviewer_image: map['reviewer_image'],
      message: map['message'],
      rating: map['rating']?.toInt(),
      status: map['status']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory SubmittedReviewItemModel.fromJson(String source) => SubmittedReviewItemModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SubmittedReviewItemModel(review_id: $review_id, reviewer_name: $reviewer_name, reviewer_image: $reviewer_image, message: $message, rating: $rating, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is SubmittedReviewItemModel &&
      other.review_id == review_id &&
      other.reviewer_name == reviewer_name &&
      other.reviewer_image == reviewer_image &&
      other.message == message &&
      other.rating == rating &&
      other.status == status;
  }

  @override
  int get hashCode {
    return review_id.hashCode ^
      reviewer_name.hashCode ^
      reviewer_image.hashCode ^
      message.hashCode ^
      rating.hashCode ^
      status.hashCode;
  }
}
