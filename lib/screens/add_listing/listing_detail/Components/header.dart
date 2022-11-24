import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/listing.dart';

class Header extends StatelessWidget {
  final Listing listing;
  const Header({Key? key, required this.listing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(width: 16),
        Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            border: Border.all(
                width: 0.5, color: MyApp.resources.color.borderColor),
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: const BorderRadius.all(
                Radius.circular(12),
              ),
              onTap: () {
                Navigator.pop(context, listing.isFavorite);
              },
              child: const Center(
                  child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: Colors.black,
              )),
            ),
          ),
        ),
        const Spacer(),
        Container(
          padding:
              const EdgeInsets.only(left: 12, right: 12, top: 2, bottom: 2),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: const Text(
            "Restaurant",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Spacer(),
        const SizedBox(
          height: 42,
          width: 42,
        ),
        const SizedBox(width: 16),
      ]),
    );
  }
}
