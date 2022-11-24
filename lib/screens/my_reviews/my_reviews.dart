import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/add_review.dart';
import 'package:rakwa/model/error.dart';
import 'package:rakwa/model/listing.dart';
import 'package:rakwa/model/my_reviews_model.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/screens/add_listing/components/tamplate.dart';
import 'package:rakwa/screens/home/home.dart';
import 'package:rakwa/screens/my_reviews/Components/received_reviews.dart';
import 'package:rakwa/screens/my_reviews/Components/review_tab.dart';
import 'package:rakwa/screens/my_reviews/Components/submitted_reviews.dart';
import 'package:rakwa/views/dialogs/review_dialog.dart';
import 'package:rakwa/views/empty_content.dart';
import 'package:rakwa/views/error_widget.dart';
import 'package:rakwa/views/header_back_btn.dart';
import 'package:rakwa/views/listing_spinner.dart';
import 'package:rakwa/views/not_registred.dart';
import 'package:rakwa/views/progressing_button.dart';
import '../add_listing/listing_detail/listing_detail.dart';
import 'Components/header.dart';

class MyReviews extends StatefulWidget {
  const MyReviews({Key? key}) : super(key: key);

  @override
  State<MyReviews> createState() => _MyReviewsState();
}

class _MyReviewsState extends State<MyReviews> {
  // 0 = all reviews, 1 = recived, 2 = submitted
  int selectedTab = 1;
  bool isLoading = false;
  Listing? selectedListing;
  ListingDetail? selectedListingDetail;
  MyReviewsModel? myReviews;
  int selectedListingReviewId = -1;

  bool progressing = true;
  List<Listing> listings = [];
  final GlobalKey<ProgressingButtonState> _progressingButton = GlobalKey();
  ErrorModel? errorModel;

  loading(progress) {
    if (progressing != progress) {
      setState(() {
        progressing = progress;
      });
    }
  }

  loadListing() {
    loading(true);
    MyApp.listingRepo
        .myListings(MyApp.token)
        .then((WebServiceResult<List<Listing>> value) {
      loading(false);
      switch (value.status) {
        case WebServiceResultStatus.success:
          if (value.data!.isNotEmpty) {
            setState(() {
              listings = value.data ?? [];
              selectedListing = listings.first;
            });

            loadMyReviews();
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

  loadMyReviews({bool afterDelete = false}) {
    loading(true);
    MyApp.listingRepo
        .myReviews(MyApp.token)
        .then((WebServiceResult<MyReviewsModel> value) {
      loading(false);
      switch (value.status) {
        case WebServiceResultStatus.success:
          setState(() {
            myReviews = value.data;
            if (afterDelete) {
              selectedTab = 1;
            }
          });

          break;
        case WebServiceResultStatus.error:
          mySnackBar(context,
              title: 'fetch reviews failed',
              message: value.message, onPressed: () {
            loadMyReviews();
          }, status: SnackBarStatus.error);

          break;
        case WebServiceResultStatus.loading:
          break;
        case WebServiceResultStatus.unauthorized:
          break;
      }
    });
  }

  _deleteReview(String reviewId, int listingId) {
    MyApp.listingRepo
        .deleteReview(listingId.toString(), reviewId, MyApp.token)
        .then((WebServiceResult<String> value) {
      switch (value.status) {
        case WebServiceResultStatus.success:
          print(value.data!);
          loadMyReviews(afterDelete: true);
          break;
        case WebServiceResultStatus.error:
          mySnackBar(context,
              title: 'delete review failed',
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

  _editReview(String comment, int rate) {
    setState(() {
      _progressingButton.currentState!.showProgress(true);
    });
    AddReview addReview = AddReview(
        listing_id: selectedListingReviewId.toString(),
        comment: comment,
        rating: rate);
    MyApp.listingRepo
        .editReview(addReview, MyApp.token)
        .then((WebServiceResult<String> value) {
      setState(() {
        _progressingButton.currentState?.showProgress(false);
      });
      switch (value.status) {
        case WebServiceResultStatus.success:
          print(value.data!);
          Navigator.of(context).pop();
          loadMyReviews(afterDelete: true);
          break;
        case WebServiceResultStatus.error:
          mySnackBar(context,
              title: 'edit review failed',
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
    if (MyApp.isConnected) {
      loadListing();
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
                      title: 'All Reviews',
                    ),
                  ),
                  Flexible(
                      child: Align(
                          alignment: Alignment.center,
                          child: RequireRegistreScreen(
                            postFunction: () {
                              if (MyApp.isConnected) {
                                loadListing();
                                loadMyReviews();
                              }
                            },
                          ))),
                ],
              )
            : (progressing
                ? Center(
                    child: MyProgressIndicator(
                    color: MyApp.resources.color.orange,
                  ))
                : errorModel != null
                    ? Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16),
                            child: HeaderWithBackScren(
                              title: 'All Reviews',
                            ),
                          ),
                          Expanded(
                              child: MyErrorWidget(errorModel: errorModel!)),
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                            const Header(),
                            ReviewsTab(
                              onClick: (int selected) {
                                setState(() {
                                  selectedTab = selected;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            (selectedTab == 1 && listings.isNotEmpty)
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: ListingSpinnerWidget(
                                      isReviews: true,
                                      myListings: listings,
                                      onListingChanged: (Listing listing) {
                                        setState(() {
                                          selectedListing = listing;
                                        });
                                      },
                                    ),
                                  )
                                : const SizedBox(),
                            SizedBox(height: (selectedTab == 1) ? 16 : 0),
                            (selectedTab == 1)
                                ? (listings.isNotEmpty)
                                    ? ReceivedReviews(
                                        list: myReviews?.Received ?? [])
                                    : Expanded(
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: double.maxFinite,
                                          child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const SizedBox(height: 80),
                                                SvgPicture.asset(
                                                  MyIcons.icError,
                                                  height: 100,
                                                  width: 80,
                                                ),
                                                const SizedBox(height: 16),
                                                const Text(
                                                  'You have not added any listings yet',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
                                                const Text(
                                                  'Click the button below to create a new listing',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      )
                                : SubmittedReviews(
                                    editReview: ((message, rate, listingId) {
                                      selectedListingReviewId = listingId;
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ReviewDialog(
                                                comment: message,
                                                oldRating: rate,
                                                isEdit: true,
                                                submit: _editReview,
                                                progressingButton:
                                                    _progressingButton);
                                          }).then((value) {
                                        setState(() {
                                          selectedListingReviewId = -1;
                                        });
                                      });
                                    }),
                                    deleteReview: ((reviewId, listingId) =>
                                        _deleteReview(
                                            reviewId.toString(), listingId)),
                                    list: myReviews?.Submitted ?? []),
                            (selectedTab == 1 && listings.isEmpty)
                                ? Container(
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
                                              color:
                                                  Colors.black.withOpacity(0.2))
                                        ]),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 18, horizontal: 16),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ChooseTemplateScreen(),
                                          ),
                                        );
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
                                            MediaQuery.of(context).size.width,
                                            55),
                                        primary: MyApp.resources.color.orange,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              12), // <-- Radius
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ])),
      ),
    );
  }
}
