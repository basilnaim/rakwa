import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/res/icons/my_icons.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: MyApp.resources.color.background,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 41.0,
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
            const Text(
              "Events",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            ),
            const Spacer(),
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
