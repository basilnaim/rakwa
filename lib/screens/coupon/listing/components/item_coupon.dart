import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/coupon.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/screens/add_listing/listing_events/Components/listing_event_item.dart';
import 'package:rakwa/screens/coupon/create/coupon_screen.dart';
import 'package:rakwa/utils/days.dart';
import 'package:rakwa/views/mini_btn.dart';

class ItemCoupon extends StatefulWidget {
  Coupon coupon;
  Function(int id) delete;
  ItemCoupon({Key? key, required this.coupon, required this.delete})
      : super(key: key);

  @override
  State<ItemCoupon> createState() => _ItemCouponState();
}

class _ItemCouponState extends State<ItemCoupon> {
  @override
  Widget build(BuildContext context) {
    List<EventDescModel> eventDescList = [];
    eventDescList.add(EventDescModel(
        key: "STATUS",
        value: "available",
        color: Colors.green,
        icon: MyIcons.icStatus));
    eventDescList.add(EventDescModel(
        key: "Start Date",
        value: formatDate2.format(widget.coupon.couponStart ?? DateTime.now()),
        icon: MyIcons.icStart));
    eventDescList.add(EventDescModel(
        key: "End",
        value:
            "${widget.coupon.couponEnd?.difference(widget.coupon.couponStart ?? DateTime.now()).inDays} days",
        icon: MyIcons.icTime));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 14, top: 12),
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          MyIcons.icCoupon,
                          width: 22,
                          height: 22,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Flexible(
                          child: InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    'your coupon is : ${widget.coupon.couponCode}'),
                              ));
                            },
                            child: Text(
                              widget.coupon.couponCode,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(
                                      color: MyApp.resources.color.orange),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${widget.coupon.discountValue}%",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(
                                  fontSize: 14,
                                  color: MyApp.resources.color.black1),
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: const Color(0xffE8E8E8), width: 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12))),
                  )),
                  SizedBox(
                    width: 14,
                  ),
                  MiniButtonWidget(
                    onClick: () {
                      AwesomeDialog(
                              context: context,
                              dialogType: DialogType.INFO,
                              animType: AnimType.SCALE,
                              title: "Delete coupon",
                              desc: "You want to remove this coupon?",
                              btnOkText: 'Delete',
                              btnOkOnPress: () =>
                                  widget.delete(widget.coupon.id),
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
                    icon: SvgPicture.asset(
                      MyIcons.icDelete,
                      width: 18,
                      height: 18,
                      color: const Color(0xff293644),
                    ),
                  ),
                  SizedBox(width: 8),
                  MiniButtonWidget(
                    onClick: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateCouponScreen(
                                  coupon: widget.coupon,
                                )),
                      );
                      setState(() {});
                    },
                    icon: SvgPicture.asset(
                      MyIcons.icEdit,
                      width: 18,
                      height: 18,
                      color: Color(0xff293644),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 16.0, right: 14),
              child: Text(
                widget.coupon.couponTitle,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    ?.copyWith(fontSize: 12, color: Color(0xff292929)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 7, left: 16.0, right: 14),
              child: Text(
                widget.coupon.couponDescription,
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                    fontSize: 11,
                    color: MyApp.resources.color.grey2.withOpacity(0.8)),
              ),
            ),
            SizedBox(height: 12),
            Container(
              height: 0.3,
              decoration: BoxDecoration(
                color: Color(0xffE1E1E1),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              padding:
                  const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 4),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                primary: false,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
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
            ),
          ],
        ),
        decoration: BoxDecoration(
            color: const Color(0xffFCFCFC).withOpacity(0.55),
            border: Border.all(color: const Color(0xffE1E1E1), width: 0.5),
            borderRadius: const BorderRadius.all(Radius.circular(12))),
      ),
    );
  }
}
