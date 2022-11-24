import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/res/icons/my_icons.dart';

class OwnContainer extends StatelessWidget {
  const OwnContainer({Key? key, this.onClick}) : super(key: key);
  final VoidCallback? onClick;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 60,
      decoration: BoxDecoration(
          border:
              Border.all(width: 0.5, color: MyApp.resources.color.borderColor),
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(16))),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          onTap: () {
            onClick?.call();
          },
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
                              MyIcons.icOwn,
                              height: 22,
                              width: 22,
                            ),
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  "Own or work here ?",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 0.5, color: MyApp.resources.color.borderColor),
                      color: MyApp.resources.color.orange,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(16))),
                  child: Row(children: const [
                    Text(
                      "Claim Now",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
                  ]),
                ),
                const SizedBox(width: 16),
              ]),
        ),
      ),
    );
  }
}
