abstract class EndPoints {
  // user endpoints
  static const String login = "login";
  static const String register = "register";
  static const String forgetPwd = "password/email";
  static const String profile = "/home/user/profile";
  static const String updatePwd = "password/reset";
  static const String logout = "logout";

  // home endpoints
  static const String home = "/home";
  static const String categories = "/home/categories";
  static const String favorite = "/home/reaction/favorite";
  static const String likeDislike = "/home/reaction/like-dislike";
  static const String filter = "/home/search/filter";
  static const String review = "/home/listing-review";
  static const String listingDetail = "/home/listing";
  static const String discover = "/home/Discover";

  // app endpoints
  static const String states = "/home/location-state";
  static const String cities = "/home/location-city";

  //listing
  static const String tamplates = "/home/listing/tamplates";
  static const String myListings = "/home/listings/my-collection";
  static String blueprint(int template_id) =>
      "/home/listing/blueprint?template_id=$template_id";
  static const String listings = "/home/listings";
  static String allListings(double lat, double long, int page) =>
      "/home/listings?lat=$lat&long=$long&page=$page&status=A";
  static const String claimListing = "/home/listing/claim";

  //events
  static const String eventParticipate = "/home/event/participate";

  //statistics
  static const String statistics = "/home/user/statistics";

  //classified
  static const String classified = "/home/classified";
  static const String classifiedList = "/home/classified/list";
  static const String myClassified = "/home/classified/my-list";

  //contact us
  static const String contactUs = "/ContactUs";

  //coupons
  static const String coupon = "/home/coupons";
  static String deleteCoupon(int couponId) => "$coupon?coupon_id=$couponId";

  //events
  static const String event = "/home/event";
  static const String allEvents = "/home/events";
  static String allEventsQuery(lat, lng) => "/home/events?lat=$lat&long=$lng";

  static const String myEvent = "/home/events/my-collection";
  static String deleteEvent(int eventId) => "$event?id=$eventId";

  //annoucements
  static const String annoucement = "/home/annoucements";
  static const String annoucementList = "/home/annoucements/my-collection";
  static String deleteAnnoucement(int annoucementId) =>
      "$annoucement?announcement_id=$annoucementId";

  //ads
  static const String adsLevel = '/home/ad-campaigns/levels';
  static const String ads = '/home/ad-campaigns';

  static String deleteAd(int id) => "$ads?id=$id";

  //reviews
  static const String myReviews = "/home/my-reviews";

  static const String modules = "/home/search/modules-categories";
}
