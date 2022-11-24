import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/listing/listing_event.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/screens/add_listing/listing_events/Components/header.dart';
import 'package:rakwa/screens/add_listing/listing_events/Components/listing_event_item.dart';

import 'package:rakwa/views/search_container.dart';

class ListingEvents extends StatefulWidget {
  ListingEvents({Key? key, this.events, this.onParticipateEvent})
      : super(key: key);

  List<ListingEvent>? events;
  final VoidCallback? onParticipateEvent;

  @override
  State<ListingEvents> createState() => _ListingEventsState();
}

class _ListingEventsState extends State<ListingEvents> {
  var textController = TextEditingController();
  bool isLoading = false;
  _eventParticipate(String eventId, String participation) {
    print('participation data started');
    setState(() {
      isLoading = true;
    });

    MyApp.listingRepo
        .eventParticipate(eventId, participation, MyApp.token)
        .then((WebServiceResult<String> value) {
      setState(() {
        isLoading = false;
      });
      switch (value.status) {
        case WebServiceResultStatus.success:
          print(value.data!);
          widget.onParticipateEvent?.call();

          break;
        case WebServiceResultStatus.error:
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'participation review failed failed',
                  desc: value.message,
                  btnOk: null,
                  btnCancel: null)
              .show();
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
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Header(),
                // SearchContainer(
                //   hint: "Search for events",
                //     isDetail: true,
                //     isHome: true,
                //     textController: textController),
                const SizedBox(height: 16),
                (widget.events != null && widget.events!.isNotEmpty)
                    ? Flexible(
                        fit: FlexFit.loose,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.events?.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, i) {
                            return ListingEventItem(
                                event: widget.events?[i],
                                onParticipate: (bool participation) {
                                  _eventParticipate(
                                      widget.events![i].eventId.toString(),
                                      (participation) ? "1" : "0");
                                });
                          },
                        ),
                      )
                    : Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  MyIcons.icError,
                                  height: 100,
                                  width: 80,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'This listing does not have any events',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
              ]),
        ),
      ),
    );
  }
}
