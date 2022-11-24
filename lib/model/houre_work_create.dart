class HoureWorkCreate {
  String weekday;
  String hours_start;
  String hours_end;
  HoureWorkCreate({
    required this.weekday,
    required this.hours_start,
    required this.hours_end,
  });

  Map<String, String> toMap() {
    final result = <String, String>{};

    result.addAll({'"weekday"': '"$weekday"'});
    result.addAll({'"hours_start"': '"$hours_start"'});
    result.addAll({'"hours_end"': '"$hours_end"'});

    return result;
  }

  factory HoureWorkCreate.fromMap(Map<String, dynamic> map) {
    return HoureWorkCreate(
      weekday: map['weekday'] ?? '',
      hours_start: map['hours_start'] ?? '',
      hours_end: map['hours_end'] ?? '',
    );
  }
}
