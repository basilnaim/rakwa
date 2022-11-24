import 'dart:convert';

class Page {
  int? page;
  int? pages;
  int? total;
  Page({
    this.page,
    this.pages,
    this.total,
  });

  Page copyWith({
    int? page,
    int? pages,
    int? total,
  }) {
    return Page(
      page: page ?? this.page,
      pages: pages ?? this.pages,
      total: total ?? this.total,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(page != null){
      result.addAll({'page': page});
    }
    if(pages != null){
      result.addAll({'pages': pages});
    }
    if(total != null){
      result.addAll({'total': total});
    }
  
    return result;
  }

  factory Page.fromMap(Map<String, dynamic> map) {
    return Page(
      page: map['page']?.toInt(),
      pages: map['pages']?.toInt(),
      total: map['total']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Page.fromJson(String source) => Page.fromMap(json.decode(source));

  @override
  String toString() => 'Page(page: $page, pages: $pages, total: $total)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Page &&
      other.page == page &&
      other.pages == pages &&
      other.total == total;
  }

  @override
  int get hashCode => page.hashCode ^ pages.hashCode ^ total.hashCode;
}
