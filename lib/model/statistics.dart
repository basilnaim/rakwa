import 'dart:convert';

class Statistics {
  int? listings_views;
  int? listings_count;
  int? my_reviews_count;
  int? my_listings_reviews_count;
  Statistics({
    this.listings_views,
    this.listings_count,
    this.my_reviews_count,
    this.my_listings_reviews_count,
  });

  Statistics copyWith({
    int? listings_views,
    int? listings_count,
    int? my_reviews_count,
    int? my_listings_reviews_count,
  }) {
    return Statistics(
      listings_views: listings_views ?? this.listings_views,
      listings_count: listings_count ?? this.listings_count,
      my_reviews_count: my_reviews_count ?? this.my_reviews_count,
      my_listings_reviews_count: my_listings_reviews_count ?? this.my_listings_reviews_count,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(listings_views != null){
      result.addAll({'listings_views': listings_views});
    }
    if(listings_count != null){
      result.addAll({'listings_count': listings_count});
    }
    if(my_reviews_count != null){
      result.addAll({'my_reviews_count': my_reviews_count});
    }
    if(my_listings_reviews_count != null){
      result.addAll({'my_listings_reviews_count': my_listings_reviews_count});
    }
  
    return result;
  }

  factory Statistics.fromMap(Map<String, dynamic> map) {
    return Statistics(
      listings_views: map['listings_views']?.toInt(),
      listings_count: map['listings_count']?.toInt(),
      my_reviews_count: map['my_reviews_count']?.toInt(),
      my_listings_reviews_count: map['my_listings_reviews_count']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Statistics.fromJson(String source) => Statistics.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Statistics(listings_views: $listings_views, listings_count: $listings_count, my_reviews_count: $my_reviews_count, my_listings_reviews_count: $my_listings_reviews_count)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Statistics &&
      other.listings_views == listings_views &&
      other.listings_count == listings_count &&
      other.my_reviews_count == my_reviews_count &&
      other.my_listings_reviews_count == my_listings_reviews_count;
  }

  @override
  int get hashCode {
    return listings_views.hashCode ^
      listings_count.hashCode ^
      my_reviews_count.hashCode ^
      my_listings_reviews_count.hashCode;
  }
}
