import 'dart:convert';

class HoursWork {
  String start;
  String end;
  bool selected;
  HoursWork({
    required this.selected,
    required this.start,
    required this.end,
  });

  HoursWork.defaultTime({
    required this.selected,
    this.start = "06:00",
    this.end = '22:00',
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'start': start});
    result.addAll({'end': end});

    return result;
  }

  factory HoursWork.fromMap(Map<String, dynamic> map) {
    return HoursWork(
        start: map['start'] ?? '',
        end: map['end'] ?? '',
        selected: map['start'].toString().toLowerCase() != "closed" &&
            map['end'].toString().toLowerCase() != "closed");
  }

  String toJson() => json.encode(toMap());

  factory HoursWork.fromJson(String source) =>
      HoursWork.fromMap(json.decode(source));

  @override
  String toString() => 'HoursWork(start: $start, end: $end)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HoursWork && other.start == start && other.end == end;
  }

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}
