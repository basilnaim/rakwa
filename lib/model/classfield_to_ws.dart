import 'dart:convert';

import 'dart:io';
import 'package:rakwa/model/classified.dart';

class ClassifiedToWs {
  int id;
  File? image;
  String title;
  String description;
  int category;
  String categoryName;
  String latitude;
  String longitude;
  String address;
  int cityId;
  int stateId;

  ClassifiedToWs(
      {this.id = 0,
      this.image,
      this.categoryName = "",
      this.title = "",
      this.description = "",
      this.category = 0,
      this.stateId = 0,
      this.latitude = "",
      this.longitude = "",
      this.address = "",
      this.cityId = 0});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'classified_id': id});
    result.addAll({'title': title});
    result.addAll({'description': description});
    result.addAll({'category': category});
    result.addAll({'latitude': latitude});
    result.addAll({'longitude': longitude});
    result.addAll({'address': address});
    result.addAll({'city_id': cityId});

    return result;
  }

  factory ClassifiedToWs.fromClassified(Classified classified) {
    return ClassifiedToWs()..updateFieldsFromClassified(classified);
  }

  updateFieldsFromClassified(Classified classified) {
    id = classified.id;
    address = classified.location?.address ?? "";
    longitude = classified.location?.longitude ?? "";
    latitude = classified.location?.latitude ?? "0.0";
    cityId = classified.location?.city?.id ?? 0;
    stateId = classified.location?.state?.id ?? 0;
    title = classified.title ?? "";
    description = classified.description ?? "";
    categoryName = classified.category ?? "";
  }

  factory ClassifiedToWs.fromMap(Map<String, dynamic> map) {
    return ClassifiedToWs(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      latitude: map['latitude'] ?? '',
      longitude: map['longitude'] ?? '',
      address: map['address'] ?? '',
      cityId: map['city_id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ClassifiedToWs.fromJson(String source) =>
      ClassifiedToWs.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ClassifiedToWs(id: $id, image: $image, title: $title, description: $description, category: $category, latitude: $latitude, longitude: $longitude, address: $address, cityId: $cityId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ClassifiedToWs &&
        other.id == id &&
        other.image == image &&
        other.title == title &&
        other.description == description &&
        other.category == category &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.address == address &&
        other.cityId == cityId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        image.hashCode ^
        title.hashCode ^
        description.hashCode ^
        category.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        address.hashCode ^
        cityId.hashCode;
  }
}
