import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/res/icons/my_icons.dart';

class Header extends StatelessWidget {
  const Header({Key? key, this.onDrawerClick}) : super(key: key);

  final VoidCallback? onDrawerClick;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: 100,
        color: MyApp.resources.color.background,
        child: Stack(children: [
          Column(children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 41.0,
              ),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
                        onDrawerClick!.call();
                      },
                      child: Center(
                        child: Icon(
                          Icons.menu,
                          color: MyApp.resources.color.iconColor,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                // header center text
                const Text(
                  "لوحة التحكم",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
                const Spacer(),
                //filter button
                Container(
                  height: 42,
                  width: 42,
                  /*  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      border: Border.all(
                          width: 1, color: MyApp.resources.color.borderColor),
                      color: Colors.white),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                        onTap: () {},
                        child: Center(
                          child: SvgPicture.asset(
                            MyIcons.icNotif,
                            width: 24,
                            height: 24,
                          ),
                        )),
                  ),*/
                )
              ]),
            ),
          ]),
          /* Positioned(
            right: 11,
            top: 36,
            child: Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orange.shade700.withOpacity(0.7)),
              child: const Center(
                  child: Text(
                '5',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              )),
            ),
          ),*/
        ]),
      ),
    );
  }
}
