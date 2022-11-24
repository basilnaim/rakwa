import 'dart:convert';

import 'package:rakwa/model/city.dart';
import 'package:rakwa/model/classified.dart';
import 'package:rakwa/model/event.dart';
import 'package:rakwa/model/listing.dart';
import 'package:rakwa/model/listing/listing_city.dart';
import 'package:rakwa/utils/days.dart';
import 'hours_work.dart';

class Module {
  int listingId;
  String title;
  String phone;
  Category? category;
  String image;
  City? city;
  String description;
  String latitude;
  String longitude;
  String friendlyUrl;
  String status;
  int views;
  int isWorkingNow;
  Map<int, HoursWork>? hoursWork;
  int isFavorite;
  int rating;
  String listingUrl;
  Module({
    this.listingId = 0,
    this.title = "",
    this.category,
    this.image = "",
    this.phone = "",
    this.description = "",
    this.friendlyUrl = "",
    this.views = 0,
    this.isWorkingNow = 0,
    this.listingUrl = "",
    this.city,
    this.rating = 0,
    this.status = "",
    this.latitude = "",
    this.longitude = "",
    this.isFavorite = 0,
    this.hoursWork = const {},
  });

  factory Module.fromMap(Map<String, dynamic> map) {
    return Module(
      listingId: map['listing_id'],
      title: map['title'] ?? '',
      category: (map['category'] != null && map['category'] == [])
          ? Category.fromMap(map['category'])
          : null,
      image: map['image'] ?? '',
      phone: map['phone'] ?? '',
      description: map['description'] ?? '',
      friendlyUrl: map['friendly_url'] ?? '',
      views: map['views']?.toInt() ?? 0,
      isWorkingNow: map.containsKey("isWorkingNow")
          ? map['isWorkingNow']?.toInt() ?? 0
          : 0,
      listingUrl: map['listing_url'] ?? '',
      city: map['city'] != null ? City.fromMap(map['city']) : null,
      rating: map.containsKey("rating") ? map['rating']?.toInt() ?? 0 : 0,
      status: map['status'].toString(),
      latitude: map['latitude'] ?? '',
      longitude: map['longitude'] ?? '',
      isFavorite: map['isFavorite']?.toInt() ?? 0,
      hoursWork: (map.containsKey("hours_work") && map["hours_work"] != null)
          ? map["hours_work"].toString() != "[]"
              ? Map<int, HoursWork>.from(map['hours_work'].map((k, v) =>
                  MapEntry(dayNames.indexOf(k), HoursWork.fromMap(v))))
              : {}
          : {},
    );
  }

  factory Module.fromJson(String source) => Module.fromMap(json.decode(source));

  Listing toListing() {
    return Listing(
        id: listingId,
        title: title,
        description: description,
        category: category,
        city: city != null
            ? ListingCity(id: city?.id ?? 0, title: city?.name ?? "")
            : null,
        hoursWork: hoursWork,
        friendlyUrl: friendlyUrl,
        image: image,
        isFavorite: isFavorite,
        isWorkingNow: isWorkingNow,
        latitude: latitude,
        longitude: longitude,
        rating: rating,
        listingUrl: listingUrl,
        phone: phone,
        views: views,
        status: status);
  }

  Classified toClassified() {
    return Classified(
      id: listingId,
      description: description,
      image: image,
      listing_id: listingId,
      title: title,
      url: listingUrl,
      contact: ClassifiedContact(phone: phone),
      location: ClassifiedLocation(
          latitude: latitude, longitude: longitude, city: city),
      category: category?.title ?? "",
    );
  }

  Event toEvent() {
    return Event(
      id: listingId,
      description: description,
      image: image,
      listingId: listingId,
      title: title,
      url: listingUrl,
      latitude: latitude,
      longitude: longitude,
    
      category: category?.title ?? "",
    );
  }

  @override
  String toString() {
    return 'Module(listingId: $listingId, title: $title, category: $category, image: $image, city: $city, description: $description, latitude: $latitude, longitude: $longitude, friendly_url: , status: $status, views: $views, isWorkingNow: $isWorkingNow, hoursWork: $hoursWork, isFavorite: $isFavorite, listingUrl: $listingUrl)';
  }
}
