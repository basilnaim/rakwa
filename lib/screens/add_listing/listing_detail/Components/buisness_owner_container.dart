import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';

class BuisnessOwnerContainer extends StatelessWidget {
  const BuisnessOwnerContainer({Key? key, this.ownerName, this.ownerEmail})
      : super(key: key);
  final String? ownerName;
  final String? ownerEmail;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          border:
              Border.all(width: 0.5, color: MyApp.resources.color.borderColor),
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(12))),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "Meet the Buisness Owner",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(children: [
           /*   const CircleAvatar(
                radius: 20.0,
                backgroundImage: NetworkImage(
                    "https://bstatic.ccmbg.com/www.linternaute.com/dist/public/public-assets/img/restaurant/villes/444x333/1.jpg"),
                backgroundColor: Colors.transparent,
              ),
              const SizedBox(width: 12),*/
              Text(
                ownerName ?? "",
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            ]),
            const SizedBox(height: 8),
            Text(
              ownerEmail ?? "",
              style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  fontWeight: FontWeight.normal),
            )
          ]),
    );
  }
}
