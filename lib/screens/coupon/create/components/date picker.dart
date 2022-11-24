import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/coupon.dart';
import 'package:rakwa/utils/days.dart';

class DatePickerScreen extends StatefulWidget {
  String title;
  //start : 0
  //end : 1
  int type;
  Coupon coupon;
  DatePickerScreen(
      {Key? key, required this.title, required this.coupon, this.type = 0})
      : super(key: key);

  @override
  State<DatePickerScreen> createState() => DatePickerScreenState();
}

class DatePickerScreenState extends State<DatePickerScreen> {
  String error = "";

  setErrot(msg) {
    error = msg;
    setState(() {});
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
                buttonTheme: const ButtonThemeData(
                  colorScheme: ColorScheme.light(
                    primary: Colors.black,
                  ),
                ),
              ),
              child: e!);
        },
        initialDate: (widget.type == 1)
            ? ((widget.coupon.couponEnd == null)
                ? DateTime.now()
                : widget.coupon.couponEnd!)
            : ((widget.coupon.couponStart == null)
                ? DateTime.now()
                : widget.coupon.couponStart!),
        lastDate: DateTime(DateTime.now().year + 10),
        firstDate: (DateTime(DateTime.now().year-2)));
    if (picked != null) {
      if (widget.type == 0) {
        if (widget.coupon.couponEnd != null &&
            picked.isAfter(widget.coupon.couponEnd!)) {
          error = "coupon start must be before coupon end";
        } else {
          error = "";
          widget.coupon.couponStart = picked;
        }
      } else {
        if (widget.coupon.couponStart != null &&
            picked.isBefore(widget.coupon.couponStart!)) {
          error = "coupon end must be after coupon start";
        } else {
          error = "";
          widget.coupon.couponEnd = picked;
        }
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    String date = "yyyy-MM-dd";
    if (widget.type == 0) {
      if (widget.coupon.couponStart != null) {
        date = formatDate.format(widget.coupon.couponStart!);
      }
    } else {
      if (widget.coupon.couponEnd != null) {
        date = formatDate.format(widget.coupon.couponEnd!);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            widget.title,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                fontSize: 12, color: MyApp.resources.color.darkColor),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          onTap: () {
            _selectDate(context);
          },
          child: Container(
            height: 60,
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
              border: Border.all(
                color: (error.isNotEmpty)
                    ? Colors.red
                    : MyApp.resources.color.borderColor,
                width: 0.8,
              ),
            ),
            child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 16),
              child: Text(date,
                  style: Theme.of(context).textTheme.caption?.copyWith(
                        color: MyApp.resources.color.colorText.withOpacity(0.6),
                      )),
            ),
          ),
        ),
        if (error.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 4),
            child: Text(
              error,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(fontSize: 8, color: Colors.red),
            ),
          ),
      ],
    );
  }
}
