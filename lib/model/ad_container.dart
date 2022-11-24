import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:rakwa/model/createAds.dart';

class AdContainer {
  List<AdCampaigns> Ads;
  List<AdCampaigns> Banner;
  AdContainer({
    required this.Ads,
    required this.Banner,
  });

  AdContainer copyWith({
    List<AdCampaigns>? Ads,
    List<AdCampaigns>? Banner,
  }) {
    return AdContainer(
      Ads: Ads ?? this.Ads,
      Banner: Banner ?? this.Banner,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'Ads': Ads.map((x) => x.toMap()).toList()});
    result.addAll({'Banner': Banner.map((x) => x.toMap()).toList()});

    return result;
  }

  factory AdContainer.fromMap(Map<String, dynamic> map) {
    return AdContainer(
      Ads: (map.containsKey('Ads'))
          ? List<AdCampaigns>.from(
              map['Ads']?.map((x) => AdCampaigns.fromMap(x)))
          : [],
      Banner: (map.containsKey('Banner'))
          ? List<AdCampaigns>.from(
              map['Banner']?.map((x) => AdCampaigns.fromMap(x)))
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory AdContainer.fromJson(String source) =>
      AdContainer.fromMap(json.decode(source));

  @override
  String toString() => 'AdContainer(Ads: $Ads, Banner: $Banner)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AdContainer &&
        listEquals(other.Ads, Ads) &&
        listEquals(other.Banner, Banner);
  }

  @override
  int get hashCode => Ads.hashCode ^ Banner.hashCode;
}
