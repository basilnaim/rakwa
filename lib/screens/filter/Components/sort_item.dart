// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';

class SortItem extends StatelessWidget {
  SortItem({Key? key, this.isSelected, this.onClick, this.titre})
      : super(key: key);

  bool? isSelected;
  VoidCallback? onClick;
  String? titre;

  @override
  Widget build(BuildContext context) {
    return (Flexible(
      flex: 1,
      child: Container(
        height: 46,
        decoration: BoxDecoration(
            color: (isSelected!) ? MyApp.resources.color.orange : Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(12))),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              onClick!.call();
            },
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: Center(
                child: Text(
              titre ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13,
                  color: (isSelected!) ? Colors.white : Colors.grey.shade700,
                  fontWeight: FontWeight.w400),
            )),
          ),
        ),
      ),
    ));
  }
}
