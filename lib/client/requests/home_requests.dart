import 'package:http/http.dart';
import 'package:rakwa/model/add_review.dart';
import 'package:rakwa/model/filter.dart';
import 'package:rakwa/model/home.dart';
import 'package:rakwa/model/likeModel.dart';

abstract class HomeRequests {
  Future<Response> home(HomeFields home, String token);
  Future<Response> categories(String module);
  Future<Response> likeDislike(LikeModel likeModel);
  Future<Response> filter(FilterModel filterModel);

  Future<Response> favorite(int listingId, int type, String token);
  Future<Response> templates(String token);
  Future<Response> formGenerator(int templateId);
  Future<Response> addReview(AddReview addReview, String token);
  Future<Response> discover(String page, String token);
  Future<Response> statistics(String token);
  Future<Response> modules();
  Future<Response> allEvents(String lat, String long, String token);
}
