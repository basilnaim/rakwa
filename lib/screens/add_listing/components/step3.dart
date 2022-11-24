import 'package:flutter/material.dart';
import 'package:rakwa/model/hours_work.dart';
import 'package:rakwa/screens/add_listing/components/tamplate.dart';
import 'package:rakwa/views/bottom_btns.dart';
import 'package:rakwa/views/day_of_week/day_of_week.dart';
import '../listing_screen.dart';

class AddListingStep3 extends StatefulWidget {
  AddListingStep3({Key? key}) : super(key: key);

  @override
  State<AddListingStep3> createState() => _AddListingStep3State();
}

class _AddListingStep3State extends State<AddListingStep3> {
  onNexClick() {
    ListingScreenState.bottomTabNavigation.moveToNext();
  }

  _onDaySelected(HoursWork day) {
    day.selected = true;
  }

  _onDayUnSelected(HoursWork day) {
    day.selected = false;
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: ChooseTemplateScreen.listingToAdd.hoursWork!.length,
                itemBuilder: (BuildContext context, int index) {
                  print('SSSSSSSS'+ChooseTemplateScreen.listingToAdd.hoursWork![index].toString());
                  return DayOfWeekWidget(
                    day: index,
                    hoursWork:
                        ChooseTemplateScreen.listingToAdd.hoursWork![index] ??
                            HoursWork.defaultTime(selected: false),
                    onSelect: _onDaySelected,
                    onUnSelect: _onDayUnSelected,
                  );
                })),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 40, right: 40, top: 16, bottom: 16),
            //  width: double.infinity,
            child: BottomButtons(
                neutralButtonText: "Previous",
                submitButtonText: "Next",
                neutralButtonClick: () {
                  Navigator.maybePop(context);
                },
                submitButtonClick: () {
                  print("object");
                  onNexClick();
                }),
          ),
        ),
      ],
    );
  }
}
