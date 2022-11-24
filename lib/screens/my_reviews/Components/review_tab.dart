import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';

class ReviewsTab extends StatefulWidget {
  ReviewsTab({Key? key, this.onClick}) : super(key: key);

  Function? onClick;

  @override
  State<ReviewsTab> createState() => _ReviewsTabState();
}

class _ReviewsTabState extends State<ReviewsTab> {
  int isSelected = 1;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 55,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(width: 0.5, color: MyApp.resources.color.borderColor)),
      child: Column(children: [
        const SizedBox(height: 2),
        const Spacer(),
        Row(mainAxisSize: MainAxisSize.min, children: [
          
          Flexible(
            flex: 1,
            child: InkWell(
              onTap: () {
                widget.onClick!(1);

                setState(() {
                  isSelected = 1;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                width: double.maxFinite,
                child: Text(
                  "Received",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: (isSelected == 1)
                        ? MyApp.resources.color.orange
                        : Colors.black,
                    fontWeight:
                        (isSelected == 1) ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: InkWell(
              onTap: () {
                widget.onClick!(2);

                setState(() {
                  isSelected = 2;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                width: double.maxFinite,
                child: Text(
                  "Submitted",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: (isSelected == 2)
                        ? MyApp.resources.color.orange
                        : Colors.black,
                    fontWeight:
                        (isSelected == 2) ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ]),
        const Spacer(),
        Row(mainAxisSize: MainAxisSize.min, children: [
          
          Flexible(
              flex: 1,
              child: SizedBox(
                width: double.maxFinite,
                height: 2,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  width: 60,
                  height: 2,
                  child: Container(
                    color: (isSelected == 1)
                        ? MyApp.resources.color.orange
                        : Colors.white,
                    height: 2,
                    width: 60,
                  ),
                ),
              )),
          Flexible(
              flex: 1,
              child: SizedBox(
                width: double.maxFinite,
                height: 2,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  width: 70,
                  height: 2,
                  child: Container(
                    color: (isSelected == 2)
                        ? MyApp.resources.color.orange
                        : Colors.white,
                    height: 2,
                    width: 70,
                  ),
                ),
              )),
        ]),
      ]),
    );
  }
}
