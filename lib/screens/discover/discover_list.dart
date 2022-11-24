import 'package:flutter/material.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/discover.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/screens/discover/Components/header.dart';
import 'package:rakwa/screens/home/home.dart';

import 'Components/discover_item.dart';
import 'discover_detail.dart';

class DiscoverList extends StatefulWidget {
  const DiscoverList({Key? key}) : super(key: key);

  @override
  State<DiscoverList> createState() => _DiscoverListState();
}

class _DiscoverListState extends State<DiscoverList> {
  DiscoverBody? discovers;
  List<Discover> discoversList = [];

  late ScrollController controller;
  bool progressing = true;

  progress(bool loading) {
    if (progressing != loading) {
      setState(() {
        progressing = loading;
      });
    }
  }

  _openDrawer() {
    Scaffold.of(context).openDrawer();
  }

  @override
  void initState() {
    super.initState();
    _fetchDiscovers();
    controller = ScrollController()
      ..addListener(() {
        if (controller.position.pixels == controller.position.maxScrollExtent) {
          if (!progressing) {
            _fetchDiscovers();
          }
        }
      });
  }

  _fetchDiscovers() {
    print('fetch discovers data started');
    int page = 0;
    if (discovers != null) {
      page = discovers!.paging!.page! + 1;
      if (page > discovers!.paging!.pages!) page = -1;
    }

    if (page > -1) {
      progress(true);
      MyApp.homeRepo
          .discover(page.toString(), MyApp.token)
          .then((WebServiceResult<DiscoverBody> value) {
        switch (value.status) {
          case WebServiceResultStatus.success:
            print(value.data!);
            discovers = value.data!;
            discoversList.addAll(discovers?.items ?? []);
            progress(false);
            break;
          case WebServiceResultStatus.error:
            mySnackBar(context,
                title: 'fetch discovers failed',
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyApp.resources.color.background,
      body: (progressing && discovers == null)
          ? MyProgressIndicator(
              color: MyApp.resources.color.orange,
            )
          : SafeArea(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                    Header(
                      onDrawerClick: () {
                        _openDrawer();
                      },
                    ),
                    //  const DiscoverTab(),
                   // const SizedBox(height: 16),
                    Flexible(
                        fit: FlexFit.loose,
                        child: RefreshIndicator(
                          color: MyApp.resources.color.orange,
                          onRefresh: () async {
                            discovers = null;
                            discoversList = [];
                            _fetchDiscovers();
                          },
                          child: ListView.builder(
                            controller: controller,
                            shrinkWrap: true,
                            itemCount: discoversList.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, i) {
                              return DiscoverItem(
                                item: discoversList[i],
                                onClick: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DiscoverDetail(
                                              item: discoversList[i],
                                            )),
                                  );
                                },
                              );
                            },
                          ),
                        )),
                    if (progressing)
                      const Align(
                          alignment: Alignment.bottomCenter,
                          child: MyProgressIndicator(
                            color: Colors.orange,
                          ))
                  ]),
          ),
    );
  }
}
