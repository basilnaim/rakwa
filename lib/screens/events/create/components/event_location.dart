import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/event.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/screens/add_listing/components/map_location_picker.dart';

class EventLocationWidget extends StatefulWidget {
  Event event;
  EventLocationWidget({Key? key, required this.event}) : super(key: key);

  @override
  State<EventLocationWidget> createState() => EventLocationWidgetState();
}

class EventLocationWidgetState extends State<EventLocationWidget> {
  String error = "";

  bool checkPosition() {
    if (widget.event.latitude.isEmpty || widget.event.longitude.isEmpty) {
      error = "pick a location";
      setState(() {});
      return false;
    }
    return true;
  }

  pickPosition() async {
    LatLng? position = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapLocationPickerScreen()),
    );
    if (position != null) {
      error = "";
      widget.event.latitude = position.latitude.toString();
      widget.event.longitude = position.longitude.toString();
    } else {
      widget.event.latitude = "";
      widget.event.longitude = "";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 90,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: MyApp.resources.color.grey1, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Material(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: Colors.white,
            child: InkWell(
              onTap: pickPosition,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select from Map",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: MyApp.resources.color.black1),
                        ),
                        Text(
                          (widget.event.latitude.isEmpty)
                              ? "Your address ..."
                              : "Location picked",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(
                                  color: MyApp.resources.color.orange,
                                  fontSize: 12),
                        ),
                      ],
                    )),
                    Container(
                      height: 46,
                      width: 46,
                      child: Center(
                          child: SvgPicture.asset(
                        MyIcons.icGps,
                        color: Colors.white,
                        width: 24,
                        height: 24,
                      )),
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        if (error.isNotEmpty)
          Text(
            error,
            style: Theme.of(context)
                .textTheme
                .bodyText2
                ?.copyWith(color: Colors.red),
          )
      ],
    );
  }
}
