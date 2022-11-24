import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/saved_listing.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/res/images/MyImages.dart';
import 'package:rakwa/screens/add_listing/detail_listing.dart';

class ItemSavedWidget extends StatelessWidget {
  SavedListing saved;
  Function(SavedListing saved) onFavoriteClick;
  ItemSavedWidget(
      {Key? key, required this.saved, required this.onFavoriteClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailListingContainerScreen(
                        listingId: saved.listing.id.toString(),
                      )),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 12,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          saved.listing.image,
                          errorBuilder: (l, m, j) {
                            return ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  MyImages.errorImage,
                                  fit: BoxFit.cover,
                                ));
                          },
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 15,
                      left: 0,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        color: MyApp.resources.color.green,
                        child: Text(
                          "Open",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 9,
                      right: 9,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          color: Colors.white,
                        ),
                        width: 30,
                        height: 30,
                        child: InkWell(
                          onTap: () {
                            onFavoriteClick(saved);
                          },
                          child: Center(
                              child: SvgPicture.asset(
                            MyIcons.icLikeFilled,
                            color: Colors.red,
                            width: 13,
                            height: 13,
                          )),
                        ),
                      ),
                    ),
                    Positioned(
                        left: 20,
                        right: 20,
                        bottom: 0,
                        child: Container(
                          height: 24,
                          width: 100,
                          child: Center(
                            child: Text(
                              saved.listing.category?.title ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  ?.copyWith(fontSize: 12, color: Colors.white),
                            ),
                          ),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color.fromARGB(255, 43, 43, 43),
                                  Color(0xff707070).withOpacity(0.9),
                                ],
                              ),
                              border: Border.all(
                                  width: 0.5,
                                  color: MyApp.resources.color.grey1)),
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                saved.listing.title,
                style: Theme.of(context).textTheme.subtitle2?.copyWith(
                    fontSize: 12, color: MyApp.resources.color.textColor),
              ),
              RatingBar.builder(
                initialRating: saved.listing.rating.toDouble(),
                glowColor: Colors.amber,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: false,
                ignoreGestures: true,
                itemCount: 5,
                itemSize: 16,
                updateOnDrag: false,
                unratedColor: Color(0xffEDF1F7),
                onRatingUpdate: (e) {},
                itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
              ),
              SizedBox(
                height: 8,
              ),
            ]),
          ),
        ),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: Colors.white,
          border: Border.all(width: 0.5, color: MyApp.resources.color.grey1)),
    );
  }
}
