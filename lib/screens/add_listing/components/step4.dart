import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/listing/media.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/views/bottom_btns.dart';
import 'package:rakwa/views/error_wrapper.dart';
import '../listing_screen.dart';

class AddListingStep4 extends StatefulWidget {
  ListingMedia media;
  AddListingStep4({Key? key, required this.media}) : super(key: key);

  @override
  State<AddListingStep4> createState() => _AddListingStep4State();
}

class _AddListingStep4State extends State<AddListingStep4> {
  bool imageError = false;
  bool imageCoverError = false;
  bool imageGalleryError = false;
  onNexClick() {
    imageError = false;
    imageCoverError = false;
    imageGalleryError = false;

    if (widget.media.image == null && !widget.media.hasImage) {
      imageError = true;
      setState(() {});
      return;
    }
    if (widget.media.coverImage == null && !widget.media.hasCoverImage) {
      imageCoverError = true;
      setState(() {});
      return;
    }
    if (widget.media.galleryPictures.isEmpty &&
        widget.media.nbrGalleryPictures == 0) {
      imageGalleryError = true;
      setState(() {});
      return;
    }
    ListingScreenState.bottomTabNavigation.moveToNext();
  }

  @override
  void initState() {
    super.initState();
  }

  final ImagePicker _picker = ImagePicker();

//from :
/* 0 : image
 * 1 : cover image
*/
  _chooseImageFromGallerie(int from) async {
    XFile? img = await _picker.pickImage(source: ImageSource.gallery);

    if (img != null) {
      if (from == 0) {
        widget.media.image = File(img.path);
        imageError = false;
      } else {
        imageCoverError = false;
        widget.media.coverImage = File(img.path);
      }

      setState(() {});
    }
  }

  _chooseMultiImageFromGallerie() async {
    List<XFile>? img = await _picker.pickMultiImage();

    if (img != null) {
      widget.media.galleryPictures = img.map((e) => File(e.path)).toList();
      imageGalleryError = false;
      widget.media.nbrGalleryPictures = img.length;

      setState(() {});
    }
  }

  _chooseMultiVideoFromGallerie() async {
    XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      widget.media.galleryVideos = [File(video.path)];
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              ErrorWrapper(
                error: (imageError) ? "pick an image" : "",
                contentWidget: buildImaheUploadContainer(
                    "Upload Image",
                    (widget.media.image != null || widget.media.hasImage)
                        ? 1
                        : 0, () {
                  _chooseImageFromGallerie(0);
                }),
              ),
              SizedBox(height: 8),
              ErrorWrapper(
                error: (imageCoverError) ? "pick a cover image" : "",
                contentWidget: buildImaheUploadContainer(
                    "Upload Cover Image",
                    widget.media.coverImage != null ||
                            widget.media.hasCoverImage
                        ? 1
                        : 0, () {
                  _chooseImageFromGallerie(1);
                }),
              ),
              SizedBox(height: 8),
              ErrorWrapper(
                error: (imageGalleryError) ? "pick images " : "",
                contentWidget: buildImaheUploadContainer(
                    "Upload Gallery Images", widget.media.nbrGalleryPictures,
                    () {
                  _chooseMultiImageFromGallerie();
                }),
              ),
              // SizedBox(height: 8),
              // buildImaheUploadContainer(
              //     "Upload Video",
              //     widget.media.galleryVideos.length,
              //     () => _chooseMultiVideoFromGallerie())
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 40, right: 40, top: 16, bottom: 16),
            //  width: double.infinity

            child: BottomButtons(
                neutralButtonText: "Previous",
                submitButtonText: "Next",
                neutralButtonClick: () {
                  Navigator.maybePop(context);
                },
                submitButtonClick: () => onNexClick()),
          ),
        ),
      ],
    );
  }

  Widget buildImaheUploadContainer(title, imageUploaded, onclick) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: MyApp.resources.color.grey1, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: Colors.white,
        child: InkWell(
          onTap: onclick,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(MyIcons.icCamera,
                    width: 24, height: 24, color: Colors.black),
                SizedBox(
                  width: 18,
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(color: MyApp.resources.color.black1),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "$imageUploaded pictures(s) to upload.",
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: MyApp.resources.color.orange, fontSize: 12),
                    ),
                  ],
                )),
                Container(
                  height: 46,
                  width: 46,
                  child: Center(
                      child: SvgPicture.asset(
                    MyIcons.icUpload,
                    color: Colors.white,
                    width: 24,
                    height: 24,
                  )),
                  decoration: BoxDecoration(
                      color: MyApp.resources.color.orange,
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
