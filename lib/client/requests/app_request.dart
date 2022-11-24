import "package:http/http.dart";
import 'package:rakwa/model/coupon.dart';
import '../../model/event.dart';

abstract class AppRequest {
  Future<Response> getStates();
  Future<Response> getCities(int stateId);
  Future<Response> getListingCoupons(int listingId,String token);
  Future<Response> createCoupon(Coupon coupon,String token);
  Future<Response> updateCoupon(Coupon coupon,String token);
  Future<Response> deleteCoupon(int coupon,String token);
  Future<Response> deleteEvent(int event,String token);
  Future<Response> mySavedListings(String token);
  Future<Response> createEvent(Event event,String token);
  Future<Response> updateEvent(Event event,String token);
  Future<Response> getListingEvents(String token);


}
