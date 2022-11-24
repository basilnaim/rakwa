import 'package:flutter/material.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/coupon.dart';
import 'package:rakwa/model/listing.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/screens/coupon/create/coupon_screen.dart';
import 'package:rakwa/screens/coupon/listing/components/item_coupon.dart';
import 'package:rakwa/screens/home/home.dart';
import 'package:rakwa/views/empty_content.dart';
import 'package:rakwa/views/header_back_btn.dart';
import 'package:rakwa/views/listing_spinner.dart';
import 'package:rakwa/views/not_registred.dart';
import 'package:rakwa/views/progressing_button.dart';

class CouponListing extends StatefulWidget {
  CouponListing({Key? key}) : super(key: key);

  @override
  State<CouponListing> createState() => _CouponListingState();
}

class _CouponListingState extends State<CouponListing> {
  GlobalKey<ProgressingButtonState> progressingButton =
      GlobalKey<ProgressingButtonState>();

  Listing? selectedListing;
  static ValueNotifier<List<Coupon>> coupons = ValueNotifier<List<Coupon>>([]);
  static ValueNotifier<List<Listing>> myListings =
      ValueNotifier<List<Listing>>([]);

  bool progressing = true;
  bool progressingCoupon = true;

  loading(progress) {
    if (progressing != progress) {
      setState(() {
        progressing = progress;
      });
    }
  }

  loadingCouponProgress(progress) {
    if (progressingCoupon != progress) {
      setState(() {
        progressingCoupon = progress;
      });
    }
  }

  @override
  initState() {
    super.initState();
    loadListing();
  }

  loadCoupons() {
    loadingCouponProgress(true);
    MyApp.appRepo.getListingCoupons(selectedListing?.id ?? 0).then((value) {
      loadingCouponProgress(false);

      switch (value.status) {
        case WebServiceResultStatus.success:
          coupons.value = value.data ?? [];

          break;
        case WebServiceResultStatus.error:
          mySnackBar(context,
              title: 'fetch coupons failed',
              message: value.message, onPressed: () {
            loadCoupons();
          }, status: SnackBarStatus.error);

          break;
        case WebServiceResultStatus.loading:
          break;
        case WebServiceResultStatus.unauthorized:
          break;
      }
    });
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
          if (myListings.value.isNotEmpty) {
            selectedListing = myListings.value.first;
            loadCoupons();
          }
          break;
        case WebServiceResultStatus.error:
          mySnackBar(context,
              title: 'fetch listing failed',
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

  deleteCoupon(int couponId) {
    loadingCouponProgress(true);
    MyApp.appRepo.deleteCoupon(couponId).then((value) {
      loadingCouponProgress(false);
      switch (value.status) {
        case WebServiceResultStatus.success:
          mySnackBar(context,
              title: 'Remove coupon',
              message: "Coupon removed successfully",
              status: SnackBarStatus.success);

          loadCoupons();

          break;
        case WebServiceResultStatus.error:
          mySnackBar(context,
              title: 'Remove coupon',
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
                    title: 'All Coupons',
                  ),
                ),
                Flexible(
                    child: Align(
                        alignment: Alignment.center,
                        child: RequireRegistreScreen(
                          postFunction: () {
                            loadListing();
                          },
                        ))),
              ],
            )
          : (progressing
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
                          child: HeaderWithBackScren(title: "All Coupons")),
                      Positioned(
                        top: 120,
                        left: 0,
                        right: 0,
                        bottom: 80,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16, top: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ValueListenableBuilder(
                                  valueListenable: myListings,
                                  builder: (BuildContext context,
                                      List<Listing> listings, Widget? child) {
                                    return listings.isEmpty
                                        ? Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.5,
                                            alignment: Alignment.center,
                                            child: EmpyContentScreen(
                                              title: "Listing",
                                              description:
                                                  "Create a listing then you can create a coupon",
                                            ))
                                        : ListingSpinnerWidget(
                                            myListings: listings,
                                            onListingChanged:
                                                (Listing listing) {
                                              selectedListing = listing;
                                              loadCoupons();
                                            },
                                          );
                                  }),
                              SizedBox(
                                height: 12,
                              ),
                              if (myListings.value.isNotEmpty)
                                Expanded(
                                  child: ValueListenableBuilder(
                                      valueListenable: coupons,
                                      builder: (BuildContext context,
                                          List<Coupon> mCoupons,
                                          Widget? child) {
                                        return progressingCoupon
                                            ? const Center(
                                                child: MyProgressIndicator(
                                                color: Colors.orange,
                                              ))
                                            : (mCoupons.isEmpty
                                                ? Align(
                                                    alignment: Alignment.center,
                                                    child: EmpyContentScreen(
                                                      title: "Coupons",
                                                      description:
                                                          "Click the button below to add the first Coupon",
                                                    ))
                                                : ListView.builder(
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemCount: mCoupons.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return ItemCoupon(
                                                          delete: deleteCoupon,
                                                          coupon:
                                                              mCoupons[index]);
                                                    }));
                                      }),
                                )
                            ],
                          ),
                        ),
                      ),
                      if (myListings.value.isNotEmpty)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            color: Colors.white,
                            height: 80,
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 20),
                            child: ProgressingButton(
                              textColor: Colors.white,
                              buttonText: 'Create New Coupon',
                              color: MyApp.resources.color.orange,
                              onSubmitForm: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CreateCouponScreen(
                                            coupon: Coupon(
                                                listingId: selectedListing?.id),
                                          )),
                                );

                                loadCoupons();
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
