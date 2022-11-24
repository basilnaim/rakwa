import 'dart:convert';

import 'package:rakwa/utils/days.dart';

class Coupon {
  int id;
  int? listingId;
  String couponTitle;
  String couponCode;
  DateTime? couponStart;
  DateTime? couponEnd;
  String couponDescription;
  String couponStatus;
  double discountValue;
  Coupon({
    this.id = 0,
    this.listingId = 0,
    this.couponTitle = "",
    this.couponCode = "",
    this.couponStart,
    this.couponEnd,
    this.couponStatus = "",
    this.couponDescription = "",
    this.discountValue = 0,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'coupon_id': id});
    result.addAll({'listing_id': listingId});
    result.addAll({'coupon_status': couponStatus});
    result.addAll({'coupon_title': couponTitle});
    result.addAll({'coupon_code': couponCode});
    if (couponStart != null) {
      result.addAll({'coupon_start': formatDate.format(couponStart!)});
    }
    if (couponEnd != null) {
      result.addAll({'coupon_end': formatDate.format(couponEnd!)});
    }
    result.addAll({'coupon_description': couponDescription});
    result.addAll({'discount_value': discountValue});

    return result;
  }

  factory Coupon.fromMap(Map<String, dynamic> map) {
    return Coupon(
      id: map['id']?.toInt() ?? 0,
      listingId:
          map['listing_id'] != null ? int.parse(map['listing_id'] ?? 0) : 0,
      couponTitle: map['coupon_title'] ?? '',
      couponStatus: map['coupon_status'] ?? '',
      couponCode: map['coupon_code'] ?? '',
      couponStart: map.containsKey("coupon_start")
          ? formatDate.parse(map['coupon_start'])
          : null,
      couponEnd: map.containsKey("coupon_end")
          ? formatDate.parse(map['coupon_end'])
          : null,
      couponDescription: map['coupon_description'] ?? '',
      discountValue: map['discount_value'] != null ? double.parse(map['discount_value'] ?? 0.0): 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Coupon.fromJson(String source) => Coupon.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Coupon(id: $id, listing_id: $listingId, coupon_title: $couponTitle, coupon_code: $couponCode, discount_start: $couponStart, coupon_end: $couponEnd, coupon_description: $couponDescription, discount_value: $discountValue)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Coupon &&
        other.id == id &&
        other.listingId == listingId &&
        other.couponTitle == couponTitle &&
        other.couponCode == couponCode &&
        other.couponStart == couponStart &&
        other.couponEnd == couponEnd &&
        other.couponDescription == couponDescription &&
        other.discountValue == discountValue;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        listingId.hashCode ^
        couponTitle.hashCode ^
        couponCode.hashCode ^
        couponStart.hashCode ^
        couponEnd.hashCode ^
        couponDescription.hashCode ^
        discountValue.hashCode;
  }
}
