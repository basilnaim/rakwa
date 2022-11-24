import 'package:flutter/material.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/home.dart';
import 'package:rakwa/res/images/MyImages.dart';
import 'package:rakwa/screens/add_listing/detail_listing.dart';

class BannerHome extends StatefulWidget {
  const BannerHome({Key? key, @required this.item}) : super(key: key);

  final AdsCompaignsHome? item;

  @override
  State<BannerHome> createState() => _BannerHomeState();
}

class _BannerHomeState extends State<BannerHome> {
  List<BannerHomeModel> adsList = [];
  PageController? controller;
  GlobalKey<PageContainerState> key = GlobalKey();

  @override
  void initState() {
    super.initState();
    adsList.addAll(widget.item?.Banner ?? []);
    adsList.addAll(widget.item?.ads ?? []);
    controller = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 187,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 16, right: 16, top: 4),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border:
              Border.all(width: 1, color: MyApp.resources.color.borderColor)),
      child: PageIndicatorContainer(
        key: key,
        child: PageView.builder(
            controller: controller,
            itemCount: adsList.length,
            itemBuilder: (context, position) {
              return BannerItem(item: adsList[position]);
            }),
        align: IndicatorAlign.bottom,
        length: adsList.length,
        indicatorSpace: 8.0,
        padding: const EdgeInsets.only(bottom: 30),
        indicatorColor: Colors.white,
        indicatorSelectorColor: MyApp.resources.color.orange,
        shape: IndicatorShape.roundRectangleShape(size: const Size(16, 6)),
      ),
    );
  }
}

class BannerItem extends StatelessWidget {
  const BannerItem({Key? key, this.item}) : super(key: key);
  final BannerHomeModel? item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailListingContainerScreen(
                      listingId: (item?.id.toString()) ?? "",
                    )),
          );
        },
        child: Stack(children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: FadeInImage.assetNetwork(
                placeholder: 'lib/res/images/loader.gif',
                image: item?.image ?? "",
                fit: BoxFit.cover,
                imageErrorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Image.asset(
                    MyImages.errorImage,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: Container(
                  color: Colors.black.withOpacity(0.2),
                )),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Image.asset(MyImages.adLogo),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 13, bottom: 24),
              child: Text(
                item?.title ?? "",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            )
          ]),
        ]),
      ),
    );
  }
}
