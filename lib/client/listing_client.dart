import 'dart:io';

import 'package:rakwa/client/requests/listing_request.dart';
import 'package:http/http.dart' as http;
import 'package:rakwa/client/client.dart' as client;
import 'package:rakwa/main.dart';
import 'package:rakwa/model/add_review.dart';
import 'package:rakwa/model/listing/claim_model.dart';

import 'end_points.dart';

class ListingClient extends client.Client implements ListingRequests {
  @override
  Future<http.Response> detail(String listingId, String token) {
    Map<String, String> headerToken = {"token": token};
    Map<String, String> params = {"listing_id": listingId};

    return get(EndPoints.listingDetail, params: params, headers: headerToken);
  }

  @override
  Future<http.Response> getReviews(String listingId, String token) {
    Map<String, String> headerToken = {"token": token};
    Map<String, String> params = {"listing_id": listingId};

    return get(EndPoints.review, params: params, headers: headerToken);
  }

  Future<http.Response> editReview(AddReview addReview, String token) {
    Map<String, String> headerToken = {"token": token};
    return put(EndPoints.review, body: addReview.toMap(), headers: headerToken);
  }

  @override
  Future<http.Response> deleteReview(
      String listingId, String reviewId, String token) {
    Map<String, String> headerToken = {"token": token};
    Map<String, String> params = {
      "listing_id": listingId,
      "review_id": reviewId
    };
    print(token);
    print(params);

    return delete(EndPoints.review,
        body: params, headers: headerToken, isQuery: true);
  }

  @override
  Future<http.Response> myListings(String token) {
    return get(EndPoints.myListings, headers: {"token": token});
  }

  @override
  Future<http.Response> deleteListing(String listingId, String token) {
    Map<String, String> headerToken = {"token": token};
    Map<String, String> params = {"listing_id": listingId};

    return delete(EndPoints.listings,
        body: params, headers: headerToken, isQuery: true);
  }

  Future<http.Response> eventParticipate(
      String eventId, String participation, String token) {
    Map<String, String> headerToken = {"token": token};
    Map<String, String> params = {
      "event_id": eventId,
      "participation": participation
    };
    return post(EndPoints.eventParticipate, body: params, headers: headerToken);
  }

  @override
  Future<http.Response> myReviews(String token) {
    return get(EndPoints.myReviews, headers: {"token": token});
  }

  Future<http.Response> allListings(double lat, double long, int page) {
    return getPath(EndPoints.allListings(lat, long, page),
        headers: {"token": MyApp.token});
  }

  Future<http.Response> claimListing(ClaimModel claimModel, String token) {
    Map<String, String> headerToken = {"token": token};
    return post(EndPoints.claimListing,
        body: claimModel.toMap(), headers: headerToken);
  }

  Future<http.Response> updateListingHours(Map<String, dynamic> data) {
    Map<String, String> headerToken = {"token": MyApp.token};
    return put(EndPoints.listingDetail,
        body: data, headers: headerToken);
  }

  @override
  Future<http.Response> addListing(
      bool create, Map<String, dynamic> data, Map<String, File> media) {
    return multiPart(EndPoints.listingDetail,
        action: create ? "POST" : "PUT",
        body: data,
        multipart: true,
        namedFiles: media,
        headers: {"token": MyApp.token});
  }
}
