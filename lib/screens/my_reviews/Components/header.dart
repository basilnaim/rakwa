import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';

class Header extends StatelessWidget {
  const Header({Key? key, this.isDetail = false}) : super(key: key);
  final bool isDetail;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 41.0,
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            //drawer button
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  border: Border.all(
                      width: 1, color: MyApp.resources.color.borderColor),
                  color: Colors.white),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Center(
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: MyApp.resources.color.iconColor,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            // header center text
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                  color: (isDetail) ? Colors.white : Colors.transparent,
                  border: Border.all(
                      width: 0.5,
                      color: (isDetail)
                          ? MyApp.resources.color.borderColor
                          : Colors.transparent),
                  borderRadius: BorderRadius.circular(24)),
              child: const Text(
                "All Reviews",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black),
              ),
            ),
            const Spacer(),
            //filter button
            const SizedBox(
              height: 42,
              width: 42,
            )
          ]),
        ),
      ]),
    );
  }
}
