import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:rakwa/model/announcement.dart';
import 'package:rakwa/model/coupon.dart';

import 'package:rakwa/model/hours_work.dart';
import 'package:rakwa/model/listing/event_date_time.dart';
import 'package:rakwa/model/listing/listing_city.dart';
import 'package:rakwa/model/listing/listing_dynamic_field.dart';
import 'package:rakwa/model/listing/listing_event.dart';
import 'package:rakwa/model/listing/listing_features.dart';
import 'package:rakwa/model/listing/listing_social_links.dart';
import 'package:rakwa/model/listing/listing_state.dart';
import 'package:rakwa/model/video.dart';
import 'package:rakwa/utils/days.dart';

import 'houre_work_create.dart';

class Listing {
  int id;
  int accountId;
  String title;
  Category? category;
  String image;
  late String imageCover;
  String address;
  int templateId;
  String phone;
  String description;
  late String shortDescription;
  late String longDescription;
  late String friendlyUrl;
  late int views;
  List<String>? gallery;
  late int isWorkingNow;
  late String listingUrl;
  late Video? video;
  late ListingCity? city;
  late ListingState? state;
  late int iReviewIt;
  List<ListingFeatures>? features;
  List<Announcement>? announcements;
  List<Coupon>? coupon;
  ListingSocialLinks? socialLinks;
  List<ListingEvent>? event;
  String specialities;
  late String specialties;
  List<DynamicFields>? dynamicFields;
  String buildingBridge;
  String policies;
  String establishedIn;
  String ownerName;
  String ownerEmail;
  String introduction;
  String overview;
  int rating;
  String status;
  String latitude;
  String longitude;
  int isFavorite;
  Map<int, HoursWork>? hoursWork;
  EventDateTime? start_date;
  EventDateTime? end_date;
  String? associated_plan;

  Listing(
      {this.id = 0,
      this.accountId = 0,
      this.title = "",
      this.category,
      this.image = "",
      this.imageCover = "",
      this.address = "",
      this.templateId = 0,
      this.phone = "",
      this.description = "",
      this.shortDescription = "",
      this.longDescription = "",
      this.friendlyUrl = "",
      this.views = 0,
      this.gallery,
      this.isWorkingNow = 0,
      this.listingUrl = "",
      this.video,
      this.city,
      this.state,
      this.iReviewIt = 0,
      this.features,
      this.announcements,
      this.coupon,
      this.socialLinks,
      this.event,
      this.specialities = "",
      this.specialties = "",
      this.dynamicFields,
      this.buildingBridge = "",
      this.policies = "",
      this.establishedIn = "",
      this.ownerName = "",
      this.ownerEmail = "",
      this.introduction = "",
      this.overview = "",
      this.rating = 0,
      this.status = "",
      this.latitude = "",
      this.longitude = "",
      this.isFavorite = 0,
      this.hoursWork = const {},
      this.start_date,
      this.end_date,
      this.associated_plan});

  Listing.withHomeWork({
    this.id = 0,
    this.accountId = 0,
    this.title = "",
    this.category,
    this.ownerEmail = "",
    this.ownerName = "",
    this.image = "",
    this.specialities = "",
    this.buildingBridge = "",
    this.policies = "",
    this.establishedIn = "",
    this.introduction = "",
    this.overview = "",
    this.address = "",
    this.phone = "",
    this.description = "",
    this.templateId = 1,
    this.rating = 0,
    this.status = "",
    this.latitude = "",
    this.longitude = "",
    this.isFavorite = 0,
  }) {
    hoursWork = {
      0: HoursWork.defaultTime(selected: false),
      1: HoursWork.defaultTime(selected: true),
      2: HoursWork.defaultTime(selected: true),
      3: HoursWork.defaultTime(selected: true),
      4: HoursWork.defaultTime(selected: true),
      5: HoursWork.defaultTime(selected: true),
      6: HoursWork.defaultTime(selected: false),
    };
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'accountId': accountId});
    result.addAll({'title': title});
    if (category != null) {
      result.addAll({'category': category!.toMap()});
    }
    result.addAll({'image': image});
    result.addAll({'imageCover': imageCover});
    result.addAll({'address': address});
    result.addAll({'templateId': templateId});
    result.addAll({'phone': phone});
    result.addAll({'description': description});
    result.addAll({'shortDescription': shortDescription});
    result.addAll({'longDescription': longDescription});
    result.addAll({'friendlyUrl': friendlyUrl});
    result.addAll({'views': views});
    if (gallery != null) {
      result.addAll({'gallery': gallery});
    }
    result.addAll({'isWorkingNow': isWorkingNow});
    result.addAll({'listingUrl': listingUrl});
    result.addAll({'video': video});
    result.addAll({'iReviewIt': iReviewIt});
    if (features != null) {
      result.addAll({'features': features!.map((x) => x.toMap()).toList()});
    }
    if (announcements != null) {
      result.addAll(
          {'announcements': announcements!.map((x) => x.toMap()).toList()});
    }
    if (coupon != null) {
      result.addAll({'coupon': coupon!.map((x) => x.toMap()).toList()});
    }
    if (socialLinks != null) {
      result.addAll({'social_links': socialLinks!.toMap()});
    }

    if (event != null) {
      result.addAll({'event': event!.map((x) => x.toMap()).toList()});
    }
    result.addAll({'specialities': specialities});
    result.addAll({'specialties': specialties});
    if (dynamicFields != null) {
      result.addAll(
          {'dynamicFields': dynamicFields!.map((x) => x.toMap()).toList()});
    }
    result.addAll({'buildingBridge': buildingBridge});
    result.addAll({'policies': policies});
    result.addAll({'establishedIn': establishedIn});
    result.addAll({'ownerName': ownerName});
    result.addAll({'ownerEmail': ownerEmail});
    result.addAll({'introduction': introduction});
    result.addAll({'overview': overview});
    result.addAll({'rating': rating});
    result.addAll({'status': status});
    result.addAll({'latitude': latitude});
    result.addAll({'longitude': longitude});
    result.addAll({'isFavorite': isFavorite});
    if (hoursWork != null) {
      List<HoureWorkCreate> houreWork = [];
      hoursWork!.forEach((key, value) {
        houreWork.add(HoureWorkCreate(
            weekday: key.toString(),
            hours_end: value.start,
            hours_start: value.end));
      });
      result.addAll({"hours_work": houreWork.map((x) => x.toMap()).toList()});
    }
    if (start_date != null) {
      result.addAll({'start_date': start_date!.toMap()});
    }
    if (end_date != null) {
      result.addAll({'end_date': end_date!.toMap()});
    }
    result.addAll({'associated_plan': image});

    return result;
  }

  factory Listing.fromMap(Map<String, dynamic> map) {
    Map<int, HoursWork> hours = map.containsKey("hours_work")
        ? map["hours_work"].toString() != "[]"
            ? Map<int, HoursWork>.from(map['hours_work'].map(
                (k, v) => MapEntry(dayNames.indexOf(k), HoursWork.fromMap(v))))
            : {}
        : {};

    if (hours.isEmpty) {
      hours = {
        0: HoursWork.defaultTime(selected: false),
        1: HoursWork.defaultTime(selected: false),
        2: HoursWork.defaultTime(selected: false),
        3: HoursWork.defaultTime(selected: false),
        4: HoursWork.defaultTime(selected: false),
        5: HoursWork.defaultTime(selected: false),
        6: HoursWork.defaultTime(selected: false),
      };
    }


    return Listing(
      id: map['id'] != null ? map['id']?.toInt() : map['listing_id'],
      accountId: map['account_id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      category:
          (map['category'] != null ) ? Category.fromMap(map['category']): null,
      image: map['image'] ?? '',
      imageCover: map['image_cover'] ?? '',
      address: map['address'] ?? '',
      templateId: map['template_id']?.toInt() ?? 0,
      phone: map['phone'] ?? '',
      description: map['description'] ?? '',
      shortDescription: map['short_description'] ?? '',
      longDescription: map['long_description'] ?? '',
      friendlyUrl: map['friendly_url'] ?? '',
      views: map['views']?.toInt() ?? 0,
      gallery:
          map['gallery'] != null ? List<String>.from(map['gallery']) : null,
      isWorkingNow: map['isWorkingNow']?.toInt() ?? 0,
      listingUrl: map['listing_url'] ?? '',
      video: map['video'] != null ? Video.fromMap(map['video']) : null,
      city: map['city'] != null ? ListingCity.fromMap(map['city']) : null,
      state: map['state'] != null ? ListingState.fromMap(map['state']) : null,
      iReviewIt: map['i_review_it']?.toInt() ?? 0,
      features: map['features'] != null
          ? List<ListingFeatures>.from(
              map['features']?.map((x) => ListingFeatures.fromMap(x)))
          : null,
      announcements: map['announcements'] != null
          ? List<Announcement>.from(
              map['announcements']?.map((x) => Announcement.fromMap(x)))
          : null,
      coupon: map['coupon'] != null
          ? List<Coupon>.from(map['coupon']?.map((x) => Coupon.fromMap(x)))
          : null,
      socialLinks: map['social_links'] != null
          ? ListingSocialLinks.fromMap(map['social_links'])
          : null,
      event: map['event'] != null
          ? List<ListingEvent>.from(
              map['event']?.map((x) => ListingEvent.fromMap(x)))
          : null,
      specialities: map['specialities'] ?? '',
      specialties: map['specialties'] ?? '',
      dynamicFields: map['dynamicFields'] != null
          ? List<DynamicFields>.from(
              map['dynamicFields']?.map((x) => DynamicFields.fromMap(x)))
          : null,
      buildingBridge: map['building_bridges'] ?? '',
      policies: map['policies'] ?? '',
      establishedIn: map['established_in'] ?? '',
      ownerName: map['business_owner_name'] ?? '',
      ownerEmail: map['business_owner_email'] ?? '',
      introduction: map['introduction'] ?? '',
      overview: map['overview'] ?? '',
      rating: map['rating']?.toInt() ?? 0,
      status: map['status'].toString(),
      latitude: map['latitude'] ?? '',
      longitude: map['longitude'] ?? '',
      isFavorite: map['isFavorite']?.toInt() ?? 0,
      hoursWork: hours,
      start_date: map['start_date'] != null
          ? EventDateTime.fromMap(map['start_date'])
          : null,
      end_date: map['end_date'] != null
          ? EventDateTime.fromMap(map['end_date'])
          : null,
      associated_plan:
          map['associated_plan'] != null ? map['associated_plan'] ?? '' : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Listing.fromJson(String source) =>
      Listing.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Listing(id: $id, accountId: $accountId, title: $title, category: $category, image: $image, imageCover: $imageCover, address: $address, templateId: $templateId, phone: $phone, description: $description, shortDescription: $shortDescription, longDescription: $longDescription, friendlyUrl: $friendlyUrl, views: $views, gallery: $gallery, isWorkingNow: $isWorkingNow, listingUrl: $listingUrl, video: $video, iReviewIt: $iReviewIt, features: $features, announcements: $announcements, coupon: $coupon, event: $event, specialities: $specialities, specialties: $specialties, dynamicFields: $dynamicFields, buildingBridge: $buildingBridge, policies: $policies, establishedIn: $establishedIn, ownerName: $ownerName, ownerEmail: $ownerEmail, introduction: $introduction, overview: $overview, rating: $rating, status: $status, latitude: $latitude, longitude: $longitude, isFavorite: $isFavorite, hoursWork: $hoursWork)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Listing &&
        other.id == id &&
        other.accountId == accountId &&
        other.title == title &&
        other.category == category &&
        other.image == image &&
        other.imageCover == imageCover &&
        other.address == address &&
        other.templateId == templateId &&
        other.phone == phone &&
        other.description == description &&
        other.shortDescription == shortDescription &&
        other.longDescription == longDescription &&
        other.friendlyUrl == friendlyUrl &&
        other.views == views &&
        listEquals(other.gallery, gallery) &&
        other.isWorkingNow == isWorkingNow &&
        other.listingUrl == listingUrl &&
        other.video == video &&
        other.iReviewIt == iReviewIt &&
        listEquals(other.features, features) &&
        listEquals(other.announcements, announcements) &&
        listEquals(other.coupon, coupon) &&
        listEquals(other.event, event) &&
        other.specialities == specialities &&
        other.specialties == specialties &&
        listEquals(other.dynamicFields, dynamicFields) &&
        other.buildingBridge == buildingBridge &&
        other.policies == policies &&
        other.establishedIn == establishedIn &&
        other.ownerName == ownerName &&
        other.ownerEmail == ownerEmail &&
        other.introduction == introduction &&
        other.overview == overview &&
        other.rating == rating &&
        other.status == status &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.isFavorite == isFavorite &&
        mapEquals(other.hoursWork, hoursWork);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        accountId.hashCode ^
        title.hashCode ^
        category.hashCode ^
        image.hashCode ^
        imageCover.hashCode ^
        address.hashCode ^
        templateId.hashCode ^
        phone.hashCode ^
        description.hashCode ^
        shortDescription.hashCode ^
        longDescription.hashCode ^
        friendlyUrl.hashCode ^
        views.hashCode ^
        gallery.hashCode ^
        isWorkingNow.hashCode ^
        listingUrl.hashCode ^
        video.hashCode ^
        iReviewIt.hashCode ^
        features.hashCode ^
        announcements.hashCode ^
        coupon.hashCode ^
        event.hashCode ^
        specialities.hashCode ^
        specialties.hashCode ^
        dynamicFields.hashCode ^
        buildingBridge.hashCode ^
        policies.hashCode ^
        establishedIn.hashCode ^
        ownerName.hashCode ^
        ownerEmail.hashCode ^
        introduction.hashCode ^
        overview.hashCode ^
        rating.hashCode ^
        status.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        isFavorite.hashCode ^
        hoursWork.hashCode;
  }

  Listing copyWith({
    int? id,
    int? accountId,
    String? title,
    Category? category,
    String? image,
    String? imageCover,
    String? address,
    int? templateId,
    String? phone,
    String? description,
    String? shortDescription,
    String? longDescription,
    String? friendlyUrl,
    int? views,
    List<String>? gallery,
    int? isWorkingNow,
    String? listingUrl,
    Video? video,
    int? iReviewIt,
    List<ListingFeatures>? features,
    List<Announcement>? announcements,
    List<Coupon>? coupon,
    List<ListingEvent>? event,
    String? specialities,
    String? specialties,
    List<DynamicFields>? dynamicFields,
    String? buildingBridge,
    String? policies,
    String? establishedIn,
    String? ownerName,
    String? ownerEmail,
    String? introduction,
    String? overview,
    int? rating,
    String? status,
    String? latitude,
    String? longitude,
    int? isFavorite,
    Map<int, HoursWork>? hoursWork,
  }) {
    return Listing(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      title: title ?? this.title,
      category: category ?? this.category,
      image: image ?? this.image,
      imageCover: imageCover ?? this.imageCover,
      address: address ?? this.address,
      templateId: templateId ?? this.templateId,
      phone: phone ?? this.phone,
      description: description ?? this.description,
      shortDescription: shortDescription ?? this.shortDescription,
      longDescription: longDescription ?? this.longDescription,
      friendlyUrl: friendlyUrl ?? this.friendlyUrl,
      views: views ?? this.views,
      gallery: gallery ?? this.gallery,
      isWorkingNow: isWorkingNow ?? this.isWorkingNow,
      listingUrl: listingUrl ?? this.listingUrl,
      video: video ?? this.video,
      iReviewIt: iReviewIt ?? this.iReviewIt,
      features: features ?? this.features,
      announcements: announcements ?? this.announcements,
      coupon: coupon ?? this.coupon,
      event: event ?? this.event,
      specialities: specialities ?? this.specialities,
      specialties: specialties ?? this.specialties,
      dynamicFields: dynamicFields ?? this.dynamicFields,
      buildingBridge: buildingBridge ?? this.buildingBridge,
      policies: policies ?? this.policies,
      establishedIn: establishedIn ?? this.establishedIn,
      ownerName: ownerName ?? this.ownerName,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      introduction: introduction ?? this.introduction,
      overview: overview ?? this.overview,
      rating: rating ?? this.rating,
      status: status ?? this.status,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isFavorite: isFavorite ?? this.isFavorite,
      hoursWork: hoursWork ?? this.hoursWork,
    );
  }
}

class Category {
  int id;
  String title;

//<editor-fold desc="Data Methods">

  Category({
    this.id = 0,
    this.title = "",
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title);

  @override
  int get hashCode => id.hashCode ^ title.hashCode;

  @override
  String toString() {
    return 'Category{id: $id, title: $title}';
  }

  CategoryopyWith({
    int? id,
    String? title,
  }) {
    return Category(
      id: id ?? this.id,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as int,
      title: map['title'] as String,
    );
  }

//</editor-fold>
}
