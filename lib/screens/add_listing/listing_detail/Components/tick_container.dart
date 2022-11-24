import 'package:flutter/material.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';

class TickContainer extends StatelessWidget {
  const TickContainer({Key? key, this.title, this.items}) : super(key: key);

  final String? title;
  final List<String>? items;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: MyApp.resources.color.borderColor),
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
            const SizedBox(height: 16),
            Flexible(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  primary: false,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: items?.length,
                  gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      childAspectRatio: (items!.length > 2)? 3: (items!.length == 2)?6 : 9,
                      crossAxisCount: (items!.length > 2)? 3: (items!.length == 2)?2 : 1),
                  itemBuilder: (_, int index) {
                    return TickItem(name: items?[index],);
                  },
                ),
              ),
            ),
          ]),
    );
  }
}

class TickItem extends StatelessWidget {
  const TickItem({Key? key, this.name}) : super(key: key);
  final String? name;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3))],
                color: MyApp.resources.color.orange,
                shape: BoxShape.circle,
                border: Border.all(width: 1, color: Colors.white)),
            child: const Center(
              child: Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 14,
              ),
            )),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            name??"",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500),
          ),
        )
      ]),
    );
  }
}
