import 'package:flutter/material.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/categorie.dart';
import 'package:rakwa/model/error.dart';
import 'package:rakwa/model/filter.dart';
import 'package:rakwa/model/home.dart';
import 'package:rakwa/model/home_user.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/screens/categories/categorie_detail.dart';
import 'package:rakwa/screens/home/Components/Classified/classified.dart';
import 'package:rakwa/screens/home/Components/LatestEvents/events.dart';
import 'package:rakwa/screens/home/Components/TopCategories/empty_top_categories.dart';
import 'package:rakwa/screens/home/Components/banner.dart';
import 'package:rakwa/screens/home/Components/header.dart';
import 'package:rakwa/screens/home/Components/TopCategories/top_categories.dart';
import 'package:rakwa/screens/home/Components/header_collapsed.dart';
import 'package:rakwa/views/error_widget.dart';
import 'Components/LatestListing/latest_listing.dart';
import 'Components/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  Home home = Home();
  bool isErrorScreen = false;

  static ValueNotifier<HomeUser?> homeUserObserver = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _fetchHome(MyApp.token);
  }

  _openDrawer() {
    Scaffold.of(context).openDrawer();
  }

  _fetchHome(String token) {
    print('fetch home data started');
    setState(() {
      isLoading = true;
    });

    if (currentPosition == null) {
      getLoc().then((value) {
        fetchHome(token);
      });
    } else {
      fetchHome(token);
    }
  }

  fetchHome(String token) {
    final homeFields = HomeFields(
        level_id: "1",
        lat: (currentPosition?.latitude ?? 36.3659527).toString(),
        long: (currentPosition?.longitude ?? -117.3645113).toString());
    MyApp.homeRepo.home(homeFields, token).then((WebServiceResult<Home> value) {
      switch (value.status) {
        case WebServiceResultStatus.success:
          try {
            setState(() {
              home = value.data!;

              CategorieModel moreCategorie =
                  CategorieModel(id: -1, title: "More");
              home.top_categories?.add(moreCategorie);
              homeUserObserver.value = home.user;
              print("bannneeeeer ${home.ads_campaigns}");
              isLoading = false;
            });
          } catch (r) {}
          break;
        case WebServiceResultStatus.error:
          /* if (value.message == "404") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NoConnectionView()),
            ).then((value) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomeContainerScreen()),
              );
            });
          } else {*/
          mySnackBar(context,
              title: 'fetch data home failed',
              message: value.message,
              status: SnackBarStatus.error);
          setState(() {
            isLoading = false;

            isErrorScreen = true;
          });
          //}

          break;
        case WebServiceResultStatus.loading:
          break;

        case WebServiceResultStatus.unauthorized:
          DrawerPageState.disconnect(context);

          break;
      }
    });
  }

  _gotToDetailCategorie(String keyWord, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CategorieDetail(
                filterModel: FilterModel(module: "listing", keyword: keyWord),
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: MyApp.resources.color.background,
      body: (isLoading)
          ? MyProgressIndicator(
              color: MyApp.resources.color.orange,
            )
          : (isErrorScreen)
              ? MyErrorWidget(
                  errorModel: ErrorModel(
                      btnClickListener: () {
                        _fetchHome(MyApp.token);
                      },
                      btnText: 'Try Again!',
                      text: 'Sorry something went wrong!'))
              : RefreshIndicator(
                  onRefresh: () async {
                    if (!isLoading) {
                      setState(() {
                        isLoading = true;
                      });
                      fetchHome(MyApp.token);
                    }
                  },
                  child: CustomScrollView(slivers: <Widget>[
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: MyApp.resources.color.background,
                      expandedHeight: 272.0,
                      collapsedHeight: 170,
                      floating: false,
                      pinned: true,
                      flexibleSpace: LayoutBuilder(builder:
                          (BuildContext context, BoxConstraints constraints) {
                        var top = constraints.biggest.height;
                        return Column(children: [
                          Flexible(
                            child: (top > 170)
                                ? HeaderHome(
                                    ads: home.ads_campaigns?.ads ?? [],
                                    onSearchClick: (query) {
                                      _gotToDetailCategorie(query, context);
                                    },
                                    onDrawerClick: () {
                                      _openDrawer();
                                    })
                                : HeaderCollapsed(onSearchClick: (query) {
                                    _gotToDetailCategorie(query, context);
                                  }, onDrawerClick: () {
                                    _openDrawer();
                                  }),
                          ),
                        ]);
                      }),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Column(children: [
                          (home.top_categories!.length > 1)
                              ? TopCategories(list: home.top_categories)
                              : const EmptyTopCategories(),
                          (home.ads_campaigns != null &&
                                  (home.ads_campaigns!.ads!.isNotEmpty ||
                                      home.ads_campaigns!.Banner!.isNotEmpty))
                              ? BannerHome(item: home.ads_campaigns)
                              : const SizedBox(),
                          (home.latest_listings != null &&
                                  home.latest_listings!.isNotEmpty)
                              ? LatestListing(list: home.latest_listings)
                              : const SizedBox(),
                          (home.latest_classifieds != null &&
                                  home.latest_classifieds!.isNotEmpty)
                              ? ClassifiedList(list: home.latest_classifieds)
                              : const SizedBox(),
                          (home.latest_events != null &&
                                  home.latest_events!.isNotEmpty)
                              ? EventsList(list: home.latest_events)
                              : const SizedBox()
                        ]),
                      ]),
                    )
                  ]),
                ),
    );
  }
}

class MyProgressIndicator extends StatelessWidget {
  const MyProgressIndicator({Key? key, this.color}) : super(key: key);
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 38,
        height: 38,
        child: CircularProgressIndicator(
          backgroundColor: MyApp.resources.color.background,
          color: color,
          strokeWidth: 3,
        ),
      ),
    );
  }
}
