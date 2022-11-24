import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';

class DiscoverTab extends StatefulWidget {
  const DiscoverTab({Key? key}) : super(key: key);

  @override
  State<DiscoverTab> createState() => _DiscoverTabState();
}

class _DiscoverTabState extends State<DiscoverTab> {
  int isSelected = 0;
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
                setState(() {
                  isSelected = 0;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                width: double.maxFinite,
                child: Text(
                  "All TOPICS",
                  style: TextStyle(
                    fontSize: 12,
                    color: (isSelected == 0)
                        ? MyApp.resources.color.orange
                        : Colors.black,
                    fontWeight:
                        (isSelected == 0) ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: InkWell(
              onTap: () {
                setState(() {
                  isSelected = 1;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                width: double.maxFinite,
                child: Text(
                  "TRENDING",
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
                setState(() {
                  isSelected = 2;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                width: double.maxFinite,
                child: Text(
                  "LATEST",
                  textAlign: TextAlign.end,
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
                  alignment: Alignment.bottomLeft,
                  width: 70,
                  height: 2,
                  child: Container(
                    color: (isSelected == 0)
                        ? MyApp.resources.color.orange
                        : Colors.white,
                    height: 2,
                    width: 74,
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
                    color: (isSelected == 1)
                        ? MyApp.resources.color.orange
                        : Colors.white,
                    height: 2,
                    width: 74,
                  ),
                ),
              )),
          Flexible(
              flex: 1,
              child: SizedBox(
                width: double.maxFinite,
                height: 2,
                child: Container(
                  alignment: Alignment.bottomRight,
                  width: 50,
                  height: 2,
                  child: Container(
                    color: (isSelected == 2)
                        ? MyApp.resources.color.orange
                        : Colors.white,
                    height: 2,
                    width: 50,
                  ),
                ),
              )),
        ]),
      ]),
    );
  }
}
