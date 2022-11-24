import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/classified.dart';
import 'package:rakwa/screens/classifieds/classified_list.dart';
import 'package:rakwa/screens/home/Components/Classified/classified_item.dart';

class ClassifiedList extends StatelessWidget {
  const ClassifiedList({Key? key, @required this.list}) : super(key: key);

  final List<Classified>? list;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
          child: Row(children: [
            Text(
              MyApp.resources.strings.classified,
              style: TextStyle(
                  color: MyApp.resources.color.textColor,
                  fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            SizedBox(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AllClassifieds()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 6, bottom: 6, left: 8, right: 8),
                    child: Row(children: [
                      Text(
                        "Show more",
                        style: TextStyle(
                          color: MyApp.resources.color.darkIconColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 12,
                        color: MyApp.resources.color.darkIconColor,
                      )
                    ]),
                  ),
                ),
              ),
            ),
          ]),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ListView.builder(
              itemBuilder: (_, index) {
                return ClassifiedItem(item: list![index]);
              },
              itemCount: list?.length ?? 0,
              primary: false,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 8),
              scrollDirection: Axis.vertical,
            ))
      ]),
    );
  }
}
