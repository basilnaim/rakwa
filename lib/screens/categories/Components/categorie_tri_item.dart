import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';

class TriItem extends StatelessWidget {
  const TriItem(
      {Key? key, this.index, this.title, this.isSelected = 0, this.onCLick})
      : super(key: key);

  final int? index;
  final String? title;
  final int? isSelected;
  final VoidCallback? onCLick;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onCLick!.call();
      },
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
            border:
                Border.all(width: 1, color: MyApp.resources.color.borderColor),
            color: (index == isSelected)
                ? MyApp.resources.color.orange
                : MyApp.resources.color.background.withOpacity(0.7),
            borderRadius: const BorderRadius.all(Radius.circular(24))),
        child: Center(
            child: Row(children: [
          Icon(
            Icons.check_circle_rounded,
            color:
                (index == isSelected) ? Colors.white : MyApp.resources.color.orange,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(title ?? "",
              style: TextStyle(
                color: (index == isSelected) ? Colors.white : Colors.black,
                fontWeight:
                    (index == isSelected) ? FontWeight.w600 : FontWeight.bold,
                fontSize: 12,
              )),
          const SizedBox(width: 4),
          Icon(
            Icons.keyboard_arrow_down_outlined,
            size: 12,
            color: (index == isSelected)
                ? Colors.white
                : MyApp.resources.color.iconColor,
          )
        ])),
      ),
    );
  }
}