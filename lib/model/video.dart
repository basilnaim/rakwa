import 'dart:convert';

class Video {
  String? url;
  String? description;
  Video({
    this.url,
    this.description,
  });

  Video copyWith({
    String? url,
    String? description,
  }) {
    return Video(
      url: url ?? this.url,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(url != null){
      result.addAll({'url': url});
    }
    if(description != null){
      result.addAll({'description': description});
    }
  
    return result;
  }

  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      url: map['url'],
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Video.fromJson(String source) => Video.fromMap(json.decode(source));

  @override
  String toString() => 'Video(url: $url, description: $description)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Video &&
      other.url == url &&
      other.description == description;
  }

  @override
  int get hashCode => url.hashCode ^ description.hashCode;
}
