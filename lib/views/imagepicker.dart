import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/res/icons/my_icons.dart';

class ImagePickerWidget extends StatefulWidget {
  String title;
  String error;
  Function(File? image) onImagePicked;

  ImagePickerWidget({
    Key? key,
    required this.title,
    required this.error,
    required this.onImagePicked,
  }) : super(key: key);

  @override
  State<ImagePickerWidget> createState() => ImagePickerWidgetState();
}

class ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? imageFile;

  final ImagePicker _picker = ImagePicker();

  _chooseImageFromGallerie() async {
    XFile? img = await _picker.pickImage(source: ImageSource.gallery);

    if (img != null) {
      imageFile = File(img.path);
      widget.error = "";
      widget.onImagePicked(imageFile);
      setState(() {});
    }
  }

  bool checkFilePicked() {
    if (imageFile == null) {
      widget.error = "pick an image";
      setState(() {});
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 90,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: widget.error.isNotEmpty
                      ? Colors.red
                      : MyApp.resources.color.grey1,
                  width: 1),
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Material(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: Colors.white,
            child: InkWell(
              onTap: () => _chooseImageFromGallerie(),
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
                          widget.title,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: MyApp.resources.color.black1),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "${imageFile != null ? 1 : ""} upload image",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(
                                  color: MyApp.resources.color.orange,
                                  fontSize: 12),
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
        ),
        if (widget.error.isNotEmpty)
          Text(
            widget.error,
            style: Theme.of(context)
                .textTheme
                .bodyText2
                ?.copyWith(color: Colors.red),
          )
      ],
    );
  }
}
