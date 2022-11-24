import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final format = DateFormat.jm(); //"6:00 AM"
final formatDate = DateFormat("yyyy-MM-dd"); 
final formatDate2 = DateFormat("dd-MM-yyyy"); 

List<String> dayNames = [
  "Sunday",
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday"
];

DateTime nowTime(TimeOfDay tod){
  final now = new DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
  return dt;
}

String formatTimeOfDay(TimeOfDay tod) {
  
  return format.format(nowTime(tod));
}

TimeOfDay? getTimeFromString(String value) {
    try{
  

        return (value.isEmpty || value.toLowerCase() == "closed")
      ? null
      : TimeOfDay.fromDateTime(DateFormat("HH:mm").parse(value.toUpperCase()));
    }catch(r){
      print("ERROR "+value);
      return null;
    }
}

TimeOfDay? getTimeWithSecondFromString(String value) {
    try{
        return (value.isEmpty || value.toLowerCase() == "closed")
      ? null
      : TimeOfDay.fromDateTime(DateFormat.Hms().parse(value));
    }catch(r){
      return null;
    }
}

compareTwoTimes(TimeOfDay s ,TimeOfDay e) =>    nowTime(s).compareTo(nowTime(e));