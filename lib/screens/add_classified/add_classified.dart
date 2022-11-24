import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/categorie.dart';
import 'package:rakwa/model/city.dart';
import 'package:rakwa/model/classfield_to_ws.dart';
import 'package:rakwa/model/classified.dart';
import 'package:rakwa/model/error.dart';
import 'package:rakwa/model/state.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/screens/add_listing/components/map_location_picker.dart';
import 'package:rakwa/screens/home/home.dart';
import 'package:rakwa/views/error_widget.dart';
import 'package:rakwa/views/error_wrapper.dart';
import 'package:rakwa/views/header_back_btn.dart';
import 'package:rakwa/views/progressing_button.dart';
import 'package:rakwa/views/text_field/my_text_field_normal.dart';

class AddClassified extends StatefulWidget {
  final ClassifiedToWs classified;
  const AddClassified({Key? key, required this.classified}) : super(key: key);

  @override
  State<AddClassified> createState() => _AddClassifiedState();
}

class _AddClassifiedState extends State<AddClassified> {
  GlobalKey<FormFieldState> titleFormField = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> descriptionFormField = GlobalKey<FormFieldState>();
  final ImagePicker _picker = ImagePicker();

  static ValueNotifier<List<StateLocation>> states =
      ValueNotifier<List<StateLocation>>([]);

  StateLocation? selectedState;

  static ValueNotifier<List<City>> cities = ValueNotifier<List<City>>([]);
  static ValueNotifier<List<CategorieModel>> categories =
      ValueNotifier<List<CategorieModel>>([]);
  GlobalKey<ProgressingButtonState> progressingKey = GlobalKey();

  ErrorModel? errorModel;
  Map<String, List<CategorieModel>> modules = {};

  bool imageError = false;
  bool locationError = false;
  bool stateError = false;
  bool cityError = false;
  bool categoryError = false;
  bool progress = false;

  progressing(progress) {
    if (progress != this.progress) {
      setState(() {
        this.progress = progress;
      });
    }
  }

  _getModules() {
    MyApp.homeRepo
        .modules()
        .then((WebServiceResult<Map<String, List<CategorieModel>>> value) {
      switch (value.status) {
        case WebServiceResultStatus.success:
          if (value.data!.isNotEmpty) {
            modules.clear();
            modules.addAll(value.data!);
            widget.classified.category = (modules["classified"] ?? [])
              .singleWhere((c) => c.title == widget.classified.categoryName,
                  orElse: () => CategorieModel(id: 0))
              .id;
            categories.value = (modules["classified"] ?? []);
          }
          break;
        case WebServiceResultStatus.error:
          mySnackBar(context,
              title: 'fetch filter failed',
              message: value.message,
              status: SnackBarStatus.error);

          break;
        case WebServiceResultStatus.loading:
          break;
        case WebServiceResultStatus.unauthorized:
          break;
      }
    });
  }

  loadStates() {
    MyApp.appRepo
        .getStates()
        .then((WebServiceResult<List<StateLocation>> value) {
      switch (value.status) {
        case WebServiceResultStatus.success:
          if (widget.classified.id != 0 && selectedState == null) {
            selectedState = (value.data ?? [])
                .singleWhere((e) => e.id == widget.classified.stateId);
            loadCities();
            setState(() {});
          }
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
        .getCities(selectedState?.id ?? 0)
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
          break;
      }
    });
  }

  fetchCategories() {
    MyApp.homeRepo
        .categories("classified")
        .then((WebServiceResult<List<CategorieModel>> value) {
      switch (value.status) {
        case WebServiceResultStatus.success:
          widget.classified.category = (value.data ?? [])
              .singleWhere((c) => c.title == widget.classified.categoryName,
                  orElse: () => CategorieModel(id: 0))
              .id;
          categories.value = (value.data ?? []);
          break;
        case WebServiceResultStatus.error:
          break;
        case WebServiceResultStatus.loading:
          break;
        case WebServiceResultStatus.unauthorized:
          break;
      }
    });
  }

  onSubmit() {
    if (!checkFields([titleFormField, descriptionFormField])) {
      return;
    }

    if (widget.classified.image == null && widget.classified.id == 0) {
      imageError = true;
      setState(() {});
      return;
    }

    if (widget.classified.category == 0) {
      categoryError = true;
      setState(() {});
      return;
    }

    if (widget.classified.latitude.isEmpty) {
      locationError = true;
      setState(() {});
      return;
    }

    if (selectedState == null) {
      stateError = true;
      setState(() {});
      return;
    }

    if (widget.classified.cityId == 0) {
      cityError = true;
      setState(() {});
      return;
    }

    widget.classified.address = (selectedState?.name ?? "") +
        " " +
        cities.value
            .singleWhere((city) => city.id == widget.classified.cityId)
            .name;

    setState(() {
      progressingKey.currentState?.progressing = true;
    });

    Future<WebServiceResult<String>> query;

    String titleDialog = 'Create Classified';
    bool create = true;
    if (widget.classified.id != 0) {
      create = false;
      query = MyApp.classifiedRepo.classified(widget.classified);
      titleDialog = 'Edit Classified';
    } else {
      query = MyApp.classifiedRepo.classified(widget.classified);
    }
    query.then((value) {
      progressingKey.currentState?.showProgress(false);
      switch (value.status) {
        case WebServiceResultStatus.success:
          if (create) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => AddClassified(
                        classified: ClassifiedToWs(),
                      )),
            );
          }

          mySnackBar(context,
              title: titleDialog,
              message: value.data ?? "",
              status: SnackBarStatus.success);

          break;
        case WebServiceResultStatus.error:
          mySnackBar(context,
              title: titleDialog,
              message: value.data ?? "",
              status: SnackBarStatus.error);
          break;
        case WebServiceResultStatus.loading:
          break;
        case WebServiceResultStatus.unauthorized:
          break;
      }
    });
  }

  _chooseImageFromGallerie(int from) async {
    XFile? img = await _picker.pickImage(source: ImageSource.gallery);

    if (img != null) {
      widget.classified.image = File(img.path);
      imageError = false;
      setState(() {});
    }
  }

  pickPosition() async {
    LatLng location = LatLng(double.tryParse(widget.classified.latitude) ?? 0.0,
        double.tryParse(widget.classified.longitude) ?? 0.0);

    LatLng? position = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MapLocationPickerScreen(
              location: location.latitude == 0.0 ? null : location)),
    );

    if (position != null) {
      locationError = false;
      widget.classified.latitude = position.latitude.toString();
      widget.classified.longitude = position.longitude.toString();
      widget.classified.address = "address";
    }
    setState(() {});
  }

  fetchClassifield() {
    progressing(true);

    MyApp.classifiedRepo
        .getClassifieldById(widget.classified.id)
        .then((WebServiceResult<Classified> value) {
      switch (value.status) {
        case WebServiceResultStatus.success:
          widget.classified.updateFieldsFromClassified(value.data!);
          _getModules();
          loadStates();

          break;
        case WebServiceResultStatus.error:
          errorModel = ErrorModel(btnClickListener: () {});
          if (value.code == 1) {
            errorModel?.text = "This classifield has been removed";
            errorModel?.btnText = "Back to inboxes";
            errorModel?.btnClickListener = () {
              Navigator.pop(context);
            };
          } else {
            errorModel?.btnText = "Retry";
            errorModel?.text = value.message;
            errorModel?.btnClickListener = () {
              fetchClassifield();
            };
          }

          break;
        case WebServiceResultStatus.loading:
          break;

        case WebServiceResultStatus.unauthorized:
          break;
      }
      progressing(false);
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.classified.id != 0) {
      fetchClassifield();
    } else {
      _getModules();
      loadStates();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyApp.resources.color.background,
      body: progress
          ? const Center(
              child: MyProgressIndicator(
              color: Colors.orange,
            ))
          : (errorModel != null
              ? MyErrorWidget(errorModel: errorModel!)
              : SafeArea(
                  child: Stack(
                    children: [
                      Positioned(
                          top: 24,
                          left: 16,
                          right: 16,
                          child: HeaderWithBackScren(title: "Add Classified")),
                      Positioned(
                        top: 100,
                        left: 16,
                        right: 16,
                        bottom: 80,
                        child: SingleChildScrollView(
                          child: Form(
                            child: Column(
                              children: [
                                MyNormalTextField(
                                    formFieldeKey: titleFormField,
                                    hint: "Title",
                                    initial: widget.classified.title,
                                    maxLines: 1,
                                    textInputAction: TextInputAction.next,
                                    validator: (String? value) {
                                      return (value == null || value.isEmpty)
                                          ? "Fill your classified title please"
                                          : null;
                                    },
                                    onSave: (String? title) {
                                      widget.classified.title = title ?? "";
                                    }),
                                const SizedBox(height: 14),
                                MyNormalTextField(
                                    formFieldeKey: descriptionFormField,
                                    hint: "Description",
                                    initial: widget.classified.description,
                                    maxLines: 6,
                                    minLines: 4,
                                    validator: (String? value) {
                                      return (value == null || value.isEmpty)
                                          ? "Fill your classified description please"
                                          : null;
                                    },
                                    textInputAction: TextInputAction.done,
                                    onSave: (String? description) {
                                      widget.classified.description =
                                          description ?? "";
                                    }),
                                const SizedBox(height: 12),
                                ErrorWrapper(
                                  error: (!imageError)
                                      ? ""
                                      : "Pick an image please",
                                  contentWidget: buildImaheUploadContainer(
                                      "Upload Image",
                                      (widget.classified.image != null ||
                                              widget.classified.id != 0)
                                          ? 1
                                          : 0, () {
                                    _chooseImageFromGallerie(0);
                                  }),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                ValueListenableBuilder(
                                    valueListenable: categories,
                                    builder: (BuildContext context,
                                        List<CategorieModel> categoriesValue,
                                        Widget? child) {
                                      final selected = categoriesValue.where(
                                          (element) =>
                                              widget.classified.category ==
                                              element.id);
                                      return ErrorWrapper(
                                        error: (!categoryError)
                                            ? ""
                                            : "Select a category please",
                                        contentWidget: dropDownContainer(
                                          "Category",
                                          MyIcons.icRocket,
                                          (categoriesValue.isEmpty)
                                              ? null
                                              : DropdownButtonHideUnderline(
                                                  child: DropdownButton<
                                                      CategorieModel>(
                                                    value: selected.isEmpty
                                                        ? categoriesValue[0]
                                                        : selected.first,
                                                    icon: const Icon(Icons
                                                        .keyboard_arrow_down),
                                                    onChanged: (CategorieModel?
                                                        newValue) {
                                                      if (widget.classified
                                                              .category !=
                                                          newValue?.id) {
                                                        if (newValue?.id !=
                                                            -1) {
                                                          widget.classified
                                                                  .category =
                                                              newValue?.id ?? 0;
                                                        } else {
                                                          widget.classified
                                                              .category = 0;
                                                        }
                                                        categoryError = false;
                                                        setState(() {});
                                                      }
                                                    },
                                                    items: categoriesValue.map<
                                                            DropdownMenuItem<
                                                                CategorieModel>>(
                                                        (CategorieModel
                                                            category) {
                                                      return DropdownMenuItem<
                                                          CategorieModel>(
                                                        value: category,
                                                        child: Text(
                                                          category.title ?? "",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyText2
                                                              ?.copyWith(
                                                                  color: MyApp
                                                                      .resources
                                                                      .color
                                                                      .colorText),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                        ),
                                      );
                                    }),
                                const SizedBox(height: 12),
                                ErrorWrapper(
                                  error: (!locationError)
                                      ? ""
                                      : "Pick a location please",
                                  contentWidget: Container(
                                    height: 90,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: MyApp.resources.color.grey1,
                                            width: 1),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12))),
                                    child: Material(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12)),
                                      color: Colors.white,
                                      child: InkWell(
                                        onTap: pickPosition,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 16),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                MyIcons.icMarker,
                                                height: 24,
                                                width: 24,
                                                color: Colors.black,
                                              ),
                                              const SizedBox(
                                                width: 12,
                                              ),
                                              Expanded(
                                                  child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Select from Map",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        ?.copyWith(
                                                            color: MyApp
                                                                .resources
                                                                .color
                                                                .black1),
                                                  ),
                                                  Text(
                                                    (widget.classified.latitude
                                                                .isEmpty ==
                                                            true)
                                                        ? "Your address ..."
                                                        : "Location picked",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        ?.copyWith(
                                                            color: MyApp
                                                                .resources
                                                                .color
                                                                .orange,
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
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                16))),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ValueListenableBuilder(
                                    valueListenable: states,
                                    builder: (BuildContext context,
                                        List<StateLocation> statesValue,
                                        Widget? child) {
                                      final selected = statesValue.where(
                                          (element) =>
                                              selectedState?.id == element.id);
                                      return ErrorWrapper(
                                        error: (!stateError)
                                            ? ""
                                            : "Pick a state please",
                                        contentWidget: dropDownContainer(
                                          "State",
                                          MyIcons.icMap,
                                          (statesValue.isEmpty)
                                              ? null
                                              : DropdownButtonHideUnderline(
                                                  child: DropdownButton<
                                                      StateLocation>(
                                                    value: selected.isEmpty
                                                        ? statesValue[0]
                                                        : selected.first,
                                                    icon: const Icon(Icons
                                                        .keyboard_arrow_down),
                                                    onChanged: (StateLocation?
                                                        newValue) {
                                                      if (selectedState?.id !=
                                                          newValue?.id) {
                                                        if (newValue?.id !=
                                                            -1) {
                                                          selectedState =
                                                              newValue;
                                                          setState(() {});
                                                          loadCities();
                                                        } else {
                                                          setState(() {});
                                                          selectedState = null;
                                                        }
                                                        stateError = false;
                                                      }
                                                    },
                                                    items: statesValue.map<
                                                            DropdownMenuItem<
                                                                StateLocation>>(
                                                        (StateLocation state) {
                                                      return DropdownMenuItem<
                                                          StateLocation>(
                                                        value: state,
                                                        child: Text(
                                                          state.name,
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyText2
                                                              ?.copyWith(
                                                                  color: MyApp
                                                                      .resources
                                                                      .color
                                                                      .colorText),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                        ),
                                      );
                                    }),
                                const SizedBox(height: 8),
                                Visibility(
                                  visible: selectedState != null,
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ValueListenableBuilder(
                                        valueListenable: cities,
                                        builder: (BuildContext context,
                                            List<City> value, Widget? child) {
                                          final selected = value.where(
                                              (element) =>
                                                  widget.classified.cityId ==
                                                  element.id);
                                          return ErrorWrapper(
                                            error: (!cityError)
                                                ? ""
                                                : "Pick a city please",
                                            contentWidget: dropDownContainer(
                                              "City",
                                              MyIcons.icMap,
                                              (value.isEmpty)
                                                  ? null
                                                  : DropdownButtonHideUnderline(
                                                      child:
                                                          DropdownButton<City>(
                                                        value: selected.isEmpty
                                                            ? value[0]
                                                            : selected.first,
                                                        icon: const Icon(Icons
                                                            .keyboard_arrow_down),
                                                        onChanged:
                                                            (City? newValue) {
                                                          widget.classified
                                                                  .cityId =
                                                              newValue?.id ?? 0;
                                                          cityError = false;
                                                          setState(() {});
                                                        },
                                                        items: value.map<
                                                            DropdownMenuItem<
                                                                City>>((City
                                                            city) {
                                                          return DropdownMenuItem<
                                                              City>(
                                                            value: city,
                                                            child: Text(
                                                              city.name,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText2
                                                                  ?.copyWith(
                                                                      color: MyApp
                                                                          .resources
                                                                          .color
                                                                          .colorText),
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
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          color: Colors.white,
                          height: 80,
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 20),
                          child: ProgressingButton(
                            key: progressingKey,
                            buttonText: "Post",
                            color: MyApp.resources.color.orange,
                            onSubmitForm: () => onSubmit(),
                            textColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
    );
  }

  Widget buildImaheUploadContainer(title, imageUploaded, onclick) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: MyApp.resources.color.grey1, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(12))),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        color: Colors.white,
        child: InkWell(
          onTap: onclick,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(MyIcons.icCamera,
                    width: 24, height: 24, color: Colors.black),
                const SizedBox(
                  width: 18,
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(color: MyApp.resources.color.black1),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$imageUploaded pictures(s) to upload.",
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: MyApp.resources.color.orange, fontSize: 12),
                    ),
                  ],
                )),
                Container(
                  height: 46,
                  width: 46,
                  child: Center(
                      child: SvgPicture.asset(
                    MyIcons.icUpload,
                    color: Colors.white,
                    width: 24,
                    height: 24,
                  )),
                  decoration: BoxDecoration(
                      color: MyApp.resources.color.orange,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(16))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget dropDownContainer(title, String icon, Widget? dropdownButton) {
    return Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          border: Border.all(
            color: MyApp.resources.color.borderColor,
            width: 0.8,
          ),
        ),
        padding: const EdgeInsets.only(left: 26, right: 26),
        child: Row(children: [
          SvgPicture.asset(icon),
          const SizedBox(
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
              const SizedBox(
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
