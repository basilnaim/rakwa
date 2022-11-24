import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/listing.dart';
import 'package:rakwa/model/my_listing.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/screens/home/home.dart';
import 'package:rakwa/screens/my_listings/Components/my_listing_item.dart';
import 'package:rakwa/screens/my_listings/Components/my_listing_tab.dart';
import 'package:rakwa/views/empty_content.dart';
import 'package:rakwa/views/header_back_btn.dart';
import 'package:rakwa/views/not_registred.dart';
import 'package:rakwa/views/search_container.dart';

import '../add_listing/components/tamplate.dart';
import 'Components/header.dart';

class MyListings extends StatefulWidget {
  const MyListings({Key? key}) : super(key: key);

  @override
  State<MyListings> createState() => _MyListingsState();
}

class _MyListingsState extends State<MyListings> {
  MyListingModel myListings = MyListingModel();
  List<Listing> displayedListings = [];

  // 0 = all listings, 1 = published, 2 = pending, 3 = expired
  int SelectedTab = 0;

  bool isLoading = false;

  isProgressing(bool progress) {
    if (isLoading != progress) {
      setState(() {
        isLoading = progress;
      });
    }
  }

  _fetchMyListings() {
    print('fetch my listings data started');
    displayedListings = [];
    isProgressing(true);

    MyApp.listingRepo
        .allMyListings(MyApp.token)
        .then((WebServiceResult<MyListingModel> value) {
      switch (value.status) {
        case WebServiceResultStatus.success:
          setState(() {
            isLoading = false;
            myListings = value.data!;
            displayedListings.addAll(myListings.published ?? []);
            displayedListings.addAll(myListings.pending ?? []);
            displayedListings.addAll(myListings.expired ?? []);
          });
          break;
        case WebServiceResultStatus.error:
          isProgressing(false);
          mySnackBar(context,
              title: 'fetch listings failed',
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

  _deleteMyListings(String listingId) {
    print('delete my listings data started');

    AwesomeDialog(
            context: context,
            dialogType: DialogType.INFO,
            animType: AnimType.SCALE,
            title: "Delete listing",
            desc: "You want to remove this listing?",
            btnOkText: 'Delete',
            btnOkOnPress: () {
              isProgressing(true);

              MyApp.listingRepo
                  .deleteListing(listingId, MyApp.token)
                  .then((WebServiceResult<String> value) {
                switch (value.status) {
                  case WebServiceResultStatus.success:
                    print(value.data!);
                    _fetchMyListings();
                    break;
                  case WebServiceResultStatus.error:
                    isProgressing(false);

                    mySnackBar(context,
                        title: 'Delete listings failed',
                        message: value.message,
                        status: SnackBarStatus.error);

                    break;
                  case WebServiceResultStatus.loading:
                    break;
                  case WebServiceResultStatus.unauthorized:
                    break;
                }
              });
            },
            btnCancelOnPress: () {},
            btnOkColor: Colors.orange,
            buttonsTextStyle: Theme.of(context)
                .textTheme
                .bodyText2
                ?.copyWith(color: Colors.white),
            btnCancelColor: Colors.blueGrey,
            btnCancelText: 'Cancel')
        .show();
  }

  @override
  void initState() {
    super.initState();
    if (MyApp.isConnected) {
      _fetchMyListings();
    }
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
                          title: 'My Listings',
                        ),
                      ),
                      Flexible(
                          child: Align(
                              alignment: Alignment.center,
                              child: RequireRegistreScreen(
                                postFunction: () {
                                  if (MyApp.isConnected) {
                                    _fetchMyListings();
                                  }
                                },
                              ))),
                    ],
                  )
                : isLoading
                    ? const Center(
                        child: MyProgressIndicator(
                        color: Colors.orange,
                      ))
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            const Header(),
                            MyListingTab(
                              onClick: (int selected) {
                                SelectedTab = selected;
                                setState(() {
                                  displayedListings.clear();
                                  if (selected == 1) {
                                    displayedListings
                                        .addAll(myListings.published ?? []);
                                  } else if (selected == 2) {
                                    displayedListings
                                        .addAll(myListings.pending ?? []);
                                  } else if (selected == 3) {
                                    displayedListings
                                        .addAll(myListings.expired ?? []);
                                  } else {
                                    displayedListings
                                        .addAll(myListings.published ?? []);
                                    displayedListings
                                        .addAll(myListings.pending ?? []);
                                    displayedListings
                                        .addAll(myListings.expired ?? []);
                                  }
                                });
                              },
                            ),
                            /*    const SizedBox(height: 12),
                        SearchContainer(
                          height: 55,
                          isHome: true,
                          isDetail: true,
                        ),*/
                            const SizedBox(height: 12),
                            (displayedListings.isNotEmpty)
                                ? Expanded(
                                    child: RefreshIndicator(
                                      color: MyApp.resources.color.orange,
                                      onRefresh: () async {
                                        displayedListings = [];
                                        _fetchMyListings();
                                      },
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: displayedListings.length,
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (context, i) {
                                          return MyListingItem(
                                            onEditClick: () {
                                              _fetchMyListings();
                                            },
                                            onRemoveClick: () {
                                              _deleteMyListings(
                                                  displayedListings[i]
                                                      .id
                                                      .toString());
                                            },
                                            item: displayedListings[i],
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                : Expanded(
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: EmpyContentScreen(
                                          title: (SelectedTab == 1)
                                              ? 'published listings '
                                              : (SelectedTab == 2)
                                                  ? 'pending listings'
                                                  : (SelectedTab == 3)
                                                      ? 'expired listings'
                                                      : 'listings',
                                          description:
                                              "Click the button below to add a new Listing",
                                        )),
                                  ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 5,
                                        spreadRadius: 5,
                                        offset: Offset(
                                          0.0, // Move to right 10  horizontally
                                          -6.0, // Move to bottom 10 Vertically
                                        ),
                                        color: Colors.black.withOpacity(0.2))
                                  ]),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 18, horizontal: 16),
                              child: ElevatedButton(
                                onPressed: () async {
                                  bool? created = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChooseTemplateScreen(),
                                    ),
                                  );

                                  print('PPPPPPP $created');

                                  if (created == true) _fetchMyListings();
                                },
                                child: const Text(
                                  'Create New Listing',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                ),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(
                                      MediaQuery.of(context).size.width, 55),
                                  primary: MyApp.resources.color.orange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12), // <-- Radius
                                  ),
                                ),
                              ),
                            ),
                          ])));
  }
}
