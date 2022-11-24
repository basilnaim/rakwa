import 'dart:convert';

class EventDateTime {
  String? date;
  int? timezoneType;
  String? timezone;
  EventDateTime({
    this.date,
    this.timezoneType,
    this.timezone,
  });

  EventDateTime copyWith({
    String? date,
    int? timezoneType,
    String? timezone,
  }) {
    return EventDateTime(
      date: date ?? this.date,
      timezoneType: timezoneType ?? this.timezoneType,
      timezone: timezone ?? this.timezone,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(date != null){
      result.addAll({'date': date});
    }
    if(timezoneType != null){
      result.addAll({'timezoneType': timezoneType});
    }
    if(timezone != null){
      result.addAll({'timezone': timezone});
    }
  
    return result;
  }

  factory EventDateTime.fromMap(Map<String, dynamic> map) {
    return EventDateTime(
      date: map['date'],
      timezoneType: map['timezoneType']?.toInt(),
      timezone: map['timezone'],
    );
  }

  String toJson() => json.encode(toMap());

  factory EventDateTime.fromJson(String source) => EventDateTime.fromMap(json.decode(source));

  @override
  String toString() => 'EventDateTime(date: $date, timezoneType: $timezoneType, timezone: $timezone)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is EventDateTime &&
      other.date == date &&
      other.timezoneType == timezoneType &&
      other.timezone == timezone;
  }

  @override
  int get hashCode => date.hashCode ^ timezoneType.hashCode ^ timezone.hashCode;
}
