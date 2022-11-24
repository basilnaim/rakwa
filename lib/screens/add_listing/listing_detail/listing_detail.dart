import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/add_review.dart';
import 'package:rakwa/model/likeModel.dart';
import 'package:rakwa/model/listing.dart';
import 'package:rakwa/model/listing/claim_model.dart';
import 'package:rakwa/model/listing/listing_dynamic_field.dart';
import 'package:rakwa/model/listing/listing_social_links.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/res/images/MyImages.dart';
import 'package:rakwa/screens/add_listing/listing_detail/Components/all_photos.dart';
import 'package:rakwa/screens/add_listing/listing_detail/Components/dynamic_fiels_form.dart';
import 'package:rakwa/screens/add_listing/listing_detail/Components/tick_container.dart';
import 'package:rakwa/screens/add_listing/listing_reviews/reviews.dart';
import 'package:rakwa/screens/home_container/home_container_screen.dart';
import 'package:rakwa/views/bottom_btns.dart';
import 'package:rakwa/views/dialogs/default_dialog.dart';
import 'package:rakwa/views/dialogs/not_registred_dialog.dart';
import 'package:rakwa/views/dialogs/review_dialog.dart';
import 'package:rakwa/views/progressing_button.dart';
import 'package:rakwa/views/text_field/my_text_field.dart';
import 'Components/announcement_container.dart';
import 'Components/buisness_owner_container.dart';
import 'Components/call_container.dart';
import 'Components/desc_container.dart';
import 'Components/double_text_container.dart';
import 'Components/header.dart';
import 'Components/history_container.dart';
import 'Components/own_container.dart';
import 'Components/photos_container.dart';
import 'Components/share_item.dart';
import 'Components/timing_container.dart';
import 'Components/video_container.dart';

class ListingDetail extends StatefulWidget {
  const ListingDetail({Key? key, required this.listing}) : super(key: key);
  final Listing listing;

  @override
  State<ListingDetail> createState() => _ListingDetailState();
}

class _ListingDetailState extends State<ListingDetail> {
  PageController? controller;
  GlobalKey<PageContainerState> key = GlobalKey();
  int mInitialPage = 0;

  final GlobalKey<FormFieldState> _firstNameFieldState =
      GlobalKey<FormFieldState>();
  TextEditingController firstNameController = TextEditingController();

  final GlobalKey<FormFieldState> _lastNameFieldState =
      GlobalKey<FormFieldState>();
  TextEditingController lastNameController = TextEditingController();

  final GlobalKey<FormFieldState> _emailFieldState =
      GlobalKey<FormFieldState>();
  TextEditingController emailController = TextEditingController();
  final GlobalKey<FormFieldState> _phoneFieldState =
      GlobalKey<FormFieldState>();
  TextEditingController phoneController = TextEditingController();

  bool isLoading = true;

  Listing listing = Listing();
  String? token;
  List<DynamicFields> dynamicFieldsList = [];
  DynamicFields? features;
  DynamicFields? amenities;
  final GlobalKey<ProgressingButtonState> _progressingButton = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.listing.dynamicFields != null &&
        widget.listing.dynamicFields!.isNotEmpty) {
      dynamicFieldsList = widget.listing.dynamicFields!;
      dynamicFieldsList.forEach((element) {
        if (element.label?.trim() == "features") {
          features = element;
        }
        if (element.label?.trim() == "Amenities") {
          amenities = element;
        }
      });
      if (features != null) {
        widget.listing.dynamicFields?.remove(features);
      }
      if (amenities != null) {
        widget.listing.dynamicFields?.remove(amenities);
      }
    }
    listing = widget.listing;

    token = MyApp.token;
    if (MyApp.isConnected) {
      firstNameController.text = MyApp.userConnected?.firstname ?? "";
      lastNameController.text = MyApp.userConnected?.lastname ?? "";
      emailController.text = MyApp.userConnected?.username ?? "";
      phoneController.text = MyApp.userConnected?.phone ?? "";
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void nextPage() {
    controller?.animateToPage(controller!.page!.toInt() + 1,
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  void previousPage() {
    controller?.animateToPage(controller!.page!.toInt() - 1,
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  void _onImageClick(int index, List<String> images) {
    print("image clicked ===> $index");
    _showImageDialog(index, images);
  }

  void _showImageDialog(int index, List<String> images) {
    controller = PageController(initialPage: index);
    Dialog imageDialog = Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: MyApp.resources.color.background),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 220,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(12)),
                child: PageIndicatorContainer(
                  key: key,
                  child: PageView.builder(
                      controller: controller,
                      itemCount: images.length,
                      itemBuilder: (context, position) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            images[position],
                            width: MediaQuery.of(context).size.width,
                            height: 220,
                            fit: BoxFit.cover,
                          ),
                        );
                      }),
                  align: IndicatorAlign.bottom,
                  length: images.length,
                  indicatorSpace: 8.0,
                  padding: const EdgeInsets.all(10),
                  indicatorColor: Colors.white,
                  indicatorSelectorColor: MyApp.resources.color.orange,
                  shape: IndicatorShape.circle(size: 12),
                ),
              ),
              const SizedBox(height: 8),
              Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        border: Border.all(
                            width: 0.5,
                            color: MyApp.resources.color.borderColor)),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          previousPage();
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: const Center(
                          child: Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                    )),
                const SizedBox(width: 4),
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: MyApp.resources.color.background,
                        border: Border.all(
                            width: 0.5,
                            color: MyApp.resources.color.borderColor)),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true)
                              .pop('dialog');
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: const Center(
                            child: Text(
                          "Close",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        )),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: MyApp.resources.color.orange,
                      border: Border.all(
                          width: 0.5,
                          color: MyApp.resources.color.borderColor)),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        nextPage();
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ]),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => imageDialog);
  }

  _addReview(String comment, int rate) {
    setState(() {
      _progressingButton.currentState!.showProgress(true);
    });
    AddReview addReview = AddReview(
        listing_id: listing.id.toString(), comment: comment, rating: rate);
    MyApp.homeRepo
        .addReview(addReview, token ?? "")
        .then((WebServiceResult<String> value) {
      setState(() {
        _progressingButton.currentState?.showProgress(false);
      });
      switch (value.status) {
        case WebServiceResultStatus.success:
          print(value.data!);
          Navigator.of(context).pop();
          setState(() {
            listing.iReviewIt = 1;
          });
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

  _claimListing(ClaimModel claimModel) {
    setState(() {
      _progressingButton.currentState?.showProgress(true);
    });
    MyApp.listingRepo
        .claimListing(claimModel, token ?? "")
        .then((WebServiceResult<String> value) {
      setState(() {
        _progressingButton.currentState?.showProgress(false);
      });
      switch (value.status) {
        case WebServiceResultStatus.success:
          print(value.data!);
          Navigator.of(context).pop();
          var snackBar = SnackBar(
            content: const Text(
              'Listing Claimed Successfully!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: MyApp.resources.color.orange,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          break;
        case WebServiceResultStatus.error:
          Navigator.of(context).pop();
          mySnackBar(context,
              title: 'Review',
              message: 'you have already claimed this listing',
              status: SnackBarStatus.error);

          break;
        case WebServiceResultStatus.loading:
          break;

        case WebServiceResultStatus.unauthorized:
          Navigator.of(context).pop();
          mySnackBar(context,
              title: 'Review',
              message: 'Please login to claim this listing',
              status: SnackBarStatus.error);
          break;
      }
    });
  }

  void _addToFavorite() {
    LikeModel likeModel = LikeModel();
    int type;
    if (listing.isFavorite == 0) {
      type = 1;
    } else {
      type = 0;
    }

    MyApp.homeRepo
        .favorite(listing.id, type, token ?? "")
        .then((WebServiceResult<String> value) {
      switch (value.status) {
        case WebServiceResultStatus.success:
          if (value.data == "Favorite removed") {
            setState(() {
              listing.isFavorite = 0;
              widget.listing.isFavorite = 0;
            });
          } else {
            setState(() {
              listing.isFavorite = 1;
              widget.listing.isFavorite = 1;
            });
          }
          break;
        case WebServiceResultStatus.error:
          mySnackBar(context,
              title: 'Favorite',
              message: 'Change favorite failed',
              status: SnackBarStatus.error);

          break;
        case WebServiceResultStatus.loading:
          break;
        case WebServiceResultStatus.unauthorized:
          break;
      }
    });
  }

  void _awaitReturnValueFromSecondScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Reviews(listing: listing)),
    );

    setState(() {
      if (listing.iReviewIt != result) {
        listing.iReviewIt = result;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyApp.resources.color.background,
      body: SingleChildScrollView(
        child: Stack(children: [
          FadeInImage.assetNetwork(
            placeholder: 'lib/res/images/loader.gif',
            placeholderFit: BoxFit.cover,
            image: (widget.listing.imageCover.isEmpty)
                ? widget.listing.image
                : widget.listing.imageCover,
            height: 350,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            imageErrorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return Image.asset(
                MyImages.errorImage,
                height: 350,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              );
            },
          ),
          Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Header(
                  listing: listing,
                ),
                const SizedBox(height: 150),
                Container(
                  height: 148,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        width: 0.5, color: Colors.grey.withOpacity(0.2)),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: SvgPicture.asset(
                            MyIcons.icAdVertical,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8, left: 16, right: 16),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Flexible(
                              child: Text(
                                widget.listing.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Visibility(
                              visible: (widget.listing.isWorkingNow == 0)
                                  ? false
                                  : true,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 4),
                                color: Colors.green,
                                child: const Text(
                                  "Open Now",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            )
                          ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 8),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            /*    const Icon(
                              Icons.watch_later_outlined,
                              color: Colors.grey,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              "5 Hour Ago",
                              style:
                                  TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                            const SizedBox(width: 4),*/
                            const Icon(
                              Icons.pin_drop_outlined,
                              color: Colors.grey,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.listing.city?.title ?? "",
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.grey),
                            )
                          ]),
                        ),
                        const Spacer(),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 0.5,
                                  color: Colors.grey.withOpacity(0.2)),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16)),
                              color: MyApp.resources.color.background),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    bottomLeft: Radius.circular(16)),
                                onTap: () {
                                  _awaitReturnValueFromSecondScreen(context);
                                },
                                child: Container(
                                  height: 26,
                                  padding:
                                      const EdgeInsets.only(right: 8, left: 8),
                                  child: Row(children: [
                                    RatingBarIndicator(
                                      rating: widget.listing.rating.toDouble(),
                                      itemBuilder: (context, index) =>
                                          const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      itemCount: 5,
                                      unratedColor: Colors.grey.shade200,
                                      itemSize: 20.0,
                                      direction: Axis.horizontal,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'View All',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade700,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 14,
                                      color: Colors.grey.shade700,
                                    ),
                                  ]),
                                ),
                              ),
                            ),
                            Container(
                                width: 1,
                                height: 26,
                                color: Colors.grey.withOpacity(0.2)),
                            Flexible(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(16),
                                      bottomRight: Radius.circular(16)),
                                  onTap: () {
                                    if (!MyApp.isConnected) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return NotRegistredDialog(
                                                postFunction: () {
                                              Navigator.pop(
                                                  context, listing.isFavorite);
                                              Navigator.pop(
                                                  context, listing.isFavorite);
                                            });
                                          });
                                    } else {
                                      if (widget.listing.accountId ==
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
                                            if (listing.iReviewIt == 0) {
                                              return ReviewDialog(
                                                  submit: _addReview,
                                                  progressingButton:
                                                      _progressingButton);
                                            } else {
                                              return defaultDialog(
                                                  context,
                                                  "Notice",
                                                  "You have already submitted a review!",
                                                  "Close", () {
                                                Navigator.pop(context);
                                              });
                                            }
                                          });
                                    }
                                  },
                                  child: SizedBox(
                                    height: 26,
                                    child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(width: 8),
                                          Container(
                                            height: 18,
                                            width: 18,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: MyApp
                                                    .resources.color.orange),
                                            child: const Center(
                                              child: Icon(
                                                Icons.add,
                                                size: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Flexible(
                                            child: Text(
                                              "Submit Review",
                                              maxLines: 1,
                                              overflow: TextOverflow.visible,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade700,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                        ]),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ),
                        const SizedBox(height: 16),
                      ]),
                ),
                const SizedBox(height: 12),
                CallContainer(
                  tel: widget.listing.phone,
                ),
                const SizedBox(height: 12),
                (widget.listing.shortDescription.isNotEmpty ||
                        amenities != null)
                    ? DescContainer(
                        desc: widget.listing.shortDescription,
                        amenities: (amenities != null)
                            ? amenities?.checkData ?? []
                            : null,
                      )
                    : const SizedBox(),

                SizedBox(
                    height: (widget.listing.shortDescription.isNotEmpty ||
                            amenities != null)
                        ? 12
                        : 0),
                OwnContainer(
                  onClick: () {
                    showBottomSheetClaim(context);
                  },
                ),
                const SizedBox(height: 12),
                (widget.listing.hoursWork != null &&
                        widget.listing.hoursWork!.isNotEmpty)
                    ? TimingContainer(
                        hours_work: widget.listing.hoursWork,
                      )
                    : const SizedBox(),
                SizedBox(
                    height: (widget.listing.hoursWork != null &&
                            widget.listing.hoursWork!.isNotEmpty)
                        ? 12
                        : 0),
                // (widget.listing.video != null &&
                //         widget.listing.video!.url!.isNotEmpty &&
                //         widget.listing.video!.url! != "[]")
                //     ? VideoContainer(
                //         video: widget.listing.video!.url,
                //       )
                //     : const SizedBox(),
                // SizedBox(
                //     height: (widget.listing.video != null &&
                //             widget.listing.video!.url!.isNotEmpty &&
                //             widget.listing.video!.url! != "[]")
                //         ? 12
                //         : 0),
                (widget.listing.announcements != null &&
                        widget.listing.announcements!.isNotEmpty)
                    ? AnnouncementContainer(
                        announcements: widget.listing.announcements)
                    : const SizedBox(),
                SizedBox(
                    height: (widget.listing.announcements != null &&
                            widget.listing.announcements!.isNotEmpty)
                        ? 12
                        : 0),
                (widget.listing.gallery != null &&
                        widget.listing.gallery!.isNotEmpty)
                    ? PhotosContainer(
                        images: widget.listing.gallery ?? [],
                        viewAllPhotos: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AllPhotos(
                                      images: widget.listing.gallery ?? [],
                                    )),
                          );
                        },
                        onClick: (int i) {
                          _onImageClick(i, widget.listing.gallery!);
                        },
                      )
                    : const SizedBox(),
                SizedBox(
                    height: (widget.listing.gallery != null &&
                            widget.listing.gallery!.isNotEmpty)
                        ? 12
                        : 0),
                // (widget.listing.establishedIn.isNotEmpty)
                //     ? HistoryContainer(date: widget.listing.establishedIn)
                //     : const SizedBox(),
                // SizedBox(
                //     height:
                //         (widget.listing.establishedIn.isNotEmpty) ? 12 : 0),
                // (widget.listing.specialties.isNotEmpty)
                //     ? DoubleTextContainer(
                //         title: "Specialities",
                //         desc: widget.listing.specialties)
                //     : const SizedBox(),
                // SizedBox(
                //     height: (widget.listing.specialties.isNotEmpty) ? 12 : 0),
                (widget.listing.ownerName.isNotEmpty)
                    ? BuisnessOwnerContainer(
                        ownerName: widget.listing.ownerName,
                        ownerEmail: widget.listing.ownerEmail,
                      )
                    : const SizedBox(),
                SizedBox(
                    height: (widget.listing.ownerName.isNotEmpty) ? 12 : 0),
                // SizedBox(
                //     height: (widget.listing.ownerName.isNotEmpty) ? 12 : 0),
                // DoubleTextContainer(
                //   title: "Introduction",
                //   desc:
                //       "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged",
                // ),
                // const SizedBox(height: 12),
                // (widget.listing.buildingBridge.isNotEmpty)
                //     ? DoubleTextContainer(
                //         title: "Building Bridges",
                //         desc: widget.listing.buildingBridge,
                //       )
                //     : const SizedBox(),
                // SizedBox(
                //     height:
                //         (widget.listing.buildingBridge.isNotEmpty) ? 12 : 0),
                // (widget.listing.policies.isNotEmpty)
                //     ? DoubleTextContainer(
                //         title: "Policies", desc: widget.listing.policies)
                //     : const SizedBox(),
                // SizedBox(
                //     height: (widget.listing.policies.isNotEmpty) ? 12 : 0),
                (features != null)
                    ? TickContainer(
                        title: "Features",
                        items: features?.checkData ?? [],
                      )
                    : (widget.listing.features != null &&
                            widget.listing.features!.isNotEmpty)
                        ? TickContainer(
                            title: "Features",
                            items: widget.listing.features!
                                .map((e) => e.label ?? "")
                                .toList(),
                          )
                        : const SizedBox(),
                SizedBox(
                    height: (features != null ||
                            (widget.listing.features != null &&
                                widget.listing.features!.isNotEmpty))
                        ? 12
                        : 0),
                (widget.listing.longDescription.isNotEmpty)
                    ? DoubleTextContainer(
                        title: "Overview", desc: widget.listing.longDescription)
                    : const SizedBox(),
                SizedBox(
                    height:
                        (widget.listing.longDescription.isNotEmpty) ? 12 : 0),
                ((widget.listing.dynamicFields != null) &&
                        widget.listing.dynamicFields!.isNotEmpty)
                    ? DynamicFieldsForm(myList: widget.listing.dynamicFields)
                    : const SizedBox(),
                const SizedBox(height: 28),
              ]),
          (MyApp.isConnected)
              ? Positioned(
                  right: 32,
                  top: 226,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 0.5,
                            color: MyApp.resources.color.borderColor),
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12))),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        onTap: () {
                          _addToFavorite();
                        },
                        child: Center(
                          child: SvgPicture.asset(
                            "lib/res/icons/ic_heart.svg",
                            width: 20,
                            height: 20,
                            color: (listing.isFavorite == 1)
                                ? Colors.red
                                : MyApp.resources.color.borderColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          Positioned(
            right: (MyApp.isConnected) ? 88 : 32,
            top: 226,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 0.5, color: MyApp.resources.color.borderColor),
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(12))),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  onTap: () {
                    showBottomSheetShare(
                        context, listing.socialLinks!, listing.listingUrl);
                  },
                  child: Center(
                    child: SvgPicture.asset(
                      MyIcons.icShape,
                      width: 20,
                      height: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }

  void showBottomSheetClaim(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        builder: (ctx) => Container(
              height: MediaQuery.of(context).size.height * 0.65,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                color: MyApp.resources.color.background,
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  width: 80,
                  height: 6,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(24)),
                      color: Colors.grey.shade400),
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'CLAIMING YOUR BUSINESS LISTING',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: MyTextField(
                            initial: (MyApp.isConnected)
                                ? firstNameController.text
                                : "",
                            prefixWidget: SvgPicture.asset(
                              MyIcons.icPerson,
                              height: 21,
                              width: 21,
                            ),
                            formFieldeKey: _firstNameFieldState,
                            textInputAction: TextInputAction.next,
                            onSubmit: (onSubmmit) {
                              firstNameController.text = onSubmmit;
                              print("onsaaaave $onSubmmit");
                            },
                            onSave: (onSave) {},
                            hint: "الإسم الأول",
                            texthint: "الإسم الأول",
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: MyTextField(
                            initial: (MyApp.isConnected)
                                ? lastNameController.text
                                : "",
                            prefixWidget: SvgPicture.asset(
                              MyIcons.icPerson,
                              height: 21,
                              width: 21,
                            ),
                            formFieldeKey: _lastNameFieldState,
                            textInputAction: TextInputAction.next,
                            onSubmit: (onSubmmit) {
                              lastNameController.text = onSubmmit;
                              print("onsaaaave $onSubmmit");
                            },
                            onSave: (onSave) {},
                            hint: "Last Name",
                            texthint: "last Name",
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: MyTextField(
                            initial:
                                (MyApp.isConnected) ? emailController.text : "",
                            prefixWidget: SvgPicture.asset(
                              MyIcons.icEmail,
                              height: 21,
                              width: 21,
                            ),
                            formFieldeKey: _emailFieldState,
                            textInputAction: TextInputAction.next,
                            textInputType: TextInputType.emailAddress,
                            onSubmit: (onSubmmit) {
                              emailController.text = onSubmmit;
                              print("onsaaaave $onSubmmit");
                            },
                            onSave: (onSave) {},
                            hint: "Email",
                            texthint: "Email",
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: MyTextField(
                            initial:
                                (MyApp.isConnected) ? phoneController.text : "",
                            prefixWidget: SvgPicture.asset(
                              MyIcons.icPhone,
                              height: 21,
                              width: 21,
                            ),
                            formFieldeKey: _phoneFieldState,
                            textInputAction: TextInputAction.done,
                            textInputType: TextInputType.phone,
                            onSubmit: (onSubmmit) {
                              phoneController.text = onSubmmit;
                              print("onsaaaave $onSubmmit");
                            },
                            onSave: (onSave) {},
                            hint: "Phone",
                            texthint: "Phone",
                          ),
                        ),
                      ),
                      // const SizedBox(height: 12),
                      // Flexible(
                      //   child: DoubleTextContainer(
                      //     title: "VERIFICATION DETAILS",
                      //     desc:
                      //         "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. ",
                      //   ),
                      // ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            const SizedBox(width: 16),
                            const Icon(Icons.verified_user_outlined,
                                color: Colors.black, size: 18),
                            const SizedBox(width: 12),
                            Flexible(
                              child: Text(
                                  "Claim request is processed after verification...",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.normal)),
                            ),
                            const SizedBox(width: 16),
                          ]),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 20),
                          height: 100,
                          color: Colors.white,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                  MyApp.resources.color.orange),
                            ),
                            onPressed: () {
                              if (emailController.text.isEmpty ||
                                  firstNameController.text.isEmpty ||
                                  lastNameController.text.isEmpty ||
                                  phoneController.text.isEmpty) {
                                Navigator.of(context).pop();
                                mySnackBar(context,
                                    title: 'Claiming',
                                    message: 'please complete the form',
                                    status: SnackBarStatus.error);
                              } else {
                                ClaimModel claimModel = ClaimModel(
                                    listing_id: widget.listing.id,
                                    title: widget.listing.title,
                                    email: emailController.text,
                                    description: "test claim first time",
                                    long: "33.635421",
                                    lat: "-117.3254785",
                                    website_url: "www.rakwa.com",
                                    additional_phone: " ",
                                    label_additional_phone: " ",
                                    address: " ",
                                    city_id: widget.listing.city?.id,
                                    state_id: widget.listing.state?.id,
                                    zip: " ",
                                    phone: " ");
                                _claimListing(claimModel);
                              }
                            },
                            child: const Text(
                              "claim your business now!",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ))
                    ]),
                  ),
                ),
              ]),
            ));
  }

  void showBottomSheetShare(
      BuildContext context, ListingSocialLinks socialLinks, String? url) {
    Map<String, String> links = {};
    links.putIfAbsent("Facebook", () => socialLinks.facebook ?? "");
    links.putIfAbsent("Linkedin", () => "");
    links.putIfAbsent("Instagram", () => socialLinks.instagram ?? "");
    links.putIfAbsent("Pinterest", () => "");
    links.putIfAbsent("Twitter", () => socialLinks.twitter ?? "");
    links.putIfAbsent("Copy Link", () => url ?? "");

    List<String> icons = [
      MyImages.facebook,
      MyImages.linkedin,
      MyImages.insta,
      MyImages.pinterest,
      MyImages.twitter,
      MyImages.copy
    ];
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        builder: (context) => Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                color: MyApp.resources.color.background,
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  width: 80,
                  height: 6,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(24)),
                      color: Colors.grey.shade400),
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "Share listing in social media",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Flexible(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                primary: false,
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: links.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        mainAxisSpacing: 16,
                                        crossAxisSpacing: 16,
                                        childAspectRatio: 2.2,
                                        crossAxisCount: 2),
                                itemBuilder: (_, int index) {
                                  return ShareItem(
                                    titre: links.keys.elementAt(index),
                                    icon: icons[index],
                                    onClick: () {
                                      openLauncher(url ?? "",
                                          links.keys.elementAt(index), context);
                                      print(links.values.elementAt(index));
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          /*Container(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            width: MediaQuery.of(context).size.width,
                            height: 100,
                            color: Colors.white,
                            child: BottomButtons(
                              neutralButtonText: "Back",
                              submitButtonText: "Share",
                              neutralButtonClick: () =>
                                  Navigator.of(context).pop(),
                              submitButtonClick: () {},
                            ),
                          ),*/
                        ]),
                  ),
                ),
              ]),
            ));
  }
}
