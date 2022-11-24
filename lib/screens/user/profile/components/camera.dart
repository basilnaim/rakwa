import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/res/images/MyImages.dart';
import 'package:rakwa/screens/user/profile/profile_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker _picker = ImagePicker();

  _chooseImageFromGallerie() async {
    XFile? img = await _picker.pickImage(source: ImageSource.gallery);

    if (img != null) {
      ProfileScreenState.user.imageFile = File(img.path);
      setState(() {});
    }
  }

  _chooseImageFromCamera() async {
    XFile? img = await _picker.pickImage(source: ImageSource.camera);
    if (img != null) {
      ProfileScreenState.user.imageFile = File(img.path);
      setState(() {});
    }
  }

  bottomDialogoption(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft:Radius.circular(20),topRight: Radius.circular(20)),
        ),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: 200,
            margin: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,top:0,bottom: 0,
                        child: RawMaterialButton(
                          constraints: BoxConstraints.tight(Size(36, 36)),
                          onPressed: () => Navigator.pop(context),
                          elevation: 0,
                          fillColor: Colors.white,
                          splashColor: Colors.grey,
                          child: Icon(
                            Icons.close,
                            color: Colors.black,
                          ),
                          padding: EdgeInsets.all(2.0),
                          shape: CircleBorder(),
                        ),
                      ),
                      const Center(
                        child: Text("Choose your image source",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ),
                  SizedBox(
                  height: 16,
                ),
                Container(
                  height: 1,
                  color: MyApp.resources.color.grey1,
                ),
                SizedBox(
                  height: 32,
                ),
                Row(
                  children: [
                    Expanded(
                      child: itemSourceImage('Camera', Icons.camera, () {
                        Navigator.pop(context);
                        _chooseImageFromCamera();
                      }),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: itemSourceImage('Gallery', Icons.image, () {
                        Navigator.pop(context);
                        _chooseImageFromGallerie();
                      }),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  Widget itemSourceImage(title, icon, action) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
          color: MyApp.resources.color.borderColor,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Material(
        child: InkWell(
          radius: 20,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          onTap: () => action(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: MyApp.resources.color.black4),
              Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      ?.copyWith(color: MyApp.resources.color.black4))
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
            child: Container(
          padding:const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: MyApp.resources.color.clearBlue,
            shape: BoxShape.circle,
          ),
          child: SizedBox(
            height: 120,
            width: 120,
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              onTap: () {
                if(ProfileScreen.editable.value == false) bottomDialogoption(context);
              },
              child: ClipOval(
                child: SizedBox.fromSize(
                  size:const Size.fromRadius(48), // Image radius
                  child: ProfileScreenState.user.imageFile == null
                      ? Image.network(
                          ProfileScreenState.user.image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(MyImages.profilePic);
                          },
                        )
                      : Image.file(ProfileScreenState.user.imageFile! ,fit: BoxFit.cover,),
                ),
              ),
            ),
          ),
        )),
        Positioned(
            top: 0,
            bottom: 0,
            left: 120,
            right: 0,
            child: Center(
                child: Container(
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                    ),
                    decoration: BoxDecoration(
                      color: MyApp.resources.color.orange.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    width: 40,
                    height: 40)))
      ],
    );
  }
}
