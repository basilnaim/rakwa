import 'dart:convert';

class AppVersion {
  String version;
  bool required;
  AppVersion({
    required this.version,
    required this.required,
  });

  AppVersion copyWith({
    String? version,
    bool? required,
  }) {
    return AppVersion(
      version: version ?? this.version,
      required: required ?? this.required,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'version': version});
    result.addAll({'required': required});
  
    return result;
  }

  factory AppVersion.fromMap(Map<String, dynamic> map) {
    return AppVersion(
      version: map['version'] ?? '',
      required: map['required'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppVersion.fromJson(String source) => AppVersion.fromMap(json.decode(source));

  @override
  String toString() => 'AppVersion(version: $version, required: $required)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AppVersion &&
      other.version == version &&
      other.required == required;
  }

  @override
  int get hashCode => version.hashCode ^ required.hashCode;
}
