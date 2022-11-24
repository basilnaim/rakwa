import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/announcement.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/screens/announcement/create/create_announcement.dart';
import 'package:rakwa/views/mini_btn.dart';
import 'package:rakwa/views/text_field/my_text_field_normal.dart';

class ItemAnnouncement extends StatefulWidget {
  Announcement announcement;
  Function(int id) delete;
  ItemAnnouncement({Key? key, required this.announcement, required this.delete})
      : super(key: key);

  @override
  State<ItemAnnouncement> createState() => _ItemAnnouncementState();
}

class _ItemAnnouncementState extends State<ItemAnnouncement> {
  @override
  Widget build(BuildContext context) {
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          MyIcons.icRocket,
                          width: 22,
                          height: 22,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Row(
                          children: [
                            Text(
                              "Get Offer",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(
                                      fontSize: 12,
                                      color: MyApp.resources.color.black1),
                            ),
                            Icon(
                              Icons.navigate_next,
                              size: 16,
                              color: MyApp.resources.color.black1,
                            )
                          ],
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: const Color(0xffE8E8E8), width: 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12))),
                  ),
                  SizedBox(
                    width: 14,
                  ),
                  Spacer(),
                  MiniButtonWidget(
                    onClick: () {
                      AwesomeDialog(
                              context: context,
                              dialogType: DialogType.INFO,
                              animType: AnimType.SCALE,
                              title: "Delete announcement",
                              desc: "You want to remove this announcement?",
                              btnOkText: 'Delete',
                              btnOkOnPress: () =>
                                  widget.delete(widget.announcement.id),
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
                            builder: (context) => CreateAnnouncementScreen(
                                  announcement: widget.announcement,
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
                widget.announcement.btnText??"",
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    ?.copyWith(fontSize: 12, color: Color(0xff292929)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 7, left: 16.0, right: 14),
              child: Text(
                widget.announcement.description??"",
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                    fontSize: 11,
                    color: MyApp.resources.color.grey2.withOpacity(0.8)),
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: MyNormalTextField(
                  isReadOnly: true,
                  initial: widget.announcement.btnLink??"",
                  textInputType: TextInputType.url,
                  prefixWidget: Padding(
                    padding: const EdgeInsets.only(top: 8, right: 8.0),
                    child: SvgPicture.asset(
                      MyIcons.icLink,
                      width: 20,
                      height: 20,
                    ),
                  ),
                  onSave: (String? text) {
                    if (text != null) {
                      widget.announcement.btnLink = text;
                    }
                  },
                  textInputAction: TextInputAction.next),
            ),
            SizedBox(height: 12),
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
