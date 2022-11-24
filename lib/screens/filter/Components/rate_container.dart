import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rakwa/main.dart';

class RateContainer extends StatefulWidget {
  const RateContainer({Key? key}) : super(key: key);

  static double rate = 0.0;

  @override
  _RateContainerState createState() => _RateContainerState();
}

class _RateContainerState extends State<RateContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 16, right: 16),
      decoration:  BoxDecoration(
        border: Border.all(width: 0.5, color: MyApp.resources.color.borderColor),
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Center(
        child: RatingBar.builder(
          initialRating: 0,
          glowColor: Colors.amber,
          minRating: 0,
          direction: Axis.horizontal,
          allowHalfRating: false,
          itemCount: 5,
          itemSize: 35,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            RateContainer.rate = rating;
          },
        ),
      ),
    );
  }
}