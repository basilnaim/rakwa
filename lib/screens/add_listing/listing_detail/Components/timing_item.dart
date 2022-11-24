import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/hours_work.dart';

class TimingItem extends StatefulWidget {
  TimingItem({Key? key, this.day, this.hours}) : super(key: key);

  final String? day;
  final HoursWork? hours;

  @override
  State<TimingItem> createState() => _TimingItemState();
}

class _TimingItemState extends State<TimingItem> {
  bool? isOpen;

  @override
  void initState() {
    super.initState();
    if (widget.hours!.start.toLowerCase() == "closed" &&
        widget.hours!.end.toLowerCase() == "closed") {
      isOpen = false;
    } else {
      isOpen = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      decoration: BoxDecoration(
          color: Colors.grey.shade50.withOpacity(0.7),
          border:
              Border.all(width: 0.5, color: MyApp.resources.color.borderColor),
          borderRadius: const BorderRadius.all(Radius.circular(12))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(width: 8),
        const Icon(
          Icons.access_time,
          size: 18,
          color: Colors.black,
        ),
        const SizedBox(width: 4),
        Text(
           widget.day?.substring(0,3).toUpperCase() ?? "",
          style: const TextStyle(
              fontSize: 12, color: Colors.black, fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          color: (isOpen!) ? Colors.green : Colors.red,
          child: Text(
            (isOpen!) ? 'ON' : 'OFF',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          height: 40,
          width: 1,
          color: MyApp.resources.color.borderColor,
        ),
        const SizedBox(width: 8),
        const Text(
          "From",
          style: TextStyle(
              fontSize: 12, color: Colors.grey, fontWeight: FontWeight.normal),
        ),
        const SizedBox(width: 3),
        Text(
          //  "11:00 AM",
          (isOpen!) ? widget.hours?.start ?? "" : "closed",
          style: const TextStyle(
              fontSize: 12, color: Colors.black, fontWeight: FontWeight.normal),
        ),
        const SizedBox(width: 8),
        Container(
          height: 40,
          width: 1,
          color: MyApp.resources.color.borderColor,
        ),
        const SizedBox(width: 8),
        const Text(
          "To",
          style: TextStyle(
              fontSize: 12, color: Colors.grey, fontWeight: FontWeight.normal),
        ),
        const SizedBox(width: 3),
        Flexible(
          child: Text(
            (isOpen!) ? widget.hours?.end ?? "" : "closed",
            style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.normal),
          ),
        ),
        const SizedBox(width: 8),
      ]),
    );
  }
}
