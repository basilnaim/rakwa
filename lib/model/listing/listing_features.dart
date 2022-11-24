import 'dart:convert';

class ListingFeatures {
  String? label;
  String? value;
  ListingFeatures({
    this.label,
    this.value,
  });

  ListingFeatures copyWith({
    String? label,
    String? value,
  }) {
    return ListingFeatures(
      label: label ?? this.label,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(label != null){
      result.addAll({'label': label});
    }
    if(value != null){
      result.addAll({'value': value});
    }
  
    return result;
  }

  factory ListingFeatures.fromMap(Map<String, dynamic> map) {
    return ListingFeatures(
      label: map['label'],
      value: map['value'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ListingFeatures.fromJson(String source) => ListingFeatures.fromMap(json.decode(source));

  @override
  String toString() => 'ListingFeatures(label: $label, value: $value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ListingFeatures &&
      other.label == label &&
      other.value == value;
  }

  @override
  int get hashCode => label.hashCode ^ value.hashCode;
}
