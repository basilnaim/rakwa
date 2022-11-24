import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/classified.dart';
import 'package:rakwa/res/images/MyImages.dart';
import 'package:rakwa/screens/classifieds/classified_detail.dart';

class ClassifiedsListItem extends StatelessWidget {
  const ClassifiedsListItem({Key? key, this.item}) : super(key: key);
  final Classified? item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        border:
            Border.all(width: 0.5, color: MyApp.resources.color.borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: (item?.id ?? 0) == 0
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ClassifiedDetail(
                              classifiedId: item?.id,
                            )),
                  );
                },
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(12),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'lib/res/images/loader.gif',
                      height: 160,
                      width: MediaQuery.of(context).size.width,
                      image: item?.image ?? "",
                      fit: BoxFit.cover,
                      imageErrorBuilder: (BuildContext context,
                          Object exception, StackTrace? stackTrace) {
                        return Image.asset(
                          MyImages.errorImage,
                          width: MediaQuery.of(context).size.width,
                          height: 160,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item?.title ?? "",
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item?.category ?? "",
                    style: TextStyle(
                        fontSize: 12,
                        color: MyApp.resources.color.orange,
                        fontWeight: FontWeight.w600),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
