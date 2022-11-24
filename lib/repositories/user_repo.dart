import 'dart:convert';

import 'package:rakwa/client/user_client.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/login.dart';
import 'package:rakwa/model/profile.dart';
import 'package:rakwa/model/update_pwd.dart';
import 'package:rakwa/model/user.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/utils/pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepo {
  UserClient userClient = UserClient();

  Future<WebServiceResult<User>> login(Login login) {
    return userClient.login(login).then((response) {
      print("login code" + response.statusCode.toString());
      print("login result" + json.decode(response.body)["user"].toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          User user = User.fromMap(json.decode(response.body)["user"]);
          SharedPreferences.getInstance().then((prefs) =>
              prefs.setString(PrefKeys.user, user.toJson().toString()));

          MyApp.fireRepo.loginUserFcm(user.id);

          /*
          if (user.activated) {
          } else {
            return Future.value(
                WebServiceResult(status: WebServiceResultStatus.error));
          }
          */
          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: user));

        case WebServiceCodeStatus.unauthorized:
          return Future.value(WebServiceResult.withMessage(
              status: WebServiceResultStatus.error,
              message: "Email or password incorrect"));

        default:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.error));
      }
    });
  }

  Future<WebServiceResult<String>> register(User user) {
    return userClient.register(user).then((response) {
      print("register code" + response.statusCode.toString());
      print("register result" + json.decode(response.body)["data"].toString());

      if (response.statusCode == 421) {
        return Future.value(WebServiceResult.withMessage(
            message: "Email address already exist",
            status: WebServiceResultStatus.error));
      } else {
        switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
          case WebServiceCodeStatus.success:
            return Future.value(WebServiceResult(
                status: WebServiceResultStatus.success,
                data:
                    "An email has been sent to the entered email, to confirm the account"));

          default:
            return Future.value(
                WebServiceResult(status: WebServiceResultStatus.error));
        }
      }
    });
  }

  Future<WebServiceResult<String>> forgetPwd(String email) {
    return userClient.forgetPwd(email).then((response) {
      print("forgetPwd code" + response.statusCode.toString());
      print("forgetPwd result" + json.decode(response.body)["code"].toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success,
              data: json.decode(response.body)["message"]));

        case WebServiceCodeStatus.errorItem:
          return Future.value(WebServiceResult.withMessage(
              status: WebServiceResultStatus.error,
              message: json.decode(response.body)["message"]));

        default:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.error));
      }
    });
  }

  Future<WebServiceResult<UserProfile>> profile(String token) {
    return userClient.profile(token).then((response) {
      print("profile code" + response.statusCode.toString());
      print("profile result" + json.decode(response.body)["data"].toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          UserProfile userProfile =
              UserProfile.fromMap(json.decode(response.body)["data"]);

          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: userProfile));

        case WebServiceCodeStatus.unauthorized:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.unauthorized));
        default:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.error));
      }
    });
  }

  Future<WebServiceResult<bool>> updateProfile(String token, UserProfile user) {
    return userClient.updateProfile(token, user).then((response) {
      print("updateProfile code" + response.statusCode.toString());
      print("updateProfile result" + response.body.toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          String? image = json.decode(response.body)["data"]["image"];
          SharedPreferences.getInstance().then((prefs) {
            String? data = prefs.getString(PrefKeys.user);
            User? userPref;

            if (data != null) {
              userPref = User.fromMap(json.decode(data));
              userPref.username = user.email;
              userPref.firstname = user.firstname;
              userPref.lastname = user.lastname;
              if (image != null) userPref.image = image;
              userPref.phone = user.phone;
              MyApp.userConnected?.username = user.email;
              MyApp.userConnected?.firstname = user.firstname;
              MyApp.userConnected?.lastname = user.lastname;
              if (image != null) MyApp.userConnected?.image = image;
              MyApp.userConnected?.phone = user.phone;
              prefs.setString(PrefKeys.user, userPref.toJson().toString());
            }
          });

          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: true));

        case WebServiceCodeStatus.unauthorized:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.unauthorized));
        default:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.error));
      }
    });
  }

  Future<WebServiceResult<bool>> updatePassword(
      String token, UpdatePassword pwd) {
    return userClient.updatePassword(token, pwd).then((response) {
      print("updateProfile code" + response.statusCode.toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: true));

        case WebServiceCodeStatus.unauthorized:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.unauthorized));

        default:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.error));
      }
    });
  }

  Future<WebServiceResult<bool>> logout() {
    return userClient.logout(MyApp.token).then((response) {
      print("logout code" + response.statusCode.toString());
      print("logout body" + response.body.toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: true));

        case WebServiceCodeStatus.unauthorized:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.unauthorized));
        default:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.unauthorized));
      }
    });
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();

    String? data = prefs.getString(PrefKeys.user);
    User? user;
    if (data != null) {
      user = User.fromMap(json.decode(data));
    }

    return user?.token ?? "";
  }
}
