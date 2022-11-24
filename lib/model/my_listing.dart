import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:rakwa/model/listing.dart';

class MyListingModel {
List<Listing>? published;
List<Listing>? pending;
List<Listing>? expired;
  MyListingModel({
    this.published,
    this.pending,
    this.expired,
  });

  MyListingModel copyWith({
    List<Listing>? published,
    List<Listing>? pending,
    List<Listing>? expired,
  }) {
    return MyListingModel(
      published: published ?? this.published,
      pending: pending ?? this.pending,
      expired: expired ?? this.expired,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(published != null){
      result.addAll({'Published': published!.map((x) => x.toMap()).toList()});
    }
    if(pending != null){
      result.addAll({'Pending': pending!.map((x) => x.toMap()).toList()});
    }
    if(expired != null){
      result.addAll({'Expired': expired!.map((x) => x.toMap()).toList()});
    }
  
    return result;
  }

  factory MyListingModel.fromMap(Map<String, dynamic> map) {
    return MyListingModel(
      published: map['Published'] != null ? List<Listing>.from(map['Published']?.map((x) => Listing.fromMap(x))) : null,
      pending: map['Pending'] != null ? List<Listing>.from(map['Pending']?.map((x) => Listing.fromMap(x))) : null,
      expired: map['Expired'] != null ? List<Listing>.from(map['Expired']?.map((x) => Listing.fromMap(x))) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MyListingModel.fromJson(String source) => MyListingModel.fromMap(json.decode(source));

  @override
  String toString() => 'MyListingModel(published: $published, pending: $pending, expired: $expired)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is MyListingModel &&
      listEquals(other.published, published) &&
      listEquals(other.pending, pending) &&
      listEquals(other.expired, expired);
  }

  @override
  int get hashCode => published.hashCode ^ pending.hashCode ^ expired.hashCode;
}
