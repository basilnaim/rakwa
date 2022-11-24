import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/event.dart';
import 'package:rakwa/model/listing.dart';
import 'package:rakwa/model/listing/contact.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/screens/events/create/components/event_date.dart';
import 'package:rakwa/screens/events/create/components/event_location.dart';
import 'package:rakwa/screens/events/create/components/event_time.dart';
import 'package:rakwa/screens/home/home.dart';
import 'package:rakwa/views/bottom_btns.dart';
import 'package:rakwa/views/empty_content.dart';
import 'package:rakwa/views/header_back_btn.dart';
import 'package:rakwa/views/imagepicker.dart';
import 'package:rakwa/views/listing_spinner.dart';
import 'package:rakwa/views/progressing_button.dart';
import 'package:rakwa/views/text_field/my_text_field.dart';
import 'package:rakwa/views/text_field/my_text_field_normal.dart';

class CreateEventScreen extends StatefulWidget {
  Event event;

  CreateEventScreen({Key? key, required this.event}) : super(key: key);

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  GlobalKey<ProgressingButtonState> progressingButton =
      GlobalKey<ProgressingButtonState>();

  static ValueNotifier<List<Listing>> myListings =
      ValueNotifier<List<Listing>>([]);

  final GlobalKey<FormFieldState> _descriptionFieldForm =
      GlobalKey<FormFieldState>();

  final GlobalKey<FormFieldState> _addressFieldState =
      GlobalKey<FormFieldState>();

  final Map<SocialMedia, GlobalKey<FormFieldState>> _socialMediaFielsForm = {};

  bool progressing = true;

  final GlobalKey<FormFieldState> _titleFieldForm = GlobalKey<FormFieldState>();
  final GlobalKey<EventLocationWidgetState> _location = GlobalKey();
  final GlobalKey<ImagePickerWidgetState> _imagePicker = GlobalKey();
  final GlobalKey<EventTimeWidgetState> _startTimeKey = GlobalKey();
  final GlobalKey<EventTimeWidgetState> _endTimeKey = GlobalKey();
  final GlobalKey<EventDateWidgetState> _startDateKey =
      GlobalKey<EventDateWidgetState>();
  final GlobalKey<EventDateWidgetState> _endDateKey =
      GlobalKey<EventDateWidgetState>();

  loading(progress) {
    if (progressing != progress) {
      setState(() {
        progressing = progress;
      });
    }
  }

  @override
  initState() {
    super.initState();
    loadListing();
  }

  loadListing() {
    loading(true);
    MyApp.listingRepo
        .myListings(MyApp.token)
        .then((WebServiceResult<List<Listing>> value) {
      loading(false);
      switch (value.status) {
        case WebServiceResultStatus.success:
          myListings.value = value.data ?? [];

          break;
        case WebServiceResultStatus.error:
          mySnackBar(context,
              title: 'fetch listing failed',
              message: value.message, onPressed: () {
            loadListing();
          }, status: SnackBarStatus.error);

          break;
        case WebServiceResultStatus.loading:
          break;
        case WebServiceResultStatus.unauthorized:
          break;
      }
    });
  }

  requiredText(String? value) {
    if (value?.isEmpty ?? false) {
      return MyApp.resources.strings.mandatoryField;
    }
    return null;
  }

  submitForm() {
    if (!checkFields([
      _titleFieldForm,
    ])) {
      return;
    }

    if (_startTimeKey.currentState
            ?.checkEventTimeNotEmpty("Pick a start time") ==
        false) {
      return;
    }

    if (_endTimeKey.currentState?.checkEventTimeNotEmpty("Pick an end time") ==
        false) {
      return;
    }

    if (_startDateKey.currentState?.checkDateNotEmpty("Pick a start date") ==
        false) {
      return;
    }

    if (_endDateKey.currentState?.checkDateNotEmpty("Pick an end date") ==
        false) {
      return;
    }

    DateTime startDate = DateTime(
        widget.event.startDate!.year,
        widget.event.startDate!.month,
        widget.event.startDate!.day,
        widget.event.startTime!.hour,
        widget.event.startTime!.minute,
        0);

    DateTime endDate = DateTime(
        widget.event.endDate!.year,
        widget.event.endDate!.month,
        widget.event.endDate!.day,
        widget.event.endTime!.hour,
        widget.event.endTime!.minute,
        0);

    if (startDate.isAfter(endDate)) {
      AwesomeDialog(
              context: context,
              dialogType: DialogType.ERROR,
              animType: AnimType.BOTTOMSLIDE,
              title: "Event Date",
              desc: "The event start date must be before the end date",
              btnOk: null,
              btnCancel: null)
          .show();
      return;
    }

    if (!checkFields([
      _descriptionFieldForm,
    ])) {
      return;
    }

    if (widget.event.image.isEmpty &&
        _imagePicker.currentState?.checkFilePicked() == false) {
      return;
    }

    if (!checkFields([
      _addressFieldState,
    ])) {
      return;
    }

    if (_location.currentState?.checkPosition() == false) {
      return;
    }
    progressingButton.currentState?.showProgress(true);

    Future<WebServiceResult<String>> query;

    String titleDialog = 'Add Event';
    bool create = true;
    if (widget.event.id != 0) {
      create = false;
      query = MyApp.appRepo.updateEvent(widget.event);
      titleDialog = 'Edit Event';
    } else {
      query = MyApp.appRepo.createEvent(widget.event);
    }

    query.then((value) {
      progressingButton.currentState?.showProgress(false);
      switch (value.status) {
        case WebServiceResultStatus.success:
          if (create) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateEventScreen(
                        event: Event(),
                      )),
            );
          }

          mySnackBar(context,
              title: titleDialog,
              message: value.data ?? '',
              status: SnackBarStatus.success);

          break;
        case WebServiceResultStatus.error:
          mySnackBar(context,
              title: titleDialog,
              message: value.data ?? '',
              status: SnackBarStatus.error);

          break;
        case WebServiceResultStatus.loading:
          break;
        case WebServiceResultStatus.unauthorized:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("cccccccc" + widget.event.toString());
    return Scaffold(
      body: progressing
          ? const Center(
              child: MyProgressIndicator(
              color: Colors.orange,
            ))
          : SafeArea(
              child: Stack(
                children: [
                  Positioned(
                      top: 25,
                      left: 16,
                      right: 16,
                      child: HeaderWithBackScren(title: "Add Event")),
                  Positioned(
                    top: 90,
                    left: 0,
                    right: 0,
                    bottom: 80,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, top: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ValueListenableBuilder(
                                valueListenable: myListings,
                                builder: (BuildContext context,
                                    List<Listing> listings, Widget? child) {
                                  if (listings.isNotEmpty) {
                                    widget.event.listingId = listings.first.id;
                                  }
                                  return listings.isEmpty
                                      ? Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.5,
                                          alignment: Alignment.center,
                                          child: EmpyContentScreen(
                                            title: "Listing",
                                            description:
                                                "Create a listing then you can create a coupon",
                                          ))
                                      : ListingSpinnerWidget(
                                          myListings: listings,
                                          onListingChanged: (Listing listing) {
                                            widget.event.listingId = listing.id;
                                          },
                                        );
                                }),
                            if (myListings.value.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 14),
                                  MyNormalTextField(
                                      initial: widget.event.title,
                                      textInputType: TextInputType.text,
                                      formFieldeKey: _titleFieldForm,
                                      validator: requiredText,
                                      hint: "Event Title",
                                      onSave: (String? text) {
                                        if (text != null) {
                                          widget.event.title = text;
                                        }
                                      },
                                      textInputAction: TextInputAction.next),
                                  const SizedBox(height: 14),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: EventTimeWidget(
                                        key: _startTimeKey,
                                        time: widget.event.startTime,
                                        onTimePicked: (time) {
                                          widget.event.startTime = time;
                                        },
                                        title: "Event start time",
                                        error: "",
                                      )),
                                      SizedBox(
                                        width: 24,
                                      ),
                                      Expanded(
                                          child: EventTimeWidget(
                                        key: _endTimeKey,
                                        time: widget.event.endTime,
                                        onTimePicked: (time) {
                                          widget.event.endTime = time;
                                        },
                                        title: "Event end time",
                                        error: "",
                                      )),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: EventDateWidget(
                                        key: _startDateKey,
                                        date: widget.event.startDate,
                                        onDatePicked: (time) {
                                          widget.event.startDate = time;
                                        },
                                        title: "Event start date",
                                        error: "",
                                      )),
                                      SizedBox(
                                        width: 24,
                                      ),
                                      Expanded(
                                          child: EventDateWidget(
                                        key: _endDateKey,
                                        date: widget.event.endDate,
                                        onDatePicked: (time) {
                                          widget.event.endDate = time;
                                        },
                                        title: "Event end date",
                                        error: "",
                                      )),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  MyNormalTextField(
                                      initial: widget.event.description,
                                      textInputType: TextInputType.multiline,
                                      formFieldeKey: _descriptionFieldForm,
                                      hint: "Event Description",
                                      maxLines: 6,
                                      minLines: 5,
                                      validator: requiredText,
                                      onSave: (String? text) {
                                        if (text != null) {
                                          widget.event.description = text;
                                        }
                                      },
                                      textInputAction: TextInputAction.newline),
                                  SizedBox(
                                    height: 14,
                                  ),
                                  ImagePickerWidget(
                                    error: "",
                                    key: _imagePicker,
                                    onImagePicked: (image) {
                                      widget.event.imageFile = image;
                                    },
                                    title: "Upload Event Image",
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),
                                  MyTextField(
                                      initial: widget.event.address,
                                      validator: requiredText,
                                      textInputType:
                                          TextInputType.streetAddress,
                                      formFieldeKey: _addressFieldState,
                                      prefixWidget: SvgPicture.asset(
                                        MyIcons.icMarker,
                                        width: 22,
                                        height: 22,
                                        color: Colors.black,
                                      ),
                                      hint: "Adress 1st Line",
                                      onSave: (String? text) {
                                        if (text != null) {
                                          widget.event.address = text;
                                        }
                                      },
                                      textInputAction: TextInputAction.done),
                                  SizedBox(height: 8),
                                  EventLocationWidget(
                                    event: widget.event,
                                    key: _location,
                                  ),
                                  /*
    SizedBox(height: 16),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      "Social media",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2
                                          ?.copyWith(
                                              fontSize: 14,
                                              color: Colors.black),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: SocialMedia.values.map((e) {
                                        _socialMediaFielsForm.putIfAbsent(e,
                                            () => GlobalKey<FormFieldState>());
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: MyTextField(
                                              hint: e.label(),
                                              prefixWidget: Image.asset(
                                                e.icon(),
                                                width: 36,
                                                height: 36,
                                              ),
                                              texthint: "paste the link ",
                                              initial:
                                                  widget.event.socialMedia[e] ??
                                                      '',
                                              textInputType: TextInputType.url,
                                              textInputAction:
                                                  TextInputAction.go,
                                              formFieldeKey:
                                                  _socialMediaFielsForm[e]!,
                                              onSave: (String? link) {
                                                if (link != null) {
                                                  widget.event.socialMedia[e] =
                                                      link;
                                                }
                                              }),
                                        );
                                      }).toList()),
                                  SizedBox(height: 8),
                                  */
                                  SizedBox(height: 28),
                                ],
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (myListings.value.isNotEmpty)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        color: Colors.white,
                        height: 80,
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                        child: BottomButtons(
                            progressingButton: progressingButton,
                            neutralButtonText: "Back",
                            submitButtonText: "Save",
                            neutralButtonClick: () {
                              Navigator.pop(context);
                            },
                            submitButtonClick: () => submitForm()),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
