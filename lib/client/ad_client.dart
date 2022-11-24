import 'package:http/http.dart' as http;
import 'package:rakwa/client/client.dart' as client;
import 'package:rakwa/client/end_points.dart';
import 'package:rakwa/client/requests/ad_request.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/createAds.dart';

class AdClient extends client.Client implements AdRequest {
  @override
  Future<http.Response> getLevels(int type) {
    return get(EndPoints.adsLevel,
        params: {"type": type.toString()}, headers: {"token": MyApp.token});
  }

  @override
  Future<http.Response> createAd(AdCampaigns ads) {
    return post(EndPoints.ads,
        body: ads.toMap(), headers: {"token": MyApp.token});
  }

  @override
  Future<http.Response> updateAd(AdCampaigns ads) {
    return put(EndPoints.ads,
        body: ads.toMap(), headers: {"token": MyApp.token});
  }

  @override
  Future<http.Response> getAds() {
    return get(EndPoints.ads, headers: {"token": MyApp.token});
  }

  @override
  Future<http.Response> removeAd(int id) {
    return delete(EndPoints.deleteAd(id),
        body: {"id": id.toString()}, headers: {"token": MyApp.token});
  }
}
