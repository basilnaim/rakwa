import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/utils/days.dart';

class EventTimeWidget extends StatefulWidget {
  String title;
  String error;
  TimeOfDay? time;
  Function(TimeOfDay time) onTimePicked;
  EventTimeWidget(
      {Key? key,
      required this.onTimePicked,
      required this.title,
      required this.error,
       this.time})
      : super(key: key);

  @override
  State<EventTimeWidget> createState() => EventTimeWidgetState();
}

class EventTimeWidgetState extends State<EventTimeWidget> {
 
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
              buttonTheme: const ButtonThemeData(
                colorScheme: ColorScheme.light(
                  primary: Colors.black,
                ),
              ),
            ),
            child: e!);
      },
      initialTime: widget.time ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
    );

    if (timeOfDay != null) {
      widget.error = "";

      widget.time = timeOfDay;
      widget.onTimePicked(timeOfDay);
      setState(() {});
    }
  }

  bool checkEventTimeNotEmpty(errorMsg) {
    if (widget.time == null) {
      widget.error = errorMsg;
      setState(() {});
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            widget.title,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                fontSize: 12, color: MyApp.resources.color.darkColor),
          ),
        ),
        SizedBox(height: 9),
        Container(
          height: 55,
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(12.0)),
            border: Border.all(
              color: (widget.error.isNotEmpty)
                  ? Colors.red
                  : MyApp.resources.color.borderColor,
              width: 0.8,
            ),
          ),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12)),
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              onTap: () {
                _selectTime(context);
              },
              child: Padding(
                padding: EdgeInsets.only(left: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.time == null
                        ? "hh:mm"
                        : formatTimeOfDay(widget.time!),
                    style: Theme.of(context).textTheme.caption?.copyWith(
                        color:
                            MyApp.resources.color.colorText.withOpacity(0.6)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
