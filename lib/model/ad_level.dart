import 'dart:convert';

class AdLevel {
  int id;
  String name;
  String image;
  String price;
  String active;
  String period;
  AdLevel({
    this.id = 0,
    this.name = "",
    this.image = "",
    this.price = "",
    this.active = "",
    this.period = "",
  });

  AdLevel copyWith({
    int? id,
    String? name,
    String? image,
    String? price,
    String? active,
    String? period,
  }) {
    return AdLevel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      active: active ?? this.active,
      period: period ?? this.period,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'image': image});
    result.addAll({'price': price});
    result.addAll({'active': active});
    result.addAll({'period': period});

    return result;
  }

  factory AdLevel.fromMap(Map<String, dynamic> map) {
    return AdLevel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      price: map['price'] ?? '',
      active: map['active'] ?? '',
      period: map['period'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AdLevel.fromJson(String source) =>
      AdLevel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AdLevel(id: $id, name: $name, image: $image, price: $price, active: $active, period: $period)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AdLevel &&
        other.id == id &&
        other.name == name &&
        other.image == image &&
        other.price == price &&
        other.active == active &&
        other.period == period;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        image.hashCode ^
        price.hashCode ^
        active.hashCode ^
        period.hashCode;
  }
}
