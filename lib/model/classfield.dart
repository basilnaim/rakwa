import 'dart:convert';
import 'dart:io';

class Classfield {
  String title;
  String description;
  String image;
  File? imageFile;
  Classfield({
    required this.title,
    required this.description,
    required this.image,
    this.imageFile,
  });

  Classfield copyWith({
    String? title,
    String? description,
    String? image,
    File? imageFile,
  }) {
    return Classfield(
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      imageFile: imageFile ?? this.imageFile,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'title': title});
    result.addAll({'description': description});
    result.addAll({'image': image});

    return result;
  }

  factory Classfield.fromMap(Map<String, dynamic> map) {
    return Classfield(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      image: map['image'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Classfield.fromJson(String source) =>
      Classfield.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Classfield(title: $title, description: $description, image: $image, imageFile: $imageFile)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Classfield &&
        other.title == title &&
        other.description == description &&
        other.image == image &&
        other.imageFile == imageFile;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        description.hashCode ^
        image.hashCode ^
        imageFile.hashCode;
  }
}
