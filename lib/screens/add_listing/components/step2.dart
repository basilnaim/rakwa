import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/city.dart';
import 'package:rakwa/model/location.dart';
import 'package:rakwa/model/state.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/screens/add_listing/components/header.dart';
import 'package:rakwa/screens/add_listing/components/map_location_picker.dart';
import 'package:rakwa/views/bottom_btns.dart';
import 'package:rakwa/views/error_wrapper.dart';
import 'package:rakwa/views/progressing_button.dart';
import 'package:rakwa/views/text_field/my_text_field.dart';
import 'package:rakwa/views/text_field/my_text_field_normal.dart';
import '../listing_screen.dart';

class AddListingStep2 extends StatefulWidget {
  Location location;
  AddListingStep2({Key? key, required this.location}) : super(key: key);

  @override
  State<AddListingStep2> createState() => _AddListingStep2State();
}

class _AddListingStep2State extends State<AddListingStep2> {
  //final GlobalKey<FormFieldState> _addressFieldState =  GlobalKey<FormFieldState>();

  static ValueNotifier<List<StateLocation>> states =
      ValueNotifier<List<StateLocation>>([]);

  static ValueNotifier<List<City>> cities = ValueNotifier<List<City>>([]);

  bool stateError = false;
  bool cityError = false;
  bool latlngError = false;

  loadStates() {
    MyApp.appRepo
        .getStates()
        .then((WebServiceResult<List<StateLocation>> value) {
      switch (value.status) {
        case WebServiceResultStatus.success:
          states.value = value.data ?? [];
          states.value.insert(0, StateLocation(id: -1, name: "pick a state"));
          break;
        case WebServiceResultStatus.error:
          states.value = [];

          break;
        case WebServiceResultStatus.loading:
          break;
        case WebServiceResultStatus.unauthorized:
          break;
      }
    });
  }

  loadCities() {
    MyApp.appRepo
        .getCities(widget.location.stateDownValue?.id ?? 0)
        .then((WebServiceResult<List<City>> value) {
      switch (value.status) {
        case WebServiceResultStatus.success:
          cities.value = value.data ?? [];
          cities.value.insert(0, City(id: -1, name: "pick a city"));

          break;
        case WebServiceResultStatus.error:
          cities.value = [];

          break;
        case WebServiceResultStatus.loading:
          break;
        case WebServiceResultStatus.unauthorized:
          // TODO: Handle this case.
          break;
      }
    });
  }

  onNexClick() {
    stateError = false;
    cityError = false;
    latlngError = false;

    if ((widget.location.stateDownValue?.id ?? 0) < 1) {
      stateError = true;
      setState(() {});
      return;
    }

    if ((widget.location.cityDownValue?.id ?? 0) < 1) {
      cityError = true;
      setState(() {});
      return;
    }
    //  if (!checkFields([_addressFieldState])) {
    //  return;
    //}

    if (widget.location.lat.isEmpty || widget.location.long.isEmpty) {
      latlngError = true;
      setState(() {});
      return;
    }
    ListingScreenState.bottomTabNavigation.moveToNext();
  }

  @override
  void initState() {
    super.initState();
    loadStates();
    if (widget.location.stateDownValue != null) {
      loadCities();
    }
  }

  pickPosition() async {
    LatLng? position = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapLocationPickerScreen()),
    );

    if (position != null) {
      widget.location.lat = position.latitude.toString();
      widget.location.long = position.longitude.toString();
    } else {
      widget.location.lat = "";
      widget.location.long = "";
    }
    latlngError = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          bottom: 80,
          left: 16,
          right: 16,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ValueListenableBuilder(
                    valueListenable: states,
                    builder: (BuildContext context,
                        List<StateLocation> statesValue, Widget? child) {
                      final selected = statesValue.where((element) =>
                          widget.location.stateDownValue?.id == element.id);
                      return ErrorWrapper(
                        error: (!stateError) ? "" : "Pick a state",
                        contentWidget: dropDownContainer(
                          "State",
                          MyIcons.icMap,
                          (statesValue.isEmpty)
                              ? null
                              : DropdownButtonHideUnderline(
                                  child: DropdownButton<StateLocation>(
                                    value: selected.isEmpty
                                        ? statesValue[0]
                                        : selected.first,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    onChanged: (StateLocation? newValue) {
                                      if (widget.location.stateDownValue?.id !=
                                          newValue?.id) {
                                        if (newValue?.id != -1) {
                                          stateError = false;
                                          widget.location.stateDownValue =
                                              newValue;
                                          loadCities();
                                        } else {
                                          widget.location.stateDownValue = null;
                                        }
                                        setState(() {});
                                      }
                                    },
                                    items: statesValue
                                        .map<DropdownMenuItem<StateLocation>>(
                                            (StateLocation state) {
                                      return DropdownMenuItem<StateLocation>(
                                        value: state,
                                        child: Text(
                                          state.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              ?.copyWith(
                                                  color: MyApp.resources.color
                                                      .colorText),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                        ),
                      );
                    }),
                SizedBox(height: 8),
                Visibility(
                  visible: widget.location.stateDownValue != null,
                  child: SizedBox(
                    width: double.infinity,
                    child: ValueListenableBuilder(
                        valueListenable: cities,
                        builder: (BuildContext context, List<City> value,
                            Widget? child) {
                          final selected = value.where((element) =>
                              widget.location.cityDownValue?.id == element.id);
                          return ErrorWrapper(
                            error: (!cityError) ? "" : "Pick a city",
                            contentWidget: dropDownContainer(
                              "City",
                              MyIcons.icMap,
                              (value.isEmpty)
                                  ? null
                                  : DropdownButtonHideUnderline(
                                      child: DropdownButton<City>(
                                        value: selected.isEmpty
                                            ? value[0]
                                            : selected.first,
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down),
                                        onChanged: (City? newValue) {
                                          cityError = false;
                                          widget.location.cityDownValue =
                                              newValue;
                                          setState(() {});
                                        },
                                        items: value
                                            .map<DropdownMenuItem<City>>(
                                                (City city) {
                                          return DropdownMenuItem<City>(
                                            value: city,
                                            child: Text(
                                              city.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  ?.copyWith(
                                                      color: MyApp.resources
                                                          .color.colorText),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                            ),
                          );
                        }),
                  ),
                ),
                /*
                SizedBox(height: 8),
                MyTextField(
                    validator: (String? value) {
                      if (value?.isEmpty ?? false) {
                        return MyApp.resources.strings.mandatoryField;
                      }
                      return null;
                    },
                    initial: widget.location.address,
                    textInputType: TextInputType.streetAddress,
                    formFieldeKey: _addressFieldState,
                    prefixWidget: SvgPicture.asset(
                      MyIcons.icMarker,
                      width: 22,
                      height: 22,
                      color: Colors.black,
                    ),
                    hint: "Adress 1st Line",
                    onSubmit: (String? text) => onNexClick(),
                    onSave: (String? text) {
                      if (text != null) {
                        widget.location.address = text;
                      }
                    },
                    textInputAction: TextInputAction.done),
                */
                SizedBox(height: 8),
                ErrorWrapper(
                  error: (!latlngError) ? "" : "Please pick your address",
                  contentWidget: Container(
                    height: 90,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: MyApp.resources.color.grey1, width: 1),
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
                                        ?.copyWith(
                                            color:
                                                MyApp.resources.color.black1),
                                  ),
                                  Text(
                                    (widget.location.lat.isEmpty)
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
                                decoration: const BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16))),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 28),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 40, right: 40, top: 16, bottom: 16),
            //  width: double.infinity

            child: BottomButtons(
                neutralButtonText: "Previous",
                submitButtonText: "Next",
                neutralButtonClick: () {
                  Navigator.maybePop(context);
                },
                submitButtonClick: () => onNexClick()),
          ),
        ),
      ],
    );
  }

  Widget dropDownContainer(title, String icon, Widget? dropdownButton) {
    return Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          border: Border.all(
            color: MyApp.resources.color.borderColor,
            width: 0.8,
          ),
        ),
        padding: EdgeInsets.only(left: 26, right: 26),
        child: Row(children: [
          SvgPicture.asset(icon),
          SizedBox(
            width: 20,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(color: MyApp.resources.color.darkColor),
              ),
              SizedBox(
                width: 8,
              ),
              SizedBox(
                  width: double.infinity,
                  height: 30,
                  child: dropdownButton ??
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Loading...",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                ?.copyWith(color: MyApp.resources.color.black3),
                          )))
            ],
          ))
        ]));
  }
}
