import 'dart:convert';

import 'package:rakwa/model/city.dart';
import 'package:rakwa/model/state.dart';

class Classified {
  int id;
  String? image;
  String? title;
  String? description;
  String? category;
  String? url;
  int? user_id;
  String? summary_description;
  int? listing_id;
  // String? status;
  ClassifiedLocation? location;
  ClassifiedContact? contact;
  Classified({
    required this.id,
    this.image,
    this.title,
    this.description,
    this.category,
    this.url,
    this.user_id,
    this.summary_description,
    this.listing_id,
    //  this.status,
    this.location,
    this.contact,
  });

  Classified copyWith({
    int? id,
    String? image,
    String? title,
    String? description,
    String? category,
    String? url,
    int? user_id,
    String? summary_description,
    int? listing_id,
    //  String? status,
  }) {
    return Classified(
      id: id ?? this.id,
      image: image ?? this.image,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      url: url ?? this.url,
      user_id: user_id ?? this.user_id,
      summary_description: summary_description ?? this.summary_description,
      listing_id: listing_id ?? this.listing_id,
      //   status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    if (image != null) {
      result.addAll({'image': image});
    }
    if (title != null) {
      result.addAll({'title': title});
    }
    if (description != null) {
      result.addAll({'description': description});
    }
    if (category != null) {
      result.addAll({'category': category});
    }
    if (url != null) {
      result.addAll({'url': url});
    }
    if (user_id != null) {
      result.addAll({'user_id': user_id});
    }
    if (summary_description != null) {
      result.addAll({'summary_description': summary_description});
    }
    if (listing_id != null) {
      result.addAll({'listing_id': listing_id});
    }
    /*  if (status != null) {
      result.addAll({'status': status});
    }*/

    return result;
  }

  factory Classified.fromMap(Map<String, dynamic> map) {
    return Classified(
      id: map['id']?.toInt() ?? 0,
      image: map['image'],
      title: map['title'],
      description: map['description'],
      category: map['category'],
      url: map['url'],
      user_id: map['user_id']?.toInt(),
      summary_description: map['summary_description'],
      listing_id: map['listing_id'],
      //  status: map['status'],
      location: map['location'] != null
          ? ClassifiedLocation.fromMap(map['location'])
          : null,
      contact: map['contact'] != null
          ? ClassifiedContact.fromMap(map['contact'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Classified.fromJson(String source) =>
      Classified.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Classified(id: $id, image: $image, title: $title, description: $description, category: $category, url: $url, user_id: $user_id, summary_description: $summary_description, listing_id: $listing_id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Classified &&
        other.id == id &&
        other.image == image &&
        other.title == title &&
        other.description == description &&
        other.category == category &&
        other.url == url &&
        other.user_id == user_id &&
        other.summary_description == summary_description &&
        other.listing_id == listing_id;
    //  other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        image.hashCode ^
        title.hashCode ^
        description.hashCode ^
        category.hashCode ^
        url.hashCode ^
        user_id.hashCode ^
        summary_description.hashCode ^
        listing_id.hashCode;
    //  status.hashCode;
  }
}

class ClassifiedLocation {
  String? latitude;
  String? longitude;
  String? address;
  City? city;
  StateLocation? state;
  ClassifiedLocation({
    this.latitude,
    this.longitude,
    this.address,
    this.city,
    this.state,
  });

  ClassifiedLocation copyWith({
    String? latitude,
    String? longitude,
    String? address,
    City? city,
    StateLocation? state,
  }) {
    return ClassifiedLocation(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (latitude != null) {
      result.addAll({'latitude': latitude});
    }
    if (longitude != null) {
      result.addAll({'longitude': longitude});
    }
    if (address != null) {
      result.addAll({'address': address});
    }
    if (city != null) {
      result.addAll({'city': city!.toMap()});
    }
    if (state != null) {
      result.addAll({'state': state!.toMap()});
    }

    return result;
  }

  factory ClassifiedLocation.fromMap(Map<String, dynamic> map) {
    return ClassifiedLocation(
      latitude: map['latitude'],
      longitude: map['longitude'],
      address: map['address'],
      city: map['city'] != null ? City.fromMap(map['city']) : null,
      state: map['state'] != null ? StateLocation.fromMap(map['state']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ClassifiedLocation.fromJson(String source) =>
      ClassifiedLocation.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ClassifiedLocation(latitude: $latitude, longitude: $longitude, address: $address, city: $city, state: $state)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ClassifiedLocation &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.address == address &&
        other.city == city &&
        other.state == state;
  }

  @override
  int get hashCode {
    return latitude.hashCode ^
        longitude.hashCode ^
        address.hashCode ^
        city.hashCode ^
        state.hashCode;
  }
}

class ClassifiedContact {
  String? name;
  String? email;
  String? phone;
  ClassifiedContact({
    this.name,
    this.email,
    this.phone,
  });

  ClassifiedContact copyWith({
    String? name,
    String? email,
    String? phone,
  }) {
    return ClassifiedContact(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (name != null) {
      result.addAll({'name': name});
    }
    if (email != null) {
      result.addAll({'email': email});
    }
    if (phone != null) {
      result.addAll({'phone': phone});
    }

    return result;
  }

  factory ClassifiedContact.fromMap(Map<String, dynamic> map) {
    return ClassifiedContact(
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ClassifiedContact.fromJson(String source) =>
      ClassifiedContact.fromMap(json.decode(source));

  @override
  String toString() =>
      'ClassifiedContact(name: $name, email: $email, phone: $phone)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ClassifiedContact &&
        other.name == name &&
        other.email == email &&
        other.phone == phone;
  }

  @override
  int get hashCode => name.hashCode ^ email.hashCode ^ phone.hashCode;
}
