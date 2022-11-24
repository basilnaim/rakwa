import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/city.dart';
import 'package:rakwa/model/location.dart';
import 'package:rakwa/model/state.dart';
import 'package:rakwa/model/update_pwd.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/screens/user/profile/profile_screen.dart';
import 'package:rakwa/views/progressing_button.dart';
import 'package:rakwa/views/text_field/my_text_field.dart';

class UpdateLocationScreen extends StatefulWidget {
  Location location;
  Function(GlobalKey<ProgressingButtonState> progressingButton) updateProfile;

  UpdateLocationScreen({
    Key? key,
    required this.updateProfile,
    required this.location,
  }) : super(key: key);

  @override
  State<UpdateLocationScreen> createState() => UpdateLocationScreenState();
}

UpdatePassword updatePassword = UpdatePassword();

class UpdateLocationScreenState extends State<UpdateLocationScreen> {
  final GlobalKey<ProgressingButtonState> _progressingButton = GlobalKey();
  static ValueNotifier<List<StateLocation>> states =
      ValueNotifier<List<StateLocation>>([]);

  static ValueNotifier<List<City>> cities = ValueNotifier<List<City>>([]);

  final GlobalKey<FormFieldState> _addressFieldState =
      GlobalKey<FormFieldState>();

  bool readOnly = ProfileScreen.editable.value ?? true;

  editableForm(bool editable) {
    setState(() {
      readOnly = editable;
    });
  }

  _onSubmitForm(context) async {
    //show progress
    _addressFieldState.currentState?.save();
    _progressingButton.currentState?.showProgress(true);
    widget.updateProfile(_progressingButton);
  }

  loadStates() {
    MyApp.appRepo
        .getStates()
        .then((WebServiceResult<List<StateLocation>> value) {
      switch (value.status) {
        case WebServiceResultStatus.success:
          final statesList = value.data ?? [];
          //  if (statesList.isNotEmpty)
          //  statesList.add(StateLocation(id: 0, name: "Choose a state"));
          states.value = statesList;
          break;
        case WebServiceResultStatus.error:
          states.value = [];

          break;
        case WebServiceResultStatus.loading:
          break;
        case WebServiceResultStatus.unauthorized:
          // TODO: Handle this case.
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
          final citiesList = value.data ?? [];
          // if (citiesList.isNotEmpty)
          // citiesList.add(City(id: 0, name: "Choose a city"));
          cities.value = citiesList;
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

  @override
  void initState() {
    super.initState();
    loadStates();
    if ((widget.location.stateDownValue?.id ?? 0) != 0) {
      loadCities();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              children: [
                MyTextField(
                    initial: widget.location.address,
                    isReadOnly: readOnly,
                    textInputType: TextInputType.streetAddress,
                    formFieldeKey: _addressFieldState,
                    prefixWidget: SvgPicture.asset(MyIcons.icMarker,
                        width: 22, height: 22),
                    hint: "العنوان التفصيلي",
                    onSubmit: (String? text) => _onSubmitForm(context),
                    onSave: (String? text) {
                      if (text != null) {
                        widget.location.address = text;
                      }
                    },
                    textInputAction: TextInputAction.done),
                SizedBox(height: 8),
                ValueListenableBuilder(
                    valueListenable: states,
                    builder: (BuildContext context,
                        List<StateLocation> statesValue, Widget? child) {
                      final selected = statesValue.where((element) =>
                          (widget.location.stateDownValue?.id ?? 0) ==
                          element.id);

                      return dropDownContainer(
                        "الولاية",
                        MyIcons.icMap,
                        DropdownButtonHideUnderline(
                          child: DropdownButton<StateLocation>(
                            value: selected.isEmpty
                                ? (statesValue.isNotEmpty
                                    ? statesValue.first
                                    : null)
                                : selected.first,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            onChanged: readOnly
                                ? null
                                : (StateLocation? newValue) {
                                    if (widget.location.stateDownValue?.id !=
                                        newValue?.id) {
                                      widget.location.stateDownValue = newValue;
                                      loadCities();
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
                                          color:
                                              MyApp.resources.color.colorText),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    }),
                SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ValueListenableBuilder(
                      valueListenable: cities,
                      builder: (BuildContext context, List<City> value,
                          Widget? child) {
                        final selected = value.where((element) =>
                            (widget.location.cityDownValue?.id ?? 0) ==
                            element.id);

                        return dropDownContainer(
                          "المدينة",
                          MyIcons.icMap,
                          DropdownButtonHideUnderline(
                            child: DropdownButton<City>(
                              value: selected.isEmpty
                                  ? (value.isNotEmpty ? value.first : null)
                                  : selected.first,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              onChanged: readOnly
                                  ? null
                                  : (City? newValue) {
                                      widget.location.cityDownValue = newValue;
                                      setState(() {});
                                    },
                              items: value
                                  .map<DropdownMenuItem<City>>((City city) {
                                return DropdownMenuItem<City>(
                                  value: city,
                                  child: Text(
                                    city.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        ?.copyWith(
                                            color: MyApp
                                                .resources.color.colorText),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      }),
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),
          Visibility(
            visible: !readOnly,
            child: Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              alignment: Alignment.bottomCenter,
              child: Container(
                color: MyApp.resources.color.background,
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ProgressingButton(
                    key: _progressingButton,
                    textColor: Colors.white,
                    buttonText: "Save",
                    onSubmitForm: () => _onSubmitForm(context),
                    color: MyApp.resources.color.orange),
              ),
            ),
          ),
          SizedBox(height: 28),
        ],
      ),
    );
  }

  Widget dropDownContainer(title, String icon, Widget dropdownButton) {
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
                  width: double.infinity, height: 30, child: dropdownButton)
            ],
          ))
        ]));
  }
}
