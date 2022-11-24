import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/hours_work.dart';
import 'package:rakwa/utils/days.dart';
import 'timing_item.dart';

class TimingContainer extends StatefulWidget {
  const TimingContainer({Key? key, this.hours_work}) : super(key: key);
  final Map<int, HoursWork>? hours_work;

  @override
  _TimingContainerState createState() => _TimingContainerState();
}

class _TimingContainerState extends State<TimingContainer> {
  bool isStretched = false;
  String? today;
  @override
  void initState() {
    super.initState();
    print(widget.hours_work.toString());
    today = DateFormat('EEEE').format(DateTime.now());
    print("todayyyyyyy $today");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          border:
              Border.all(width: 0.5, color: MyApp.resources.color.borderColor),
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(12))),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
              child: Row(children: [
                const Text(
                  "Timing",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 0.5, color: MyApp.resources.color.borderColor),
                      color: Colors.white,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12))),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      onTap: () {
                        setState(() {
                          isStretched = !isStretched;
                        });
                      },
                      child: Center(
                          child: Icon(
                        (isStretched)
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        size: 20,
                        color: Colors.black,
                      )),
                    ),
                  ),
                )
              ]),
            ),
            const SizedBox(height: 12),
            (!isStretched)
                ? TimingItem(
                    day: dayNames.where((element) => element == today).first,
                    hours: widget.hours_work!.entries
                        .where((element) =>
                            element.key == dayNames.indexOf(today!))
                        .first
                        .value)
                : Column(
                    children: widget.hours_work!.entries
                        .map((entry) => TimingItem(
                              day: dayNames[entry.key],
                              hours: entry.value,
                            ))
                        .toList()

                    /* TimingItem(day: "Monday", isOpen: true),
                    TimingItem(day: "Tuesday", isOpen: true),
                    TimingItem(day: "Wednesday", isOpen: false),
                    TimingItem(day: "Tuesday", isOpen: true),
                    TimingItem(day: "Friday", isOpen: true),
                    TimingItem(day: "Saturday", isOpen: true),
                    TimingItem(day: "Sunday", isOpen: false),*/
                    )
          ]),
    );
  }
}
