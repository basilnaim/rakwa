import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';

class DropDownContainer extends StatelessWidget {
  const DropDownContainer({
    Key? key,
    required this.context,
    required this.title,
    required this.dropdownButton,
  }) : super(key: key);

  final BuildContext context;
  final String title;
  final Widget dropdownButton;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          border: Border.all(
            color: MyApp.resources.color.borderColor,
            width: 0.8,
          ),
        ),
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontSize: 12, color: MyApp.resources.color.darkColor),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    border: Border.all(
                        color: MyApp.resources.color.borderColor, width: 1)),
                width: double.infinity,
                height: 45,
                child: dropdownButton)
          ],
        ));
  }
}
