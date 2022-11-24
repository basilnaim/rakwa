import 'dart:io';

class ListingMedia {
  List<File> galleryPictures = [];
  List<File> galleryVideos = [];
  File? coverImage;
  File? image;
  int nbrGalleryPictures = 0;
  int nbrGalleryVideos = 0;
  bool hasCoverImage = false;
  bool hasImage = false;
  bool hasVideo = false;
  ListingMedia({
    this.galleryPictures = const [],
    this.galleryVideos = const [],
    this.coverImage ,
    this.image,
    this.nbrGalleryPictures = 0,
    this.nbrGalleryVideos=0,
    this.hasCoverImage=false,
    this.hasImage=false,
    this.hasVideo=false,
  });
}
