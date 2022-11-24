import 'dart:convert';

import 'package:rakwa/client/home_client.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/add_review.dart';
import 'package:rakwa/model/categorie.dart';
import 'package:rakwa/model/discover.dart';
import 'package:rakwa/model/filter.dart';
import 'package:rakwa/model/generic_form.dart';
import 'package:rakwa/model/home.dart';
import 'package:rakwa/model/likeModel.dart';
import 'package:rakwa/model/listing/listing_event.dart';
import 'package:rakwa/model/statistics.dart';
import 'package:rakwa/model/template.dart';
import 'package:rakwa/model/web_service_result.dart';

class HomeRepo {
  HomeClient homeClient = HomeClient();

  Future<WebServiceResult<Home>> home(HomeFields home, String token) {
    return homeClient.home(home, token).then((response) {
      print("home code" + response.statusCode.toString());
      print("home result" + json.decode(response.body)["data"].toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          Home home = Home.fromMap(json.decode(response.body)["data"]);

          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: home));

        case WebServiceCodeStatus.unauthorized:
          return Future.value(WebServiceResult.withMessage(
              status: WebServiceResultStatus.error,
              message: "Username or password incorrect !"));

        case WebServiceCodeStatus.notFound:
          return Future.value(WebServiceResult.withMessage(
              status: WebServiceResultStatus.error, message: "404"));
        default:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.error));
      }
    });
  }

  Future<WebServiceResult<List<CategorieModel>>> categories(String module) {
    return homeClient.categories(module).then((response) {
      print("categories code" + response.statusCode.toString());
  
      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          var data = jsonDecode(response.body)["data"];

          List<CategorieModel> categories = List<CategorieModel>.from(
              data.map((x) => CategorieModel.fromMap(x)));

          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: categories));

        case WebServiceCodeStatus.unauthorized:
          return Future.value(WebServiceResult.withMessage(
              status: WebServiceResultStatus.error,
              message: "Username or password incorrect !"));

        default:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.error));
      }
    });
  }

  Future<WebServiceResult<List<LikeResponse>>> likeDislike(
      LikeModel likeModel) {
    return homeClient.likeDislike(likeModel).then((response) {
      print("likeDislike code" + response.body.toString());
      print(
          "likeDislike result" + json.decode(response.body)["data"].toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          var data = jsonDecode(response.body)["data"];

          List<LikeResponse> likeDislike =
              List<LikeResponse>.from(data.map((x) => LikeResponse.fromMap(x)));

          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: likeDislike));

        case WebServiceCodeStatus.unauthorized:
          return Future.value(WebServiceResult.withMessage(
              status: WebServiceResultStatus.error,
              message: "Username or password incorrect !"));

        default:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.error));
      }
    });
  }

  Future<WebServiceResult<FilterResponse>> filter(FilterModel filterModel) {
    return homeClient.filter(filterModel).then((response) {
      print("filter request" + filterModel.toMap().toString());
      print("filter code" + response.statusCode.toString());
      //  print("filter result" + json.decode(response.body).toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          FilterResponse filterResponse =
              FilterResponse.fromMap(json.decode(response.body)["data"]);

          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: filterResponse));

        case WebServiceCodeStatus.unauthorized:
          return Future.value(WebServiceResult.withMessage(
              status: WebServiceResultStatus.error,
              message: "fiter fields incorrect !"));

        default:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.error));
      }
    });
  }

  Future<WebServiceResult<String>> favorite(
      int listingId, int type, String token) {
    return homeClient.favorite(listingId, type, token).then((response) {
      print("favorite code" + response.body.toString());
      print("favorite result" +
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
              message: "fiter fields incorrect !"));

        default:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.error));
      }
    });
  }

  Future<WebServiceResult<List<Template>>> templates() {
    return homeClient.templates(MyApp.token).then((response) {
      print("templates code" + response.statusCode.toString());
      print("templates result" + json.decode(response.body).toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          var data = jsonDecode(response.body)["data"];
          List<Template> templates =
              List<Template>.from(data.map((x) => Template.fromMap(x)));

          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: templates));

        case WebServiceCodeStatus.unauthorized:
          return Future.value(WebServiceResult(
            status: WebServiceResultStatus.error,
          ));

        default:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.error));
      }
    });
  }

  Future<WebServiceResult<String>> addReview(
      AddReview addReview, String token) {
    return homeClient.addReview(addReview, token).then((response) {
      print("add review code" + response.body.toString());
      print(
          "add review result" + json.decode(response.body)["data"].toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          var data = jsonDecode(response.body)["data"];

          String addReview =
              json.decode(response.body)["status_message"].toString();

          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: addReview));

        case WebServiceCodeStatus.unauthorized:
          return Future.value(WebServiceResult.withMessage(
              status: WebServiceResultStatus.error,
              message: "Username or password incorrect !"));

        default:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.error));
      }
    });
  }

  Future<WebServiceResult<List<GenericForm>>> formGenerator(int templateId) {
    return homeClient.formGenerator(templateId).then((response) {
      print("formGenerator code $templateId" + response.statusCode.toString());
      print("formGenerator result" + json.decode(response.body).toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          var data = jsonDecode(response.body);

          List<GenericForm> genericForms =
              List<GenericForm>.from(data.map((x) => GenericForm.fromMap(x)));

          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: genericForms));

        default:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.error));
      }
    });
  }

  Future<WebServiceResult<DiscoverBody>> discover(String page, String token) {
    return homeClient.discover(page, token).then((response) {
      print("discover code" + response.statusCode.toString());
      print("discover result" + json.decode(response.body)["data"].toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          DiscoverBody discoverBody =
              DiscoverBody.fromMap(json.decode(response.body)["data"]);
          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: discoverBody));

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

  Future<WebServiceResult<Statistics>> statistics(String token) {
    return homeClient.statistics(token).then((response) {
      print("statistics code" + response.statusCode.toString());
      print(
          "statistics result" + json.decode(response.body)["data"].toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          Statistics statistics =
              Statistics.fromMap(json.decode(response.body)["data"]);
          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: statistics));

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

  Future<WebServiceResult<Map<String, List<CategorieModel>>>> modules() {
    return homeClient.modules().then((response) {
      print("modules code" + response.statusCode.toString());
      print("modules result" + json.decode(response.body)["data"].toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          Map<String, List<CategorieModel>> models = {};
          try {
            Map<String, dynamic>.from(json.decode(response.body)["data"])
                .forEach((key, value) {
              models.putIfAbsent(
                  key,
                  () => List<CategorieModel>.from(
                      value.map((x) => CategorieModel.fromMap(x))));
            });
          } catch (e) {
            print(e);
          }

          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: models));

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

  Future<WebServiceResult<List<ListingEvent>>> allEvents(
      String lat, String long, String token) {
    return homeClient.allEvents(lat, long, token).then((response) {
      print("all events code" + response.statusCode.toString());
      print("all events msg" + response.body.toString());
      print(
          "all events result" + json.decode(response.body)["data"].toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          var data = jsonDecode(response.body)["data"];

          List<ListingEvent> events =
              List<ListingEvent>.from(data.map((x) => ListingEvent.fromMap(x)));

          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: events));

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
}
