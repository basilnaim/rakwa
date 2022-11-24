import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/likeModel.dart';
import 'package:rakwa/model/listing.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/res/images/MyImages.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/screens/add_listing/detail_listing.dart';

import '../../home_location.dart';

class LatestListingItem extends StatefulWidget {
  LatestListingItem({Key? key, required this.item, this.onClick})
      : super(key: key);

  final Listing item;
  final VoidCallback? onClick;

  @override
  State<LatestListingItem> createState() => _LatestListingItemState();
}

class _LatestListingItemState extends State<LatestListingItem> {
  _goToDetail() async {
    int? isFavorite = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DetailListingContainerScreen(
                listingId: widget.item.id.toString(),
              )),
    );

    print("zzzzzzzzz" + isFavorite.toString());

    if (isFavorite != null) {
      setState(() {
        widget.item.isFavorite = isFavorite;
      });
    }
  }

  _addToFavorite() {
    LikeModel likeModel = LikeModel();
    int type;
    if (widget.item.isFavorite == 0) {
      type = 1;
    } else {
      type = 0;
    }

    MyApp.homeRepo
        .favorite(widget.item.id, type, MyApp.token)
        .then((WebServiceResult<String> value) {
      switch (value.status) {
        case WebServiceResultStatus.success:
          if (value.data == "Favorite removed") {
            setState(() {
              widget.item.isFavorite = 0;
            });
          } else {
            setState(() {
              widget.item.isFavorite = 1;
            });
          }
          break;
        case WebServiceResultStatus.error:
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'Favorite failed',
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
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border:
              Border.all(width: 1, color: MyApp.resources.color.borderColor),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            onTap: () {
              _goToDetail();
            },
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // listing image container
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
                    height: 144,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Stack(children: [
                      Positioned(
                          left: 0.0,
                          right: 0.0,
                          top: 0.0,
                          bottom: 0.0,
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            child: FadeInImage.assetNetwork(
                              placeholder: 'lib/res/images/loader.gif',
                              placeholderFit: BoxFit.fill,
                              image: widget.item.image,
                              fit: BoxFit.cover,
                              imageErrorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return Image.asset(
                                  MyImages.errorImage,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          )),
                      (MyApp.isConnected)
                          ? Padding(
                              padding: const EdgeInsets.only(top: 10, right: 8),
                              child: Row(children: [
                                Image.asset(MyImages.adLogo),
                                const Spacer(),
                                Container(
                                  height: 32,
                                  width: 32,
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.4),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12))),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12)),
                                      onTap: () {
                                        _addToFavorite();
                                      },
                                      child: Center(
                                        child: SvgPicture.asset(
                                          'lib/res/icons/ic_heart.svg',
                                          height: 14,
                                          width: 14,
                                          color: (widget.item.isFavorite == 0)
                                              ? Colors.white
                                              : Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            )
                          : const SizedBox(),
                      Positioned(
                        bottom: 6,
                        left: 6,
                        child: Container(
                          height: 32,
                          padding: const EdgeInsets.only(
                              left: 11, right: 11, top: 5, bottom: 5),
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16))),
                          child: Row(
                            children: [
                              Text(
                                widget.item.category?.title ?? "",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(width: 6),
                              RatingBarIndicator(
                                rating: widget.item.rating.toDouble(),
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 18.0,
                                direction: Axis.horizontal,
                              ),
                            ],
                          ),
                        ),
                      )
                    ]),
                  ),
                  const SizedBox(height: 12),
                  // listing titre
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(children: [
                      Flexible(
                        child: Text(widget.item.title,
                            style: TextStyle(
                                color: MyApp.resources.color.topCategoriesColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      (widget.item.isWorkingNow == 1)
                          ? Container(
                              padding: const EdgeInsets.only(
                                  left: 4, right: 4, top: 2, bottom: 2),
                              color: MyApp.resources.color.green,
                              child: const Text(
                                'Open Now',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          : const SizedBox(width: 8)
                    ]),
                  ),
                  const SizedBox(height: 8),
                if(widget.item.address.isNotEmpty)  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(children: [
                   /*   SvgPicture.asset(
                        'lib/res/icons/ic_clock.svg',
                        height: 13,
                        width: 13,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '5 Hour ago',
                        style: TextStyle(
                            color: MyApp.resources.color.lightGrey,
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 8),*/
                      if(widget.item.address.isNotEmpty)
                      SvgPicture.asset(
                        'lib/res/icons/ic_marker.svg',
                        height: 13,
                        width: 13,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          widget.item.address,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              color: MyApp.resources.color.lightGrey,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ]),
                  ),
                 if(widget.item.address.isNotEmpty) const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      widget.item.description,
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: MyApp.resources.color.hintColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width,
                    color: MyApp.resources.color.borderColor,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 56,
                    decoration: BoxDecoration(
                        color:
                            MyApp.resources.color.borderColor.withOpacity(0.2),
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12))),
                    child: Row(children: [
                      Flexible(
                        flex: 1,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(12)),
                            onTap: () {
                              makePhoneCall(widget.item.phone);
                            },
                            child: Center(
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                        height: 32,
                                        width: 32,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(8)),
                                          color: Colors.grey.withOpacity(0.1),
                                        ),
                                        child: Icon(
                                          Icons.phone,
                                          color:
                                              MyApp.resources.color.iconColor,
                                        )),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Call ',
                                      style: TextStyle(
                                          color:
                                              MyApp.resources.color.iconColor,
                                          fontSize: 13),
                                    ),
                                    Flexible(
                                      child: Text(
                                        widget.item.phone,
                                        style: TextStyle(
                                            color: Colors.orange.shade700,
                                            fontSize: 13),
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: MediaQuery.of(context).size.height,
                        color: MyApp.resources.color.borderColor,
                      ),
                      Flexible(
                        flex: 1,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(12)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ListingLocation(item: widget.item)),
                              );
                            },
                            child: Center(
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 32,
                                      width: 32,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8)),
                                        color: Colors.grey.withOpacity(0.1),
                                      ),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          'lib/res/icons/ic_marker.svg',
                                          height: 22,
                                          width: 22,
                                          color:
                                              MyApp.resources.color.iconColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'View Location',
                                      style: TextStyle(
                                          color:
                                              MyApp.resources.color.iconColor,
                                          fontSize: 13),
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  )
                ]),
          ),
        ));
  }
}
