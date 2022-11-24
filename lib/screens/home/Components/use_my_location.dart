import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/res/images/MyImages.dart';

class UseMyLocationContainer extends StatelessWidget {
  const UseMyLocationContainer({Key? key, this.onClick}) : super(key: key);

  final VoidCallback? onClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(width: 0.5, color: Colors.grey.withOpacity(0.2)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          onTap: () {
            onClick!.call();
          },
          child: Row(children: [
            const SizedBox(width: 16),
            SvgPicture.asset(
              MyIcons.icGps,
              color: MyApp.resources.color.orange,
              height: 24,
              width: 24,
            ),
            const SizedBox(width: 12),
            const Text(
              "use my location",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.black,
              size: 18,
            ),
            const SizedBox(width: 16),
          ]),
        ),
      ),
    );
  }
}