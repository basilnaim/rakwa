import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/res/icons/my_icons.dart';

class CallContainer extends StatelessWidget {
  const CallContainer({Key? key, this.tel}) : super(key: key);
  final String? tel;

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
          borderRadius: const BorderRadius.all(Radius.circular(12))),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          onTap: () {
            makePhoneCall(tel??"");
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
                              MyIcons.icPhone,
                              height: 24,
                              width: 24,
                            ),
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  "Phone",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 8),
                Text(
                  tel??"",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.orange.shade400,
                      fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 0.5, color: MyApp.resources.color.borderColor),
                      color: Colors.grey.shade50,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(16))),
                  child: Row(children: const [
                    Text(
                      "Call",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: Colors.black,
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
