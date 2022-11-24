import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:rakwa/model/sumitted_reviews_model.dart';

class MyReviewsModel {
  List<SubmittedReviewsModel>? Received;
  List<SubmittedReviewsModel>? Submitted;
  MyReviewsModel({
    this.Received,
    this.Submitted,
  });

  MyReviewsModel copyWith({
    List<SubmittedReviewsModel>? Received,
    List<SubmittedReviewsModel>? Submitted,
  }) {
    return MyReviewsModel(
      Received: Received ?? this.Received,
      Submitted: Submitted ?? this.Submitted,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(Received != null){
      result.addAll({'Received': Received!.map((x) => x.toMap()).toList()});
    }
    if(Submitted != null){
      result.addAll({'Submitted': Submitted!.map((x) => x.toMap()).toList()});
    }
  
    return result;
  }

  factory MyReviewsModel.fromMap(Map<String, dynamic> map) {
    return MyReviewsModel(
      Received: map['Received'] != null ? List<SubmittedReviewsModel>.from(map['Received']?.map((x) => SubmittedReviewsModel.fromMap(x))) : null,
      Submitted: map['Submitted'] != null ? List<SubmittedReviewsModel>.from(map['Submitted']?.map((x) => SubmittedReviewsModel.fromMap(x))) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MyReviewsModel.fromJson(String source) => MyReviewsModel.fromMap(json.decode(source));

  @override
  String toString() => 'MyReviewsModel(Received: $Received, Submitted: $Submitted)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is MyReviewsModel &&
      listEquals(other.Received, Received) &&
      listEquals(other.Submitted, Submitted);
  }

  @override
  int get hashCode => Received.hashCode ^ Submitted.hashCode;
}
