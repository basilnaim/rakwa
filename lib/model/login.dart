import 'dart:io';

class Login {
  String email = "", password = "";

//<editor-fold desc="Data Methods">

  Login({
    this.email = "",
    this.password = "",
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Login &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          password == other.password);

  @override
  int get hashCode => email.hashCode ^ password.hashCode;

  @override
  String toString() {
    return 'login{email: $email, password: $password}';
  }

  Login copyWith({
    String? email,
    String? password,
  }) {
    return Login(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'device_type': Platform.isAndroid ? 1 : 2,
    };
  }

  factory Login.fromMap(Map<String, dynamic> map) {
    return Login(
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

//</editor-fold>
}
