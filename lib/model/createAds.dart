import 'dart:convert';

import 'package:rakwa/model/event.dart';
import 'package:rakwa/utils/days.dart';

class AdCampaigns {
  int id;
  String title;
  String status;
  String image;
  AdsType type;
  int listingId;
  DateTime? startDate;
  DateTime? endDate;
  int days;
  int level;
  AdCampaigns(
      {this.id = 0,
      this.status = "",
      this.image = "",
      this.title = "",
      this.endDate,
      this.startDate,
      this.listingId = 0,
      this.days = 0,
      this.level = 0,
      this.type = AdsType.banner});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'title': title});
    result.addAll({'level': level});
    result.addAll({'days': days});
    result.addAll({'listing_id': listingId});
    result.addAll({"type": type.adValue()});

    return result;
  }

  factory AdCampaigns.fromMap(Map<String, dynamic> map) {
    DateTime? start = (!map.containsKey('start_date'))
        ? null
        : formatDate
            .parse(EventDate.fromMap(map['start_date']).date.split(' ')[0]);

    DateTime? end = (!map.containsKey('end_date'))
        ? null
        : formatDate
            .parse(EventDate.fromMap(map['end_date']).date.split(' ')[0]);

    int days = 0;

    print("staaaart"+start.toString());
    print("ennnnnnd"+end.toString());
    if(start != null && end != null){
      days = end.difference(start).inDays;
    }
    print("days"+end.toString());

    return AdCampaigns(
      image: map['image'],
      title: map['title'],
      startDate: start,
      endDate: end,
      listingId: map['listing_id'],
      status: map['status'],
      id: map['id'],
      days: days
    );
  }

  String toJson() => json.encode(toMap());

  factory AdCampaigns.fromJson(String source) =>
      AdCampaigns.fromMap(json.decode(source));

  @override
  String toString() => 'Ads(des, image: $title)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AdCampaigns && other.title == title;
  }
}

enum AdsType { banner, adsCompaigns }

extension AdsTypeExt on AdsType {
  String adName() {
    switch (this) {
      case AdsType.banner:
        return "Banner";
      case AdsType.adsCompaigns:
        return "Ad Compaigns";
    }
  }

  int adValue() {
    switch (this) {
      case AdsType.banner:
        return 1;
      case AdsType.adsCompaigns:
        return 2;
    }
  }

  AdsType adFromValue(int value) {
    switch (value) {
      case 0:
        return AdsType.banner;
      case 1:
        return AdsType.adsCompaigns;
      default:
        return AdsType.banner;
    }
  }
}
