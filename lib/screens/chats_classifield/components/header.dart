import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/classified.dart';

class InboxHeader extends StatelessWidget {
  const InboxHeader({
    Key? key,
    required this.classfield,
  }) : super(key: key);

  final Classified classfield;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border.all(
            width: 0.5,
            color: MyApp.resources.color.borderColor,
          )),
      height: 130,
      margin: const EdgeInsets.only(left: 16, right: 16),
      padding: const EdgeInsets.only(top: 14, bottom: 14, left: 16, right: 16),
      child: Stack(
        children: [
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  classfield.image ?? "",
                  height: 150.0,
                  fit: BoxFit.cover,
                  width: 100.0,
                ),
              )),
          Positioned(
              top: 0,
              bottom: 0,
              left: 18,
              right: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    classfield.title ?? "",
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    classfield.description ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        ?.copyWith(color: Colors.white, fontSize: 11),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
