import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/createAds.dart';

class AdsDays extends StatefulWidget {
  AdCampaigns ads;
  AdsDays({Key? key, required this.ads}) : super(key: key);

  @override
  State<AdsDays> createState() => _AdsDaysState();
}

class _AdsDaysState extends State<AdsDays> {
  ValueNotifier<int> days = ValueNotifier<int>(1);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Center(
        child: Row(
          children: [
            Expanded(
              child: Text(
                "Set Days For This Campaign",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(color: MyApp.resources.color.textColor),
              ),
            ),
            Container(
                height: 50,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: MyApp.resources.color.grey3,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    border: Border.all(
                        color: MyApp.resources.color.borderColor, width: 0.8)),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      child: Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          onTap: () {
                            int dayn = days.value;
                            if (dayn > 0) days.value = dayn - 1;
                          },
                          child: Center(
                              child: Icon(
                            Icons.remove,
                            color: Color(0xff202020),
                          )),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: MyApp.resources.color.grey3,
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          border: Border.all(
                              color: MyApp.resources.color.borderColor,
                              width: 0.8)),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    ValueListenableBuilder(
                        valueListenable: days,
                        builder: (context, int daysNumber, w) {
                          widget.ads.days = daysNumber;
                          return Text(
                            daysNumber.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(color: MyApp.resources.color.orange),
                          );
                        }),
                    SizedBox(
                      width: 8,
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      child: Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          onTap: () {
                            int dayn = days.value;
                            days.value = dayn + 1;
                          },
                          child: Center(
                              child: Icon(
                            Icons.add,
                            color: Color(0xff202020),
                          )),
                        )
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          border: Border.all(
                              color: MyApp.resources.color.borderColor,
                              width: 0.8)),
                    )
                  ],
                ))
          ],
        ),
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          border:
              Border.all(color: MyApp.resources.color.borderColor, width: 0.8)),
    );
  }
}
