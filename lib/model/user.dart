import 'dart:convert';

import 'dart:io';

class User {
  int id;
  String firstname;
  String lastname;
  String username;
  String image;
  bool activated;
  String token;
  String phone;
  String fcm;
  String password;

  User({
    this.id = 0,
    this.firstname = "",
    this.phone = "",
    this.lastname = "",
    this.username = "",
    this.image = "",
    this.activated = false,
    this.token = "",
    this.fcm = "",
    this.password = "",
  });

  User copyWith({
    int? id,
    String? firstname,
    String? lastname,
    String? username,
    String? image,
    bool? activated,
    String? token,
    String? fcm,
  }) {
    return User(
      id: id ?? this.id,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      username: username ?? this.username,
      image: image ?? this.image,
      activated: activated ?? this.activated,
      token: token ?? this.token,
      fcm: fcm ?? this.fcm,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'firstname': firstname});
    result.addAll({'lastname': lastname});
    result.addAll({'username': username});
    result.addAll({'image': image});
    result.addAll({'phone': phone});
    result.addAll({'activated': activated});
    result.addAll({'token': token});
    result.addAll({'fcm': fcm});

    return result;
  }

  Map<String, dynamic> toRegisterMap() {
    final result = <String, dynamic>{};

    result.addAll({'firstname': firstname});
    result.addAll({'lastname': lastname});
    result.addAll({'email': username});
    result.addAll({'password': password});
    result.addAll({'terms': true});
    result.addAll({'device_type': Platform.isAndroid ? 1 : 2});

    return result;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id']?.toInt() ?? 0,
      firstname: map['firstname'] ?? '',
      lastname: map['lastname'] ?? '',
      username: map['username'] ?? '',
      phone: map['phone'] ?? '',
      image: map['image'] ?? '',
      activated: map['activated'] ?? false,
      token: map['token'] ?? '',
      fcm: map['fcm'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, firstname: $firstname, lastname: $lastname, username: $username, image: $image, activated: $activated, token: $token, fcm: $fcm)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.firstname == firstname &&
        other.lastname == lastname &&
        other.username == username &&
        other.image == image &&
        other.activated == activated &&
        other.token == token &&
        other.fcm == fcm;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        firstname.hashCode ^
        lastname.hashCode ^
        username.hashCode ^
        image.hashCode ^
        activated.hashCode ^
        token.hashCode ^
        fcm.hashCode;
  }
}
