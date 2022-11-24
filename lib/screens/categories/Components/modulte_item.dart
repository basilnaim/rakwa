import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/module.dart';
import 'package:rakwa/res/images/MyImages.dart';

class ModuleItem extends StatelessWidget {
  const ModuleItem({Key? key, this.item}) : super(key: key);
  final Module? item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
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
          onTap: null,
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
                  if (item?.description.isNotEmpty == true)
                    Text(
                      item?.description ?? "",
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          ?.copyWith(color: MyApp.resources.color.textColor),
                    ),
                ]),
          ),
        ),
      ),
    );
  }
}
