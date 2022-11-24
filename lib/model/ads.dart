import 'dart:convert';

class Ads {
  String? description;
  String? image;
  Ads({
    this.description,
    this.image,
  });

  Ads copyWith({
    String? description,
    String? image,
  }) {
    return Ads(
      description: description ?? this.description,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(description != null){
      result.addAll({'description': description});
    }
    if(image != null){
      result.addAll({'image': image});
    }
  
    return result;
  }

  factory Ads.fromMap(Map<String, dynamic> map) {
    return Ads(
      description: map['description'],
      image: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Ads.fromJson(String source) => Ads.fromMap(json.decode(source));

  @override
  String toString() => 'Ads(description: $description, image: $image)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Ads &&
      other.description == description &&
      other.image == image;
  }

  @override
  int get hashCode => description.hashCode ^ image.hashCode;
}
