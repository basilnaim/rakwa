import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/add_review.dart';
import 'package:rakwa/model/likeModel.dart';
import 'package:rakwa/model/listing.dart';
import 'package:rakwa/model/listing/listing_social_links.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/res/images/MyImages.dart';
import 'package:rakwa/screens/add_listing/listing_detail/Components/share_item.dart';
import 'package:rakwa/screens/add_listing/listing_reviews/reviews.dart';
import 'package:rakwa/screens/filter/Components/header.dart';
import 'package:rakwa/views/dialogs/default_dialog.dart';
import 'package:rakwa/views/dialogs/not_registred_dialog.dart';
import 'package:rakwa/views/dialogs/review_dialog.dart';
import 'package:rakwa/views/progressing_button.dart';
import 'package:url_launcher/url_launcher.dart';

class ListingLocation extends StatefulWidget {
  const ListingLocation({Key? key, this.item}) : super(key: key);
  final Listing? item;

  @override
  _ListingLocationState createState() => _ListingLocationState();
}

class _ListingLocationState extends State<ListingLocation>
    with WidgetsBindingObserver {
  GoogleMapController? _controller;
  final Set<Marker> _markers = {};
  bool firstCameraMove = true;
  String? _mapStyle;
  LocationData? myPosition;
  final GlobalKey<ProgressingButtonState> _progressingButton = GlobalKey();

  void _onMapCreated(GoogleMapController _cntlr) {
    _cntlr.setMapStyle(_mapStyle);

    _controller = _cntlr;
  }

  getIcons(Listing listing) async {
    final Response response = await get(Uri.parse(listing.image));
    var bytes = response.bodyBytes;

    final BitmapDescriptor markerIcon =
        await getBytesFromCanvas(120, 120, bytes);

    setState(() {
      print("markeeeer ==> $markerIcon");
      _markers.add(Marker(
        markerId: MarkerId(listing.id.toString()),
        position: LatLng(
          double.parse(listing.latitude),
          double.parse(listing.longitude),
        ),
        infoWindow: InfoWindow(
            title: (listing.listingUrl.isNotEmpty)
                ? listing.listingUrl
                : listing.title),
        onTap: () async {
          if (listing.listingUrl.isNotEmpty)
            await launchUrl(Uri.parse(listing.listingUrl));
        },
        icon: markerIcon,
      ));
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    rootBundle.loadString('lib/res/json_assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    if (currentPosition != null) {
      myPosition = currentPosition;
    } else {
      getLoc().then((value) {
        myPosition = value;
      });
    }
    if (widget.item != null) {
      getIcons(widget.item!);
    }
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        print('appLifeCycleState inactive');
        break;
      case AppLifecycleState.resumed:
        //final GoogleMapController controller = _controller!;
        _onMapCreated(_controller!);
        print('appLifeCycleState resumed');
        break;
      case AppLifecycleState.paused:
        _controller?.dispose();

        print('appLifeCycleState paused');
        break;
      case AppLifecycleState.detached:
        print('appLifeCycleState detached');
        break;
    }
  }

  void _AddToFavorite() {
    LikeModel likeModel = LikeModel();
    int type;
    if (widget.item?.isFavorite == 0) {
      type = 1;
    } else {
      type = 0;
    }

    MyApp.homeRepo
        .favorite(widget.item!.id, type, MyApp.token)
        .then((WebServiceResult<String> value) {
      switch (value.status) {
        case WebServiceResultStatus.success:
          if (value.data == "Favorite removed") {
            setState(() {
              widget.item?.isFavorite = 0;
            });
          } else {
            setState(() {
              widget.item?.isFavorite = 1;
            });
          }
          break;
        case WebServiceResultStatus.error:
          mySnackBar(context,
              title: 'Favorite failed',
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

  _addReview(String comment, int rate) {
    setState(() {
      _progressingButton.currentState!.showProgress(true);
    });
    AddReview addReview = AddReview(
        listing_id: widget.item?.id.toString(), comment: comment, rating: rate);
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
          break;
        case WebServiceResultStatus.error:
          mySnackBar(context,
              title: 'Favorite ',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyApp.resources.color.background,
      body: SafeArea(
        child: Stack(children: [
          GoogleMap(
              padding: const EdgeInsets.only(bottom: 230),
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(double.parse(widget.item?.latitude ?? "0.0"),
                    double.parse(widget.item?.longitude ?? "0.0")),
                zoom: 15,
              ),
              zoomControlsEnabled: false,
              onMapCreated: _onMapCreated),
          HeaderFilter(titre: "Location"),
          /*  const Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: UseMyLocationContainer(),
          ),*/
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Container(
              height: 138,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                border:
                    Border.all(width: 0.5, color: Colors.grey.withOpacity(0.2)),
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
                      padding:
                          const EdgeInsets.only(top: 8, left: 16, right: 16),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Flexible(
                          child: Text(
                            widget.item?.title ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 4),
                        (widget.item?.isWorkingNow == 1)
                            ? Container(
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
                              )
                            : const SizedBox(),
                      ]),
                    ),
                    if (widget.item!.address.isNotEmpty ||
                        widget.item!.city != null)
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 16, right: 16, top: 8),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          /*   const Icon(
                          Icons.watch_later_outlined,
                          color: Colors.grey,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          "5 Hour Ago",
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        const SizedBox(width: 4),*/
                          if (widget.item!.address.isNotEmpty ||
                              widget.item!.city != null)
                            const Icon(
                              Icons.pin_drop_outlined,
                              color: Colors.grey,
                              size: 16,
                            ),
                          const SizedBox(width: 4),
                          Text(
                            (widget.item?.address.isNotEmpty == true)
                                ? widget.item?.address ?? ""
                                : widget.item?.city?.title ?? "",
                            style: const TextStyle(
                                fontSize: 13, color: Colors.grey),
                          )
                        ]),
                      ),
                    //  const Spacer(),
                    Container(
                      margin:
                          const EdgeInsets.only(right: 16, left: 16, top: 16),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 0.5, color: Colors.grey.withOpacity(0.2)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16)),
                          color: Colors.grey.shade50),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                bottomLeft: Radius.circular(16)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Reviews(listing: widget.item),
                                ),
                              );
                            },
                            child: Container(
                              height: 26,
                              padding: const EdgeInsets.only(right: 8, left: 8),
                              child: Row(children: [
                                RatingBarIndicator(
                                  rating: (widget.item?.rating ?? 0).toDouble(),
                                  itemBuilder: (context, index) => const Icon(
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
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        });
                                      });
                                } else {
                                  if (widget.item?.accountId == MyApp.id) {
                                    mySnackBar(context,
                                        title: 'Review Info.',
                                        message: "You cannot evaluate yourself",
                                        status: SnackBarStatus.error);
                                    return;
                                  }
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        if (widget.item?.iReviewIt != null) {
                                          if (widget.item?.iReviewIt == 0) {
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
                                        } else {
                                          return ReviewDialog(
                                              submit: _addReview,
                                              progressingButton:
                                                  _progressingButton);
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
                                            color:
                                                MyApp.resources.color.orange),
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
                    const SizedBox(height: 8),
                  ]),
            ),
          ),
          // favori button
          (MyApp.isConnected)
              ? Positioned(
                  right: 32,
                  bottom: 130,
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      border: Border.all(
                          width: 0.5, color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        onTap: () {
                          _AddToFavorite();
                        },
                        child: Center(
                          child: SvgPicture.asset("lib/res/icons/ic_heart.svg",
                              width: 20,
                              height: 20,
                              color: (widget.item?.isFavorite == 1)
                                  ? Colors.red
                                  : MyApp.resources.color.borderColor),
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          //share button
          Positioned(
            right: (MyApp.isConnected) ? 88 : 32,
            bottom: 130,
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                border:
                    Border.all(width: 0.5, color: Colors.grey.withOpacity(0.2)),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  onTap: () {
                    showBottomSheetShare(
                        context,
                        widget.item?.socialLinks ?? ListingSocialLinks(),
                        widget.item?.listingUrl);
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
                          /*  Container(
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
