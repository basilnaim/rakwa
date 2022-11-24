import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/discover.dart';
import 'package:rakwa/res/images/MyImages.dart';

class DiscoverItem extends StatelessWidget {
  const DiscoverItem({Key? key, this.onClick, this.item}) : super(key: key);
  final VoidCallback? onClick;
  final Discover? item;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(width: 0.5, color: MyApp.resources.color.borderColor)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            onClick?.call();
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'lib/res/images/loader.gif',
                        placeholderFit: BoxFit.cover,
                        image: item?.image ?? "",
                        height: 160,
                        width: MediaQuery.of(context).size.width,
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
                    Positioned(
                        left: 0.0, top: 16, child: Image.asset(MyImages.adLogo))
                  ]),
                  const SizedBox(height: 12),
                  Flexible(
                    child: Text(
                      item?.title ?? "",
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
               /*   const SizedBox(height: 4),
                  Row(children: const [
                    Icon(
                      Icons.access_time_rounded,
                      size: 16,
                      color: Colors.black,
                    ),
                    SizedBox(width: 2),
                    Text(
                      '5 Hour ago',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500),
                    )
                  ]),*/
                  const SizedBox(height: 8),
                  Flexible(
                    child: Text(
                      item?.summarydesc ?? "",
                      style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
