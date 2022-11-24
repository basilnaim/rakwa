import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/screens/categories/categories_list.dart';

class EmptyTopCategories extends StatelessWidget {
  const EmptyTopCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(top: 16, left: 16),
        child: Text(
          MyApp.resources.strings.topCategories,
          style: TextStyle(
              color: MyApp.resources.color.textColor,
              fontWeight: FontWeight.w600),
        ),
      ),
      const SizedBox(height: 16),
      Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: 60,
        decoration: BoxDecoration(
            border: Border.all(
                width: 1, color: MyApp.resources.color.borderColor),
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(12))),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Categories()),
              );
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
                    child: Center(
                      child: SvgPicture.asset(MyIcons.icListing,
                          color: MyApp.resources.color.iconColor,
                          width: 24,
                          height: 24,
                          fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    "Top Categories",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 8),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.only(
                        right: 8, top: 8, bottom: 8, left: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 0.5,
                            color: MyApp.resources.color.borderColor),
                        color: Colors.grey.shade50,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16))),
                    child: Row(children: const [
                      Text(
                        "View All",
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
      ),
    ]);
  }
}
