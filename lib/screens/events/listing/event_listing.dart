import 'package:flutter/material.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/event.dart';
import 'package:rakwa/model/listing.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/screens/all_events/Components/all_event_item.dart';
import 'package:rakwa/screens/events/create/create_event.dart';
import 'package:rakwa/screens/home/home.dart';
import 'package:rakwa/views/empty_content.dart';
import 'package:rakwa/views/header_back_btn.dart';
import 'package:rakwa/views/listing_spinner.dart';
import 'package:rakwa/views/not_registred.dart';
import 'package:rakwa/views/progressing_button.dart';
import 'package:rakwa/views/text_field/my_text_field_normal.dart';

class EventListing extends StatefulWidget {
  const EventListing({Key? key}) : super(key: key);

  @override
  State<EventListing> createState() => _EventListingState();
}

class _EventListingState extends State<EventListing> {
  GlobalKey<ProgressingButtonState> progressingButton =
      GlobalKey<ProgressingButtonState>();

  Listing? selectedListing;
  static ValueNotifier<List<Event>> events = ValueNotifier<List<Event>>([]);
  static ValueNotifier<List<Listing>> myListings =
      ValueNotifier<List<Listing>>([]);

  bool progressing = true;
  bool progressingEvents = true;

  loading(progress) {
    if (progressing != progress) {
      setState(() {
        progressing = progress;
      });
    }
  }

  loadingEventProgress(progress) {
    if (progressingEvents != progress) {
      setState(() {
        progressingEvents = progress;
      });
    }
  }

  @override
  initState() {
    super.initState();
    loadEvent();
  }

  loadEvent() {
    loadingEventProgress(true);
    MyApp.appRepo.getListingEvents().then((value) {
      loadingEventProgress(false);

      switch (value.status) {
        case WebServiceResultStatus.success:
          events.value = value.data ?? [];

          break;
        case WebServiceResultStatus.error:
          mySnackBar(context,
              title: 'fetch events failed',
              message: value.message, onPressed: () {
            loadEvent();
          }, status: SnackBarStatus.error);

          break;
        case WebServiceResultStatus.loading:
          break;
        case WebServiceResultStatus.unauthorized:
          break;
      }
    });
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
          if (myListings.value.isNotEmpty) {
            selectedListing = myListings.value.first;
            loadEvent();
          }
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

  deleteEvent(int id) {
    loadingEventProgress(true);
    MyApp.appRepo.deleteEvent(id).then((value) {
      loadingEventProgress(false);
      switch (value.status) {
        case WebServiceResultStatus.success:
          mySnackBar(context,
              title: 'Remove Event',
              message: "Event removed successfully",
              status: SnackBarStatus.success);

          loadEvent();

          break;
        case WebServiceResultStatus.error:
          mySnackBar(context,
              title: 'Remove Event',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyApp.resources.color.background,
      body: !MyApp.isConnected
          ? Column(
              children: [
                SizedBox(
                  height: 64,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: HeaderWithBackScren(
                    title: 'All Events',
                  ),
                ),
                Flexible(
                    child: Align(
                        alignment: Alignment.center,
                        child: RequireRegistreScreen(
                          postFunction: () {
                            loadEvent();
                          },
                        ))),
              ],
            )
          : (
              /*
            progressing
              ? const Center(
                  child: MyProgressIndicator(
                  color: Colors.orange,
                ))
              :
            */
              SafeArea(
              child: Stack(
                children: [
                  Positioned(
                      top: 25,
                      left: 16,
                      right: 16,
                      child: HeaderWithBackScren(title: "All Events")),
                  Positioned(
                    top: 80,
                    left: 0,
                    right: 0,
                    bottom: 80,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 16.0, right: 16, top: 24),
                      child: ValueListenableBuilder(
                          valueListenable: events,
                          builder: (BuildContext context, List<Event> mEvents,
                              Widget? child) {
                            return progressingEvents
                                ? const Center(
                                    child: MyProgressIndicator(
                                    color: Colors.orange,
                                  ))
                                : (mEvents.isEmpty
                                    ? Align(
                                        alignment: Alignment.center,
                                        child: EmpyContentScreen(
                                          title: "Events",
                                          description:
                                              "Click the button below to add the first Event",
                                        ))
                                    : ListView.builder(
                                        itemCount: mEvents.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return AllEventItem(
                                              onDelete: deleteEvent,
                                              event: mEvents[index]);
                                        }));
                          }),
                    ),
                  ),
                  //   if (myListings.value.isNotEmpty)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Colors.white,
                      height: 80,
                      padding:
                          const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      child: ProgressingButton(
                        textColor: Colors.white,
                        buttonText: 'Create New Event',
                        color: MyApp.resources.color.orange,
                        onSubmitForm: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateEventScreen(
                                      event: Event(),
                                    )),
                          );

                          loadEvent();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )),
    );
  }
}
