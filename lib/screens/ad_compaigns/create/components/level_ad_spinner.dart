import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/ad_level.dart';
import 'package:rakwa/model/ads.dart';
import 'package:rakwa/model/createAds.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/res/images/MyImages.dart';
import 'package:rakwa/screens/ad_compaigns/create/components/step1.dart';
import 'package:rakwa/screens/home/home.dart';
import 'package:rakwa/views/spinner_container.dart';

class AdLevelPager extends StatefulWidget {
  AdCampaigns ads;
  AdLevelPager({Key? key, required this.ads}) : super(key: key);

  @override
  State<AdLevelPager> createState() => _AdLevelPagerState();
}

class _AdLevelPagerState extends State<AdLevelPager> {
  GlobalKey<PageContainerState> key = GlobalKey();
  int mInitialPage = 0;
  PageController? controller;
  List<AdLevel> levels = [];

  bool progressing = true;
  loading(progress) {
    if (progressing != progress) {
      setState(() {
        progressing = progress;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    CreateAdStep1State.adsType.addListener(() {
      loadLevels();
    });
    loadLevels();
  }

  loadLevels() {
    loading(true);
    MyApp.adRepo
        .getLevels(CreateAdStep1State.adsType.value.adValue())
        .then((WebServiceResult<List<AdLevel>> value) {
      loading(false);
      switch (value.status) {
        case WebServiceResultStatus.success:
          levels = value.data ?? [];
          if (levels.isNotEmpty) {
            widget.ads.level = levels[0].id;
          }
          setState(() {});

          break;
        case WebServiceResultStatus.error:
          mySnackBar(context,
              title: 'Fetch levels failed',
              message: value.message, onPressed: () {
            loadLevels();
          }, status: SnackBarStatus.error);
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'fetch levels failed',
                  desc: value.message,
                  btnOkText: "Retry",
                  btnOkColor: Colors.orange,
                  btnOkOnPress: () {
                    loadLevels();
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

  @override
  Widget build(BuildContext context) {
    return progressing
        ? const Center(
            child: MyProgressIndicator(
            color: Colors.orange,
          ))
        : Container(
            width: MediaQuery.of(context).size.width,
            height: 335,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: PageIndicatorContainer(
              key: key,
              child: PageView.builder(
                  onPageChanged: (position) {
                    widget.ads.level = levels[position].id;
                  },
                  controller: controller,
                  itemCount: levels.length,
                  itemBuilder: (context, position) {
                    return levelWidget(levels[position]);
                  }),
              align: IndicatorAlign.bottom,
              length: levels.length,
              indicatorSpace: 4.0,
              padding: const EdgeInsets.all(10),
              indicatorColor: Color(0xffD5D5D5),
              indicatorSelectorColor: MyApp.resources.color.orange,
              shape: IndicatorShape.circle(size: 10),
            ),
          );
  }

  Widget levelWidget(AdLevel level) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  level.name,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(color: MyApp.resources.color.textColor),
                ),
              ),
              /*
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                decoration: BoxDecoration(
                    color: MyApp.resources.color.grey3,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    border: Border.all(
                        color: MyApp.resources.color.borderColor, width: 0.8)),
                child: RichText(
                  text: TextSpan(
                    text: level.period + " ",
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        fontSize: 11, color: MyApp.resources.color.textColor),
                    children: <TextSpan>[
                      TextSpan(
                          text: level.price + '\$',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(
                                  fontSize: 11,
                                  color: MyApp.resources.color.orange)),
                    ],
                  ),
                ),
              )
           
             */
            ],
          ),
          SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              level.image,
              width: double.maxFinite,
              height: 240,
              errorBuilder: (m, l, n) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    MyImages.errorImage,
                    fit: BoxFit.cover,
                    width: double.maxFinite,
                    height: 240,
                  ),
                );
              },
              fit: BoxFit.cover,
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          border:
              Border.all(color: MyApp.resources.color.borderColor, width: 0.8)),
    );
  }
}
