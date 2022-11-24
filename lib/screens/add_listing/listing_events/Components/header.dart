import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(width: 16),
        Container(
          height: 42,
          width: 42,
          decoration:  BoxDecoration(
            border: Border.all(width: 0.5, color: MyApp.resources.color.borderColor),
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Center(
                  child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: Colors.black,
              )),
            ),
          ),
        ),
        const Spacer(),
        const Text(
          "Events",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        const SizedBox(
          height: 42,
          width: 42,
        ),
        const SizedBox(width: 16),
      ]),
    );
  }
}
