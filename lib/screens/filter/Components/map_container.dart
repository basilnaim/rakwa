import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/res/images/MyImages.dart';
import 'package:rakwa/screens/add_listing/components/map_location_picker.dart';

class MapContainer extends StatefulWidget {
  MapContainer({Key? key}) : super(key: key);

  static LatLng? location;
  @override
  State<MapContainer> createState() => _MapContainerState();
}

class _MapContainerState extends State<MapContainer>
    with WidgetsBindingObserver {
  pickPosition() async {
    LatLng? position = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapLocationPickerScreen(
        location: MapContainer.location,
      )),
    );

    MapContainer.location = position;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: MapContainer.location != null ? 230 : 76,
      decoration: BoxDecoration(
        border:
            Border.all(width: 0.5, color: MyApp.resources.color.borderColor),
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Material(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          onTap: () {
            pickPosition();
          },
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16, left: 32, right: 16),
                  child: Row(children: [
                    SvgPicture.asset(
                      MyIcons.icMarker,
                      height: 24,
                      width: 24,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 16),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Where",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ]),
                    const Spacer(),
                    MapContainer.location == null
                        ? Container(
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
                          )
                        : InkWell(
                            onTap: () {
                              MapContainer.location = null;
                              setState(() {});
                            },
                            child: const Text(
                              "Clear",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                  ]),
                ),
                const SizedBox(height: 16),
                if (MapContainer.location != null)
                  Flexible(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                      child: SizedBox(
                        height: double.maxFinite,
                        width: double.maxFinite,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                  child: Image.asset(MyImages.map)),
                            ),
                            Align(
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                  MyIcons.icMarker,
                                  height: 24,
                                  width: 24,
                                  color: Colors.orange,
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
              ]),
        ),
      ),
    );
  }
}
