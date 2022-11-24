import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:rakwa/model/listing.dart';
import 'package:rakwa/model/module.dart';
import 'package:rakwa/model/page.dart';

import 'listing/all_listing.dart';

class FilterModel {
  String? sort_by;
  String? keyword;
  String? module;
  String? category;
  String? lat;
  String? long;
  String? is_open;
  String? rate;
  String? page;
  FilterModel({
    this.sort_by,
    this.keyword,
    this.module,
    this.category,
    this.lat,
    this.long,
    this.is_open,
    this.rate,
    this.page,
  });

  FilterModel copyWith({
    String? sort_by,
    String? keyword,
    String? module,
    String? category,
    String? lat,
    String? long,
    String? is_open,
    String? rate,
    String? page,
  }) {
    return FilterModel(
      sort_by: sort_by ?? this.sort_by,
      keyword: keyword ?? this.keyword,
      module: module ?? this.module,
      category: category ?? this.category,
      lat: lat ?? this.lat,
      long: long ?? this.long,
      is_open: is_open ?? this.is_open,
      rate: rate ?? this.rate,
      page: page ?? this.page,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (sort_by != null) {
      result.addAll({'sort_by': sort_by});
    }
    if (keyword != null) {
      result.addAll({'keyword': keyword});
    }
    if (module != null) {
      result.addAll({'module': module});
    }
    if (category != null) {
      result.addAll({'category': category});
    }
    if (lat != null) {
      result.addAll({'lat': lat});
    }
    if (long != null) {
      result.addAll({'long': long});
    }
    if (is_open != null) {
      result.addAll({'is_open': is_open});
    }
    if (rate != null) {
      result.addAll({'rate': rate});
    }
    if (page != null) {
      result.addAll({'page': page});
    }

    return result;
  }

  factory FilterModel.fromMap(Map<String, dynamic> map) {
    return FilterModel(
      sort_by: map['sort_by'],
      keyword: map['keyword'],
      module: map['module'],
      category: map['category'],
      lat: map['lat'],
      long: map['long'],
      is_open: map['is_open'],
      rate: map['rate'],
      page: map['page'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FilterModel.fromJson(String source) =>
      FilterModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FilterModel(sort_by: $sort_by, keyword: $keyword, module: $module, category: $category, lat: $lat, long: $long, is_open: $is_open, rate: $rate, page: $page)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FilterModel &&
        other.sort_by == sort_by &&
        other.keyword == keyword &&
        other.module == module &&
        other.category == category &&
        other.lat == lat &&
        other.long == long &&
        other.is_open == is_open &&
        other.rate == rate &&
        other.page == page;
  }

  @override
  int get hashCode {
    return sort_by.hashCode ^
        keyword.hashCode ^
        module.hashCode ^
        category.hashCode ^
        lat.hashCode ^
        long.hashCode ^
        is_open.hashCode ^
        rate.hashCode ^
        page.hashCode;
  }
}

class FilterResponse {
  List<Module>? items;
  PagingListing paging;
  FilterResponse({
    this.items,
    required this.paging,
  });

  factory FilterResponse.fromMap(Map<String, dynamic> map) {
    return FilterResponse(
      items: map['items'] != null
          ? List<Module>.from(map['items']?.map((x) => Module.fromMap(x)))
          : null,
      paging: map['paging'] != null ? PagingListing.fromMap(map['paging']) : PagingListing(),
    );
  }

  factory FilterResponse.fromJson(String source) =>
      FilterResponse.fromMap(json.decode(source));

  @override
  String toString() => 'FilterResponse(items: $items)';

 

}
