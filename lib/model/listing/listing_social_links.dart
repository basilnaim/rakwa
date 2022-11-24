import 'dart:convert';

class ListingSocialLinks {
  String? facebook;
  String? instagram;
  String? twitter;
  ListingSocialLinks({
    this.facebook,
    this.instagram,
    this.twitter,
  });

  ListingSocialLinks copyWith({
    String? facebook,
    String? instagram,
    String? twitter,
  }) {
    return ListingSocialLinks(
      facebook: facebook ?? this.facebook,
      instagram: instagram ?? this.instagram,
      twitter: twitter ?? this.twitter,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(facebook != null){
      result.addAll({'facebook': facebook});
    }
    if(instagram != null){
      result.addAll({'instagram': instagram});
    }
    if(twitter != null){
      result.addAll({'twitter': twitter});
    }
  
    return result;
  }

  factory ListingSocialLinks.fromMap(Map<String, dynamic> map) {
    return ListingSocialLinks(
      facebook: map['facebook'],
      instagram: map['instagram'],
      twitter: map['twitter'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ListingSocialLinks.fromJson(String source) => ListingSocialLinks.fromMap(json.decode(source));

  @override
  String toString() => 'ListingSocialLinks(facebook: $facebook, instagram: $instagram, twitter: $twitter)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ListingSocialLinks &&
      other.facebook == facebook &&
      other.instagram == instagram &&
      other.twitter == twitter;
  }

  @override
  int get hashCode => facebook.hashCode ^ instagram.hashCode ^ twitter.hashCode;
}
