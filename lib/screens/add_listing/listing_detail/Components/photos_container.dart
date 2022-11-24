import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/res/images/MyImages.dart';

class PhotosContainer extends StatelessWidget {
  const PhotosContainer(
      {Key? key, this.onClick, this.images, this.viewAllPhotos})
      : super(key: key);
  final Function(int i)? onClick;
  final VoidCallback? viewAllPhotos;
  final List<String>? images;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
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
            Row(children: [
              const Text(
                "Photos",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 0.5, color: MyApp.resources.color.borderColor),
                    color: Colors.grey.shade50,
                    borderRadius: const BorderRadius.all(Radius.circular(16))),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    onTap: () {
                      viewAllPhotos?.call();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      child: Row(children: const [
                        Text(
                          "View all",
                          style: TextStyle(
                              fontSize: 13,
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
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 12),
            SizedBox(
              height: 170,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: images?.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, i) {
                  return PhotosItem(
                    image: images?[i],
                    onCLick: () {
                      onClick!(i);
                    },
                  );
                },
              ),
            ),
          ]),
    );
  }
}

class PhotosItem extends StatelessWidget {
  const PhotosItem({Key? key, this.onCLick, this.image}) : super(key: key);
  final Function? onCLick;
  final String? image;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 8),
      height: 170,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          color: Colors.white,
          border:
              Border.all(width: 0.5, color: MyApp.resources.color.borderColor)),
      child: Stack(children: [
        Container(
          width: 120,
          height: 170,
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: FadeInImage.assetNetwork(
              placeholder: 'lib/res/images/loader.gif',
              placeholderFit: BoxFit.cover,
              image: image ?? "",
              height: 160,
              width: 114,
              fit: BoxFit.cover,
              imageErrorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return Image.asset(
                  MyImages.errorImage,
                  height: 160,
                  width: 114,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
          width: 120,
          height: 170,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                onCLick!();
              },
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
          ),
        )
      ]),
    );
  }
}
