import 'dart:convert';
import 'dart:io';

import 'package:rakwa/model/state.dart';

import 'city.dart';

class UserProfile {
  int id;
  String firstname;
  String lastname;
  String email;
  String phone;
  String bio;
  String image;
  City? city;
  StateLocation? state;
  String address;
  int activated;

  File? imageFile;
  UserProfile({
    this.id = 0,
    this.firstname = "",
    this.lastname = "",
    this.email = "",
    this.phone = "",
    this.bio = "",
    this.image = "",
    this.city,
    this.state,
    this.address = "",
    this.activated = 0,
  });

  UserProfile copyWith({
    int? id,
    String? firstname,
    String? lastname,
    String? email,
    String? phone,
    String? bio,
    String? image,
    City? city,
    StateLocation? state,
    String? address,
    int? activated,
  }) {
    return UserProfile(
      id: id ?? this.id,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      image: image ?? this.image,
      city: city ?? this.city,
      state: state ?? this.state,
      address: address ?? this.address,
      activated: activated ?? this.activated,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'firstname': firstname});
    result.addAll({'lastname': lastname});
    result.addAll({'email': email});
    result.addAll({'phone': phone});
    result.addAll({'bio': bio});
    result.addAll({'city': city?.id});
    result.addAll({'state': state?.id});
    result.addAll({'address': address});
    result.addAll({'activated': activated});

    return result;
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id']?.toInt() ?? 0,
      firstname: map['firstname'] ?? '',
      lastname: map['lastname'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      bio: map['bio'] ?? '',
      image: map['image'] ?? '',
      city: (map.containsKey('city')) ? City.fromMap(map['city']) : null,
      state: (map.containsKey('state'))
          ? StateLocation.fromMap(map['state'])
          : null,
      address: map['address'] ?? '',
      activated: map['activated']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfile.fromJson(String source) =>
      UserProfile.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, firstname: $firstname, lastname: $lastname, email: $email, phone: $phone, bio: $bio, image: $image, city: $city, state: $state, address: $address, activated: $activated)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfile &&
        other.id == id &&
        other.firstname == firstname &&
        other.lastname == lastname &&
        other.email == email &&
        other.phone == phone &&
        other.bio == bio &&
        other.image == image &&
        other.city == city &&
        other.state == state &&
        other.address == address &&
        other.activated == activated;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        firstname.hashCode ^
        lastname.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        bio.hashCode ^
        image.hashCode ^
        city.hashCode ^
        state.hashCode ^
        address.hashCode ^
        activated.hashCode;
  }
}
