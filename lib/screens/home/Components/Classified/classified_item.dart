import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/classified.dart';
import 'package:rakwa/res/images/MyImages.dart';
import 'package:rakwa/screens/classifieds/classified_detail.dart';

class ClassifiedItem extends StatelessWidget {
  const ClassifiedItem({Key? key, @required this.item, this.onCLick})
      : super(key: key);

  final Classified? item;
  final VoidCallback? onCLick;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border:
              Border.all(width: 1, color: MyApp.resources.color.borderColor),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ClassifiedDetail(
                          classifiedId: item?.id,
                        )),
              );
            },
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // classified image container
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
                    height: 144,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'lib/res/images/loader.gif',
                        image: item?.image ?? "",
                        fit: BoxFit.cover,
                        imageErrorBuilder: (BuildContext context,
                            Object exception, StackTrace? stackTrace) {
                          return Image.asset(
                            MyImages.errorImage,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // classified titre
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(item?.title ?? "",
                        style: TextStyle(
                            color: MyApp.resources.color.topCategoriesColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  //classified categorie
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      item?.category ?? "",
                      style: TextStyle(
                          color: Colors.orange.shade700,
                          fontSize: 13,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 16),
                ]),
          ),
        ));
  }
}
