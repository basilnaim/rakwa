import 'dart:convert';

import 'package:rakwa/model/listing/event_date_time.dart';
import 'package:rakwa/model/listing/event_participant.dart';

class ListingEvent {
  int eventId;
  String? title;
  String? description;
  String? image;
  EventDateTime? startDate;
  EventDateTime? startTime;
  EventDateTime? endDate;
  EventDateTime? endTime;
  String? internalUrl;
  String? externalUrl;
  String? location;
  String? zipCode;
  String? latitude;
  String? longitude;
  String? address;
  String? status;
  int? isParticipated;
  EventParticipant? participants;
  ListingEvent({
    required this.eventId,
    this.title,
    this.description,
    this.participants,
    this.image,
    this.startDate,
    this.startTime,
    this.endDate,
    this.endTime,
    this.internalUrl,
    this.externalUrl,
    this.location,
    this.zipCode,
    this.latitude,
    this.longitude,
    this.address,
    this.status,
    this.isParticipated,
  });

  ListingEvent copyWith({
    int? eventId,
    String? title,
    String? description,
    String? image,
    EventDateTime? startDate,
    EventDateTime? startTime,
    EventDateTime? endDate,
    EventDateTime? endTime,
    String? internalUrl,
    String? externalUrl,
    String? location,
    String? zipCode,
    String? latitude,
    String? longitude,
    String? address,
    String? status,
    int? isParticipated,
    EventParticipant? participants,
  }) {
    return ListingEvent(
      eventId: eventId ?? this.eventId,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      startDate: startDate ?? this.startDate,
      startTime: startTime ?? this.startTime,
      endDate: endDate ?? this.endDate,
      endTime: endTime ?? this.endTime,
      internalUrl: internalUrl ?? this.internalUrl,
      externalUrl: externalUrl ?? this.externalUrl,
      location: location ?? this.location,
      zipCode: zipCode ?? this.zipCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      status: status ?? this.status,
      isParticipated: isParticipated ?? this.isParticipated,
      participants: participants ?? this.participants,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'eventId': eventId});
    if(title != null){
      result.addAll({'title': title});
    }
    if(description != null){
      result.addAll({'description': description});
    }
    if(image != null){
      result.addAll({'image': image});
    }
    if(startDate != null){
      result.addAll({'startDate': startDate!.toMap()});
    }
    if(startTime != null){
      result.addAll({'startTime': startTime!.toMap()});
    }
    if(endDate != null){
      result.addAll({'endDate': endDate!.toMap()});
    }
    if(endTime != null){
      result.addAll({'endTime': endTime!.toMap()});
    }
    if(internalUrl != null){
      result.addAll({'internalUrl': internalUrl});
    }
    if(externalUrl != null){
      result.addAll({'externalUrl': externalUrl});
    }
    if(location != null){
      result.addAll({'location': location});
    }
    if(zipCode != null){
      result.addAll({'zipCode': zipCode});
    }
    if(latitude != null){
      result.addAll({'latitude': latitude});
    }
    if(longitude != null){
      result.addAll({'longitude': longitude});
    }
    if(address != null){
      result.addAll({'address': address});
    }
    if(status != null){
      result.addAll({'status': status});
    }
    if(isParticipated != null){
      result.addAll({'isParticipated': isParticipated});
    }
    if(participants != null){
      result.addAll({'participants': participants!.toMap()});
    }
  
    return result;
  }

  factory ListingEvent.fromMap(Map<String, dynamic> map) {
    return ListingEvent(
      eventId: map['event_id']?.toInt() ?? 0,
      title: map['title'],
      description: map['description'],
      image: map['image'],
      startDate: map['start-date'] != null ? EventDateTime.fromMap(map['start-date']) : null,
      startTime: map['start-time'] != null ? EventDateTime.fromMap(map['start-time']) : null,
      endDate: map['end-date'] != null ? EventDateTime.fromMap(map['end-date']) : null,
      endTime: map['end-time'] != null ? EventDateTime.fromMap(map['end-time']) : null,
      internalUrl: map['internal-url'],
      externalUrl: map['external-url'],
      location: map['location'],
      zipCode: map['zip-code'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      address: map['address'],
      status: map['status'],
      isParticipated: map['is_participated']?.toInt(),
      participants: map['participants'] != null ? EventParticipant.fromMap(map['participants']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ListingEvent.fromJson(String source) => ListingEvent.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ListingEvent(eventId: $eventId, title: $title, description: $description, image: $image, startDate: $startDate, startTime: $startTime, endDate: $endDate, endTime: $endTime, internalUrl: $internalUrl, externalUrl: $externalUrl, location: $location, zipCode: $zipCode, latitude: $latitude, longitude: $longitude, address: $address, status: $status, isParticipated: $isParticipated, participants: $participants)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ListingEvent &&
      other.eventId == eventId &&
      other.title == title &&
      other.description == description &&
      other.image == image &&
      other.startDate == startDate &&
      other.startTime == startTime &&
      other.endDate == endDate &&
      other.endTime == endTime &&
      other.internalUrl == internalUrl &&
      other.externalUrl == externalUrl &&
      other.location == location &&
      other.zipCode == zipCode &&
      other.latitude == latitude &&
      other.longitude == longitude &&
      other.address == address &&
      other.status == status &&
      other.isParticipated == isParticipated &&
      other.participants == participants;
  }

  @override
  int get hashCode {
    return eventId.hashCode ^
      title.hashCode ^
      description.hashCode ^
      image.hashCode ^
      startDate.hashCode ^
      startTime.hashCode ^
      endDate.hashCode ^
      endTime.hashCode ^
      internalUrl.hashCode ^
      externalUrl.hashCode ^
      location.hashCode ^
      zipCode.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      address.hashCode ^
      status.hashCode ^
      isParticipated.hashCode ^
      participants.hashCode;
  }
}
