import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rakwa/main.dart';

class PriceContainer extends StatelessWidget {
  const PriceContainer({Key? key, this.titre, this.value}) : super(key: key);

  final String? titre;
  final String? value;
 
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 60,
      decoration: BoxDecoration(
          border:
              Border.all(width: 0.5, color: MyApp.resources.color.borderColor),
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(12))),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 16),
            Text(
              titre ?? "",
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            RatingBarIndicator(
              rating: double.parse(value ?? "0.0"),
              itemBuilder: (context, index) => Text(
                "\$",
                style: TextStyle(
                    color: MyApp.resources.color.orange, fontSize: 16),
                // color: Colors.amber,
              ),
              itemCount: 5,
              unratedColor: Colors.grey.shade200,
              itemSize: 20.0,
              direction: Axis.horizontal,
            ),
            const SizedBox(width: 16),
          ]),
    );
  }
}
