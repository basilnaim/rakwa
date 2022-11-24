import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:rakwa/main.dart';
import 'package:rakwa/model/createAds.dart';
import 'package:rakwa/res/fonts/fonts.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/screens/ad_compaigns/create/create_ad.dart';

import '../../../all_events/Components/all_event_item.dart';

class ItemCampaigns extends StatefulWidget {
  AdCampaigns campaign;
  Function(int id) onDeleteClicked;
  ItemCampaigns(
      {Key? key, required this.campaign, required this.onDeleteClicked})
      : super(key: key);

  @override
  State<ItemCampaigns> createState() => _ItemCampaignsState();
}

class _ItemCampaignsState extends State<ItemCampaigns> {
  List<EventDescModel> eventDescList = [];

  @override
  void initState() {
    super.initState();

    eventDescList.add(EventDescModel(
        key: "STATUS",
        value: "Published",
        color: Colors.green,
        icon: MyIcons.icStatus));

    String? formattedStartDate = (widget.campaign.startDate == null)
        ? null
        : DateFormat('dd-MM-yyyy').format(widget.campaign.startDate!);

    if (formattedStartDate != null) {
      eventDescList.add(EventDescModel(
          key: "AD Start", value: formattedStartDate, icon: MyIcons.icRocket));
    }

    eventDescList.add(EventDescModel(
        key: "AD End",
        value: widget.campaign.days.toString() + " Days",
        icon: MyIcons.icTime));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 0, bottom: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border.all(color: MyApp.resources.color.borderColor, width: 0.8),
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            height: 148,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      widget.campaign.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                    top: 14,
                    left: 0,
                    child: SvgPicture.asset(MyIcons.icAdTiket)),
                Positioned(
                  top: 15,
                  left: 10,
                  child: Text(
                    "AD",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        ?.copyWith(fontSize: 12, color: Colors.white),
                  ),
                ),
              ],
            ),
            padding: EdgeInsets.only(left: 12, right: 14, top: 14)),
        Padding(
          padding: EdgeInsets.only(top: 12, left: 16),
          child: Text(
            widget.campaign.title,
            style: Theme.of(context).textTheme.subtitle2?.copyWith(
                fontSize: 12, color: MyApp.resources.color.colorText),
          ),
        ),
        Container(
          height: 50,
          margin: EdgeInsets.only(bottom: 16, top: 8),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            primary: false,
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 16, right: 16),
            itemCount: eventDescList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 8,
                crossAxisSpacing: 5,
                childAspectRatio: 2.2,
                crossAxisCount: 3),
            itemBuilder: (_, int index) {
              return EventDescItem(
                eventDescModel: eventDescList[index],
              );
            },
          ),
          decoration: BoxDecoration(
              color: Color(0xffFCFCFC),
              border: Border.all(
                  color: MyApp.resources.color.borderColor, width: 1)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 12),
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: ElevatedButton.icon(
                  icon: SvgPicture.asset(MyIcons.icDelete),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 44),
                      elevation: 1,
                      shadowColor: MyApp.resources.color.grey1,
                      primary: MyApp.resources.color.grey1,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: BorderSide(
                              color: MyApp.resources.color.grey1, width: 0.8))),
                  onPressed: () {
                    AwesomeDialog(
                            context: context,
                            dialogType: DialogType.INFO,
                            animType: AnimType.SCALE,
                            title: "Remove AD",
                            desc: "You want to remove this Ad?",
                            btnOkText: 'Delete',
                            btnOkOnPress: () =>
                                widget.onDeleteClicked(widget.campaign.id),
                            btnCancelOnPress: () {},
                            btnOkColor: Colors.orange,
                            buttonsTextStyle: Theme.of(context)
                                .textTheme
                                .bodyText2
                                ?.copyWith(color: Colors.white),
                            btnCancelColor: Colors.blueGrey,
                            btnCancelText: 'Cancel')
                        .show();
                  },
                  label: Text(
                    "Remove AD",
                    style: Theme.of(context).textTheme.button?.copyWith(
                        fontSize: 12,
                        fontWeight: FontFamily.regular.fontWeight(),
                        color: MyApp.resources.color.black2),
                  ),
                ),
              ),
              /*
               SizedBox(width: 16),
              Flexible(
                flex: 1,
                child: ElevatedButton.icon(
                  icon: SvgPicture.asset(
                    MyIcons.icEdit,
                    color: Colors.white,
                  ),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 44),
                      elevation: 1,
                      shadowColor: MyApp.resources.color.orange,
                      primary: MyApp.resources.color.orange,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: BorderSide(
                              color: MyApp.resources.color.orange,
                              width: 0.8))),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateAdCompaign(
                                ads: widget.campaign,
                              )),
                    );

                    setState(() {});
                  },
                  label: Text(
                    "Edit AD",
                    style: Theme.of(context).textTheme.button?.copyWith(
                        fontSize: 12,
                        fontWeight: FontFamily.regular.fontWeight(),
                        color: Colors.white),
                  ),
                ),
              ),
            
              */
            ],
          ),
        )
      ]),
    );
  }
}
