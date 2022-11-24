import 'package:http/http.dart' as http;
import 'package:rakwa/client/client.dart' as client;
import 'package:rakwa/client/end_points.dart';
import 'package:rakwa/client/requests/user_requests.dart';
import 'package:rakwa/model/login.dart';
import 'package:rakwa/model/profile.dart';
import 'package:rakwa/model/update_pwd.dart';
import 'package:rakwa/model/user.dart';

class UserClient extends client.Client implements UserRequest {
  @override
  Future<http.Response> login(Login login) {
    return post(EndPoints.login, body: login.toMap());
  }

  @override
  Future<http.Response> register(User user) {
    return post(EndPoints.register, body: user.toRegisterMap());
  }

  @override
  Future<http.Response> forgetPwd(String email) {
    return post(EndPoints.forgetPwd, body: {"email": email});
  }

  @override
  Future<http.Response> profile(String token) {
    return get(EndPoints.profile, headers: {"token": token});
  }

  @override
  Future<http.Response> updateProfile(String token, UserProfile user) {
    return multiPart(EndPoints.profile,
        headers: {"token": token},
        files: user.imageFile == null ? [] : [user.imageFile!],
        body: user.toMap());
  }

  @override
  Future<http.Response> updatePassword(
      String token, UpdatePassword updatePassword) {
    return put(EndPoints.updatePwd,
        headers: {"token": token}, body: updatePassword.toMap());
  }

  @override
  Future<http.Response> logout(String token) {
    return post(EndPoints.logout, isQuery: true, headers: {"token": token});
  }
}
