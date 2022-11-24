import 'dart:convert';

import 'package:rakwa/res/images/MyImages.dart';

class ListingContact {
  String website;
  String phone;
  Map<SocialMedia, String> socialMedia;
  ListingContact({
    this.website = "",
    this.phone = "",
    required this.socialMedia ,
  });
}

enum SocialMedia { facebook, tweeter, instagram, linkedin }

extension SocialMediaValues on SocialMedia {
  SocialMedia fromString(String value) {
    switch (value) {
      case 'facebook':
        return SocialMedia.facebook;
      case 'instagram':
        return SocialMedia.instagram;
      case 'twitter':
        return SocialMedia.tweeter;
      default:
        return SocialMedia.linkedin;
    }
  }

  String label() {
    switch (this) {
      case SocialMedia.facebook:
        return "Facebook";
      case SocialMedia.tweeter:
        return 'Twitter';
      case SocialMedia.instagram:
        return "Instagram";
      case SocialMedia.linkedin:
        return "LinkedIn";
    }
  }

  String icon() {
    switch (this) {
      case SocialMedia.facebook:
        return MyImages.facebook;
      case SocialMedia.tweeter:
        return MyImages.facebook;
      case SocialMedia.instagram:
        return MyImages.insta;
      case SocialMedia.linkedin:
        return MyImages.linkedin;
    }
  }
}
