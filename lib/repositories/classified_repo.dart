import 'package:rakwa/client/classified_client.dart';
import 'package:rakwa/model/classfield_to_ws.dart';
import 'package:rakwa/model/classified.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'dart:convert';

class ClassifiedRepo {
  ClassifiedClient classifiedClient = ClassifiedClient();

  Future<WebServiceResult<Classified>> detailClassified(int classifiedId) {
    return classifiedClient.detailClassified(classifiedId).then((response) {
      print("classified detail code" + response.statusCode.toString());
      print("classified detail result" + json.decode(response.body).toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          Classified classified =
              Classified.fromMap(json.decode(response.body)["data"]);

          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: classified));

        default:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.error));
      }
    });
  }

  Future<WebServiceResult<List<Classified>>> classifiedList(
      String lat, String lng) {
    return classifiedClient.classifiedList(lat, lng).then((response) {
      print("classified list code" + response.statusCode.toString());
      print("classified list result" + json.decode(response.body).toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          var data = jsonDecode(response.body)["data"];
          List<Classified> classified =
              List<Classified>.from(data.map((x) => Classified.fromMap(x)));

          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: classified));

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

  Future<WebServiceResult<List<Classified>>> myClassified() {
    return classifiedClient.myClassified().then((response) {
      print("classified list code" + response.statusCode.toString());
      print("classified list result" + json.decode(response.body).toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          var data = jsonDecode(response.body)["data"];
          List<Classified> classified =
              List<Classified>.from(data.map((x) => Classified.fromMap(x)));

          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: classified));

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

  Future<WebServiceResult<Classified>> getClassifieldById(int id) {
    return classifiedClient.getClassifieldById(id).then((response) {
      print("classified by id code" + response.statusCode.toString());
      print("classified by id result" + json.decode(response.body).toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          var data = jsonDecode(response.body)["data"];
          Classified classified = Classified.fromMap(data);

          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: classified));

        case WebServiceCodeStatus.badRequest:
          return Future.value(WebServiceResult(
            code: 1,
            status: WebServiceResultStatus.error,
          ));
        default:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.error));
      }
    });
  }

  Future<WebServiceResult<String>> deleteClassified(String classifiedId) {
    return classifiedClient.deleteClassified(classifiedId).then((response) {
      print("delete classified code" + response.body.toString());
      print("delete classieid result" +
          json.decode(response.body)["status_message"].toString());

      String msg =
          (json.decode(response.body)["status_message"] ?? "").toString();
      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: msg));

        case WebServiceCodeStatus.badRequest:
          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.error, data: msg));
        default:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.error));
      }
    });
  }

  Future<WebServiceResult<String>> classified(ClassifiedToWs classified) {
    return classifiedClient.classified(classified).then((response) {
      print("add classified code" + response.body.toString());
      print("add classieid result" +
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
              message: "classified id incorrect !"));
        default:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.error));
      }
    });
  }
}
