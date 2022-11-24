import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/hours_work.dart';
import 'package:rakwa/utils/days.dart';
import 'package:rakwa/views/day_of_week/text_time.dart';

class DayOfWeekWidget extends StatefulWidget {
  HoursWork hoursWork;
  int day;
  Function(HoursWork hoursWork)? onSelect;
  Function(HoursWork hoursWork)? onUnSelect;

  DayOfWeekWidget(
      {Key? key,
      required this.day,
      required this.hoursWork,
      required this.onUnSelect,
      required this.onSelect})
      : super(key: key);

  @override
  State<DayOfWeekWidget> createState() => _DayOfWeekWidgetState();
}

class _DayOfWeekWidgetState extends State<DayOfWeekWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        child: Row(
          children: [
            Flexible(
                flex: 3,
                child: SizedBox(
                  height: double.infinity,
                  child: Material(
                    borderRadius: const BorderRadius.all(Radius.circular(14)),
                    color: Colors.white,
                    child: InkWell(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(14),
                          bottomLeft: Radius.circular(14)),
                      onTap:
                          (widget.onUnSelect != null && widget.onSelect != null)
                              ? () {
                                  if (widget.hoursWork.selected) {
                                    widget.onUnSelect!(widget.hoursWork);
                                  } else {
                                    widget.onSelect!(widget.hoursWork);
                                  }
                                  setState(() {});
                                }
                              : null,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 12,
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            child: Visibility(
                                visible: widget.hoursWork.selected,
                                child: const Center(
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                )),
                            decoration: BoxDecoration(
                                color: widget.hoursWork.selected
                                    ? MyApp.resources.color.orange
                                    : MyApp.resources.color.blue4,
                                shape: BoxShape.circle),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              dayNames[widget.day],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(
                                      fontSize: 12,
                                      color: MyApp.resources.color.black1),
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Container(
                            color: widget.hoursWork.selected
                                ? Colors.green
                                : Colors.red,
                            padding:const EdgeInsets.all(2),
                            child: Text(
                              widget.hoursWork.selected ? "ON" : "OFF",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            width: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
            Flexible(
              flex: 4,
              child: Row(
                children: [
                  Expanded(
                      child: TextTime(
                    label: "From",
                    hoursWork: widget.hoursWork,
                  )),
                  Expanded(
                      child: TextTime(
                    label: "To",
                    isStartDay: false,
                    hoursWork: widget.hoursWork,
                  )),
                ],
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: MyApp.resources.color.grey1, width: 0.5),
            borderRadius: BorderRadius.all(Radius.circular(14))));
  }
}
