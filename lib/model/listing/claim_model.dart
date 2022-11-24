import 'dart:convert';

class ClaimModel {
  int? listing_id;
  String? title;
  String? email;
  String? phone;
  String? description;
  String? long;
  String? lat;
  String? website_url;
  String? label_additional_phone;
  String? additional_phone;
  String? address;
  int? city_id;
  int? state_id;
  String? zip;

  ClaimModel({
    this.listing_id,
    this.title,
    this.email,
    this.phone,
    this.description,
    this.long,
    this.lat,
    this.website_url,
    this.label_additional_phone,
    this.additional_phone,
    this.address,
    this.city_id,
    this.state_id,
    this.zip,
  });

  ClaimModel copyWith({
    int? listing_id,
    String? title,
    String? email,
    String? phone,
    String? description,
    String? long,
    String? lat,
    String? website_url,
    String? label_additional_phone,
    String? additional_phone,
    String? address,
    int? city_id,
    int? state_id,
    String? zip,
  }) {
    return ClaimModel(
      listing_id: listing_id ?? this.listing_id,
      title: title ?? this.title,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      description: description ?? this.description,
      long: long ?? this.long,
      lat: lat ?? this.lat,
      website_url: website_url ?? this.website_url,
      label_additional_phone: label_additional_phone ?? this.label_additional_phone,
      additional_phone: additional_phone ?? this.additional_phone,
      address: address ?? this.address,
      city_id: city_id ?? this.city_id,
      state_id: state_id ?? this.state_id,
      zip: zip ?? this.zip,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(listing_id != null){
      result.addAll({'listing_id': listing_id});
    }
    if(title != null){
      result.addAll({'title': title});
    }
    if(email != null){
      result.addAll({'email': email});
    }
    if(phone != null){
      result.addAll({'phone': phone});
    }
    if(description != null){
      result.addAll({'description': description});
    }
    if(long != null){
      result.addAll({'long': long});
    }
    if(lat != null){
      result.addAll({'lat': lat});
    }
    if(website_url != null){
      result.addAll({'website_url': website_url});
    }
    if(label_additional_phone != null){
      result.addAll({'label_additional_phone': label_additional_phone});
    }
    if(additional_phone != null){
      result.addAll({'additional_phone': additional_phone});
    }
    if(address != null){
      result.addAll({'address': address});
    }
    if(city_id != null){
      result.addAll({'city_id': city_id});
    }
    if(state_id != null){
      result.addAll({'state_id': state_id});
    }
    if(zip != null){
      result.addAll({'zip': zip});
    }
  
    return result;
  }

  factory ClaimModel.fromMap(Map<String, dynamic> map) {
    return ClaimModel(
      listing_id: map['listing_id']?.toInt(),
      title: map['title'],
      email: map['email'],
      phone: map['phone'],
      description: map['description'],
      long: map['long'],
      lat: map['lat'],
      website_url: map['website_url'],
      label_additional_phone: map['label_additional_phone'],
      additional_phone: map['additional_phone'],
      address: map['address'],
      city_id: map['city_id']?.toInt(),
      state_id: map['state_id']?.toInt(),
      zip: map['zip'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ClaimModel.fromJson(String source) => ClaimModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ClaimModel(listing_id: $listing_id, title: $title, email: $email, phone: $phone, description: $description, long: $long, lat: $lat, website_url: $website_url, label_additional_phone: $label_additional_phone, additional_phone: $additional_phone, address: $address, city_id: $city_id, state_id: $state_id, zip: $zip)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ClaimModel &&
      other.listing_id == listing_id &&
      other.title == title &&
      other.email == email &&
      other.phone == phone &&
      other.description == description &&
      other.long == long &&
      other.lat == lat &&
      other.website_url == website_url &&
      other.label_additional_phone == label_additional_phone &&
      other.additional_phone == additional_phone &&
      other.address == address &&
      other.city_id == city_id &&
      other.state_id == state_id &&
      other.zip == zip;
  }

  @override
  int get hashCode {
    return listing_id.hashCode ^
      title.hashCode ^
      email.hashCode ^
      phone.hashCode ^
      description.hashCode ^
      long.hashCode ^
      lat.hashCode ^
      website_url.hashCode ^
      label_additional_phone.hashCode ^
      additional_phone.hashCode ^
      address.hashCode ^
      city_id.hashCode ^
      state_id.hashCode ^
      zip.hashCode;
  }
}
