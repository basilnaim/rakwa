import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/res/icons/my_icons.dart';

class MiniButtonWidget extends StatelessWidget {
  Widget icon;
  Function onClick;
  MiniButtonWidget({Key? key, required this.icon, required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 42,
      decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: MyApp.resources.color.grey1, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(12))),
      child: Material(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: InkWell(
          splashColor: Colors.orange,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          onTap: () => onClick(),
          child: Center(child: icon),
        ),
      ),
    );
  }
}
