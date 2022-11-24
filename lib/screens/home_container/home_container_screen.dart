import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/res/fonts/fonts.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/screens/add_listing/components/tamplate.dart';
import 'package:rakwa/screens/add_listing/listing_reviews/reviews.dart';
import 'package:rakwa/screens/contact/contact_screen.dart';
import 'package:rakwa/screens/dashboard/dashboard.dart';
import 'package:rakwa/screens/discover/discover_list.dart';
import 'package:rakwa/screens/home/Components/drawer.dart';
import 'package:rakwa/screens/home/home.dart';
import 'package:rakwa/screens/inbox/inbox_screen.dart';
import 'package:rakwa/screens/my_listings/my_listing.dart';
import 'package:rakwa/screens/my_reviews/my_reviews.dart';
import 'package:rakwa/screens/user/profile/profile_screen.dart';
import 'package:rakwa/utils/bottom_tab_nav.dart';
import 'package:rakwa/views/progressing_button.dart';

import '../saved/saved_listing.dart';

class HomeContainerScreen extends StatefulWidget {
  const HomeContainerScreen({Key? key}) : super(key: key);

  @override
  State<HomeContainerScreen> createState() => HomeContainerScreenState();
}

class HomeContainerScreenState extends State<HomeContainerScreen> {
  static late BottomTabNavigation bottomTabNavigation;

  static Map source = {ConnectivityResult.none: false};
  final MyConnectivity _connectivity = MyConnectivity.instance;

  static pushWidget(Widget widget) {
    bottomTabNavigation.pushWidget(widget);
  }

  @override
  dispose() {
    _connectivity.disposeStream();
    bottomTabNavigation.onWidgetChangedListener.dispose();
    super.dispose();
  }

  Future<bool> _willPopCallback() async {
    return bottomTabNavigation.pop();
  }

  GlobalKey<ProgressingButtonState> progressingKey = GlobalKey();
  static bool isDialogShown = false;
  static bool isShownOnce = false;
  @override
  initState() {
    super.initState();
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() {
        source = source;
        print(source);
        if (source.keys.first == ConnectivityResult.none) {
          if (!isShownOnce) {
            isShownOnce = true;
            setState(() {
              isDialogShown = true;
            });
            showConnectionDialog(context);
          }
        } else {
          isShownOnce = false;
          if (isDialogShown) {
            Navigator.pop(context);
          }
        }
      });
    });
    getLoc();
    bottomTabNavigation = BottomTabNavigation(rootWidgets: [
      const HomeScreen(),
      const Dashboard(),
      ChooseTemplateScreen(),
      const DiscoverList(),
      ProfileScreen(),
    ]);
  }

  static navigationFromDrawer(
      BuildContext context, DrawerItems selectedMenuTab) {
    switch (selectedMenuTab) {
      case DrawerItems.home:
        DrawerPage.selectedMenuTab.value = selectedMenuTab;
        bottomTabNavigation.switchTab(0);
        break;

      case DrawerItems.discover:
        DrawerPage.selectedMenuTab.value = selectedMenuTab;
        bottomTabNavigation.switchTab(3);
        break;
      case DrawerItems.profile:
        DrawerPage.selectedMenuTab.value = selectedMenuTab;
        bottomTabNavigation.switchTab(4);

        break;
      case DrawerItems.dashboard:
        DrawerPage.selectedMenuTab.value = selectedMenuTab;
        bottomTabNavigation.switchTab(1);
        break;
      case DrawerItems.listing:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyListings()),
        );
        break;
      case DrawerItems.inbox:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InboxScreen()),
        );
        break;
      case DrawerItems.invoices:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => notImplementedLayout()),
        );
        break;
      case DrawerItems.saved:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SavedListingScreen()),
        );
        break;
      case DrawerItems.reviews:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyReviews()),
        );
        break;
      case DrawerItems.contactus:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ContactUsScreen()),
        );
        break;
    }
  }

  static notImplementedLayout() => const Scaffold(
        body: SizedBox(
          child: Center(child: Text("not implemented yet ")),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        child: WillPopScope(
          onWillPop: _willPopCallback,
          child: ValueListenableBuilder<int>(
              valueListenable: bottomTabNavigation.onWidgetChangedListener,
              builder: (context, selectedIndex, _) {
                switch (bottomTabNavigation.currentTab) {
                  case 0:
                    DrawerPage.selectedMenuTab.value = DrawerItems.home;
                    break;
                  case 1:
                    DrawerPage.selectedMenuTab.value = DrawerItems.dashboard;
                    break;
                  case 4:
                    DrawerPage.selectedMenuTab.value = DrawerItems.profile;
                    break;
                }

                return Scaffold(
                  drawer: DrawerPage(),
                  backgroundColor: MyApp.resources.color.background,
                  body: SafeArea(
                    child: Container(
                      color: Colors.transparent,
                      child: Stack(
                        children: [
                          Positioned(
                              left: 0,
                              right: 0,
                              top: 0,
                              bottom: 70,
                              child: bottomTabNavigation.getCurrentWidget()),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              color: MyApp.resources.color.black5,
                              height: 70,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  bottomTab(
                                      icon: MyIcons.icHome,
                                      label: "الرئيسية",
                                      index: 0),
                                  bottomTab(
                                      icon: MyIcons.icDashboard,
                                      label: "لوحة التحكم",
                                      index: 1),
                                  bottomTab(label: 'إضافة عمل', index: 2),
                                  bottomTab(
                                      icon: MyIcons.icClassfield,
                                      label: "الإعلانات المبوبة",
                                      index: 3),
                                  bottomTab(
                                      icon: MyIcons.icPerson,
                                      label: "الملف الشخصي",
                                      index: 4),
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.23),
                                  shape: BoxShape.circle),
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(bottom: 35),
                              child: FloatingActionButton(
                                mini: false,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChooseTemplateScreen(),
                                    ),
                                  );
                                },
                                child: const Icon(
                                  Icons.add,
                                  size: 32,
                                ),
                                backgroundColor: MyApp.resources.color.orange,
                              ),
                            ),
                          ),
                        ],
                      ),
                      height: MediaQuery.of(context).size.height,
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }

  Widget bottomTab({String? icon, String label = "", int index = -1}) {
    bool selected = bottomTabNavigation.currentTab == index;
    return Expanded(
        child: Material(
      color: Colors.transparent,
      child: InkWell(
          onTap: index == 2
              ? null
              : () {
                  bottomTabNavigation.switchTab(index);
                },
          splashColor: Colors.orange.withOpacity(0.3),
          borderRadius: BorderRadius.circular(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (icon != null)
                SvgPicture.asset(icon,
                    color:
                        selected ? MyApp.resources.color.orange : Colors.white),
              const SizedBox(
                height: 6,
              ),
              Text(label,
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      fontWeight: FontFamily.semibold.fontWeight(),
                      fontSize: 10,
                      color: selected
                          ? MyApp.resources.color.orange
                          : Colors.white)),
              const SizedBox(
                height: 16,
              )
            ],
          )),
    ));
  }
}
