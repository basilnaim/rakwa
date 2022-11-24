import 'dart:convert';
import 'dart:io';

import 'package:rakwa/client/listing_client.dart';
import 'package:rakwa/model/add_review.dart';
import 'package:rakwa/model/listing.dart';
import 'package:rakwa/model/listing/claim_model.dart';
import 'package:rakwa/model/my_listing.dart';
import 'package:rakwa/model/my_reviews_model.dart';
import 'package:rakwa/model/review_result.dart';
import 'package:rakwa/model/web_service_result.dart';

import '../model/listing/all_listing.dart';

class ListingRepo {
  ListingClient listingClient = ListingClient();

  Future<WebServiceResult<Listing>> detail(String listingId, String token) {
    return listingClient.detail(listingId, token).then((response) {
      print("detail listing code" + response.statusCode.toString());
      print("detial listing result" +
          json.decode(response.body)["data"].toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          Listing listing = Listing.fromMap(json.decode(response.body)["data"]);

          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: listing));

        case WebServiceCodeStatus.notFound:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.error, code: 1));

        case WebServiceCodeStatus.unauthorized:
          return Future.value(WebServiceResult.withMessage(
              status: WebServiceResultStatus.error,
              message: "listing id incorrect !"));

        default:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.error));
      }
    });
  }

  Future<WebServiceResult<ReviewResult>> getReviews(
      String listingId, String token) {
    return listingClient.getReviews(listingId, token).then((response) {
      print("list reviews code" + response.statusCode.toString());
      print("list reviews result" +
          json.decode(response.body)["data"].toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          ReviewResult reviews =
              ReviewResult.fromMap(json.decode(response.body)["data"]);

          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: reviews));

        case WebServiceCodeStatus.unauthorized:
          return Future.value(WebServiceResult.withMessage(
              status: WebServiceResultStatus.error,
              message: "listing id incorrect !"));

        default:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.error));
      }
    });
  }

  Future<WebServiceResult<String>> editReview(
      AddReview addReview, String token) {
    return listingClient.editReview(addReview, token).then((response) {
      print("edit review code" + response.body.toString());
      print(
          "edit review result" + json.decode(response.body)["data"].toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          var data = jsonDecode(response.body)["data"];

          String addReview =
              json.decode(response.body)["status_message"].toString();

          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: addReview));

        default:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.error));
      }
    });
  }

  Future<WebServiceResult<List<Listing>>> myListings(String token) {
    return listingClient.myListings(token).then((response) {
      print("myListings code" + response.statusCode.toString());
      print("myListings result" + json.decode(response.body).toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          List<Listing> listings = [];

          try {
            listings.addAll(List<Listing>.from(json
                .decode(response.body)["data"]["Published"]
                .map((e) => Listing.fromMap(e))));
          } catch (r) {}

          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: listings));

        case WebServiceCodeStatus.unauthorized:
          return Future.value(WebServiceResult.withMessage(
              status: WebServiceResultStatus.error,
              message: "listing id incorrect !"));

        default:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.error));
      }
    });
  }

  Future<WebServiceResult<String>> deleteReview(
      String listingId, String reviewId, String token) {
    return listingClient
        .deleteReview(listingId, reviewId, token)
        .then((response) {
      print("delete review code" + response.body.toString());
      print("delete review result" +
          json.decode(response.body)["status_message"].toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          String statut =
              json.decode(response.body)["status_message"].toString();

          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: statut));

        case WebServiceCodeStatus.unauthorized:
          return Future.value(WebServiceResult.withMessage(
              status: WebServiceResultStatus.error,
              message: "review id incorrect !"));

        default:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.error));
      }
    });
  }

  Future<WebServiceResult<MyListingModel>> allMyListings(String token) {
    return listingClient.myListings(token).then((response) {
      print("myListings code" + response.statusCode.toString());
      print("myListings result" + json.decode(response.body).toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          print("ababababab ${json.decode(response.body)["data"]}");
          MyListingModel myListings =
              (json.decode(response.body)["data"].toString() == "[]")
                  ? MyListingModel()
                  : MyListingModel.fromMap(json.decode(response.body)["data"]);

          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: myListings));

        case WebServiceCodeStatus.unauthorized:
          return Future.value(WebServiceResult.withMessage(
              status: WebServiceResultStatus.error,
              message: "listing id incorrect !"));

        default:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.error));
      }
    });
  }

  Future<WebServiceResult<String>> deleteListing(
      String listingId, String token) {
    return listingClient.deleteListing(listingId, token).then((response) {
      print("delete listing code" + response.body.toString());
      print("delete listing result" +
          json.decode(response.body)["status_message"].toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          String statut =
              json.decode(response.body)["status_message"].toString();

          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: statut));

        case WebServiceCodeStatus.unauthorized:
          return Future.value(WebServiceResult.withMessage(
              status: WebServiceResultStatus.error,
              message: "listing id incorrect !"));

        default:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.error));
      }
    });
  }

  Future<WebServiceResult<String>> eventParticipate(
      String eventId, String participation, String token) {
    return listingClient
        .eventParticipate(eventId, participation, token)
        .then((response) {
      print("participation event code" + response.body.toString());
      print("participation event result" +
          json.decode(response.body)["status_message"].toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          String statut =
              json.decode(response.body)["status_message"].toString();

          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: statut));

        case WebServiceCodeStatus.unauthorized:
          return Future.value(WebServiceResult.withMessage(
              status: WebServiceResultStatus.error,
              message: "token incorrect !"));

        default:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.error));
      }
    });
  }

  Future<WebServiceResult<MyReviewsModel>> myReviews(String token) {
    return listingClient.myReviews(token).then((response) {
      print("myReviews code" + response.statusCode.toString());
      print("myReviews result" + json.decode(response.body).toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          MyReviewsModel myReviews =
              MyReviewsModel.fromMap(json.decode(response.body)["data"]);

          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: myReviews));

        case WebServiceCodeStatus.unauthorized:
          return Future.value(WebServiceResult.withMessage(
              status: WebServiceResultStatus.error,
              message: "reviews id incorrect !"));
        default:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.error));
      }
    });
  }

  Future<WebServiceResult<AllListing>> allListings(
      double lat, double long, int page) {
    return listingClient.allListings(lat, long, page).then((response) {
      print("all Listings code" + response.statusCode.toString());
      print("all Listings result" + json.decode(response.body).toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          AllListing listing =
              AllListing.fromMap(json.decode(response.body)["data"]);

          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: listing));

        case WebServiceCodeStatus.unauthorized:
          return Future.value(WebServiceResult.withMessage(
              status: WebServiceResultStatus.error,
              message: "listing id incorrect !"));

        default:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.error));
      }
    });
  }

  Future<WebServiceResult<String>> claimListing(
      ClaimModel claimModel, String token) {
    return listingClient.claimListing(claimModel, token).then((response) {
      print("claim listing code" + response.body.toString());
      print("claim listing result" +
          json.decode(response.body)["status_message"].toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          String statut =
              json.decode(response.body)["status_message"].toString();

          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: statut));

        case WebServiceCodeStatus.unauthorized:
          return Future.value(WebServiceResult.withMessage(
              status: WebServiceResultStatus.unauthorized,
              message: "token incorrect !"));

        default:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.error));
      }
    });
  }

  Future<WebServiceResult<String>> addListing(
      bool create, Map<String, dynamic> data, Map<String, File> media) {
    return listingClient.addListing(create, data, media).then((response) {
      print("addListing code" + response.statusCode.toString());
      print("addListing result" + json.decode(response.body).toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          String statut =
              json.decode(response.body)["status_message"].toString();

          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: statut));

        case WebServiceCodeStatus.unauthorized:
          return Future.value(WebServiceResult.withMessage(
              status: WebServiceResultStatus.error,
              message: "token incorrect !"));

        default:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.error));
      }
    });
  }

  Future<WebServiceResult<String>> updateHoursListing(
      String message, Map<String, dynamic> data) {
    return listingClient.updateListingHours(data).then((response) {
      print("updateHoursListing code" + response.body.toString());
      print(
          "updateHoursListing result" + json.decode(response.body).toString());

      return Future.value(WebServiceResult(
          status: WebServiceResultStatus.success, data: message));
    });
  }
}
