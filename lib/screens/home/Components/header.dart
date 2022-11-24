import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/home.dart';
import 'package:rakwa/res/images/MyImages.dart';
import 'package:rakwa/screens/filter/filter.dart';
import 'package:rakwa/views/search_container.dart';

import '../../../model/ads.dart';

class HeaderHome extends StatelessWidget {
  const HeaderHome({Key? key, this.onDrawerClick, this.ads, this.onSearchClick})
      : super(key: key);

  final VoidCallback? onDrawerClick;
  final Function(String)? onSearchClick;
  final List<BannerHomeModel>? ads;
  @override
  Widget build(BuildContext context) {
    print("mmmmm" + ads![0].image.toString());
    return SizedBox(
      height: 272,
      child: Stack(children: [
        SizedBox(
          height: 272,
          width: MediaQuery.of(context).size.width,
          child: FadeInImage.assetNetwork(
            placeholder: 'lib/res/images/loader.gif',
            image: (ads!.isNotEmpty) ? ads![0].image ?? "" : "",
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
        Positioned(
          left: 16.0,
          right: 16.0,
          top: 41.0,
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            //drawer button
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  border: Border.all(
                      width: 0.5, color: MyApp.resources.color.borderColor),
                  color: Colors.white),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  onTap: () {
                    onDrawerClick!.call();
                  },
                  splashColor: Colors.orange,
                  child: Center(
                    child: Icon(
                      Icons.menu,
                      color: MyApp.resources.color.iconColor,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            // header center text
            Image.asset(MyImages.rakwaLogo),
            const Spacer(),
            //filter button
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  border: Border.all(
                      width: 0.5, color: MyApp.resources.color.borderColor),
                  color: Colors.white),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Filter()),
                      );
                    },
                    child: Center(
                      child: SvgPicture.asset(
                        'lib/res/icons/ic_filter.svg',
                        //MyIcons.filter,
                        width: 22,
                        height: 22,
                      ),
                    )),
              ),
            )
          ]),
        ),
        Positioned(
          bottom: 22,
          left: 0.0,
          right: 0.0,
          child: SearchContainer(
            onSubmitQuery: ((query) => onSearchClick!(query)),
            isHome: true,
            textController: TextEditingController(),
          ),
        )
      ]),
    );
  }
}
