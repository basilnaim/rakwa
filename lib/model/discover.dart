import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:rakwa/model/page.dart';

class Discover {
  int id;
  int? accountId;
  String? title;
  String? contactname;
  String? address;
  String? phone; 
  String? summarydesc;
  String? longitude;
  String? latitude;
  String? detaildesc;
  String? image;
  CreatedAt? createdAt;
  Discover({
    required this.id,
    this.accountId,
    this.title,
    this.contactname,
    this.address,
    this.phone,
    this.summarydesc,
    this.longitude,
    this.latitude,
    this.detaildesc,
    this.image,
    this.createdAt,
  });


  Discover copyWith({
    int? id,
    int? accountId,
    String? title,
    String? contactname,
    String? address,
    String? phone,
    String? summarydesc,
    String? longitude,
    String? latitude,
    String? detaildesc,
    String? image,
    CreatedAt? createdAt,
  }) {
    return Discover(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      title: title ?? this.title,
      contactname: contactname ?? this.contactname,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      summarydesc: summarydesc ?? this.summarydesc,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      detaildesc: detaildesc ?? this.detaildesc,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    if(accountId != null){
      result.addAll({'accountId': accountId});
    }
    if(title != null){
      result.addAll({'title': title});
    }
    if(contactname != null){
      result.addAll({'contactname': contactname});
    }
    if(address != null){
      result.addAll({'address': address});
    }
    if(phone != null){
      result.addAll({'phone': phone});
    }
    if(summarydesc != null){
      result.addAll({'summarydesc': summarydesc});
    }
    if(longitude != null){
      result.addAll({'longitude': longitude});
    }
    if(latitude != null){
      result.addAll({'latitude': latitude});
    }
    if(detaildesc != null){
      result.addAll({'detaildesc': detaildesc});
    }
    if(image != null){
      result.addAll({'image': image});
    }
    if(createdAt != null){
      result.addAll({'createdAt': createdAt!.toMap()});
    }
  
    return result;
  }

  factory Discover.fromMap(Map<String, dynamic> map) {
    return Discover(
      id: map['id']?.toInt() ?? 0,
      accountId: map['accountId']?.toInt(),
      title: map['title'],
      contactname: map['contactname'],
      address: map['address'],
      phone: map['phone'],
      summarydesc: map['summarydesc'],
      longitude: map['longitude'],
      latitude: map['latitude'],
      detaildesc: map['detaildesc'],
      image: map['image'],
      createdAt: map['createdAt'] != null ? CreatedAt.fromMap(map['createdAt']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Discover.fromJson(String source) => Discover.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Discover(id: $id, accountId: $accountId, title: $title, contactname: $contactname, address: $address, phone: $phone, summarydesc: $summarydesc, longitude: $longitude, latitude: $latitude, detaildesc: $detaildesc, image: $image, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Discover &&
      other.id == id &&
      other.accountId == accountId &&
      other.title == title &&
      other.contactname == contactname &&
      other.address == address &&
      other.phone == phone &&
      other.summarydesc == summarydesc &&
      other.longitude == longitude &&
      other.latitude == latitude &&
      other.detaildesc == detaildesc &&
      other.image == image &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      accountId.hashCode ^
      title.hashCode ^
      contactname.hashCode ^
      address.hashCode ^
      phone.hashCode ^
      summarydesc.hashCode ^
      longitude.hashCode ^
      latitude.hashCode ^
      detaildesc.hashCode ^
      image.hashCode ^
      createdAt.hashCode;
  }
}

class CreatedAt {
  String? date;
  int? timezone_type;
  String? timezone;
  CreatedAt({
    this.date,
    this.timezone_type,
    this.timezone,
  });

  CreatedAt copyWith({
    String? date,
    int? timezone_type,
    String? timezone,
  }) {
    return CreatedAt(
      date: date ?? this.date,
      timezone_type: timezone_type ?? this.timezone_type,
      timezone: timezone ?? this.timezone,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(date != null){
      result.addAll({'date': date});
    }
    if(timezone_type != null){
      result.addAll({'timezone_type': timezone_type});
    }
    if(timezone != null){
      result.addAll({'timezone': timezone});
    }
  
    return result;
  }

  factory CreatedAt.fromMap(Map<String, dynamic> map) {
    return CreatedAt(
      date: map['date'],
      timezone_type: map['timezone_type']?.toInt(),
      timezone: map['timezone'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CreatedAt.fromJson(String source) => CreatedAt.fromMap(json.decode(source));

  @override
  String toString() => 'CreatedAt(date: $date, timezone_type: $timezone_type, timezone: $timezone)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CreatedAt &&
      other.date == date &&
      other.timezone_type == timezone_type &&
      other.timezone == timezone;
  }

  @override
  int get hashCode => date.hashCode ^ timezone_type.hashCode ^ timezone.hashCode;
}

class DiscoverBody {
  List<Discover>? items;
  Page? paging;
  DiscoverBody({
    this.items,
    this.paging,
  });

  DiscoverBody copyWith({
    List<Discover>? items,
    Page? paging,
  }) {
    return DiscoverBody(
      items: items ?? this.items,
      paging: paging ?? this.paging,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(items != null){
      result.addAll({'items': items!.map((x) => x.toMap()).toList()});
    }
    if(paging != null){
      result.addAll({'paging': paging!.toMap()});
    }
  
    return result;
  }

  factory DiscoverBody.fromMap(Map<String, dynamic> map) {
    return DiscoverBody(
      items: map['items'] != null ? List<Discover>.from(map['items']?.map((x) => Discover.fromMap(x))) : null,
      paging: map['paging'] != null ? Page.fromMap(map['paging']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DiscoverBody.fromJson(String source) => DiscoverBody.fromMap(json.decode(source));

  @override
  String toString() => 'DiscoverBody(items: $items, paging: $paging)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is DiscoverBody &&
      listEquals(other.items, items) &&
      other.paging == paging;
  }

  @override
  int get hashCode => items.hashCode ^ paging.hashCode;
}
