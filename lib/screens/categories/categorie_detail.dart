import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/filter.dart';
import 'package:rakwa/model/module.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/res/fonts/fonts.dart';
import 'package:rakwa/screens/add_listing/detail_listing.dart';
import 'package:rakwa/screens/home/Components/LatestListing/latest_listings_item.dart';
import 'package:rakwa/screens/home/home.dart';
import 'package:rakwa/views/header_back_btn.dart';
import 'package:rakwa/views/search_container.dart';
import '../../res/icons/my_icons.dart';
import '../classifieds/Components/classifieds_list_item.dart';
import 'Components/categorie_tri_item.dart';
import 'Components/modulte_item.dart';

class CategorieDetail extends StatefulWidget {
  const CategorieDetail({Key? key, required this.filterModel})
      : super(key: key);

  final FilterModel filterModel;

  @override
  State<CategorieDetail> createState() => _CategorieDetailState();
}

class _CategorieDetailState extends State<CategorieDetail>
    with WidgetsBindingObserver {
  late ScrollController controller;

  var top = 0.0;
  ScrollPhysics physics = const AlwaysScrollableScrollPhysics();
  List<Module> result = [];
  List<Marker> _markers = [];
  List<LatLng> latlonglist = [];

  FilterResponse? filterResponse;

  BitmapDescriptor? customIcon;
  var textController = TextEditingController();
  int triSelected = 0;
  List<String> tries = [
    "Most Reviewed",
    "Inexpensive",
    "Open Now",
    "Inexpensive"
  ];

  LocationData? myPosition;
  GoogleMapController? _controller;
  bool firstCameraMove = true;
  LatLng? centerPoint;
  bool isLoading = false;

  setLoading(bool loading) {
    if (isLoading != loading) {
      setState(() {
        isLoading = loading;
      });
    }
  }

  _onMapCreated(GoogleMapController _cntlr) {
    _cntlr.setMapStyle(_mapStyle);
    _controller = _cntlr;
    if (centerPoint != null) {
      _controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(centerPoint!.latitude, centerPoint!.longitude),
              zoom: 8),
        ),
      );
    }
  }

  String? _mapStyle;
  String? token;
  bool progressing = true;

  progress(bool loading) {
    if (progressing != loading) {
      setState(() {
        progressing = loading;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    token = MyApp.token;
    rootBundle.loadString('lib/res/json_assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    textController.text = widget.filterModel.keyword ?? "";
    _fetchFilter();
    controller = ScrollController();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        print('appLifeCycleState inactive');
        break;
      case AppLifecycleState.resumed:
        //final GoogleMapController controller = _controller!;
        _onMapCreated(_controller!);
        print('appLifeCycleState resumed');
        break;
      case AppLifecycleState.paused:
        print('appLifeCycleState paused');
        break;
      case AppLifecycleState.detached:
        print('appLifeCycleState detached');
        break;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();

    super.dispose();
  }

  getIcons(Module listing) async {
    final Response response = await get(Uri.parse(listing.image));
    var bytes = await response.bodyBytes;

    final BitmapDescriptor markerIcon =
        await getBytesFromCanvas(120, 120, bytes);

    try {
      setState(() {
        _markers.add(Marker(
          markerId: MarkerId(listing.title),
          position: LatLng(
            double.parse(listing.latitude),
            double.parse(listing.longitude),
          ),
          infoWindow: InfoWindow(title: listing.title),
          icon: markerIcon,
        ));
      });
    } catch (e) {}
  }

  updateLocation(double latitude, double longitude, double zoom) async {
    _controller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latitude, longitude), zoom: zoom),
      ),
    );
  }

  _fetchFilter() {
    print('fetch filter data started');
    int page = 0;
    if (filterResponse != null) {
      page = (filterResponse!.paging.page + 1);
      if (page > filterResponse!.paging.pages) page = -1;
    }

    if (page > -1) {
      widget.filterModel.page = "$page";
      setLoading(true);
      MyApp.homeRepo
          .filter(widget.filterModel)
          .then((WebServiceResult<FilterResponse> value) {
        switch (value.status) {
          case WebServiceResultStatus.success:
            filterResponse = value.data;
            final list = value.data?.items ?? [];
            result.addAll(list);
            for (int i = 0; i < list.length; i++) {
              latlonglist.add(LatLng(double.parse(list[i].latitude),
                  double.parse(list[i].longitude)));
              getIcons(list[i]);
            }
            centerPoint = computeCentroid(latlonglist);
            updateLocation(
                centerPoint?.latitude ?? 0.0, centerPoint?.longitude ?? 0.0, 8);

            break;
          case WebServiceResultStatus.error:
            break;
          case WebServiceResultStatus.loading:
            break;
          case WebServiceResultStatus.unauthorized:
            break;
        }
        setLoading(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return (isLoading && filterResponse == null)
        ? Scaffold(
            backgroundColor: MyApp.resources.color.background,
            body: MyProgressIndicator(color: MyApp.resources.color.orange))
        : ((filterResponse?.paging.pages ?? 0) == 0
            ? Scaffold(
                backgroundColor: MyApp.resources.color.background,
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(MyIcons.icNotFound),
                      const SizedBox(height: 32),
                      Text(
                        "للأسف، لم تقم بالتسجيل",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(color: MyApp.resources.color.black1),
                      ),
                      const SizedBox(height: 26),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(150, 56),
                            elevation: 1,
                            shadowColor: MyApp.resources.color.orange,
                            primary: MyApp.resources.color.orange,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                side: BorderSide(
                                    color: MyApp.resources.color.grey1,
                                    width: 0.8))),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "الرجوع إلي التصفية",
                          style: Theme.of(context).textTheme.button?.copyWith(
                              fontWeight: FontFamily.regular.fontWeight(),
                              color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              )
            : Scaffold(
                backgroundColor: MyApp.resources.color.background,
                bottomSheet: DraggableScrollableSheet(
                  minChildSize: 0.58,
                  initialChildSize: 0.58,
                  expand: false,
                  builder: (context, scrollController) {
                    scrollController.addListener(() {
                      if (scrollController.position.pixels ==
                          scrollController.position.maxScrollExtent) {
                        if (!isLoading) {
                          _fetchFilter();
                        }
                      }
                    });
                    return Column(
                      children: <Widget>[
                        Card(
                          elevation: 4,
                          shadowColor: Colors.black.withOpacity(0.5),
                          margin: const EdgeInsets.all(0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 12,
                            color: Colors.white,
                            child: Center(
                              child: Container(
                                  width: 50,
                                  height: 6,
                                  decoration: BoxDecoration(
                                      color: MyApp.resources.color.orange,
                                      borderRadius: BorderRadius.circular(24))),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        /*Card(
                          elevation: 4,
                          shadowColor: Colors.black.withOpacity(0.7),
                          margin: const EdgeInsets.all(0),
                          child: Container(
                            height: 70,
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(vertical: 19),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: ListView.builder(
                              itemBuilder: (_, index) {
                                return TriItem(
                                  index: index,
                                  title: tries[index],
                                  isSelected: triSelected,
                                  onCLick: () {
                                    setState(() {
                                      triSelected = index;
                                    });
                                  },
                                );
                              },
                              itemCount: tries.length,
                              primary: false,
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(left: 16),
                              scrollDirection: Axis.horizontal,
                            ),
                          ),
                        ),*/
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, left: 16, right: 16),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Results of ",
                                  style: TextStyle(
                                      color: MyApp.resources.color.iconColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Flexible(
                                  child: Text(
                                    (widget.filterModel.keyword?.isNotEmpty ==
                                            true)
                                        ? widget.filterModel.keyword ?? ""
                                        : widget.filterModel.module ?? "",
                                    style: TextStyle(
                                        color: MyApp.resources.color.orange,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                )
                              ]),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: ListView.builder(
                              controller: scrollController,
                              itemBuilder: (_, index) {
                                switch (widget.filterModel.module) {
                                  case "listing":
                                    {
                                      return LatestListingItem(
                                        item: result[index].toListing(),
                                        onClick: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailListingContainerScreen(
                                                      listingId: result[index]
                                                          .toListing()
                                                          .id
                                                          .toString(),
                                                    )),
                                          );
                                        },
                                      );
                                    }
                                  case "classified":
                                    {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: ClassifiedsListItem(
                                          item: result[index].toClassified(),
                                        ),
                                      );
                                    }

                                  default:
                                    {
                                      return ModuleItem(
                                        item: result[index],
                                      );
                                    }
                                }
                              },
                              itemCount: result.length,
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              scrollDirection: Axis.vertical,
                            ),
                          ),
                        ),
                        if (isLoading)
                          const Align(
                              alignment: Alignment.bottomCenter,
                              child: MyProgressIndicator(
                                color: Colors.orange,
                              ))
                      ],
                    );
                  },
                ),
                body: SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0, left: 16),
                        child: HeaderWithBackScren(
                          title: "النتائج",
                        ),
                      ),
                      Expanded(
                        child: Stack(children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.37,
                            width: MediaQuery.of(context).size.width,
                            child: Stack(children: [
                              GoogleMap(
                                  padding: const EdgeInsets.only(bottom: 0),
                                  markers: Set.from(_markers),
                                  myLocationEnabled: true,
                                  myLocationButtonEnabled: true,
                                  mapType: MapType.normal,
                                  initialCameraPosition: CameraPosition(
                                      target: LatLng(
                                          myPosition?.latitude ?? 0.0,
                                          myPosition?.longitude ?? 0.0),
                                      zoom: 15),
                                  zoomControlsEnabled: false,
                                  onMapCreated: _onMapCreated),
                              Positioned(
                                  top: 24,
                                  left: 0.0,
                                  right: 0.0,
                                  child: SearchContainer(
                                    isDetail: true,
                                    isHome: true,
                                    textController: textController,
                                    onSubmitQuery: (String query) {
                                      widget.filterModel.keyword = query;
                                      filterResponse = null;
                                      result = [];
                                      latlonglist = [];
                                      _markers = [];
                                      print(widget.filterModel);

                                      _fetchFilter();
                                    },
                                  )),
                            ]),
                          ),
                        ]),
                      ),
                    ],
                  ),
                )));
  }
}
