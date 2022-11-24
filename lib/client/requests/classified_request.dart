import "package:http/http.dart";
import 'package:rakwa/model/classfield_to_ws.dart';

abstract class ClassifiedRequest {
  Future<Response> detailClassified(int classifiedId);
  Future<Response> classifiedList(String lat, String lng);
  Future<Response> myClassified();
  Future<Response> getClassifieldById(int id);
  Future<Response> deleteClassified(String classifiedId);
  Future<Response> classified(ClassifiedToWs classified);
}
