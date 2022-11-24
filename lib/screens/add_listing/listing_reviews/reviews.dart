import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/add_review.dart';
import 'package:rakwa/model/listing.dart';
import 'package:rakwa/model/review.dart';
import 'package:rakwa/model/review_result.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/res/images/MyImages.dart';
import 'package:rakwa/screens/home/home.dart';
import 'package:rakwa/views/bottom_btns.dart';
import 'package:rakwa/views/dialogs/review_dialog.dart';
import 'package:rakwa/views/progressing_button.dart';

import 'Components/header.dart';
import 'Components/review_item.dart';

class Reviews extends StatefulWidget {
  const Reviews({Key? key, this.listing}) : super(key: key);
  final Listing? listing;

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  bool isLoading = true;
  ReviewResult reviews = ReviewResult();
  String? token;
  final GlobalKey<ProgressingButtonState> _progressingButton = GlobalKey();

  @override
  void initState() {
    super.initState();

    _fetchReviews(MyApp.token);
  }

  _fetchReviews(String token) {
    print('fetch reviews data started');
    setState(() {
      isLoading = true;
    });

    MyApp.listingRepo
        .getReviews((widget.listing?.id ?? 0).toString(), token)
        .then((WebServiceResult<ReviewResult> value) {
      setState(() {
        isLoading = false;
      });
      switch (value.status) {
        case WebServiceResultStatus.success:
          print(value.data!);
          setState(() {
            reviews = value.data!;
          });
          break;
        case WebServiceResultStatus.error:
          reviews.listingDetails = ListingDetail(
              image: widget.listing?.image,
              name: widget.listing?.title,
              rating: widget.listing?.rating,
              view: widget.listing?.views);
          /* AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'fetch data home failed',
                  desc: value.message,
                  btnOk: null,
                  btnCancel: null)
              .show();*/

          break;
        case WebServiceResultStatus.loading:
          break;

        case WebServiceResultStatus.unauthorized:
          break;
      }
    });
  }

  _addReview(String comment, int rate) {
    setState(() {
      _progressingButton.currentState!.showProgress(true);
    });
    AddReview addReview = AddReview(
        listing_id: widget.listing?.id.toString(),
        comment: comment,
        rating: rate);
    MyApp.homeRepo
        .addReview(addReview, MyApp.token)
        .then((WebServiceResult<String> value) {
      setState(() {
        _progressingButton.currentState?.showProgress(false);
      });
      switch (value.status) {
        case WebServiceResultStatus.success:
          print(value.data!);
          Navigator.of(context).pop();
          _fetchReviews(MyApp.token);
          mySnackBar(context,
              title: 'Reviews',
              message: 'your review sended successfully',
              status: SnackBarStatus.success);
          break;
        case WebServiceResultStatus.error:
          mySnackBar(context,
              title: 'Review',
              message: 'you have already submitted a review',
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
        listing_id: widget.listing?.id.toString(),
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
          _fetchReviews(MyApp.token);

          mySnackBar(context,
              title: 'Review',
              message: 'Review edited successfully',
              status: SnackBarStatus.success);
          break;
        case WebServiceResultStatus.error:
          mySnackBar(context,
              title: 'Review',
              message: 'you have already submitted a review',
              status: SnackBarStatus.error);

          break;
        case WebServiceResultStatus.loading:
          break;

        case WebServiceResultStatus.unauthorized:
          break;
      }
    });
  }

  _deleteReview(String reviewId) {
    MyApp.listingRepo
        .deleteReview(widget.listing!.id.toString(), reviewId, MyApp.token)
        .then((WebServiceResult<String> value) {
      setState(() {
        _progressingButton.currentState?.showProgress(false);
      });
      switch (value.status) {
        case WebServiceResultStatus.success:
          print(value.data!);
          reviews.reviews
              ?.removeWhere((element) => element.id.toString() == reviewId);
          setState(() {});
          mySnackBar(context,
              title: 'Review',
              message: 'Review deleted!',
              status: SnackBarStatus.success);
          //_fetchReviews(MyApp.token)
          break;
        case WebServiceResultStatus.error:
          mySnackBar(context,
              title: 'Review',
              message: 'Deleting review failed!',
              status: SnackBarStatus.error);

          break;
        case WebServiceResultStatus.loading:
          break;

        case WebServiceResultStatus.unauthorized:
          break;
      }
    });
  }

  _onBackPressed() {
    int iReviewIt = 0;
    if (reviews.reviews != null && reviews.reviews!.isNotEmpty) {
      for (int i = 0; i < reviews.reviews!.length; i++) {
        if (reviews.reviews?[i].user_id == MyApp.userConnected?.id) {
          iReviewIt = 1;
        }
      }
    }
    Navigator.pop(context, iReviewIt);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _onBackPressed();
        return false;
      },
      child: Scaffold(
        backgroundColor: MyApp.resources.color.background,
        body: SafeArea(
          child: (isLoading)
              ? MyProgressIndicator(
                  color: MyApp.resources.color.orange,
                )
              : SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - 30,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Header(
                            onBackClick: () {
                              _onBackPressed();
                            },
                          ),
                          ReviewListingHeader(
                            listing: reviews.listingDetails,
                          ),
                          const SizedBox(height: 16),
                          (reviews.reviews != null &&
                                  reviews.reviews!.isNotEmpty)
                              ? Flexible(
                                  fit: FlexFit.loose,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: reviews.reviews?.length,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, i) {
                                      return ReviewItem(
                                        review: reviews.reviews?[i],
                                        editReview: () {
                                          if (widget.listing?.accountId ==
                                              MyApp.id) {
                                            mySnackBar(context,
                                                title: 'Review Info.',
                                                message:
                                                    "You cannot evaluate yourself",
                                                status: SnackBarStatus.error);
                                            return;
                                          }
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ReviewDialog(
                                                    comment: reviews
                                                        .reviews?[i].comment,
                                                    oldRating: reviews
                                                        .reviews?[i].rating,
                                                    isEdit: true,
                                                    submit: _editReview,
                                                    progressingButton:
                                                        _progressingButton);
                                              });
                                        },
                                        deleteReview: () {
                                          _deleteReview(reviews.reviews![i].id
                                              .toString());
                                        },
                                      );
                                    },
                                  ),
                                )
                              : Expanded(
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: double.maxFinite,
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(height: 16),
                                          SvgPicture.asset(
                                            MyIcons.icError,
                                            height: 100,
                                            width: 80,
                                          ),
                                          const SizedBox(height: 16),
                                          const Text(
                                            'This listing does not have any review',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          const Text(
                                            'Click the button below to submit first review',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const Spacer(),
                                          Container(
                                            margin: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                        .padding
                                                        .bottom +
                                                    16),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 32),
                                            height: 100,
                                            color: Colors.white,
                                            child: BottomButtons(
                                                neutralButtonText: "Back",
                                                submitButtonText:
                                                    "Submit Review",
                                                neutralButtonClick: () {
                                                  _onBackPressed();
                                                },
                                                submitButtonClick: () {
                                                  if (widget
                                                          .listing?.accountId ==
                                                      MyApp.id) {
                                                    mySnackBar(context,
                                                        title: 'Review Info.',
                                                        message:
                                                            "You cannot evaluate yourself",
                                                        status: SnackBarStatus
                                                            .error);
                                                    return;
                                                  }
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return ReviewDialog(
                                                            submit: _addReview,
                                                            progressingButton:
                                                                _progressingButton);
                                                      });
                                                }),
                                          )
                                        ]),
                                  ),
                                )
                        ]),
                  ),
                ),
        ),
      ),
    );
  }
}

class ReviewListingHeader extends StatelessWidget {
  const ReviewListingHeader({Key? key, this.listing}) : super(key: key);
  final ListingDetail? listing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 190,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border:
              Border.all(width: 0.5, color: MyApp.resources.color.borderColor)),
      child: Stack(children: [
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              listing?.image ?? "",
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.5),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          top: 0,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 14),
                Image.asset(
                  MyImages.adLogo,
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    listing?.name ?? "",
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Row(children: [
                        Icon(
                          Icons.visibility_outlined,
                          size: 16,
                          color: MyApp.resources.color.orange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          (listing?.view ?? 0).toString(),
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white),
                        )
                      ]),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(24))),
                      child: Row(children: [
                        const Text(
                          "Restaurant",
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 4),
                        RatingBarIndicator(
                          rating: (listing?.rating ?? 0.0).toDouble(),
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 16.0,
                          unratedColor: Colors.grey.shade100,
                          direction: Axis.horizontal,
                        ),
                      ]),
                    ),
                  ]),
                ),
                const SizedBox(height: 8),
              ]),
        )
      ]),
    );
  }
}
