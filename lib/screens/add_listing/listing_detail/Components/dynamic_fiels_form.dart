import 'package:flutter/material.dart';
import 'package:rakwa/model/listing/listing_dynamic_field.dart';
import 'package:rakwa/screens/add_listing/listing_detail/Components/double_text_container.dart';
import 'package:rakwa/screens/add_listing/listing_detail/Components/price_container.dart';
import 'package:rakwa/screens/add_listing/listing_detail/Components/tick_container.dart';

class DynamicFieldsForm extends StatefulWidget {
  const DynamicFieldsForm({Key? key, this.myList}) : super(key: key);
  final List<DynamicFields>? myList;

  @override
  State<DynamicFieldsForm> createState() => _DynamicFieldsFormState();
}

class _DynamicFieldsFormState extends State<DynamicFieldsForm> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
          children: widget.myList!.map((e) {
        if (e.type == "textarea") {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: DoubleTextContainer(
              title: e.label,
              desc: e.data,
            ),
          );
        } else if (e.type == "range") {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: PriceContainer(
              titre: e.label,
              value: e.data,
            ),
          );
        } else if (e.type == "url") {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: DoubleTextContainer(
              title: e.label,
              desc: e.data,
            ),
          );
        } else if (e.type == "dropdown") {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: DoubleTextContainer(
              title: e.label,
              desc: e.data,
            ),
          );
        } else if (e.type == "text") {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: DoubleTextContainer(
              title: e.label,
              desc: e.data,
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TickContainer(title: e.label, items: e.checkData),
          );
        }
      }).toList()),
    );
  }
}
