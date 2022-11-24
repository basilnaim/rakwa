import 'dart:convert';

import 'package:rakwa/model/state.dart';

import 'city.dart';

class Location {
  City? cityDownValue;
  StateLocation? stateDownValue;
  String address = "";
  String lat = "";
  String long = "";
  Location({
    this.cityDownValue,
    this.stateDownValue,
    // this.address ="",
     this.long ="",
     this.lat ="",
  });

}
