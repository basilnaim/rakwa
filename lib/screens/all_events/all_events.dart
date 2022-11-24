import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/error.dart';
import 'package:rakwa/model/listing/listing_event.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/screens/add_listing/listing_events/Components/listing_event_item.dart';
import 'package:rakwa/screens/home/home.dart';
import 'package:rakwa/views/error_widget.dart';
import 'Components/Header.dart';

class AllEvenets extends StatefulWidget {
  const AllEvenets({Key? key}) : super(key: key);

  @override
  State<AllEvenets> createState() => _AllEvenetsState();
}

class _AllEvenetsState extends State<AllEvenets> {
  var textController = TextEditingController();
  List<ListingEvent> eventsList = [];
  bool progressing = true;
  bool hasError = false;

  progress(bool loading) {
    if (progressing != loading) {
      setState(() {
        progressing = loading;
      });
    }
  }

  _fetchEvents() {
    print('fetch events started');

    progress(true);
    MyApp.homeRepo
        .allEvents(
      (currentPosition != null)
          ? currentPosition!.latitude!.toString()
          : "33.9633673",
      (currentPosition != null)
          ? currentPosition!.longitude!.toString()
          : "117.3645113",
      MyApp.token,
    )
        .then((WebServiceResult<List<ListingEvent>> value) {
      switch (value.status) {
        case WebServiceResultStatus.success:
          print(value.data!);
          eventsList = value.data!;
          setState(() {
            progressing = false;
            hasError = false;
          });
          break;
        case WebServiceResultStatus.error:
          setState(() {
            hasError = true;
            progressing = false;
          });

          break;
        case WebServiceResultStatus.loading:
          break;
        case WebServiceResultStatus.unauthorized:
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (currentPosition == null) {
      getLoc();
    }
    _fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyApp.resources.color.background,
      body: SafeArea(
        child: (progressing && eventsList == null)
            ? MyProgressIndicator(
                color: MyApp.resources.color.orange,
              )
            : hasError
                ? Column(
                    children: [
                      Header(),
                      Expanded(
                        child: MyErrorWidget(
                            errorModel: ErrorModel(
                                btnClickListener: () {
                                  _fetchEvents();
                                },
                                btnText: 'Try Again!',
                                text: 'Sorry something went wrong!')),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        const Header(),
                        /*  SearchContainer(
                    hint: "Search For Events",
                      isDetail: true,
                      isHome: true,
                      textController: textController),*/
                        const SizedBox(height: 12),
                        (eventsList != null && eventsList!.isNotEmpty)
                            ? Expanded(
                                child: RefreshIndicator(
                                  color: MyApp.resources.color.orange,
                                  onRefresh: () async {
                                    _fetchEvents();
                                  },
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: eventsList.length,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, i) {
                                      return ListingEventItem(
                                        event: eventsList?[i],
                                      );
                                    },
                                  ),
                                ),
                              )
                            : Expanded(
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: double.maxFinite,
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(height: 80),
                                        SvgPicture.asset(
                                          MyIcons.icError,
                                          height: 100,
                                          width: 80,
                                        ),
                                        const SizedBox(height: 16),
                                        const Text(
                                          'There is no events to show',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        const Text(
                                          'Go to Dashboard Events to create new event',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ]),
                                ),
                              ),
                      ]),
      ),
    );
  }
}
