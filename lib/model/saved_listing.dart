import 'dart:convert';

import 'package:rakwa/model/categorie.dart';
import 'package:rakwa/model/listing.dart';

class SavedListing {
  int id;
  Listing listing;
  SavedListing({
    required this.id,
    required this.listing,
  });
  
 

  SavedListing copyWith({
    int? id,
    Listing? listing,
  }) {
    return SavedListing(
      id: id ?? this.id,
      listing: listing ?? this.listing,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'listing': listing.toMap()});
  
    return result;
  }

  factory SavedListing.fromMap(Map<String, dynamic> map) {
    return SavedListing(
      id: map['id']?.toInt() ?? 0,
      listing: Listing.fromMap(map['listing']),
    );
  }

  String toJson() => json.encode(toMap());

  factory SavedListing.fromJson(String source) => SavedListing.fromMap(json.decode(source));

  @override
  String toString() => 'SavedListing(id: $id, listing: $listing)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is SavedListing &&
      other.id == id &&
      other.listing == listing;
  }

  @override
  int get hashCode => id.hashCode ^ listing.hashCode;
}
