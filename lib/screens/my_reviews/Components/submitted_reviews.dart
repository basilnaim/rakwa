import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/listing.dart';
import 'package:rakwa/model/sumitted_reviews_model.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/res/images/MyImages.dart';
import 'package:rakwa/views/empty_content.dart';
import 'package:rakwa/views/my_customScroll_behavior.dart';

class SubmittedReviews extends StatefulWidget {
  const SubmittedReviews(
      {Key? key, this.list, this.deleteReview, this.editReview})
      : super(key: key);
  final List<SubmittedReviewsModel>? list;
  final Function(int reviewId, int listingId)? deleteReview;
  final Function(String comment, int rate, int listingId)? editReview;

  @override
  State<SubmittedReviews> createState() => _SubmittedReviewsState();
}

class _SubmittedReviewsState extends State<SubmittedReviews> {
  @override
  void initState() {
    super.initState();
    if (widget.list != null && widget.list!.isNotEmpty) {
      for (int i = 0; i < widget.list!.length; i++) {
        _fetchDetail(MyApp.token, widget.list![i], i);
      }
    }
  }

  _fetchDetail(String token, SubmittedReviewsModel review, int index) {
    print('fetch listing review data started');

    MyApp.listingRepo
        .detail((review.listing_id ?? 0).toString(), token)
        .then((WebServiceResult<Listing> value) {
      switch (value.status) {
        case WebServiceResultStatus.success:
          print(value.data!);
          setState(() {
            widget.list![index].listing = value.data!;
          });
          break;
        case WebServiceResultStatus.error:
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'fetch detail listing failed',
                  desc: value.message,
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
    return (widget.list != null && widget.list!.isNotEmpty)
        ? Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ScrollConfiguration(
                behavior: MyCustomScrollBehavior(),
                child: ListView.builder(
                  cacheExtent: 20,
                  shrinkWrap: true,
                  itemCount: widget.list?.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, i) {
                    return SubmittedReviewItem(
                      review: widget.list?[i],
                      editReview: () => widget.editReview!(
                          widget.list?[i].reviews?.first.message ?? "",
                          widget.list?[i].reviews?.first.rating ?? 0,
                          widget.list?[i].listing_id ?? 0),
                      deleteReview: () => widget.deleteReview!(
                          widget.list?[i].reviews?.first.review_id ?? 0,
                          widget.list?[i].listing_id ?? 0),
                    );
                  },
                ),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Align(
                alignment: Alignment.center,
                child: EmpyContentScreen(
                  title: "Submitted Reviews",
                  description: "",
                )),
          );
  }
}

class SubmittedReviewItem extends StatefulWidget {
  const SubmittedReviewItem(
      {Key? key, this.review, this.deleteReview, this.editReview})
      : super(key: key);
  final SubmittedReviewsModel? review;
  final VoidCallback? deleteReview;
  final VoidCallback? editReview;

  @override
  State<SubmittedReviewItem> createState() => _SubmittedReviewItemState();
}

class _SubmittedReviewItemState extends State<SubmittedReviewItem> {
  @override
  void initState() {
    super.initState();
    //precacheImage(NetworkImage(widget.review?.listing?.image ?? ""), context);
  }

  _showPopupMenu(BuildContext context, TapDownDetails details) {
    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        details.globalPosition.dx,
        details.globalPosition.dy,
        details.globalPosition.dx,
        details.globalPosition.dy,
      ), //position where you want to show the menu on screen
      items: [
        const PopupMenuItem<String>(child: Text('Edit'), value: '1'),
        const PopupMenuItem<String>(child: Text('Delete'), value: '2'),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value == "1") {
        widget.editReview?.call();
      }
      if (value == "2") {
        widget.deleteReview?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border.all(width: 0.5, color: MyApp.resources.color.borderColor),
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ReviewSubmittedItemHeader(
            listing: widget.review?.listing,
          ),
          const SizedBox(height: 16),
          Row(mainAxisSize: MainAxisSize.min, children: [
            (widget.review?.reviews?[0].reviewer_image != null)
                ? CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage(
                        widget.review?.reviews?[0].reviewer_image ?? ""),
                    backgroundColor: Colors.transparent,
                  )
                : const Icon(
                    Icons.account_circle_rounded,
                    size: 50,
                    color: Colors.black,
                  ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.review?.reviews?[0].reviewer_name ?? "",
                      style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    RatingBarIndicator(
                      rating:
                          (widget.review?.reviews?[0].rating ?? 0.0).toDouble(),
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 18.0,
                      unratedColor: Colors.grey.shade100,
                      direction: Axis.horizontal,
                    ),
                  ]),
            ),
            GestureDetector(
              onTapDown: (details) => _showPopupMenu(context, details),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                    color: MyApp.resources.color.background,
                    border: Border.all(
                        width: 0.5,
                        color:
                            MyApp.resources.color.borderColor.withOpacity(0.7)),
                    borderRadius: const BorderRadius.all(Radius.circular(13))),
                child: Center(
                  child: Image.asset(MyImages.dots, height: 16, width: 16),
                ),
              ),
            ),
          ]),
          const SizedBox(height: 12),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 0.5,
            color: MyApp.resources.color.borderColor,
          ),
          const SizedBox(height: 12),
          Text(
            widget.review?.reviews?[0].message ?? "",
            style: const TextStyle(
                fontSize: 13, color: Colors.black, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}

class ReviewSubmittedItemHeader extends StatelessWidget {
  const ReviewSubmittedItemHeader({Key? key, this.listing}) : super(key: key);
  final Listing? listing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 160,
      child: Stack(children: [
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FadeInImage.assetNetwork(
              placeholder: 'lib/res/images/loader.gif',
              image: listing?.image ?? "",
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
              imageErrorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return Image.asset(
                  MyImages.errorImage,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.cover,
                );
              },
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
                    listing?.title ?? "",
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
                          (listing?.views ?? 0).toString(),
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
                        Text(
                          listing?.category?.title ?? "",
                          style: const TextStyle(
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
