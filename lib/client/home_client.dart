import 'package:http/http.dart' as http;
import 'package:rakwa/client/client.dart' as client;
import 'package:rakwa/client/end_points.dart';
import 'package:rakwa/client/requests/home_requests.dart';
import 'package:rakwa/model/add_review.dart';
import 'package:rakwa/model/filter.dart';
import 'package:rakwa/model/home.dart';
import 'package:rakwa/model/likeModel.dart';

import '../communs.dart';

class HomeClient extends client.Client implements HomeRequests {
  @override
  Future<http.Response> home(HomeFields home, String token) {
    Map<String, String> headerToken = {"token": token};
    return get(EndPoints.home, params: home.toMap(), headers: headerToken);
  }

  @override
  Future<http.Response> categories(String module) {
    Map<String, String> params = {"module": module};
    return get(EndPoints.categories, params: params);
  }

  @override
  Future<http.Response> likeDislike(LikeModel likeModel) {
    Map<String, String> headerToken = {
      "token":
          "MTIxMGJiMzExMWRlYjVkNjMwOTA2MThmYzNjY2UzMDAzZmJkOWJhZTE5MTYyNDJjMDk4NjdiNmU3YjRkNGIxOA"
    };
    return post(EndPoints.likeDislike,
        body: likeModel.toMap(), headers: headerToken);
  }

  @override
  Future<http.Response> filter(FilterModel filterModel) {
    return getPath(EndPoints.filter + toQuery(filterModel.toMap()));
  }

  @override
  Future<http.Response> favorite(int listingId, int type, String token) {
    Map<String, String> headerToken = {"token": token};
    Map<String, String> params = {"listing": listingId.toString()};

    if (type == 1) {
      return post(EndPoints.favorite,
          body: params, headers: headerToken, isQuery: true);
    } else {
      return delete(EndPoints.favorite,
          body: params, headers: headerToken, isQuery: true);
    }
  }

  @override
  Future<http.Response> templates(String token) {
    return get(EndPoints.tamplates, headers: {"token": token});
  }

  @override
  Future<http.Response> formGenerator(int templateId) {
    return getPath(EndPoints.blueprint(templateId));
  }

  Future<http.Response> addReview(AddReview addReview, String token) {
    Map<String, String> headerToken = {"token": token};
    return post(EndPoints.review,
        body: addReview.toMap(), headers: headerToken);
  }

  @override
  Future<http.Response> discover(String page, String token) {
    Map<String, String> param = {"page": page};

    return get(EndPoints.discover, headers: {"token": token}, params: param);
  }

  @override
  Future<http.Response> statistics(String token) {
    return get(EndPoints.statistics, headers: {"token": token});
  }

  @override
  Future<http.Response> modules() {
    return get(EndPoints.modules);
  }

  Future<http.Response> allEvents(String lat, String long, String token) {
    Map<String, String> param = {"lat": lat, "long": long};
    return get(EndPoints.allEvents, params: param, headers: {"token": token});
  }
}
