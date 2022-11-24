import 'package:http/http.dart' as http;
import 'package:rakwa/client/client.dart' as client;
import 'package:rakwa/client/end_points.dart';
import 'package:rakwa/client/requests/app_request.dart';
import 'package:rakwa/model/announcement.dart';
import 'package:rakwa/model/contact.dart';
import 'package:rakwa/model/coupon.dart';
import 'package:rakwa/model/event.dart';

class AppClient extends client.Client implements AppRequest {
  @override
  Future<http.Response> getCities(int stateId) {
    return get(EndPoints.cities, params: {"state": "$stateId"});
  }

  @override
  Future<http.Response> getStates() {
    return getPath(EndPoints.states);
  }

  @override
  Future<http.Response> contactUs(Contact contact) {
    return post(EndPoints.contactUs, body: contact.toMap());
  }

  @override
  Future<http.Response> createCoupon(Coupon coupon, String token) {
    return post(EndPoints.coupon,
        body: coupon.toMap(), headers: {'token': token});
  }

  @override
  Future<http.Response> updateCoupon(Coupon coupon, String token) {
    return put(EndPoints.coupon,
        body: coupon.toMap(), headers: {'token': token});
  }

  @override
  Future<http.Response> getListingCoupons(int listingId, String token) {
    return get(EndPoints.coupon,
        headers: {'token': token},
        params: {"listing_id": listingId.toString()});
  }

  @override
  Future<http.Response> deleteCoupon(int coupon, String token) {
    return delete(EndPoints.deleteCoupon(coupon),
        headers: {'token': token}, body: {"coupon_id": coupon.toString()});
  }

  @override
  Future<http.Response> createAnnouncement(
      Announcement announcement, String token) {
    return multiPart(EndPoints.annoucement,
        action: "POST",
        body: announcement.toMap(),
        files: announcement.imageFile == null ? [] : [announcement.imageFile!],
        headers: {'token': token});
  }

  @override
  Future<http.Response> updateAnnouncement(
      Announcement announcement, String token) {
    return multiPart(EndPoints.annoucement,
        body: announcement.toMap(), headers: {'token': token});
  }

  @override
  Future<http.Response> getListingAnnouncement(int listingId, String token) {
    return get(EndPoints.annoucementList,
        headers: {'token': token},
        params: {"list_id": listingId.toString()});
  }

  @override
  Future<http.Response> deleteAnnouncement(int coupon, String token) {
    return delete(EndPoints.deleteAnnoucement(coupon),
        headers: {'token': token}, body: {"coupon_id": coupon.toString()});
  }

  @override
  Future<http.Response> mySavedListings(String token) {
    return get(
      EndPoints.favorite,
      headers: {'token': token},
    );
  }

  @override
  Future<http.Response> createEvent(Event event, String token) {
    return multiPart(EndPoints.event,
        action: 'POST',
        body: event.toMap(),
        headers: {'token': token},
        files: event.imageFile == null ? [] : [event.imageFile!]);
  }

  @override
  Future<http.Response> updateEvent(Event event, String token) {
    return multiPart(EndPoints.event,
        action: 'PUT',
        body: event.toMap(),
        headers: {'token': token},
        files: event.imageFile == null ? [] : [event.imageFile!]);
  }

   @override
  Future<http.Response> getListingEvents( String token) {
    return get(EndPoints.myEvent,
        headers: {'token': token},
       );
  }

    @override
  Future<http.Response> deleteEvent(int event, String token) {
    return delete(EndPoints.deleteEvent(event),
        headers: {'token': token}, body: {"coupon_id": event.toString()});
  }
}
