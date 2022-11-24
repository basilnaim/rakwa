import 'package:rakwa/client/ad_client.dart';
import 'package:rakwa/model/ad_container.dart';
import 'package:rakwa/model/ad_level.dart';
import 'package:rakwa/model/city.dart';
import 'package:rakwa/model/createAds.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'dart:convert';

import 'app_repo.dart';

class AdRepo {
  AdClient adClient = AdClient();

  Future<WebServiceResult<List<AdLevel>>> getLevels(int type) {
    return adClient.getLevels(type).then((response) {
      print("getLevels code" + response.statusCode.toString());
      print("getLevels result" + json.decode(response.body).toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          List<AdLevel> levels = List<AdLevel>.from(json
              .decode(response.body)["data"]
              .map((e) => AdLevel.fromMap(e)));

          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: levels));

        default:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.error));
      }
    });
  }

  Future<WebServiceResult<String>> createAd(AdCampaigns ads) {
    return adClient.createAd(ads).then((response) {
      print("createAd code" + response.statusCode.toString());
      print("createAd result" + json.decode(response.body).toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success,
              data: (json.decode(response.body)["status_message"])));
        case WebServiceCodeStatus.errorItem:

        default:
          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.error,
              data: errorMsgWs(response)));
      }
    });
  }

  Future<WebServiceResult<String>> updateAd(AdCampaigns ads) {
    return adClient.updateAd(ads).then((response) {
      print("createAd code" + response.statusCode.toString());
      print("createAd result" + json.decode(response.body).toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success,
              data: (json.decode(response.body)["status_message"])));
        case WebServiceCodeStatus.errorItem:

        default:
          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.error,
              data: errorMsgWs(response)));
      }
    });
  }

  Future<WebServiceResult<String>> removeAd(int id) {
    return adClient.removeAd(id).then((response) {
      print("removeAd code" + response.statusCode.toString());
      print("removeAd result" + json.decode(response.body).toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success,
              data: (json.decode(response.body)["status_message"])));
        case WebServiceCodeStatus.errorItem:

        default:
          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.error,
              data: errorMsgWs(response)));
      }
    });
  }

  Future<WebServiceResult<List<AdCampaigns>>> getAds() {
    return adClient.getAds().then((response) {
      print("getAds code" + response.statusCode.toString());
      print("getAds result" + json.decode(response.body).toString());

      switch (WebServiceCodeStatusExtension.decode(response.statusCode)) {
        case WebServiceCodeStatus.success:
          AdContainer container =
              AdContainer.fromMap(json.decode(response.body)["data"]);
          List<AdCampaigns> adsCampaigns = [];
          adsCampaigns.addAll(container.Ads);
          adsCampaigns.addAll(container.Banner);

          return Future.value(WebServiceResult(
              status: WebServiceResultStatus.success, data: adsCampaigns));

        default:
          return Future.value(
              WebServiceResult(status: WebServiceResultStatus.error));
      }
    });
  }
}
