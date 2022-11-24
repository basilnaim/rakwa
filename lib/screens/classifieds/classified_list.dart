import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/classified.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/screens/classifieds/Components/classifieds_list_item.dart';
import 'package:rakwa/screens/home/home.dart';
import 'package:rakwa/views/search_container.dart';

import 'Components/header.dart';

class AllClassifieds extends StatefulWidget {
  const AllClassifieds({Key? key}) : super(key: key);

  @override
  State<AllClassifieds> createState() => _AllClassifiedsState();
}

class _AllClassifiedsState extends State<AllClassifieds> {
  List<Classified>? list;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    if (currentPosition == null) {
      getLoc();
    }
    _fetchClassified();
  }

  _fetchClassified() {
    setState(() {
      isLoading = true;
    });
    MyApp.classifiedRepo
    //.classifiedList("33.9633673", "-117.3645113")
         .classifiedList(
      (currentPosition != null)
          ? (currentPosition?.latitude ?? 0.0).toString()
          : "33.9633673",
      (currentPosition != null)
          ? (currentPosition?.longitude ?? 0.0).toString()
          : "-117.3645113",
    )
        .then((WebServiceResult<List<Classified>> value) {
      switch (value.status) {
        case WebServiceResultStatus.success:
          print(value.data!);

          setState(() {
            isLoading = false;
            list = value.data ?? [];
          });
          break;
        case WebServiceResultStatus.error:
          setState(() {
            isLoading = false;
          });
          mySnackBar(context,
              title: 'fetch classified failed',
              message: value.message,
              status: SnackBarStatus.error);

          break;
        case WebServiceResultStatus.loading:
          break;
        case WebServiceResultStatus.unauthorized:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyApp.resources.color.background,
      body: SafeArea(
        child: (isLoading)
            ? MyProgressIndicator(
                color: MyApp.resources.color.orange,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                    const Header(),
                    /*   SearchContainer(
                    hint: "Search For Classifieds",
                    isHome: true,
                    isDetail: true,
                  ),*/
                    const SizedBox(height: 24),
                    (list != null && list!.isNotEmpty)
                        ? Flexible(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        "Featured Classifieds",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      if (list != null)
                                        ListView.builder(
                                          itemBuilder: (_, index) {
                                            return ClassifiedsListItem(
                                              item: list?[index],
                                            );
                                          },
                                          itemCount: list?.length,
                                          primary: false,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          scrollDirection: Axis.vertical,
                                        )
                                    ]),
                              ),
                            ),
                          )
                        : Expanded(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: double.maxFinite,
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 80),
                                    SvgPicture.asset(
                                      MyIcons.icError,
                                      height: 100,
                                      width: 80,
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'There is no classified to show',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Go to Dashboard Classified to create a new Classified',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ]),
                            ),
                          )
                  ]),
      ),
    );
  }
}
