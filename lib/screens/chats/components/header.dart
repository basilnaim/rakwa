import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/listing.dart';
import 'package:rakwa/res/images/MyImages.dart';

class InboxHeader extends StatelessWidget {
  const InboxHeader({
    Key? key,
    required this.listing,
  }) : super(key: key);

  final Listing listing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 66,
      color: Colors.white,
      padding: EdgeInsets.only(top: 14, bottom: 14, left: 20, right: 32),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    onError: (e, t) {
                      Image.asset(MyImages.profilePic);
                    },
                    image: NetworkImage(
                      listing.image.isEmpty ? "null" : listing.image,
                    ))),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        listing.title,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(color: MyApp.resources.color.colorText),
                      ),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(top: 2, bottom: 2, left: 4, right: 4),
                      color: MyApp.resources.color.green,
                      child: Text(
                        "Open now",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            ?.copyWith(color: Colors.white),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                Flexible(
                  child: RatingBar.builder(
                    initialRating: listing.rating.toDouble(),
                    glowColor: Colors.amber,
                    minRating: 0,
                    ignoreGestures: true,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemSize: 18,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {},
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
