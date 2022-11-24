import 'dart:io';
import 'package:http/http.dart';
import 'package:rakwa/model/add_review.dart';
import 'package:rakwa/model/listing/claim_model.dart';

abstract class ListingRequests {
  Future<Response> detail(String listingId, String token);
  Future<Response> getReviews(String listingId, String token);
  Future<Response> editReview(AddReview addReview, String token);
  Future<Response> deleteReview(
      String listingId, String reviewId, String token);

  Future<Response> myListings(String token);
  Future<Response> deleteListing(String listingId, String token);
  Future<Response> eventParticipate(
      String eventId, String participation, String token);
  Future<Response> myReviews(String token);
  Future<Response> allListings(double lat , double long , int page );
  Future<Response> claimListing(ClaimModel claimModel , String token );
  Future<Response> addListing(bool create,Map<String, dynamic> data, Map<String, File> media);
  Future<Response> updateListingHours(Map<String, dynamic> data);

}
