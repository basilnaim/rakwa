import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/announcement.dart';
import 'package:rakwa/model/listing.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/screens/home/home.dart';
import 'package:rakwa/views/bottom_btns.dart';
import 'package:rakwa/views/header_back_btn.dart';
import 'package:rakwa/views/listing_spinner.dart';
import 'package:rakwa/views/progressing_button.dart';
import 'package:rakwa/views/text_field/my_text_field_normal.dart';

class CreateAnnouncementScreen extends StatefulWidget {
  Announcement announcement;
  CreateAnnouncementScreen({Key? key, required this.announcement})
      : super(key: key);

  @override
  State<CreateAnnouncementScreen> createState() =>
      _CreateAnnouncementScreenState();
}

class _CreateAnnouncementScreenState extends State<CreateAnnouncementScreen> {
  GlobalKey<ProgressingButtonState> progressingButton =
      GlobalKey<ProgressingButtonState>();

  static ValueNotifier<List<Listing>> myListings =
      ValueNotifier<List<Listing>>([]);

  final GlobalKey<FormFieldState> _btnTextFieldForm =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _btnLinkFieldForm =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _descriptionFieldForm =
      GlobalKey<FormFieldState>();
  bool progressing = true;
  bool errorImg = false;

  loading(progress) {
    if (progressing != progress) {
      setState(() {
        progressing = progress;
      });
    }
  }

  @override
  initState() {
    super.initState();
    loadListing();
  }

  loadListing() {
    loading(true);
    MyApp.listingRepo
        .myListings(MyApp.token)
        .then((WebServiceResult<List<Listing>> value) {
      loading(false);
      switch (value.status) {
        case WebServiceResultStatus.success:
          myListings.value = value.data ?? [];

          break;
        case WebServiceResultStatus.error:
          mySnackBar(context,
              title: 'fetch listings failed',
              message: value.message, onPressed: () {
            loadListing();
          }, status: SnackBarStatus.error);

          break;
        case WebServiceResultStatus.loading:
          break;
        case WebServiceResultStatus.unauthorized:
          break;
      }
    });
  }

  submitForm() {
    if (widget.announcement.imageFile == null &&
        widget.announcement.image!.isEmpty) {
      errorImg = true;

      setState(() {});
      return;
    }
    if (!checkFields(
        [_btnTextFieldForm, _btnLinkFieldForm, _descriptionFieldForm])) {
      return;
    }

    progressingButton.currentState?.showProgress(true);

    String titleDialog = 'Add Announcement';
    bool create = true;
    Future<WebServiceResult<String>> query;
    print('ffffff ${widget.announcement.id}');
    if (widget.announcement.id != 0) {
      create = false;
      print('xxxxxxxx ${widget.announcement.id}');

      query = MyApp.appRepo.updateAnnouncement(widget.announcement);
      titleDialog = 'Edit Announcement';
    } else {
      query = MyApp.appRepo.createAnnouncement(widget.announcement);
    }

    query.then((value) {
      progressingButton.currentState?.showProgress(false);
      switch (value.status) {
        case WebServiceResultStatus.success:
          if (create) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateAnnouncementScreen(
                        announcement: Announcement(
                          listingId: widget.announcement.listingId ?? 0,
                        ),
                      )),
            );
          }

          mySnackBar(context,
              title: titleDialog,
              message: value.data ?? "",
              status: SnackBarStatus.success);

          break;
        case WebServiceResultStatus.error:
          mySnackBar(context,
              title: titleDialog,
              message: value.data ?? "",
              status: SnackBarStatus.error);

          break;
        case WebServiceResultStatus.loading:
          break;
        case WebServiceResultStatus.unauthorized:
          break;
      }
    });
  }

  final ImagePicker _picker = ImagePicker();

  _chooseImageFromGallerie() async {
    XFile? img = await _picker.pickImage(source: ImageSource.gallery);

    if (img != null) {
      widget.announcement.imageFile = File(img.path);
      errorImg = false;
      setState(() {});
    }
  }

  requiredText(String? value) {
    if (value?.isEmpty ?? false) {
      return MyApp.resources.strings.mandatoryField;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: progressing
          ? const Center(
              child: MyProgressIndicator(
              color: Colors.orange,
            ))
          : SafeArea(
              child: Stack(
                children: [
                  Positioned(
                      top: 25,
                      left: 16,
                      right: 16,
                      child: HeaderWithBackScren(title: "َََAdd Annoucement")),
                  Positioned(
                    top: 90,
                    left: 0,
                    right: 0,
                    bottom: 80,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, top: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.announcement.id == 0)
                              ValueListenableBuilder(
                                  valueListenable: myListings,
                                  builder: (BuildContext context,
                                      List<Listing> listings, Widget? child) {
                                    if (listings.isNotEmpty &&
                                        (widget.announcement.listingId ?? 0) ==
                                            0) {
                                      widget.announcement.listingId =
                                          listings.first.id;
                                    }
                                    return ListingSpinnerWidget(
                                      selectedListingID:
                                          widget.announcement.listingId,
                                      myListings: listings,
                                      onListingChanged: (Listing listing) {
                                        widget.announcement.listingId =
                                            listing.id;
                                      },
                                    );
                                  }),
                            const SizedBox(height: 14),
                            buildImaheUploadContainer("Upload Icon Image", () {
                              _chooseImageFromGallerie();
                            }, error: errorImg),
                            if (errorImg)
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 4, left: 8, bottom: 4),
                                child: Text(
                                  'Please choose an image',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.copyWith(
                                          fontSize: 12, color: Colors.red),
                                ),
                              ),
                            const SizedBox(height: 14),
                            MyNormalTextField(
                                initial: widget.announcement.btnText ?? "",
                                textInputType: TextInputType.text,
                                formFieldeKey: _btnTextFieldForm,
                                validator: requiredText,
                                hint: "Button Text",
                                onSave: (String? text) {
                                  if (text != null) {
                                    widget.announcement.btnText = text;
                                  }
                                },
                                textInputAction: TextInputAction.next),
                            const SizedBox(height: 14),
                            MyNormalTextField(
                                initial: widget.announcement.btnLink ?? "",
                                textInputType: TextInputType.url,
                                formFieldeKey: _btnLinkFieldForm,
                                prefixWidget: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, right: 8.0),
                                  child: SvgPicture.asset(
                                    MyIcons.icLink,
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                                validator: requiredText,
                                hint: "Button Link",
                                texthint: "www.example.com",
                                onSave: (String? text) {
                                  if (text != null) {
                                    widget.announcement.btnLink = text;
                                  }
                                },
                                textInputAction: TextInputAction.next),
                            const SizedBox(height: 14),
                            MyNormalTextField(
                                initial: widget.announcement.description ?? "",
                                textInputType: TextInputType.multiline,
                                formFieldeKey: _descriptionFieldForm,
                                hint: "Announcement Description",
                                maxLines: 6,
                                minLines: 5,
                                validator: requiredText,
                                onSave: (String? text) {
                                  if (text != null) {
                                    widget.announcement.description = text;
                                  }
                                },
                                textInputAction: TextInputAction.newline),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Colors.white,
                      height: 80,
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      child: BottomButtons(
                          progressingButton: progressingButton,
                          neutralButtonText: "Back",
                          submitButtonText: "Save",
                          neutralButtonClick: () {
                            Navigator.pop(context);
                          },
                          submitButtonClick: () => submitForm()),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildImaheUploadContainer(title, onclick, {bool error = false}) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: error ? Colors.red : MyApp.resources.color.grey1,
              width: 1),
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
                      "${widget.announcement.imageFile != null ? 1 : ""} upload image",
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
