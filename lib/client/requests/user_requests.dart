import "package:http/http.dart";
import 'package:rakwa/model/login.dart';
import 'package:rakwa/model/profile.dart';
import 'package:rakwa/model/update_pwd.dart';
import 'package:rakwa/model/user.dart';


abstract class UserRequest {

  Future<Response> login(Login login);
  
  Future<Response> register(User user);

  Future<Response> forgetPwd(String email);

  Future<Response> profile(String token);

  Future<Response> logout(String token);

  Future<Response> updateProfile(String token,UserProfile user);

  Future<Response> updatePassword(String token,UpdatePassword updatePassword);

}
