import "package:http/http.dart";
import 'package:rakwa/model/createAds.dart';

abstract class AdRequest {

  Future<Response> getLevels(int type);
  Future<Response> createAd(AdCampaigns ads);
  Future<Response> updateAd(AdCampaigns ads);
  Future<Response> getAds();
  Future<Response> removeAd(int id);
}
