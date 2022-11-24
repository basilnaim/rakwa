import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/utils/days.dart';

class EventDateWidget extends StatefulWidget {
  String title;
  String error;
  DateTime? date;
  Function(DateTime date) onDatePicked;
  EventDateWidget(
      {Key? key,
      this.date,
      required this.onDatePicked,
      required this.title,
      required this.error})
      : super(key: key);

  @override
  State<EventDateWidget> createState() => EventDateWidgetState();
}

class EventDateWidgetState extends State<EventDateWidget> {
  DateTime? selectedDate;


  @override
  initState(){
    super.initState();
   selectedDate = widget.date; 
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
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
        initialDate: selectedDate ?? DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 10),
        firstDate: DateTime.now());
    if (picked != null) {
      widget.error = "";
      widget.onDatePicked(picked);
      selectedDate = picked;
      setState(() {});
    }
  }

  bool checkDateNotEmpty(errorMsg) {
    if (selectedDate == null) {
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
                _selectDate(context);
              },
              child: Padding(
                padding: EdgeInsets.only(left: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    selectedDate == null
                        ? "yyyy-MM-dd"
                        : formatDate.format(selectedDate!),
                    style: Theme.of(context).textTheme.caption?.copyWith(
                        color:
                            MyApp.resources.color.colorText.withOpacity(0.6)),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (widget.error.isNotEmpty)
          Text(
            widget.error,
            style: Theme.of(context)
                .textTheme
                .bodyText2
                ?.copyWith(color: Colors.red),
          )
      ],
    );
  }
}
