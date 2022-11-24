import 'package:rakwa/model/categorie.dart';
import 'package:rakwa/model/generic_form.dart';
import 'package:rakwa/model/houre_work_create.dart';
import 'package:rakwa/model/listing.dart';
import 'package:rakwa/model/listing/contact.dart';
import 'package:rakwa/model/listing/media.dart';
import 'package:rakwa/model/location.dart';

Map<String, dynamic> prepareAddListingRequest(
    String title,
    Listing listing,
    ListingMedia media,
    Location location,
    List<CategorieModel> listingCategories,
    ListingContact contact,
    List<GenericForm> form) {
  final result = <String, dynamic>{};
  if (listing.id > 0) {
    result.addAll({'listing_id': listing.id});
  }

  if (title != listing.title) {
    result.addAll({'title': listing.title});
  }
  result.addAll({'phone': contact.phone});
  result.addAll({'description': listing.description});
  result.addAll({'lat': location.lat});
  result.addAll({'long': location.long});
  result.addAll({'city_id': location.cityDownValue?.id ?? ""});
  result.addAll({'website_url': contact.website});
  result.addAll({'template_id': listing.templateId});
  result.addAll({'specialties': listing.specialities});
  result.addAll({'established_in': listing.establishedIn});
  result.addAll({'policies': listing.policies});
  result.addAll({'building_bridges': listing.buildingBridge});
  result.addAll({'business_owner_name': listing.ownerName});
  result.addAll({'business_owner_email	': listing.ownerEmail});

  List<HoureWorkCreate> houreWork = [];
  listing.hoursWork?.forEach((key, value) {
    if (value.selected) {
      houreWork.add(HoureWorkCreate(
          weekday: key.toString(),
          hours_end: value.end,
          hours_start: value.start));
    }
  });

  result.addAll({"hours_work": houreWork.map((x) => x.toMap()).toList()});
  List<Map<String, String>> socialNetwork = [];
  contact.socialMedia.forEach((key, value) {
    if (value.isNotEmpty) {
      socialNetwork.add({'"${key.label()}"': '"${value.split(' ')[0]}"'});
    }
  });
  result.addAll({'social_network': socialNetwork});
  result.addAll(
      {'category': listingCategories.map((e) => e.id).toList()}); //array
  form.forEach((element) {
    result.addAll(element.toMap());
  });

  return result;
}
