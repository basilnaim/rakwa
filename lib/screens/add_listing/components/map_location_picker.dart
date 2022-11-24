import 'dart:convert';
import 'dart:typed_data';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/views/bottom_btns.dart';

class MapLocationPickerScreen extends StatefulWidget {
  MapLocationPickerScreen({Key? key, this.onTouch, this.location})
      : super(key: key);
  final Function(bool tou)? onTouch;
  LatLng? location;

  @override
  State<MapLocationPickerScreen> createState() =>
      _MapLocationPickerScreenState();
}

class _MapLocationPickerScreenState extends State<MapLocationPickerScreen> {
  GoogleMapController? _controller;
  bool firstCameraMove = true;
  final List<Marker> _markers = [];
  String? _mapStyle;
  BitmapDescriptor? customIcon;

  setMarker(LatLng myPosition) async {
    final Uint8List? markerIcon =
        await getBytesFromAsset('lib/res/images/you.png', 400).then((value) {
      setState(() {
        _markers.clear();
        _markers.add(Marker(
            markerId: const MarkerId("myPosition"),
            position: myPosition,
            icon: BitmapDescriptor.fromBytes(value)));
      });
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  _onMapCreated(GoogleMapController _cntlr) {
    _cntlr.setMapStyle(_mapStyle);
    _controller = _cntlr;
    if (widget.location != null) pickLocation(widget.location!);
  }

  @override
  void initState() {
    super.initState();

    if (widget.location == null) {
      getLoc().then((LocationData? value) {
        if (value != null) {
          widget.location =
              LatLng(value.latitude ?? 0.0, value.longitude ?? 0.0);
          _controller?.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: widget.location!, zoom: 15),
            ),
          );
          pickLocation(widget.location!);
          setState(() {});
        }
      });
    }

    rootBundle.loadString('lib/res/json_assets/map_style.txt').then((string) {
      _mapStyle = string;
    });

    /* getLoc().then((value) {
      //getIcons(LatLng(value?.latitude ?? 0.0, value?.longitude ?? 0.0));
      myPosition = value;
    });*/
  }

  myLocation() {
    setState(() {
      _markers.clear();
    });
    getLoc().then((LocationData? value) {
      if (value != null) {
        var latlng = LatLng(value.latitude ?? 0.0, value.longitude ?? 0.0);
        setMarker(latlng);
        _controller?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: latlng, zoom: 15),
          ),
        );
      }
    });
  }

  pickLocation(LatLng point) {
    setState(() {
      _markers.clear();
      _markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: InfoWindow(
          title: 'Picked Location',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Listener(
                    behavior: HitTestBehavior.opaque,
                    onPointerDown: (PointerDownEvent details) {
                      if (widget.onTouch == null) widget.onTouch!(true);
                    },
                    onPointerUp: (details) {
                      if (widget.onTouch == null) widget.onTouch!(false);
                    },
                    child: SizedBox(
                      height: double.maxFinite,
                      width: double.maxFinite,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        child: GoogleMap(
                            markers: Set.from(_markers),
                            myLocationEnabled: true,
                            myLocationButtonEnabled: false,
                            mapType: MapType.normal,
                            initialCameraPosition: CameraPosition(
                                target: widget.location ??
                                    const LatLng(32.3625555, -120.369522),
                                zoom: 5),
                            zoomControlsEnabled: false,
                            onTap: (lat) => pickLocation(lat),
                            onMapCreated: _onMapCreated),
                      ),
                    ),
                  ),
                ),
              ]),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 64,
                  child: InkWell(
                    onTap: () {
                      myLocation();
                    },
                    child: Row(
                      children: [
                        Container(
                          height: 42,
                          width: 42,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              color: MyApp.resources.color.orange),
                          child: Center(
                            child: SvgPicture.asset(
                              MyIcons.icGps,
                              width: 24,
                              height: 24,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'use my location',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: MyApp.resources.color.grey2),
                        )
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: MyApp.resources.color.borderColor, width: 0.8),
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  margin: EdgeInsets.only(left: 16, right: 16),
                  padding: EdgeInsets.only(left: 14, right: 14),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  color: Colors.white,
                  padding:
                      EdgeInsets.only(left: 40, right: 40, top: 16, bottom: 16),
                  //  width: double.infinity,
                  child: BottomButtons(
                      neutralButtonText: "Cancel",
                      submitButtonText: "Save",
                      neutralButtonClick: () {
                        Navigator.pop(context);
                      },
                      submitButtonClick: () {
                        if (_markers.isNotEmpty) {
                          Navigator.pop(context, _markers.first.position);
                        } else {
                          AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.ERROR,
                                  animType: AnimType.BOTTOMSLIDE,
                                  title: 'Pick a position',
                                  desc: "Pick a location first.",
                                  btnOkText: "ok",
                                  btnCancel: null)
                              .show();
                        }
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
