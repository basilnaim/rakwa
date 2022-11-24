import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/res/images/MyImages.dart';

import '../../../../model/categorie.dart';

class TopCatgorieItem extends StatelessWidget {
  const TopCatgorieItem(
      {Key? key, required this.item, this.isLast = false, this.onCLick})
      : super(key: key);
  final CategorieModel? item;
  final bool isLast;
  final VoidCallback? onCLick;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        color: (isLast) ? Colors.orange : Colors.transparent,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          onTap: () {
            if (onCLick != null) {
              onCLick!.call();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    (!isLast)
                        ? Flexible(
                            child: FadeInImage.assetNetwork(
                              placeholder: 'lib/res/images/loader.gif',
                              image: item?.icon ?? "",
                              fit: BoxFit.cover,
                              width: 26,
                              height: 26,
                              imageErrorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return Image.asset(
                                  MyImages.errorImage,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          )
                        : Flexible(
                            child: SvgPicture.asset(MyIcons.icListing,
                                color: Colors.white,
                                width: 26,
                                height: 26,
                                fit: BoxFit.cover),
                          ),
                    const SizedBox(height: 8),
                    Text(
                      item?.title ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: (isLast)
                              ? Colors.white
                              : MyApp.resources.color.topCategoriesColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
