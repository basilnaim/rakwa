import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/screens/home_container/home_container_screen.dart';
import 'package:rakwa/views/dialogs/connection_dialog.dart';
import 'package:rakwa/views/no_connection_view.dart';
import 'package:social_share/social_share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:location/location.dart';

bool checkFields(List<GlobalKey<FormFieldState>> fields) {
  for (GlobalKey<FormFieldState> formField in fields) {
    if (!(formField.currentState?.validate() ?? false)) {
      return false;
    }
    formField.currentState?.save();
  }
  return true;
}

Future<void> makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launch(launchUri.toString());
}

Future<BitmapDescriptor> getBytesFromCanvas(
    double width, double height, Uint8List dataBytes) async {
  Size size = ui.Size(width, height);

  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);

  final Radius radius = Radius.circular(size.width / 2);

  final Paint tagPaint = Paint()..color = Colors.blue;
  final double tagWidth = 40.0;

  final Paint shadowPaint = Paint()..color = Colors.white;
  final double shadowWidth = 5.0;

  final Paint borderPaint = Paint()..color = Colors.white;
  final double borderWidth = 3.0;

  final double imageOffset = shadowWidth + borderWidth;

  // Add shadow circle
  canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0.0, 0.0, size.width, size.height),
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      ),
      shadowPaint);

  // Add border circle
  canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(shadowWidth, shadowWidth, size.width - (shadowWidth * 2),
            size.height - (shadowWidth * 2)),
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      ),
      borderPaint);

  // Add tag circle
  /* canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
              size.width - tagWidth,
              0.0,
              tagWidth,
              tagWidth
          ),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        tagPaint);

    // Add tag text
    TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: '1',
      style: TextStyle(fontSize: 20.0, color: Colors.white),
    );

    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(
            size.width - tagWidth / 2 - textPainter.width / 2,
            tagWidth / 2 - textPainter.height / 2
        )
    );*/

  // Oval for the image
  Rect oval = Rect.fromLTWH(imageOffset, imageOffset,
      size.width - (imageOffset * 2), size.height - (imageOffset * 2));

  // Add path for oval image
  canvas.clipPath(Path()..addOval(oval));

  // Add image
  var image = await loadImage(dataBytes.buffer.asUint8List());
  paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.cover);

  // Convert canvas to image
  final ui.Image markerAsImage = await pictureRecorder
      .endRecording()
      .toImage(size.width.toInt(), size.height.toInt());

  // Convert image to bytes
  final ByteData? byteData =
      await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
  final Uint8List uint8List = byteData!.buffer.asUint8List();

  return BitmapDescriptor.fromBytes(uint8List);
}

Future<ui.Image> loadImage(List<int> img) async {
  final Completer<ui.Image> completer = Completer();
  ui.decodeImageFromList(img as Uint8List, (ui.Image img) {
    return completer.complete(img);
  });
  return completer.future;
}

LocationData? currentPosition;
Location location = Location();
bool isLocationPermissionInProgress = false;

Future<LocationData?> getLoc() async {
   bool _serviceEnabled;
    PermissionStatus _permissionGranted;

  if (!isLocationPermissionInProgress) {
    isLocationPermissionInProgress = true;
   
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    currentPosition = await location.getLocation();
    /* location.onLocationChanged.listen((LocationData currentLocation) {
    print("${currentLocation.longitude} : ${currentLocation.longitude}");
    _currentPosition = currentLocation;
  });*/
  }else{
    
  }

  return currentPosition;
}

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}

Future<BitmapDescriptor> bitmapDescriptorFromSvgAsset(
    BuildContext context, String assetName) async {
  String svgString = await DefaultAssetBundle.of(context).loadString(assetName);
  //Draws string representation of svg to DrawableRoot
  DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, "");
  ui.Picture picture = svgDrawableRoot.toPicture();
  ui.Image image = await picture.toImage(150, 150);
  ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
}

/*Future<BitmapDescriptor> bitmapDescriptorFromSvgAsset(
    BuildContext context, String assetName) async {
  // Read SVG file as String
  String svgString = await DefaultAssetBundle.of(context).loadString(assetName);
  // Create DrawableRoot from SVG String
  DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, "null");

  // toPicture() and toImage() don't seem to be pixel ratio aware, so we calculate the actual sizes here
  MediaQueryData queryData = MediaQuery.of(context);
  double devicePixelRatio = queryData.devicePixelRatio;
  double width = 32 * devicePixelRatio; // where 32 is your SVG's original width
  double height = 32 * devicePixelRatio; // same thing

  // Convert to ui.Picture
  ui.Picture picture = svgDrawableRoot.toPicture(size: Size(width, height));

  // Convert to ui.Image. toImage() takes width and height as parameters
  // you need to find the best size to suit your needs and take into account the
  // screen DPI
  ui.Image image = await picture.toImage(width.toInt(), height.toInt());
  ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
}*/

List<DropdownMenuItem<String>> buildList(List list, BuildContext context) {
  List<DropdownMenuItem<String>> items = [];
  for (String str in list) {
    items.add(
      DropdownMenuItem(
        value: str,
        child: Row(
          children: [
            Text(
              str,
              style: TextStyle(
                  color: MyApp.resources.color.textColor, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
  return items;
}

void openLauncher(String url, String type, BuildContext context) async {
  final FlutterShareMe flutterShareMe = FlutterShareMe();
  String? response;
  switch (type) {
    case "Facebook":
      response = await flutterShareMe.shareToFacebook(url: url, msg: "ommar");
      break;
    case "Twitter":
      response = await flutterShareMe.shareToTwitter(url: url, msg: "ommar");
      break;
    case "Instagram":
      response = await flutterShareMe.shareToTwitter(url: url, msg: "ommar");

      break;
    case "Copy Link":
      SocialShare.copyToClipboard(url);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Link Copied"),
      ));
      break;
    case "Pinterest":
      response = await flutterShareMe.shareToSystem(msg: url);
      break;
    case "Linkedin":
      if (await canLaunch(
          "https://www.linkedin.com/shareArticle?mini=true&url=$url")) {
        await launch(
            "https://www.linkedin.com/shareArticle?mini=true&url=$url");
      } else {
        throw 'Could not launch $url';
      }
  }
  print(response);
  Navigator.of(context).pop();
}

LatLng computeCentroid(Iterable<LatLng> points) {
  double latitude = 0;
  double longitude = 0;
  int n = points.length;

  for (LatLng point in points) {
    latitude += point.latitude;
    longitude += point.longitude;
  }

  return LatLng(latitude / n, longitude / n);
}

class MapUtils {
  static LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
        northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }
}

String toQuery(Map<String, dynamic> data) {
  if (data.isEmpty) return "";

  String query = "?";
  data.forEach((key, value) {
    if (query == "?") {
      query += "$key=$value";
    } else {
      query += "&$key=$value";
    }
  });
  return query;
}

enum SnackBarStatus { success, error, defaultSnack }

extension SnackBarStatusExt on SnackBarStatus {
  Color background() {
    switch (this) {
      case SnackBarStatus.success:
        return Colors.green;
      case SnackBarStatus.error:
        return Colors.red;
      case SnackBarStatus.defaultSnack:
        return Colors.orange.shade800;
    }
  }
}

mySnackBar(BuildContext context,
    {bool showInBottom = true,
    String message = "",
    String title = "",
    Function? onPressed,
    String labelAction = "Retry",
    SnackBarStatus status = SnackBarStatus.defaultSnack}) {
  MyApp.snack?.showSnackBar(SnackBar(
      margin: showInBottom
          ? const EdgeInsets.all(24)
          : EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(context).size.height - 200),
      elevation: 5,
      action: onPressed != null
          ? SnackBarAction(
              textColor: Colors.white,
              label: labelAction,
              onPressed: () => onPressed.call(),
            )
          : null,
      backgroundColor: status.background(),
      dismissDirection:
          showInBottom ? DismissDirection.down : DismissDirection.startToEnd,
      duration: const Duration(seconds: 3),
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 24, right: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      behavior: SnackBarBehavior.floating,
      content: SizedBox(
        height: 60,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.copyWith(color: Colors.white)),
            const SizedBox(
              height: 4,
            ),
            Text(message,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: Theme.of(context).textTheme.subtitle2?.copyWith(
                    color: Colors.white.withOpacity(0.7), fontSize: 12)),
          ],
        ),
      )));
}

Future<bool> hasNetwork() async {
  try {
    final result = await InternetAddress.lookup('www.google.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  }
}

showConnectionDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConnectionDialog(
          context: context,
          title: "No Internet Connection",
          desc:
              "Sorry there is no internet connection in your phone please connect and try again",
          btnText: "Ok",
        );
      }).then((value) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NoConnectionView()),
    );
    HomeContainerScreenState.isDialogShown = false;
  });
}

String capitalize(String value) {
  return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
}
