import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/createAds.dart';
import 'package:rakwa/model/error.dart';
import 'package:rakwa/model/listing.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/screens/ad_compaigns/create/components/days.dart';
import 'package:rakwa/screens/ad_compaigns/create/components/level_ad_spinner.dart';
import 'package:rakwa/screens/ad_compaigns/create/components/type_ad_spinner.dart';
import 'package:rakwa/screens/ad_compaigns/create/create_ad.dart';
import 'package:rakwa/screens/home/home.dart';
import 'package:rakwa/views/bottom_btns.dart';
import 'package:rakwa/views/empty_content.dart';
import 'package:rakwa/views/error_widget.dart';
import 'package:rakwa/views/listing_spinner.dart';
import 'package:rakwa/views/progressing_button.dart';
import 'package:rakwa/views/text_field/my_text_field_normal.dart';

class CreateAdStep1 extends StatefulWidget {
  AdCampaigns ads;
  CreateAdStep1({Key? key, required this.ads}) : super(key: key);

  @override
  State<CreateAdStep1> createState() => CreateAdStep1State();
}

class CreateAdStep1State extends State<CreateAdStep1> {
  GlobalKey<ProgressingButtonState> progressingButton =
      GlobalKey<ProgressingButtonState>();
  GlobalKey<FormFieldState> _titleFieldForm = GlobalKey<FormFieldState>();

  ValueNotifier<List<Listing>> myListings = ValueNotifier<List<Listing>>([]);
  static ValueNotifier<AdsType> adsType =
      ValueNotifier<AdsType>(AdsType.banner);

  ErrorModel? errorModel;
  bool progressing = true;
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
          if (myListings.value.isEmpty) {
            setState(() {});
          }
          break;
        case WebServiceResultStatus.error:
          errorModel = ErrorModel(btnClickListener: () {});
          errorModel?.text = 'failed to fetch listing';
          errorModel?.btnText = 'try again';
          errorModel?.btnClickListener = () {
            loadListing();
          };

          break;
        case WebServiceResultStatus.loading:
          break;
        case WebServiceResultStatus.unauthorized:
          break;
      }
    });
  }

  onNexClick() {
    CreateAdCompaignState.bottomTabNavigation.moveToNext();
  }

  submitForm() {
    if (!checkFields([
      _titleFieldForm,
    ])) {
      return;
    }
    progressingButton.currentState?.showProgress(true);

    Future<WebServiceResult<String>> query;

    String titleDialog = 'Create Ad';
    bool create = true;
    if (widget.ads.id != 0) {
      create = false;
      query = MyApp.adRepo.updateAd(widget.ads);
      titleDialog = 'Edit Ad';
    } else {
      query = MyApp.adRepo.createAd(widget.ads);
    }

    query.then((value) {
      progressingButton.currentState?.showProgress(false);
      switch (value.status) {
        case WebServiceResultStatus.success:
          if (create) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateAdCompaign(ads: AdCampaigns())),
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

  requiredText(String? value) {
    if (value?.isEmpty ?? false) {
      return MyApp.resources.strings.mandatoryField;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return progressing
        ? const Center(
            child: MyProgressIndicator(
            color: Colors.orange,
          ))
        : errorModel != null
            ? MyErrorWidget(errorModel: errorModel!)
            : myListings.value.isEmpty
                ? Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    alignment: Alignment.center,
                    child: EmpyContentScreen(
                      title: "Listing",
                      description: "Create a listing then you can create an ad",
                    ))
                : Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 16,
                        right: 16,
                        bottom: 100,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              MyNormalTextField(
                                  initial: widget.ads.title,
                                  textInputType: TextInputType.text,
                                  formFieldeKey: _titleFieldForm,
                                  validator: requiredText,
                                  hint: "Ad Title",
                                  onSave: (String? text) {
                                    if (text != null) {
                                      widget.ads.title = text;
                                    }
                                  },
                                  textInputAction: TextInputAction.next),
                              const SizedBox(height: 14),
                              AdTypeSpinner(
                                ads: widget.ads,
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                              ValueListenableBuilder(
                                  valueListenable: myListings,
                                  builder: (BuildContext context,
                                      List<Listing> listings, Widget? child) {
                                    if (listings.isNotEmpty) {
                                      widget.ads.listingId = listings.first.id;
                                    }

                                    return ListingSpinnerWidget(
                                      myListings: listings,
                                      onListingChanged: (Listing listing) {
                                        widget.ads.listingId = listing.id;
                                        setState(() {});
                                      },
                                    );
                                  }),
                              SizedBox(
                                height: 18,
                              ),
                              AdLevelPager(
                                ads: widget.ads,
                              ),
                              SizedBox(
                                height: 18,
                              ),
                              AdsDays(
                                ads: widget.ads,
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.only(
                              left: 40, right: 40, top: 16, bottom: 16),
                          //  width: double.infinity,
                          child: BottomButtons(
                              neutralButtonText: "Back",
                              submitButtonText: "Save",
                              progressingButton: progressingButton,
                              neutralButtonClick: () {
                                Navigator.pop(context);
                              },
                              submitButtonClick: () {
                                submitForm();
                              }),
                        ),
                      ),
                    ],
                  );
  }
}
