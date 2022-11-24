import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/classified.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/screens/filter/Components/header.dart';

class ClassifiedLocationScreen extends StatefulWidget {
  const ClassifiedLocationScreen({Key? key, this.item}) : super(key: key);
  final Classified? item;

  @override
  _ClassifiedLocationScreenState createState() =>
      _ClassifiedLocationScreenState();
}

class _ClassifiedLocationScreenState extends State<ClassifiedLocationScreen>
    with WidgetsBindingObserver {
  GoogleMapController? _controller;
  final Set<Marker> _markers = {};
  bool firstCameraMove = true;
  String? _mapStyle;

  void _onMapCreated(GoogleMapController _cntlr) {
    _cntlr.setMapStyle(_mapStyle);
    _controller = _cntlr;
  }

  getIcons(Classified classified) async {
    final Response response = await get(Uri.parse(classified.image ?? ""));
    var bytes = response.bodyBytes;

    final BitmapDescriptor markerIcon =
        await getBytesFromCanvas(120, 120, bytes);

    setState(() {
      // print("markeeeer ==> $markerIcon");
      _markers.add(Marker(
        markerId: MarkerId(classified.id.toString()),
        position: LatLng(
          double.parse(classified.location?.latitude ?? "0.0"),
          double.parse(classified.location?.longitude ?? "0.0"),
        ),
        infoWindow: InfoWindow(title: classified.title),
        icon: markerIcon,
      ));
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    rootBundle.loadString('lib/res/json_assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    getIcons(widget.item!);
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          GoogleMap(
              padding: const EdgeInsets.only(bottom: 140),
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    double.parse(widget.item?.location?.latitude ?? "0.0"),
                    double.parse(widget.item?.location?.longitude ?? "0.0")),
                zoom: 15,
              ),
              zoomControlsEnabled: false,
              onMapCreated: _onMapCreated),
          HeaderFilter(titre: "Location"),
          //a remplacer par classified container
          Positioned(
            bottom: 32,
            left: 16,
            right: 16,
            child: Container(
              width: MediaQuery.of(context).size.width,
              // margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 0.5,
                    color: MyApp.resources.color.borderColor,
                  ),
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.item?.title ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            MyIcons.icMarker,
                            width: 14,
                            height: 14,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.item?.location?.address ?? "",
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                          ),
                        ])
                  ]),
            ),
          ),
        ]),
      ),
    );
  }
}
