import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/res/icons/my_icons.dart';

class HistoryContainer extends StatelessWidget {
  const HistoryContainer({Key? key, this.date}) : super(key: key);
  final String? date;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 60,
      decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: MyApp.resources.color.borderColor),
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(12))),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 16),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child:  Center(
                child: SvgPicture.asset(
                              MyIcons.icHistory,
                              height: 26,
                              width: 26,
                            ),
              ),
            ),
            const SizedBox(width: 16),
            const Text(
              "History",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 12),
            const Text(
              "Established in ",
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(width: 4),
            Text(
              date??"",
              style: TextStyle(
                  fontSize: 14,
                  color: MyApp.resources.color.orange,
                  fontWeight: FontWeight.bold),
            ),
          ]),
    );
  }
}
