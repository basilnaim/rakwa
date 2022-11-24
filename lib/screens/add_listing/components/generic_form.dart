import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/generic_form.dart';
import 'package:rakwa/model/listing.dart';
import 'package:rakwa/screens/add_listing/components/generic_field_container.dart';
import 'package:rakwa/views/bottom_btns.dart';
import 'package:rakwa/views/progressing_button.dart';
import '../listing_screen.dart';

class GenericFormScreen extends StatefulWidget {
  Listing listing;
  List<GenericForm> form;
  Function(GlobalKey<ProgressingButtonState>) saveListing;

  GenericFormScreen(
      {Key? key,
      required this.listing,
      required this.form,
      required this.saveListing})
      : super(key: key);

  @override
  State<GenericFormScreen> createState() => _GenericFormScreenState();
}

class _GenericFormScreenState extends State<GenericFormScreen> {
  final GlobalKey<ProgressingButtonState> _progressingButton = GlobalKey();
  onNexClick() {
    ListingScreenState.bottomTabNavigation.moveToNext();
  }

  @override
  void initState() {
    super.initState();
    widget.form
        .map((e) => e.fields)
        .expand((element) => element)
        .forEach((element) {
      GlobalKey<GenericFieldContainerState> fkey =
          GlobalKey<GenericFieldContainerState>();
      element.key = fkey;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 80,
          child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: widget.form.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16, top: 8, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.form[index].fields.length > 1)
                        Text(
                          widget.form[index].sectionName,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: Colors.black),
                        ),
                      SizedBox(
                        height: 12,
                      ),
                      Column(
                        children: widget.form[index].fields.map((e) {
                          return GenericFieldContainer(
                            field: e,
                            key: e.key,
                          );
                        }).toList(),
                      )
                    ],
                  ),
                );
              }),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white,
            padding:
                const EdgeInsets.only(left: 40, right: 40, top: 16, bottom: 16),
            //  width: double.infinity
            height: 80,
            child: BottomButtons(
                progressingButton: _progressingButton,
                neutralButtonText: "Previous",
                submitButtonText: "Save",
                neutralButtonClick: () {
                  Navigator.maybePop(context);
                },
                submitButtonClick: () {
                  for (var field in widget.form) {
                    if (field.fields.any((element) => element.isRequired)) {
                      String? result;
                      if (!field.fields
                          .any((element) => element.value.isNotEmpty)) {
                        for (var element in field.fields) {
                          result = element.key?.currentState?.save();
                        }

                        if (result != null) {
                          if (result.isNotEmpty) {
                            mySnackBar(context,
                                showInBottom: false,
                                title: 'Require field',
                                message: 'please fill ${field.sectionName}',
                                status: SnackBarStatus.error);
                          }
                          return;
                        }
                      }
                    }
                  }

                  // widget.form
                  //     .map((e) => e.fields)
                  //     .expand((element) => element)
                  //     .forEach((element) {
                  //   String? result = element.key?.currentState?.save();
                  //   if (result != null) {
                  //     if (result.isNotEmpty) {
                  //       mySnackBar(context,
                  //           showInBottom: false,
                  //           title: 'Required field',
                  //           message: result,
                  //           status: SnackBarStatus.error);
                  //     }
                  //     return;
                  //   }
                  // });

                  widget.saveListing(_progressingButton);
                }),
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
