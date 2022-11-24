import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/announcement.dart';

class AnnouncementContainer extends StatelessWidget {
  AnnouncementContainer({Key? key, this.announcements}) : super(key: key);
  List<Announcement>? announcements;
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
            const Text(
              "Announcements",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              primary: false,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: announcements?.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.9,
                  crossAxisCount: 2),
              itemBuilder: (_, int index) {
                return AnnouncementItem(item: announcements?[index]);
              },
            ),
          ]),
    );
  }
}

class AnnouncementItem extends StatelessWidget {
  AnnouncementItem({Key? key, this.item}) : super(key: key);
  Announcement? item;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade50.withOpacity(0.8),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border:
              Border.all(width: 0.5, color: MyApp.resources.color.borderColor)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            width: 0.5,
                            color: MyApp.resources.color.borderColor),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12))),
                    child: const Center(
                      child: Icon(
                        Icons.star_outline,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Free Appetizer",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item?.description ?? "",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.normal),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 0.5,
                            color: MyApp.resources.color.borderColor),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                        color: Colors.white),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Flexible(
                        child: Text(
                          item?.btnText ?? "",
                          style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.black,
                        size: 16,
                      )
                    ]),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
