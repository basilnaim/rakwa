import 'dart:convert';

class UpdatePassword {
  String currentPwd;
  String newPwd;
  String confirmPwd;
  UpdatePassword({
    this.currentPwd = "",
    this.newPwd = "",
    this.confirmPwd = "",
  });

  UpdatePassword copyWith({
    String? currentPwd,
    String? newPwd,
    String? oldPwd,
  }) {
    return UpdatePassword(
      currentPwd: currentPwd ?? this.currentPwd,
      newPwd: newPwd ?? this.newPwd,
      confirmPwd: oldPwd ?? this.confirmPwd,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'old_password': currentPwd});
    result.addAll({'new_password': newPwd});
    result.addAll({'confirm_password': confirmPwd});

    return result;
  }

  factory UpdatePassword.fromMap(Map<String, dynamic> map) {
    return UpdatePassword(
      currentPwd: map['currentPwd'] ?? '',
      newPwd: map['newPwd'] ?? '',
      confirmPwd: map['oldPwd'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdatePassword.fromJson(String source) =>
      UpdatePassword.fromMap(json.decode(source));

  @override
  String toString() =>
      'UpdatePassword(currentPwd: $currentPwd, newPwd: $newPwd, oldPwd: $confirmPwd)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UpdatePassword &&
        other.currentPwd == currentPwd &&
        other.newPwd == newPwd &&
        other.confirmPwd == confirmPwd;
  }

  @override
  int get hashCode =>
      currentPwd.hashCode ^ newPwd.hashCode ^ confirmPwd.hashCode;
}
