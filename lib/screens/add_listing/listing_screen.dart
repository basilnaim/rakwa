import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/categorie.dart';
import 'package:rakwa/model/city.dart';
import 'package:rakwa/model/error.dart';
import 'package:rakwa/model/generic_form.dart';
import 'package:rakwa/model/listing.dart';
import 'package:rakwa/model/listing/add_listing.dart';
import 'package:rakwa/model/listing/contact.dart';
import 'package:rakwa/model/listing/media.dart';
import 'package:rakwa/model/location.dart';
import 'package:rakwa/model/state.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/screens/add_listing/components/categories_list.dart';
import 'package:rakwa/screens/add_listing/components/general_info.dart';
import 'package:rakwa/screens/add_listing/components/generic_form.dart';
import 'package:rakwa/screens/add_listing/components/step1.dart';
import 'package:rakwa/screens/add_listing/components/step2.dart';
import 'package:rakwa/screens/add_listing/components/step3.dart';
import 'package:rakwa/screens/add_listing/components/step4.dart';
import 'package:rakwa/screens/add_listing/components/step5.dart';
import 'package:rakwa/screens/add_listing/components/tamplate.dart';
import 'package:rakwa/screens/home/home.dart';
import 'package:rakwa/utils/bottom_tab_nav.dart';
import 'package:rakwa/views/error_widget.dart';
import 'package:rakwa/views/header_back_btn.dart';
import 'package:rakwa/views/progressing_button.dart';
import 'package:rakwa/views/header_back_btn.dart';
import 'components/header.dart';

class ListingScreen extends StatefulWidget {
  ListingScreen(
      {Key? key,
      this.form = const [],
      this.create = true,
      this.listingToUpdate,
      this.categorieModel})
      : super(key: key);

  List<GenericForm> form = [];
  bool create;
  Listing? listingToUpdate;
  CategorieModel? categorieModel;

  @override
  State<ListingScreen> createState() => ListingScreenState();
}

class ListingScreenState extends State<ListingScreen> {
  static late BottomTabNavigation bottomTabNavigation;

  List<String> stepTitles = [
    "LISTING CATEGORIES",
    "LISTING DETAILS",
    "Location",
    "BUSINESS HOURS",
    'MEDIA',
    'CONTACT',
    'GENERAL INFO',
  ];

  static bool containGenericForm = false;
  @override
  dispose() {
    bottomTabNavigation.onWidgetChangedListener.dispose();
    super.dispose();
  }

  Future<bool> _willPopCallback() async {
    return bottomTabNavigation.pop();
  }

  late ListingMedia media;
  late List<CategorieModel> listingCategories;
  late ListingContact listingContact;
  late Location location;
  bool isLoading = false;
  bool initilised = false;

  createListing(GlobalKey<ProgressingButtonState> progress) {
    progress.currentState?.showProgress(true);
    final listingToAdd = prepareAddListingRequest(
        widget.listingToUpdate?.title ?? "",
        ChooseTemplateScreen.listingToAdd,
        media,
        location,
        listingCategories,
        listingContact,
        widget.form);

    print('QQQQQQQ' + listingToAdd.toString());

    Map<String, File> mMedia = {};

    if (media.image != null) {
      mMedia.addAll({"image": media.image!});
    }

    if (media.coverImage != null) {
      mMedia.addAll({"image_cover": media.coverImage!});
    }

    if (media.galleryPictures.isNotEmpty) {
      for (var i = 0; i < media.galleryPictures.length; i++) {
        mMedia.addAll({"image_gallery[$i]": media.galleryPictures[i]});
      }
    }

    if (media.galleryVideos.isNotEmpty) {
      for (var video in media.galleryVideos) {
        mMedia.addAll({"video[]": video});
      }
    }

    //return;
    MyApp.listingRepo
        .addListing(widget.create, listingToAdd, mMedia)
        .then((WebServiceResult<String> value) {
      progress.currentState?.showProgress(false);
      switch (value.status) {
        case WebServiceResultStatus.success:
          mySnackBar(context,
              title: "Listing",
              message:
                  "Listing ${widget.create ? 'added' : 'updated'} successfully",
              status: SnackBarStatus.success);
          Navigator.pop(context, true);
          if (widget.create) Navigator.pop(context, true);
          break;
        case WebServiceResultStatus.error:
          mySnackBar(context,
              title: 'Error while creating the listing',
              message: value.message,
              status: SnackBarStatus.error);
          break;
        case WebServiceResultStatus.loading:
          break;
        case WebServiceResultStatus.unauthorized:
          break;
      }
    });
  }

  _fetchDetail() {
    print('fetch home data started');

    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
    }

    MyApp.listingRepo
        .detail(widget.listingToUpdate?.id.toString() ?? "", MyApp.token)
        .then((WebServiceResult<Listing> value) {
      switch (value.status) {
        case WebServiceResultStatus.success:
          initilised = true;
          ChooseTemplateScreen.listingToAdd = value.data!;
          listingCategories = [];
          if (widget.categorieModel != null) {
            listingCategories.add(widget.categorieModel!);
          }

          Map<SocialMedia, String> socials = {};
          socials.addAll({
            SocialMedia.facebook:
                ChooseTemplateScreen.listingToAdd.socialLinks?.facebook ?? ""
          });
          socials.addAll({
            SocialMedia.instagram:
                ChooseTemplateScreen.listingToAdd.socialLinks?.instagram ?? ""
          });
          socials.addAll({
            SocialMedia.tweeter:
                ChooseTemplateScreen.listingToAdd.socialLinks?.twitter ?? ""
          });

          media = ListingMedia(
            hasVideo: ChooseTemplateScreen.listingToAdd.video != null,
            nbrGalleryPictures:
                ChooseTemplateScreen.listingToAdd.gallery?.length ?? 0,
            nbrGalleryVideos:
                ChooseTemplateScreen.listingToAdd.video == null ? 0 : 1,
            hasCoverImage:
                ChooseTemplateScreen.listingToAdd.imageCover.isNotEmpty,
            hasImage: ChooseTemplateScreen.listingToAdd.image.isNotEmpty,
          );

          listingContact = ListingContact(
              website: ChooseTemplateScreen.listingToAdd.listingUrl,
              phone: ChooseTemplateScreen.listingToAdd.phone,
              socialMedia: socials);

          location = Location(
            lat: ChooseTemplateScreen.listingToAdd.latitude,
            long: ChooseTemplateScreen.listingToAdd.longitude,
            stateDownValue: StateLocation(
              id: ChooseTemplateScreen.listingToAdd.state?.id ?? 0,
              name: ChooseTemplateScreen.listingToAdd.state?.title ?? "",
            ),
            cityDownValue: City(
              id: ChooseTemplateScreen.listingToAdd.city?.id ?? 0,
              name: ChooseTemplateScreen.listingToAdd.city?.title ?? "",
            ),
          );

          _initBottom();

          break;
        case WebServiceResultStatus.error:
          initilised = false;

          break;
        case WebServiceResultStatus.loading:
          break;

        case WebServiceResultStatus.unauthorized:
          break;
      }

      if (isLoading) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    if (!widget.create) {
      _fetchDetail();
    } else {
      initilised = true;
      media = ListingMedia();
      listingCategories = [];
      listingContact = ListingContact(socialMedia: {});
      location = Location();
      _initBottom();
    }

    if (widget.form.isNotEmpty) {
      stepTitles.add("More Informations");
    }
  }

  _initBottom() {
    bottomTabNavigation = BottomTabNavigation(rootWidgets: [
      CategoriesScreen(listingCategories: listingCategories),
      AddListingStep1(),
      AddListingStep2(location: location),
      AddListingStep3(),
      AddListingStep4(
        media: media,
      ),
      AddListingStep5(
        listingContact: listingContact,
      ),
      ListingGeneralInfo(
        saveListing: createListing,
      ),
      if (widget.form.isNotEmpty)
        GenericFormScreen(
          listing: ChooseTemplateScreen.listingToAdd,
          form: widget.form,
          saveListing: createListing,
        ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    containGenericForm = widget.form.isNotEmpty;
    return Scaffold(
      backgroundColor: MyApp.resources.color.colorBackground,
      body: isLoading
          ? Center(
              child: MyProgressIndicator(
                color: MyApp.resources.color.orange,
              ),
            )
          : !initilised
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16),
                      child: HeaderWithBackScren(
                        title: "إضافة عمل",
                        backEnabled: true,
                        onClick: () {
                          Navigator.pop(context);
                          if (widget.create) Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(height: 8),
                    MyErrorWidget(
                        errorModel: ErrorModel(
                            btnText: 'try again',
                            text:
                                "Couldn't find this listing, please try again",
                            btnClickListener: () {
                              _fetchDetail();
                            }))
                  ],
                )
              : SafeArea(
                  child: WillPopScope(
                      onWillPop: _willPopCallback,
                      child: ValueListenableBuilder<int>(
                          valueListenable:
                              bottomTabNavigation.onWidgetChangedListener,
                          builder: (context, selectedIndex, _) {
                            return Container(
                              height: MediaQuery.of(context).size.height,
                              padding: const EdgeInsets.only(top: 25),
                              child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, right: 16),
                                  child: HeaderWithBackScren(
                                    title: "إضافة عمل",
                                    backEnabled: true,
                                    onClick: () {
                                      Navigator.pop(context);
                                      if (widget.create) Navigator.pop(context);
                                    },
                                  ),
                                ),
                                SizedBox(height: 8),
                                ListingHeader(
                                  steps: bottomTabNavigation.rootWidgets.length,
                                  step: bottomTabNavigation.currentTab,
                                  title: stepTitles[
                                      bottomTabNavigation.currentTab],
                                ),
                                SizedBox(height: 20),
                                Expanded(
                                    child:
                                        bottomTabNavigation.getCurrentWidget()),
                              ]),
                            );
                          }))),
    );
  }
}
