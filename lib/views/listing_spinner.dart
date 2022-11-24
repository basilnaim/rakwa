import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import 'package:rakwa/main.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/views/empty_content.dart';
import 'package:rakwa/views/spinner_container.dart';

import '../model/listing.dart';

class ListingSpinnerWidget extends StatefulWidget {
  List<Listing> myListings;
  int? selectedListingID;
  final bool? isReviews;

  Function(Listing listing) onListingChanged;

  ListingSpinnerWidget({
    Key? key,
    this.selectedListingID,
    required this.myListings,
    required this.onListingChanged,
    this.isReviews = false,
  }) : super(key: key);

  @override
  State<ListingSpinnerWidget> createState() => _ListingSpinnerWidgetState();
}

class _ListingSpinnerWidgetState extends State<ListingSpinnerWidget> {
  Listing? selectedListing;
  @override
  void initState() {
    super.initState();

    if (widget.selectedListingID != null &&
        (widget.selectedListingID ?? 0) > 0) {
      if (widget.myListings.isNotEmpty) {
        selectedListing = widget.myListings.singleWhere(
            (e) => e.id == widget.selectedListingID,
            orElse: () => widget.myListings.first);
     
      }
    } else {
      if (widget.myListings.isNotEmpty)
        selectedListing = widget.myListings.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropDownContainer(
        context: context,
        title:(widget.isReviews!)? "Select Listing to view reviews": "Select Listing to view the coupons",
        dropdownButton: DropdownButtonHideUnderline(
          child: DropdownButton<Listing>(
            value: selectedListing,
            icon: const Icon(Icons.keyboard_arrow_down),
            onChanged: (Listing? newValue) {
              if (newValue != null) {
                selectedListing = newValue;
                widget.onListingChanged(newValue);
              }
              setState(() {});
            },
            items: widget.myListings
                .map<DropdownMenuItem<Listing>>((Listing listing) {
              return DropdownMenuItem<Listing>(
                value: listing,
                child: Text(
                  listing.title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: MyApp.resources.color.colorText),
                ),
              );
            }).toList(),
          ),
        ));
  }
}
