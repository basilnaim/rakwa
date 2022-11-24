import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/listing.dart';
import 'package:rakwa/res/images/MyImages.dart';

class MyListingImageContainer extends StatelessWidget {
  const MyListingImageContainer({Key? key, this.listing}) : super(key: key);
  final Listing? listing;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 160,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
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
            child: FadeInImage.assetNetwork(
              placeholder: 'lib/res/images/loader.gif',
              image: listing?.image ?? "",
              fit: BoxFit.cover,
              imageErrorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return Image.asset(
                  MyImages.errorImage,
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
