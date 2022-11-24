import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:rakwa/model/classified.dart';
import 'package:rakwa/model/discover.dart';
import 'package:rakwa/model/event.dart';
import 'package:rakwa/model/listing.dart';
import 'ads.dart';
import 'categorie.dart';
import 'home_user.dart';

class Home {
  HomeUser? user;
  List<Listing>? latest_listings;
  List<Classified>? latest_classifieds;
  List<Event>? latest_events;
  List<CategorieModel>? top_categories;
  List<Ads>? ads;
  AdsCompaignsHome? ads_campaigns;

  Home(
      {this.latest_listings,
      this.latest_classifieds,
      this.latest_events,
      this.top_categories,
      this.ads,
      this.user,
      this.ads_campaigns});

  Home copyWith({
    List<Listing>? latest_listings,
    List<Classified>? latest_classifieds,
    List<Event>? latest_events,
    List<CategorieModel>? top_categories,
    List<Ads>? ads,
  }) {
    return Home(
      latest_listings: latest_listings ?? this.latest_listings,
      latest_classifieds: latest_classifieds ?? this.latest_classifieds,
      latest_events: latest_events ?? this.latest_events,
      top_categories: top_categories ?? this.top_categories,
      ads: ads ?? this.ads,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (latest_listings != null) {
      result.addAll(
          {'latest_listings': latest_listings!.map((x) => x.toMap()).toList()});
    }
    if (latest_classifieds != null) {
      result.addAll({
        'latest_classifieds': latest_classifieds!.map((x) => x.toMap()).toList()
      });
    }
    if (latest_events != null) {
      result.addAll(
          {'latest_events': latest_events!.map((x) => x.toMap()).toList()});
    }
    if (top_categories != null) {
      result.addAll(
          {'top_categories': top_categories!.map((x) => x.toMap()).toList()});
    }
    if (ads != null) {
      result.addAll({'ads': ads!.map((x) => x.toMap()).toList()});
    }

    return result;
  }

  factory Home.fromMap(Map<String, dynamic> map) {
    return Home(
      user: (map.containsKey('user') && map['user'] != null)
          ? HomeUser.fromMap(map['user'])
          : null,
      latest_listings: map['latest_listings'] != null
          ? List<Listing>.from(
              map['latest_listings']?.map((x) => Listing.fromMap(x)))
          : null,
      latest_classifieds: map['latest_classifieds'] != null
          ? List<Classified>.from(
              map['latest_classifieds']?.map((x) => Classified.fromMap(x)))
          : null,
      latest_events: map['latest_events'] != null
          ? List<Event>.from(map['latest_events']?.map((x) => Event.fromMap(x)))
          : null,
      top_categories: map['top_categories'] != null
          ? List<CategorieModel>.from(
              map['top_categories']?.map((x) => CategorieModel.fromMap(x)))
          : null,
      ads: map['ads'] != null
          ? List<Ads>.from(map['ads']?.map((x) => Ads.fromMap(x)))
          : null,
      ads_campaigns:
          (map.containsKey('ads_campaigns') && map['ads_campaigns'] != null)
              ? AdsCompaignsHome.fromMap(map['ads_campaigns'])
              : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Home.fromJson(String source) => Home.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Home(latest_listings: $latest_listings, latest_classifieds: $latest_classifieds, latest_events: $latest_events, top_categories: $top_categories, ads: $ads)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Home &&
        listEquals(other.latest_listings, latest_listings) &&
        listEquals(other.latest_classifieds, latest_classifieds) &&
        listEquals(other.latest_events, latest_events) &&
        listEquals(other.top_categories, top_categories) &&
        listEquals(other.ads, ads);
  }

  @override
  int get hashCode {
    return latest_listings.hashCode ^
        latest_classifieds.hashCode ^
        latest_events.hashCode ^
        top_categories.hashCode ^
        ads.hashCode;
  }
}

class HomeFields {
  String? level_id;
  String lat;
  String long;
  HomeFields({
    this.level_id,
    required this.lat,
    required this.long,
  });

  HomeFields copyWith({
    String? level_id,
    String? lat,
    String? long,
  }) {
    return HomeFields(
      level_id: level_id ?? this.level_id,
      lat: lat ?? this.lat,
      long: long ?? this.long,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'level_id': level_id});
    result.addAll({'lat': lat});
    result.addAll({'long': long});

    return result;
  }

  factory HomeFields.fromMap(Map<String, dynamic> map) {
    return HomeFields(
      level_id: map['level_id']?.toInt() ?? 0,
      lat: map['lat'] ?? '',
      long: map['long'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory HomeFields.fromJson(String source) =>
      HomeFields.fromMap(json.decode(source));

  @override
  String toString() =>
      'HomeFields(level_id: $level_id, lat: $lat, long: $long)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HomeFields &&
        other.level_id == level_id &&
        other.lat == lat &&
        other.long == long;
  }

  @override
  int get hashCode => level_id.hashCode ^ lat.hashCode ^ long.hashCode;
}

class AdsCompaignsHome {
  List<BannerHomeModel>? Banner;
  List<BannerHomeModel>? ads;
  AdsCompaignsHome({
    this.Banner,
    this.ads,
  });

  AdsCompaignsHome copyWith({
    List<BannerHomeModel>? Banner,
    List<BannerHomeModel>? ads,
  }) {
    return AdsCompaignsHome(
      Banner: Banner ?? this.Banner,
      ads: ads ?? this.ads,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (Banner != null) {
      result.addAll({'Banner': Banner!.map((x) => x.toMap()).toList()});
    }
    if (ads != null) {
      result.addAll({'Ads': ads!.map((x) => x.toMap()).toList()});
    }

    return result;
  }

  factory AdsCompaignsHome.fromMap(Map<String, dynamic> map) {
    return AdsCompaignsHome(
      Banner: map['Banner'] != null
          ? List<BannerHomeModel>.from(
              map['Banner']?.map((x) => BannerHomeModel.fromMap(x)))
          : null,
      ads: map['Ads'] != null
          ? List<BannerHomeModel>.from(
              map['Ads']?.map((x) => BannerHomeModel.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AdsCompaignsHome.fromJson(String source) =>
      AdsCompaignsHome.fromMap(json.decode(source));

  @override
  String toString() => 'AdsCompaignsHome(Banner: $Banner, ads: $ads)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AdsCompaignsHome &&
        listEquals(other.Banner, Banner) &&
        listEquals(other.ads, ads);
  }

  @override
  int get hashCode => Banner.hashCode ^ ads.hashCode;
}

class BannerHomeModel {
  int? id;
  String? title;
  int? listing_id;
  String? status;
  CreatedAt? start_date;
  CreatedAt? end_date;
  int? level_id;
  String? image;
  BannerHomeModel({
    this.id,
    this.title,
    this.listing_id,
    this.status,
    this.start_date,
    this.end_date,
    this.level_id,
    this.image,
  });

  BannerHomeModel copyWith({
    int? id,
    String? title,
    int? listing_id,
    String? status,
    CreatedAt? start_date,
    CreatedAt? end_date,
    int? level_id,
    String? image,
  }) {
    return BannerHomeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      listing_id: listing_id ?? this.listing_id,
      status: status ?? this.status,
      start_date: start_date ?? this.start_date,
      end_date: end_date ?? this.end_date,
      level_id: level_id ?? this.level_id,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    if (title != null) {
      result.addAll({'title': title});
    }
    if (listing_id != null) {
      result.addAll({'listing_id': listing_id});
    }
    if (status != null) {
      result.addAll({'status': status});
    }
    if (start_date != null) {
      result.addAll({'start_date': start_date!.toMap()});
    }
    if (end_date != null) {
      result.addAll({'end_date': end_date!.toMap()});
    }
    if (level_id != null) {
      result.addAll({'level_id': level_id});
    }
    if (image != null) {
      result.addAll({'image': image});
    }

    return result;
  }

  factory BannerHomeModel.fromMap(Map<String, dynamic> map) {
    return BannerHomeModel(
      id: map['id']?.toInt(),
      title: map['title'],
      listing_id: map['listing_id']?.toInt(),
      status: map['status'],
      start_date: map['start_date'] != null
          ? CreatedAt.fromMap(map['start_date'])
          : null,
      end_date:
          map['end_date'] != null ? CreatedAt.fromMap(map['end_date']) : null,
      level_id: map['level_id']?.toInt(),
      image: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BannerHomeModel.fromJson(String source) =>
      BannerHomeModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BannerHome(id: $id, title: $title, listing_id: $listing_id, status: $status, start_date: $start_date, end_date: $end_date, level_id: $level_id, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BannerHomeModel &&
        other.id == id &&
        other.title == title &&
        other.listing_id == listing_id &&
        other.status == status &&
        other.start_date == start_date &&
        other.end_date == end_date &&
        other.level_id == level_id &&
        other.image == image;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        listing_id.hashCode ^
        status.hashCode ^
        start_date.hashCode ^
        end_date.hashCode ^
        level_id.hashCode ^
        image.hashCode;
  }
}
