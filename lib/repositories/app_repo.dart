import 'dart:convert';
import 'package:rakwa/client/app_client.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/announcement.dart';
import 'package:rakwa/model/city.dart';
import 'package:rakwa/model/contact.dart';
import 'package:rakwa/model/coupon.dart';
import 'package:rakwa/model/event.dart';
import 'package:rakwa/model/saved_listing.dart';
import 'package:rakwa/model/state.dart';
import 'package:rakwa/model/web_service_result.dart';

class AppRepo {
  AppClient appClient = AppClient();

  Future<WebServiceResult<List<City>>> getCities(int stateId) {
    return appClient.getCities(stateId).then((response) {
      print("getCities code" + response.statusCode.toString());
      print("getCities result" + json.decode(response.body).toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          List<City> cities = List<City>.from(
              json.decode(response.body)["data"].map((e) => City.fromMap(e)));
          cities.sort((a, b) => a.name.compareTo(b.name));

          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: cities));

        default:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.error));
      }
    });
  }

  Future<WebServiceResult<List<StateLocation>>> getStates() {
    return appClient.getStates().then((response) {
      print("getStates code" + response.statusCode.toString());
      print("getStates result" + json.decode(response.body).toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          List<StateLocation> cities = List<StateLocation>.from(json
              .decode(response.body)["data"]
              .map((e) => StateLocation.fromMap(e)));

          cities.sort((a, b) => a.name.compareTo(b.name));
          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: cities));

        default:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.error));
      }
    });
  }

  Future<WebServiceResult<String>> contactUs(Contact contact) {
    return appClient.contactUs(contact).then((response) {
      print("contactUs code" + response.statusCode.toString());
      print("contactUs result" + json.decode(response.body).toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success,
              data: (json.decode(response.body)["status_message"])));

        default:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.error));
      }
    });
  }

  Future<WebServiceResult<String>> createCoupon(Coupon coupon) {
    return appClient.createCoupon(coupon, MyApp.token).then((response) {
      print("createCoupon code" + response.statusCode.toString());
      print("createCoupon result" + json.decode(response.body).toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success,
              data: (json.decode(response.body)["status_message"])));
        case WebServiceCodeStatus.errorItem:

        default:
          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.error,
              data: errorMsgWs(response)));
      }
    });
  }

  Future<WebServiceResult<String>> deleteCoupon(int coupon) {
    return appClient.deleteCoupon(coupon, MyApp.token).then((response) {
      print("deleteCoupon code" + response.statusCode.toString());
      print("deleteCoupon result" + json.decode(response.body).toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success,
              data: (json.decode(response.body)["status_message"])));
        case WebServiceCodeStatus.errorItem:

        default:
          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.error,
              data: errorMsgWs(response)));
      }
    });
  }

  Future<WebServiceResult<List<Coupon>>> getListingCoupons(int listingId) {
    return appClient.getListingCoupons(listingId, MyApp.token).then((response) {
      print("getListingCoupons code" + response.statusCode.toString());
      print("getListingCoupons result" + json.decode(response.body).toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          List<Coupon> coupons = List<Coupon>.from(
              json.decode(response.body)["data"].map((e) => Coupon.fromMap(e)));

          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: coupons));

        default:
          return Future.value(WebServiceResult.withMessage(
              status: WebServiceResultStatus.error,
              message: errorMsgWs(response)));
      }
    });
  }

  Future<WebServiceResult<List<SavedListing>>> mySavedListings() {
    return appClient.mySavedListings(MyApp.token).then((response) {
      print("mySavedListings code" + response.statusCode.toString());
      print("mySavedListings result" + json.decode(response.body).toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          List<SavedListing> savedListings = List<SavedListing>.from(json
              .decode(response.body)["data"]
              .map((e) => SavedListing.fromMap(e)));

          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: savedListings));

        default:
          return Future.value(WebServiceResult.withMessage(
              status: WebServiceResultStatus.error,
              message: errorMsgWs(response)));
      }
    });
  }

  Future<WebServiceResult<String>> updateCoupon(Coupon coupon) {
    return appClient.updateCoupon(coupon, MyApp.token).then((response) {
      print("updateCoupon code" + response.statusCode.toString());
      print("updateCoupon result" + json.decode(response.body).toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success,
              data: (json.decode(response.body)["status_message"])));

        default:
          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.error,
              data: errorMsgWs(response)));
      }
    });
  }

  Future<WebServiceResult<String>> updateAnnouncement(
      Announcement announcement) {
    return appClient
        .updateAnnouncement(announcement, MyApp.token)
        .then((response) {
      print("updateAnnouncement code" + response.statusCode.toString());
      print(
          "updateAnnouncement result" + json.decode(response.body).toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success,
              data: (json.decode(response.body)["status_message"])));

        default:
          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.error,
              data: errorMsgWs(response)));
      }
    });
  }

  Future<WebServiceResult<String>> createAnnouncement(
      Announcement announcement) {
    return appClient
        .createAnnouncement(announcement, MyApp.token)
        .then((response) {
      print("createAnnouncement code" + response.statusCode.toString());
      print(
          "createAnnouncement result" + json.decode(response.body).toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success,
              data: (json.decode(response.body)["status_message"])));
        case WebServiceCodeStatus.errorItem:

        default:
          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.error,
              data: errorMsgWs(response)));
      }
    });
  }

  Future<WebServiceResult<List<Announcement>>> getListingAnnoucement(
      int listingId) {
    return appClient
        .getListingAnnouncement(listingId, MyApp.token)
        .then((response) {
      print("getListingCoupons code" + response.statusCode.toString());
      print("getListingCoupons result" + json.decode(response.body).toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          List<Announcement> announcements = List<Announcement>.from(json
              .decode(response.body)["data"]
              .map((e) => Announcement.fromMap(e)));

          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: announcements));

        default:
          return Future.value(WebServiceResult.withMessage(
              status: WebServiceResultStatus.error,
              message: errorMsgWs(response)));
      }
    });
  }

  Future<WebServiceResult<String>> deleteAnnouncement(int id) {
    return appClient.deleteAnnouncement(id, MyApp.token).then((response) {
      print("deleteCoupon code" + response.statusCode.toString());
      print("deleteCoupon result" + json.decode(response.body).toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success,
              data: (json.decode(response.body)["status_message"])));
        case WebServiceCodeStatus.errorItem:

        default:
          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.error,
              data: errorMsgWs(response)));
      }
    });
  }

  Future<WebServiceResult<String>> createEvent(Event event) {
    return appClient.createEvent(event, MyApp.token).then((response) {
      print("createEvent code" + response.statusCode.toString());
      print("createEvent result" + json.decode(response.body).toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success,
              data: (json.decode(response.body)["status_message"])));
        case WebServiceCodeStatus.errorItem:

        default:
          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.error,
              data: errorMsgWs(response)));
      }
    });
  }

  Future<WebServiceResult<String>> updateEvent(Event event) {
    return appClient.updateEvent(event, MyApp.token).then((response) {
      print("updateEvent code" + response.statusCode.toString());
      print("updateEvent result" + json.decode(response.body).toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success,
              data: (json.decode(response.body)["status_message"])));

        default:
          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.error,
              data: errorMsgWs(response)));
      }
    });
  }

  Future<WebServiceResult<List<Event>>> getListingEvents() {
    return appClient.getListingEvents(MyApp.token).then((response) {
      print("getListingEvents code" + response.statusCode.toString());
      print("getListingEvents result" + json.decode(response.body).toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          List<Event> events = [];

          // try {
          events = List<Event>.from(json
              .decode(response.body)["data"]["Pending"]
              .map((e) => Event.fromMyCollectionMap(e)));

          // ignore: empty_catches
          //  } catch (r) {
          //   print(r);
          //}
          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: events));

        default:
          return Future.value(WebServiceResult.withMessage(
              status: WebServiceResultStatus.error,
              message: errorMsgWs(response)));
      }
    });
  }

  Future<WebServiceResult<String>> deleteEvent(int event) {
    return appClient.deleteEvent(event, MyApp.token).then((response) {
      print("deleteEvent code" + response.statusCode.toString());
      print("deleteEvent result" + json.decode(response.body).toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success,
              data: (json.decode(response.body)["status_message"])));
        case WebServiceCodeStatus.errorItem:

        default:
          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.error,
              data: errorMsgWs(response)));
      }
    });
  }
}

String errorMsgWs(response) {
  List<ErrorString> errors = [];

  try {
    errors = List<ErrorString>.from(json
        .decode(response.body)["errors"]
        .map((e) => ErrorString.fromMap(e)));
  } catch (r) {}

  return errors.isNotEmpty
      ? errors.first.message
      : MyApp.resources.strings.errorWS;
}
