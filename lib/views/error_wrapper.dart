import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';

class ErrorWrapper extends StatelessWidget {
  ErrorWrapper({
    Key? key,
    required this.error,
    required this.contentWidget,
  }) : super(key: key);
  String error = "";
  Widget contentWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius:const BorderRadius.all(Radius.circular(12)),
            border: Border.all(
              color: (error.isNotEmpty) ?Colors.red : MyApp.resources.color.borderColor
            )
          ),
          child: contentWidget),
        if (error.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 4),
            child: Text(
              error,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(fontSize: 12, color: Colors.red),
            ),
          ),
      ],
    );
  }
}
