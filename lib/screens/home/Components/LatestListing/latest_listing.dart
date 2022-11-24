import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/listing.dart';
import 'package:rakwa/screens/all_listings/all_listings_screen.dart';
import 'package:rakwa/screens/home/Components/LatestListing/latest_listings_item.dart';

class LatestListing extends StatefulWidget {
  const LatestListing({Key? key, @required this.list}) : super(key: key);

  final List<Listing>? list;

  @override
  State<LatestListing> createState() => _LatestListingState();
}

class _LatestListingState extends State<LatestListing> {
  String? token;

  @override
  void initState() {
    super.initState();
    token = MyApp.token;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Row(children: [
            Text(
              MyApp.resources.strings.latestListing,
              style: TextStyle(
                  color: MyApp.resources.color.textColor,
                  fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            SizedBox(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AllListingsScreen()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 6, bottom: 6, left: 8, right: 8),
                    child: Row(children: [
                      Text(
                        "Show more",
                        style: TextStyle(
                          color: MyApp.resources.color.darkIconColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 12,
                        color: MyApp.resources.color.darkIconColor,
                      )
                    ]),
                  ),
                ),
              ),
            ),
          ]),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ListView.builder(
              itemBuilder: (_, index) {
                return LatestListingItem(
                  item: widget.list![index],
                );
              },
              itemCount: widget.list?.length ?? 0,
              primary: false,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 8),
              scrollDirection: Axis.vertical,
            ))
      ]),
    );
  }
}
