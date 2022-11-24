import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:rakwa/model/listing.dart';

class AllListing {
  List<Listing> items;
  PagingListing paging;
  AllListing({
    required this.items,
    required this.paging,
  });

  AllListing copyWith({
    List<Listing>? items,
    PagingListing? paging,
  }) {
    return AllListing(
      items: items ?? this.items,
      paging: paging ?? this.paging,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'items': items.map((x) => x.toMap()).toList()});
    result.addAll({'paging': paging.toMap()});
  
    return result;
  }

  factory AllListing.fromMap(Map<String, dynamic> map) {
    return AllListing(
      items: List<Listing>.from(map['items']?.map((x) => Listing.fromMap(x))),
      paging: PagingListing.fromMap(map['paging']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AllListing.fromJson(String source) => AllListing.fromMap(json.decode(source));

  @override
  String toString() => 'AllListing(items: $items, paging: $paging)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AllListing &&
      listEquals(other.items, items) &&
      other.paging == paging;
  }

  @override
  int get hashCode => items.hashCode ^ paging.hashCode;
}

class PagingListing {
  int page;
  int pages;
  int total;
  PagingListing({
     this.page =0,
     this.pages=0,
     this.total=0,
  });

  PagingListing copyWith({
    int? page,
    int? pages,
    int? total,
  }) {
    return PagingListing(
      page: page ?? this.page,
      pages: pages ?? this.pages,
      total: total ?? this.total,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'page': page});
    result.addAll({'pages': pages});
    result.addAll({'total': total});
  
    return result;
  }

  factory PagingListing.fromMap(Map<String, dynamic> map) {
    return PagingListing(
      page: map['page']?.toInt() ?? 0,
      pages: map['pages']?.toInt() ?? 0,
      total: map['total']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory PagingListing.fromJson(String source) => PagingListing.fromMap(json.decode(source));

  @override
  String toString() => 'PagingListing(page: $page, pages: $pages, total: $total)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is PagingListing &&
      other.page == page &&
      other.pages == pages &&
      other.total == total;
  }

  @override
  int get hashCode => page.hashCode ^ pages.hashCode ^ total.hashCode;
}
