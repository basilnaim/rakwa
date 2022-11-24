import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/announcement.dart';
import 'package:rakwa/model/createAds.dart';
import 'package:rakwa/model/listing.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/screens/ad_compaigns/create/create_ad.dart';
import 'package:rakwa/screens/ad_compaigns/listing/components/item_campaign.dart';
import 'package:rakwa/screens/announcement/create/create_announcement.dart';
import 'package:rakwa/screens/announcement/listing/components/item_announcement.dart';
import 'package:rakwa/screens/home/home.dart';
import 'package:rakwa/views/empty_content.dart';
import 'package:rakwa/views/header_back_btn.dart';
import 'package:rakwa/views/listing_spinner.dart';
import 'package:rakwa/views/not_registred.dart';
import 'package:rakwa/views/progressing_button.dart';

class CampaignsListingScreen extends StatefulWidget {
  const CampaignsListingScreen({Key? key}) : super(key: key);

  @override
  State<CampaignsListingScreen> createState() => _CampaignsListingScreenState();
}

class _CampaignsListingScreenState extends State<CampaignsListingScreen> {
  GlobalKey<ProgressingButtonState> progressingButton =
      GlobalKey<ProgressingButtonState>();

  static ValueNotifier<List<AdCampaigns>> adCampaigns =
      ValueNotifier<List<AdCampaigns>>([]);

  bool progressingCampaigns = true;

  loadingCampaignsProgress(progress) {
    if (progressingCampaigns != progress) {
      setState(() {
        progressingCampaigns = progress;
      });
    }
  }

  @override
  initState() {
    super.initState();
    loadCampaigns();
  }

  loadCampaigns() {
    loadingCampaignsProgress(true);
    MyApp.adRepo.getAds().then((value) {
      loadingCampaignsProgress(false);

      switch (value.status) {
        case WebServiceResultStatus.success:
          adCampaigns.value = value.data ?? [];

          break;
        case WebServiceResultStatus.error:
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'fetch campaigns failed',
                  desc: value.message,
                  btnOkText: "Retry",
                  btnOkColor: Colors.orange,
                  btnOkOnPress: () {
                    loadCampaigns();
                  },
                  btnCancel: null)
              .show();
          break;
        case WebServiceResultStatus.loading:
          break;
        case WebServiceResultStatus.unauthorized:
          break;
      }
    });
  }

  deleteCampaigns(int id) {
    // loadingCampaignsProgress(true);
    MyApp.adRepo.removeAd(id).then((value) {
      //  loadingCampaignsProgress(false);
      switch (value.status) {
        case WebServiceResultStatus.success:
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.SUCCES,
                  animType: AnimType.BOTTOMSLIDE,
                  title: "Remove AD",
                  btnOk: null,
                  desc: "Ad campaigns removed successfully",
                  btnCancel: null)
              .show();

          loadCampaigns();

          break;
        case WebServiceResultStatus.error:
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  animType: AnimType.BOTTOMSLIDE,
                  title: "Remove AD",
                  desc: value.data,
                  btnOk: null,
                  btnCancel: null)
              .show();
          break;
        case WebServiceResultStatus.loading:
          break;
        case WebServiceResultStatus.unauthorized:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyApp.resources.color.background,
      body: !MyApp.isConnected
          ? Column(
              children: [
                SizedBox(
                  height: 64,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: HeaderWithBackScren(
                    title: 'Ad Campaigns',
                  ),
                ),
                Flexible(
                    child: Align(
                        alignment: Alignment.center,
                        child: RequireRegistreScreen(
                          postFunction: () {
                            loadCampaigns();
                          },
                        ))),
              ],
            )
          : (progressingCampaigns
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
                          child: HeaderWithBackScren(
                            title: 'Ad Campaigns',
                          )),
                      Positioned(
                        top: 80,
                        left: 0,
                        right: 0,
                        bottom: 90,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16, top: 16),
                          child: ValueListenableBuilder(
                              valueListenable: adCampaigns,
                              builder: (BuildContext context,
                                  List<AdCampaigns> mCampaigns, Widget? child) {
                                return progressingCampaigns
                                    ? const Center(
                                        child: MyProgressIndicator(
                                        color: Colors.orange,
                                      ))
                                    : (mCampaigns.isEmpty
                                        ? Align(
                                            alignment: Alignment.center,
                                            child: EmpyContentScreen(
                                              title: "Campaigns",
                                              description:
                                                  "Click the button below to add the first Ad",
                                            ))
                                        : ListView.builder(
                                            itemCount: mCampaigns.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return ItemCampaigns(
                                                  onDeleteClicked:
                                                      deleteCampaigns,
                                                  campaign: mCampaigns[index]);
                                            }));
                              }),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          color: Colors.white,
                          height: 80,
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 20),
                          child: ProgressingButton(
                            textColor: Colors.white,
                            buttonText: 'Create New Ad',
                            color: MyApp.resources.color.orange,
                            onSubmitForm: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreateAdCompaign(
                                          ads: AdCampaigns(),
                                        )),
                              );

                              loadCampaigns();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
    );
  }
}
