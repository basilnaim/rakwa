import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/listing.dart';
import 'package:rakwa/model/listing/all_listing.dart';
import 'package:rakwa/model/my_listing.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/screens/add_listing/detail_listing.dart';
import 'package:rakwa/screens/home/home.dart';
import 'package:rakwa/views/header_back_btn.dart';

import '../home/Components/LatestListing/latest_listings_item.dart';

class AllListingsScreen extends StatefulWidget {
  const AllListingsScreen({Key? key}) : super(key: key);

  @override
  State<AllListingsScreen> createState() => _AllListingsScreenState();
}

class _AllListingsScreenState extends State<AllListingsScreen> {
  bool progressing = true;
  late ScrollController controller;

  AllListing? allListing;
  List<Listing> listings = [];
  progress(bool loading) {
    if (progressing != loading) {
      setState(() {
        progressing = loading;
      });
    }
  }

  _fetchAllListings() {
    print('fetch all listings data started');

    int page = 0;
    if (allListing != null) {
      page = allListing!.paging.page + 1;
      if (page > allListing!.paging.pages) page = -1;
    }

    if (page > -1) {
      progress(true);

      if (currentPosition == null) {
        getLoc().then((value) {
          _fetchListings(page);
        });
      } else {
        _fetchListings(page);
      }
    }
  }

  _fetchListings(page) {
    try {
      MyApp.listingRepo
          .allListings((currentPosition?.latitude ?? 36.3659527),
              (currentPosition?.longitude ?? -117.3645113), page)
          .then((WebServiceResult<AllListing> value) {
        switch (value.status) {
          case WebServiceResultStatus.success:
            allListing = value.data!;
            listings.addAll(allListing?.items ?? []);
            progress(false);
            break;
          case WebServiceResultStatus.error:
            progress(false);
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
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    _fetchAllListings();
    controller = ScrollController()
      ..addListener(() {
        if (controller.position.pixels == controller.position.maxScrollExtent) {
          if (!progressing) {
            _fetchAllListings();
          }
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyApp.resources.color.background,
        body: SafeArea(
            child: (progressing && allListing == null)
                ? const Center(
                    child: MyProgressIndicator(
                    color: Colors.orange,
                  ))
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, left: 16, right: 16),
                        child: HeaderWithBackScren(title: "All Listing"),
                      ),
                      Expanded(
                        child: (allListing == null)
                            ? const Center(
                                child: Text("Some problem has occured"),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: RefreshIndicator(
                                  onRefresh: () async {
                                    allListing = null;
                                    listings = [];
                                    _fetchAllListings();
                                  },
                                  child: ListView.builder(
                                    controller: controller,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemBuilder: (cntx, index) {
                                      return LatestListingItem(
                                        item: listings[index],
                                      );
                                    },
                                    itemCount: listings.length,
                                    primary: false,
                                    shrinkWrap: true,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    scrollDirection: Axis.vertical,
                                  ),
                                )),
                      ),
                      if (progressing)
                        const Align(
                            alignment: Alignment.bottomCenter,
                            child: MyProgressIndicator(
                              color: Colors.orange,
                            ))
                    ],
                  )));
  }
}
