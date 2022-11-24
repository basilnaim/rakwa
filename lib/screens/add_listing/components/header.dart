import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';

class ListingHeader extends StatelessWidget {
  int step;
  int steps;
  String title;
  ListingHeader(
      {Key? key, required this.steps, required this.step, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      margin: EdgeInsets.only(left: 16, right: 16),
      padding: EdgeInsets.only(bottom: 20, top: 20, right: 26, left: 26),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Step ${step+1}',
            style: Theme.of(context).textTheme.subtitle1?.copyWith(
                fontSize: 12,
                color: MyApp.resources.color.black2.withOpacity(0.8)),
          ),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headline3
                ?.copyWith(fontSize: 18, color: MyApp.resources.color.black2),
          ),
          stepperBuilder()
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: MyApp.resources.color.grey1, width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }

  Widget stepperBuilder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < (steps*2)-1; i++) 
               (i%2 ==0 ) ?  stationStep(i/2):stationSeparator(i/2)
      ],
    );
  }


  Widget stationStep(substep) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            color: substep <= step
                ? MyApp.resources.color.orange
                : MyApp.resources.color.grey1,
            width: 1),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget stationSeparator(substep) {
    return Expanded(
      child: Container(
        height: 2,
        color: substep < step
            ? MyApp.resources.color.orange
            : MyApp.resources.color.grey1,
      ),
    );
  }
}
