import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/screens/all_events/Components/all_event_item.dart';

import '../../../communs.dart';

class SelectListingConatiner extends StatefulWidget {
  const SelectListingConatiner({Key? key}) : super(key: key);

  @override
  State<SelectListingConatiner> createState() => _SelectListingConatinerState();
}

class _SelectListingConatinerState extends State<SelectListingConatiner> {
  List<String> listingItems = ['Listing', 'Classified', 'Article', 'Event'];
  String selectedListing = 'Listing';
  List<DropdownMenuItem<String>> listingListDropDownItems = [];

  void onChangeListingListDropDownItem(String? selected) {
    setState(() {
      selectedListing = selected!;
      //  _getCategories(selectedType.toLowerCase());
    });
  }

  @override
  void initState() {
    listingListDropDownItems = buildList(listingItems, context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          border:
              Border.all(width: 0.5, color: MyApp.resources.color.borderColor),
          color: Colors.white,
          borderRadius: BorderRadius.circular(16)),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Select Listing to View events",
              style: TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            MyDropDownListing<String>(
                value: selectedListing,
                items: listingListDropDownItems,
                onChanged: onChangeListingListDropDownItem),
          ]),
    );
  }
}

class MyDropDownListing<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>>? items;
  final IconData? icon;
  final T? value;
  final String? hintText;
  // ValueChanged with the passed type
  final ValueChanged<T?>? onChanged;

  const MyDropDownListing(
      {Key? key,
      @required this.items,
      this.icon,
      this.value,
      this.hintText,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 0.5,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
            value: value,
            icon: const Icon(Icons.keyboard_arrow_down),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.black, fontSize: 14),
            onChanged: onChanged!,
            items: items),
      ),
    );
  }
}
