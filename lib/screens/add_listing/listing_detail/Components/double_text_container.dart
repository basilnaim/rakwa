import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';

class DoubleTextContainer extends StatelessWidget {
  DoubleTextContainer({Key? key, this.title, this.desc}) : super(key: key);

  String? title;
  String? desc;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          border:
              Border.all(width: 0.5, color: MyApp.resources.color.borderColor),
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(12))),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              capitalize(title ?? ""),
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              HtmlParser.parseHTML(HtmlParser.parseHTML(desc ?? "").text).text,
              // desc ?? "",
              style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  fontWeight: FontWeight.normal),
            )
          ]),
    );
  }
}
