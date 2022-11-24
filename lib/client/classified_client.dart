import 'package:http/http.dart' as http;
import 'package:rakwa/client/client.dart' as client;
import 'package:rakwa/client/end_points.dart';
import 'package:rakwa/client/requests/classified_request.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/classfield_to_ws.dart';

class ClassifiedClient extends client.Client implements ClassifiedRequest {
  @override
  Future<http.Response> detailClassified(int classifiedId) {
    return get(EndPoints.classified,
        params: {"classified_id": classifiedId.toString()},
        headers: {"token": MyApp.token});
  }

  @override
  Future<http.Response> classifiedList(String lat, String lng) {
    Map<String, String> param = {"latitude": lat, "longitude": lng};
    return get(EndPoints.classifiedList,
        params: param, headers: {"token": MyApp.token});
  }

  @override
  Future<http.Response> myClassified() {
    return get(EndPoints.myClassified, headers: {"token": MyApp.token});
  }

  @override
  Future<http.Response> getClassifieldById(int id) {
    return get(EndPoints.classified,
        params: {"classified_id": id.toString()},
        headers: {"token": MyApp.token});
  }

  Future<http.Response> deleteClassified(String classifiedId) {
    Map<String, String> headerToken = {"token": MyApp.token};
    Map<String, String> params = {"classified_id": classifiedId};

    return delete(EndPoints.classified,
        body: params, headers: headerToken, isQuery: true);
  }

  @override
  Future<http.Response> classified(ClassifiedToWs classified) {
    return multiPart(EndPoints.classified,
        action: classified.id == 0 ? "POST" : "PUT",
        body: classified.toMap(),
        multipart: false,
        files: classified.image == null ? [] : [classified.image!],
        headers: {"token": MyApp.token});
  }
}
