import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/discover.dart';
import 'package:rakwa/res/images/MyImages.dart';

class DiscoverDetail extends StatefulWidget {
  const DiscoverDetail({Key? key, this.item}) : super(key: key);
  final Discover? item;

  @override
  _DiscoverDetailState createState() => _DiscoverDetailState();
}

class _DiscoverDetailState extends State<DiscoverDetail> {
  var top = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyApp.resources.color.background,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: 270.0,
                backgroundColor: Colors.white,
                floating: false,
                pinned: true,
                collapsedHeight: 60,
                leadingWidth: 58,
                leading: Container(
                  margin: const EdgeInsets.only(left: 16, top: 9, bottom: 5),
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 0.5, color: MyApp.resources.color.borderColor),
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Center(
                          child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 20,
                        color: Colors.black,
                      )),
                    ),
                  ),
                ),
                flexibleSpace: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  // print('constraints=' + constraints.toString());
                  top = constraints.biggest.height;
                  return FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.only(left: 16, right: 16),
                    centerTitle: false,
                    title: (top != 60)
                        ? Container(
                            padding: const EdgeInsets.only(bottom: 16, left: 8),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      widget.item?.title ?? "",
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  /*   const SizedBox(height: 4),
                                  Row(children: const [
                                    Icon(
                                      Icons.access_time_rounded,
                                      size: 13,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 2),
                                    Text(
                                      '5 Hour ago',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400),
                                    )
                                  ]),*/
                                ]),
                          )
                        : SizedBox(
                            //  padding: const EdgeInsets.symmetric(vertical: 9),
                            height: 60,
                            child: Row(children: [
                              Container(
                                height: 42,
                                width: 42,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.5,
                                      color: MyApp.resources.color.borderColor),
                                  color: MyApp.resources.color.background,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Center(
                                        child: Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      size: 20,
                                      color: Colors.black,
                                    )),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Flexible(
                                child: Text(
                                  widget.item?.title ?? "",
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ]),
                          ),
                    background: Stack(children: [
                      FadeInImage.assetNetwork(
                        placeholder: 'lib/res/images/loader.gif',
                        placeholderFit: BoxFit.cover,
                        image: widget.item?.image ?? "",
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                        imageErrorBuilder: (BuildContext context,
                            Object exception, StackTrace? stackTrace) {
                          return Image.asset(
                            MyImages.errorImage,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: double.maxFinite,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        )),
                      )
                    ]),
                  );
                }),
              ),
            ];
          },
          body: SizedBox(
            height: MediaQuery.of(context).size.height - 60,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 70),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      HtmlParser.parseHTML(widget.item?.detaildesc ?? "").text,
                      //widget.item?.detaildesc ?? "",
                      style: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          height: 1.6,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  const SizedBox(height: 40),
                ]),
          ),
        ),
      ),
    );
  }
}
