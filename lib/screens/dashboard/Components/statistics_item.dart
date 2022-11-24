import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';

class StatisticsItem extends StatelessWidget {
  const StatisticsItem({Key? key, this.label, this.value}) : super(key: key);
  final String? label;
  final String? value;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border:
              Border.all(width: 1.5, color: MyApp.resources.color.borderColor)),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             Text(
              label??"",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w700),
            ),
            Text(
              value??"",
              maxLines: 1,
              overflow: TextOverflow.fade,
              style: TextStyle(
                  fontSize: 26,
                  color: MyApp.resources.color.orange,
                  fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}
