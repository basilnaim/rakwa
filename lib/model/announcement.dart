import 'dart:convert';
import 'dart:io';

class Announcement {
  int id;
  int? listingId;
  File? imageFile;
  String? btnText;
  String? btnLink;
  String? description;
  String? image;
  Announcement({
    this.id = 0,
    this.listingId = 0,
    this.imageFile,
    this.btnText = "",
    this.btnLink = "",
    this.description = "",
    this.image = "",
  });

  Announcement copyWith({
    int? id,
    int? listingId,
    File? imageFile,
    String? btnText,
    String? btnLink,
    String? description,
    String? image,
  }) {
    return Announcement(
      id: id ?? this.id,
      listingId: listingId ?? this.listingId,
      imageFile: imageFile ?? this.imageFile,
      btnText: btnText ?? this.btnText,
      btnLink: btnLink ?? this.btnLink,
      description: description ?? this.description,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap({bool create = true}) {
    final result = <String, dynamic>{};

    if (id > 0) result.addAll({'announcement_id': id});
    if (listingId != null) {
      if (!create) result.addAll({'listing_id': listingId});
      if (create) result.addAll({'item_id': listingId});
    }
    /*  if(imageFile != null){
      result.addAll({'imageFile': imageFile!.toMap()});
    }*/
    if (btnText != null) {
      result.addAll({'btn_text': btnText});
    }
    if (btnLink != null) {
      result.addAll({'btn_link': btnLink});
    }
    if (description != null) {
      result.addAll({'description': description});
    }
    if (image != null) {
      result.addAll({'image': image});
    }

    return result;
  }

  factory Announcement.fromMap(Map<String, dynamic> map) {
    return Announcement(
      id: map['id']?.toInt() ?? 0,
      listingId: int.parse(map['listing_id'] ?? "0"),
      //  imageFile: map['imageFile'] != null ? File.fromMap(map['imageFile']) : null,
      btnText: map['btn_text'],
      btnLink: map['btn_link'],
      description: map['description'],
      image: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Announcement.fromJson(String source) =>
      Announcement.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Announcement(id: $id, listingId: $listingId, imageFile: $imageFile, btnText: $btnText, btnLink: $btnLink, description: $description, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Announcement &&
        other.id == id &&
        other.listingId == listingId &&
        other.imageFile == imageFile &&
        other.btnText == btnText &&
        other.btnLink == btnLink &&
        other.description == description &&
        other.image == image;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        listingId.hashCode ^
        imageFile.hashCode ^
        btnText.hashCode ^
        btnLink.hashCode ^
        description.hashCode ^
        image.hashCode;
  }
}
