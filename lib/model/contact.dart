import 'dart:convert';

class Contact {
  String firstname;
  String lastname;
  String email;
  String message;
  String phone;
  Contact({
    this.firstname = "",
    this.lastname = "",
    this.email = "",
    this.message = "",
    this.phone = "",
  });

  Contact copyWith({
    String? firstname,
    String? lastname,
    String? email,
    String? message,
    String? phone,
  }) {
    return Contact(
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      email: email ?? this.email,
      message: message ?? this.message,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'firstname': firstname});
    result.addAll({'lastname': lastname});
    result.addAll({'email': email});
    result.addAll({'message': message});
    result.addAll({'phone': phone});

    return result;
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      firstname: map['firstname'] ?? '',
      lastname: map['lastname'] ?? '',
      email: map['email'] ?? '',
      message: map['message'] ?? '',
      phone: map['phone'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Contact.fromJson(String source) =>
      Contact.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Contact(firstname: $firstname, lastname: $lastname, email: $email, message: $message, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Contact &&
        other.firstname == firstname &&
        other.lastname == lastname &&
        other.email == email &&
        other.message == message &&
        other.phone == phone;
  }

  @override
  int get hashCode {
    return firstname.hashCode ^
        lastname.hashCode ^
        email.hashCode ^
        message.hashCode ^
        phone.hashCode;
  }
}
