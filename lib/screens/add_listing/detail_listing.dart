import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/user.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/res/fonts/fonts.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/screens/add_listing/listing_detail/listing_detail.dart';
import 'package:rakwa/screens/add_listing/listing_events/listing_events.dart';
import 'package:rakwa/screens/chats/inbox_screen.dart';
import 'package:rakwa/screens/home/home.dart';
import 'package:rakwa/screens/home/home_location.dart';
import 'package:rakwa/utils/bottom_tab_nav.dart';

import '../../model/listing.dart';

class DetailListingContainerScreen extends StatefulWidget {
  final String listingId;

  const DetailListingContainerScreen({Key? key, required this.listingId})
      : super(key: key);

  @override
  State<DetailListingContainerScreen> createState() =>
      DetailListingContainerScreenState();
}

class DetailListingContainerScreenState
    extends State<DetailListingContainerScreen> {
  static late BottomTabNavigation bottomTabNavigation;

  bool isLoading = true;
  Listing listing = Listing();
  bool bottomNavInitialized = false;

  static pushWidget(Widget widget) {
    bottomTabNavigation.pushWidget(widget);
  }

  @override
  dispose() {
    bottomTabNavigation.onWidgetChangedListener.dispose();
    super.dispose();
  }

  Future<bool> _willPopCallback() async {
    bool pop = await bottomTabNavigation.pop();
    if (pop) {
      Navigator.pop(context, listing.isFavorite);
    }
    return false;
  }

  _fetchDetail(String token) {
    print('fetch home data started');
    setState(() {
      isLoading = true;
    });

    MyApp.listingRepo
        .detail(widget.listingId, token)
        .then((WebServiceResult<Listing> value) {
      setState(() {
        isLoading = false;
      });
      switch (value.status) {
        case WebServiceResultStatus.success:
          print(value.data!);
          listing = value.data!;
          bottomNavInitialized = true;
          bottomTabNavigation = BottomTabNavigation(rootWidgets: [
            ListingDetail(
              listing: listing,
            ),
            ListingEvents(
              events: listing.event,
              onParticipateEvent: () {
                _fetchDetail(MyApp.token);
              },
            ),
            ListingLocation(
              item: listing,
            ),
            ChatScreen(
              otherUser: User(
                  id: listing.accountId,
                  firstname: listing.title,
                  image: listing.image),
              listing: listing,
            )
          ]);
          break;
        case WebServiceResultStatus.error:
          mySnackBar(context,
              title: 'Listing Not Found',
              message: value.message, onPressed: () {
            _fetchDetail(token);
          }, status: SnackBarStatus.error);

          break;
        case WebServiceResultStatus.loading:
          break;

        case WebServiceResultStatus.unauthorized:
          break;
      }
    });
  }

  @override
  initState() {
    super.initState();

    _fetchDetail(MyApp.token);
  }

  @override
  Widget build(BuildContext context) {
    return (isLoading)
        ? Scaffold(
            body: Center(
              child: MyProgressIndicator(
                color: MyApp.resources.color.orange,
              ),
            ),
          )
        : (bottomNavInitialized)
            ? WillPopScope(
                onWillPop: _willPopCallback,
                child: ValueListenableBuilder<int>(
                    valueListenable:
                        bottomTabNavigation.onWidgetChangedListener,
                    builder: (context, selectedIndex, _) {
                      return Scaffold(
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
                                    child:
                                        bottomTabNavigation.getCurrentWidget()),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 70,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            blurRadius: 5,
                                            spreadRadius: 2,
                                            offset: Offset(
                                              0.0, // Move to right 10  horizontally
                                              -6.0, // Move to bottom 10 Vertically
                                            ),
                                          ),
                                        ]),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        bottomTab(
                                            icon: MyIcons.icListing,
                                            label: "Listing",
                                            index: 0),
                                        bottomTab(
                                            icon: MyIcons.icEvent,
                                            label: "Events",
                                            index: 1),
                                        bottomTab(
                                            icon: MyIcons.icMarker,
                                            label: "Location",
                                            index: 2),
                                        bottomTab(
                                            icon: MyIcons.icContact,
                                            label: "Contact",
                                            index: 3),
                                      ],
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
              )
            : Scaffold(
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
                          bottom: 0,
                          child: SafeArea(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 100),
                                    SvgPicture.asset(
                                      MyIcons.icError,
                                      height: 100,
                                      width: 80,
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Listing Not Found',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Go back to add a listing please!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                    height: MediaQuery.of(context).size.height,
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
          onTap: () {
            bottomTabNavigation.switchTab(index);
          },
          splashColor: Colors.orange.withOpacity(0.3),
          borderRadius: BorderRadius.circular(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (icon != null)
                SvgPicture.asset(icon,
                    color: selected
                        ? MyApp.resources.color.orange
                        : const Color(0xffBBBBBB)),
              const SizedBox(
                height: 6,
              ),
              Text(label,
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      fontWeight: FontFamily.semibold.fontWeight(),
                      fontSize: 10,
                      color: selected
                          ? MyApp.resources.color.orange
                          : const Color(0xffBBBBBB))),
              const SizedBox(
                height: 16,
              )
            ],
          )),
    ));
  }
}
