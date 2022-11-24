import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/hours_work.dart';
import 'package:rakwa/utils/days.dart';

class TextTime extends StatefulWidget {
  String label;
  HoursWork hoursWork;
  bool isStartDay;
  TextTime(
      {Key? key,
      required this.label,
      required this.hoursWork,
      this.isStartDay = true})
      : super(key: key);

  @override
  State<TextTime> createState() => _TextTimeState();
}

class _TextTimeState extends State<TextTime> {
  late TimeOfDay current;
  late TimeOfDay comparableTime;
  @override
  initState() {
    super.initState();
    current = ((widget.isStartDay)
            ? getTimeFromString(widget.hoursWork.start)
            : getTimeFromString(widget.hoursWork.end)) ??
        TimeOfDay(hour: (widget.isStartDay) ? 6 : 20, minute: 0);

    comparableTime = ((widget.isStartDay)
            ? getTimeFromString(widget.hoursWork.end)
            : getTimeFromString(widget.hoursWork.start)) ??
        TimeOfDay(hour: (widget.isStartDay) ? 6 : 20, minute: 0);
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      builder: (c, e) {
        return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                // change the border color
                primary: MyApp.resources.color.grey2,
                // change the text color
                onSurface: Colors.black,
              ),
              // button colors
              buttonTheme: ButtonThemeData(
                colorScheme: ColorScheme.light(
                  primary: Colors.black,
                ),
              ),
            ),
            child: e!);
      },
      initialTime: current,
      initialEntryMode: TimePickerEntryMode.dial,
    );

    if (timeOfDay != null) {
      int compare = compareTwoTimes(timeOfDay, comparableTime);
      current = timeOfDay;
      if (widget.isStartDay) {
        widget.hoursWork.start = DateFormat.Hm().format(nowTime(current));
      } else {
        widget.hoursWork.end = DateFormat.Hm().format(nowTime(current));
      }
      setState(() {});
      /*
      if (widget.isStartDay) {
    
        if (compare < 0) {
          // not ok
       
          errorMessage(context, "Start date should not be after the end date");
        } else {
          //ok
          current = timeOfDay;
          setState(() {});
        }
      } else {
        if (compare >= 0) {
          // not ok
          errorMessage(context, "End date should not be befor the start date");
        } else {
          //ok
          current = timeOfDay;
          setState(() {});
        }
      }
     */
    }
  }

  errorMessage(context, message) {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.INFO,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Hour Picker',
            desc: message,
            btnOkText: "ok",
            btnOkOnPress: () => _selectTime(context),
            btnOkColor: Colors.black,
            btnCancel: null)
        .show();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      color: Colors.white,
      child: InkWell(
          borderRadius: !widget.isStartDay
              ? BorderRadius.only(
                  bottomRight: Radius.circular(14),
                  topRight: Radius.circular(14))
              : null,
          onTap: () {
            if (widget.hoursWork.selected) _selectTime(context);
          },
          child: Container(
            height: double.infinity,
            padding: EdgeInsets.only(left: 4, right: 6),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                    color: Color(0xff888888).withOpacity(0.6), width: 0.5),
              ),
            ),
            child: Center(
              child: RichText(
                text: TextSpan(
                  text: widget.label + "  ",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      ?.copyWith(fontSize: 10, color: Color(0xff888888)),
                  children: <TextSpan>[
                    TextSpan(
                      text: formatTimeOfDay(current),
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          ?.copyWith(fontSize: 12, color: Color(0xff484848)),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
