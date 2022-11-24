import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/classfield_to_ws.dart';
import 'package:rakwa/model/classified.dart';
import 'package:rakwa/res/images/MyImages.dart';
import 'package:rakwa/screens/add_classified/add_classified.dart';
import 'package:rakwa/screens/classifieds/classified_detail.dart';

class MyClassifiedItem extends StatefulWidget {
  const MyClassifiedItem({Key? key, this.item, this.onDelete, this.onRefresh})
      : super(key: key);
  final Classified? item;
  final VoidCallback? onDelete;
  final Function? onRefresh;

  @override
  State<MyClassifiedItem> createState() => _MyClassifiedItemState();
}

class _MyClassifiedItemState extends State<MyClassifiedItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        border:
            Border.all(width: 0.5, color: MyApp.resources.color.borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ClassifiedDetail(
                      isMine: true, classifiedId: widget.item?.id)),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(12),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'lib/res/images/loader.gif',
                      height: 160,
                      width: MediaQuery.of(context).size.width,
                      // image: item!.image,
                      image: widget.item?.image ?? "",
                      fit: BoxFit.cover,
                      imageErrorBuilder: (BuildContext context,
                          Object exception, StackTrace? stackTrace) {
                        return Image.asset(
                          MyImages.errorImage,
                          width: MediaQuery.of(context).size.width,
                          height: 160,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.item?.title ?? "",
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.item?.category ?? "",
                    style: TextStyle(
                        fontSize: 12,
                        color: MyApp.resources.color.orange,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                            color: MyApp.resources.color.background
                                .withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                width: 0.5,
                                color: MyApp.resources.color.borderColor)),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.INFO,
                                      animType: AnimType.SCALE,
                                      title: "Delete classified",
                                      desc:
                                          "You want to remove this classified?",
                                      btnOkText: 'Delete',
                                      btnOkOnPress: () =>
                                          widget.onDelete?.call(),
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
                            borderRadius: BorderRadius.circular(12),
                            child: Center(
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(
                                      Icons.delete_forever_outlined,
                                      color: Colors.black,
                                      size: 18,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "Remove",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ]),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      flex: 1,
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                            color: MyApp.resources.color.orange,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                width: 0.5,
                                color: MyApp.resources.color.borderColor)),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              ClassifiedToWs classifiedToWs =
                                  ClassifiedToWs.fromClassified(widget.item!);
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddClassified(
                                          classified: classifiedToWs,
                                        )),
                              );

                              widget.onRefresh?.call();
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Center(
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(
                                      Icons.mode_edit_outline_outlined,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "Edit",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ])
                ]),
          ),
        ),
      ),
    );
  }
}
