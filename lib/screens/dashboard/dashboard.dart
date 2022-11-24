import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/statistics.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/screens/ad_compaigns/listing/list.dart';
import 'package:rakwa/screens/announcement/listing/list_announcement.dart';
import 'package:rakwa/screens/coupon/listing/coupon_listing.dart';
import 'package:rakwa/screens/dashboard/Components/statistics_item.dart';
import 'package:rakwa/screens/events/listing/event_listing.dart';
import 'package:rakwa/screens/home/home.dart';
import 'package:rakwa/screens/inbox/inbox_screen.dart';
import 'package:rakwa/screens/my_classifieds/my_classifieds.dart';
import 'package:rakwa/screens/my_listings/my_listing.dart';
import 'package:rakwa/screens/my_reviews/my_reviews.dart';
import 'package:rakwa/screens/saved/saved_listing.dart';
import 'package:rakwa/views/header_back_btn.dart';
import 'package:rakwa/views/not_registred.dart';

import 'Components/header.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  _openDrawer() {
    Scaffold.of(context).openDrawer();
  }

  bool isLoading = false;
  Statistics statistics = Statistics();

  _fetchStatistics(String token) {
    print('fetch statistics data started');
    setState(() {
      isLoading = true;
    });

    MyApp.homeRepo.statistics(token).then((WebServiceResult<Statistics> value) {
      switch (value.status) {
        case WebServiceResultStatus.success:
          print(value.data!);
          setState(() {
            isLoading = false;
            statistics = value.data!;
          });
          break;
        case WebServiceResultStatus.error:
          setState(() {
            isLoading = false;
          });
          mySnackBar(context,
              title: 'fetch data statistics failed',
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

  @override
  void initState() {
    super.initState();
    if (MyApp.isConnected) _fetchStatistics(MyApp.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyApp.resources.color.background,
      body: SafeArea(
          child: !MyApp.isConnected
              ? Column(
                  children: [
                    const SizedBox(
                      height: 64,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16),
                      child: HeaderWithBackScren(
                        title: 'لوحة التحكم',
                      ),
                    ),
                    Flexible(
                        child: Align(
                            alignment: Alignment.center,
                            child: RequireRegistreScreen(
                              postFunction: () {
                                if (MyApp.isConnected)
                                  _fetchStatistics(MyApp.token);
                              },
                            ))),
                  ],
                )
              : ((isLoading)
                  ? MyProgressIndicator(
                      color: MyApp.resources.color.orange,
                    )
                  : RefreshIndicator(
                      onRefresh: (() => _fetchStatistics(MyApp.token)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // header
                            Header(
                              onDrawerClick: () {
                                _openDrawer();
                              },
                            ),
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        DashboardStatContainer(
                                            statistics: statistics),
                                        const SizedBox(height: 16),
                                        const DashboardFeaturesContainer()
                                      ]),
                                ),
                              ),
                            ),
                          ]),
                    ))),
    );
  }
}

class DashboardStatContainer extends StatefulWidget {
  const DashboardStatContainer({Key? key, this.statistics}) : super(key: key);
  final Statistics? statistics;

  @override
  State<DashboardStatContainer> createState() => _DashboardStatContainerState();
}

class _DashboardStatContainerState extends State<DashboardStatContainer> {
  Map<String, int> stats = {};

  @override
  void initState() {
    super.initState();
    stats.putIfAbsent(
        "مشاهدة أعمالي", () => widget.statistics?.listings_views ?? 0);
    stats.putIfAbsent("أعمالي", () => widget.statistics?.listings_count ?? 0);
    stats.putIfAbsent(
        "تقييماتي", () => widget.statistics?.my_reviews_count ?? 0);
    stats.putIfAbsent("تقييمات أعمالي",
        () => widget.statistics?.my_listings_reviews_count ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(width: 0.5, color: MyApp.resources.color.borderColor),
          color: Colors.white,
        ),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'إحصائيات',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                primary: false,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: 4,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 6,
                    childAspectRatio: 1.8,
                    crossAxisCount: 2),
                itemBuilder: (_, int index) {
                  return StatisticsItem(
                    label: stats.keys.elementAt(index),
                    value: stats.values.elementAt(index).toString(),
                  );
                },
              ),
            ]),
      ),
    );
  }
}

class DashboardFeaturesContainer extends StatefulWidget {
  const DashboardFeaturesContainer({Key? key}) : super(key: key);

  @override
  State<DashboardFeaturesContainer> createState() =>
      _DashboardFeaturesContainerState();
}

class _DashboardFeaturesContainerState
    extends State<DashboardFeaturesContainer> {
  List<FeatureItemModel> features = [];

  @override
  void initState() {
    FeatureItemModel myListing = FeatureItemModel(
        icon: MyIcons.icListing,
        name: "مشاريعي",
        onClick: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyListings()),
          );
        });
    FeatureItemModel inbox = FeatureItemModel(
        icon: MyIcons.icListing,
        name: "الرسائل",
        onClick: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InboxScreen()),
          );
        });
    // FeatureItemModel invoices = FeatureItemModel(
    //     icon: MyIcons.icWallet, name: "INVOICES", onClick: () {});
    FeatureItemModel saved = FeatureItemModel(
        icon: MyIcons.icLike,
        name: "المفضلة",
        onClick: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SavedListingScreen()),
          );
        });
    FeatureItemModel reviews = FeatureItemModel(
        icon: MyIcons.icReviews,
        name: "التقييمات",
        onClick: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyReviews()),
          );
        });
    // FeatureItemModel coupons = FeatureItemModel(
    //     icon: MyIcons.icCoupon,
    //     name: "COUPONS",
    //     onClick: () {
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(builder: (context) => CouponListing()),
    //       );
    //     });

    // FeatureItemModel events = FeatureItemModel(
    //     icon: MyIcons.icEvent,
    //     name: "EVENTS",
    //     onClick: () {
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(builder: (context) => EventListing()),
    //       );
    //     });

    // FeatureItemModel adCampaigns = FeatureItemModel(
    //     icon: MyIcons.icCrown,
    //     name: "AD CAMPAIGNS",
    //     onClick: () {
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) => const CampaignsListingScreen()),
    //       );
    //     });
    // FeatureItemModel announcements = FeatureItemModel(
    //     icon: MyIcons.icAnnouncement,
    //     name: "ANNOUNCEMENTS",
    //     onClick: () {
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) => const AnnouncementListingScreen()),
    //       );
    //     });
    FeatureItemModel classifieds = FeatureItemModel(
        icon: MyIcons.icClassfield,
        name: "الإعلانات المبوبة",
        onClick: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyClassifieds()),
          );
        });
    features.add(myListing);
    features.add(inbox);
    // features.add(invoices);
    features.add(saved);
    features.add(reviews);
    // features.add(coupons);
    // features.add(events);
    // features.add(adCampaigns);
    // features.add(announcements);
    features.add(classifieds);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(width: 0.5, color: MyApp.resources.color.borderColor),
        color: Colors.white,
      ),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'المميزات',
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              primary: false,
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 24),
              itemCount: features.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 6,
                  childAspectRatio: 0.8,
                  crossAxisCount: 3),
              itemBuilder: (_, int index) {
                return FeaturesItem(
                  onClick: () => features[index].onClick(),
                  feature: features[index],
                );
              },
            ),
          ]),
    );
  }
}

class FeaturesItem extends StatelessWidget {
  const FeaturesItem({Key? key, this.feature, this.onClick}) : super(key: key);
  final FeatureItemModel? feature;
  final VoidCallback? onClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(width: 0.5, color: MyApp.resources.color.borderColor)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            onClick?.call();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            child: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const SizedBox(height: 8),
                SvgPicture.asset(
                  feature?.icon ?? "",
                  width: 26,
                  height: 26,
                  color: MyApp.resources.color.orange,
                ),
                const SizedBox(height: 12),
                Text(
                  feature?.name ?? "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                      color: MyApp.resources.color.background,
                      border: Border.all(
                          width: 0.5, color: MyApp.resources.color.borderColor),
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                      child: Row(children: [
                    const SizedBox(width: 8),
                    Text(
                      'المزيد',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade900),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: Colors.grey.shade900,
                    ),
                    const SizedBox(width: 6),
                  ])),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class FeatureItemModel {
  String? icon;
  String? name;
  Function onClick;
  FeatureItemModel({this.icon, this.name, required this.onClick});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (icon != null) {
      result.addAll({'icon': icon});
    }
    if (name != null) {
      result.addAll({'name': name});
    }

    return result;
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'FeatureItemModel(icon: $icon, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FeatureItemModel &&
        other.icon == icon &&
        other.name == name;
  }

  @override
  int get hashCode => icon.hashCode ^ name.hashCode;
}
