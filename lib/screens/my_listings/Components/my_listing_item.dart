// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:intl/intl.dart';
// import 'package:rakwa/main.dart';
// import 'package:rakwa/model/categorie.dart';
// import 'package:rakwa/model/city.dart';
// import 'package:rakwa/model/listing.dart';
// import 'package:rakwa/model/listing/contact.dart';
// import 'package:rakwa/model/listing/media.dart';
// import 'package:rakwa/model/location.dart';
// import 'package:rakwa/model/state.dart';
// import 'package:rakwa/res/icons/my_icons.dart';
// import 'package:rakwa/screens/add_listing/detail_listing.dart';
// import 'package:rakwa/screens/add_listing/listing_screen.dart';
// import 'package:rakwa/screens/my_listings/Components/my_listing_img_container.dart';

// import '../../add_listing/components/tamplate.dart';
// import '../../add_listing/listing_events/Components/listing_event_item.dart';

// class MyListingItem extends StatefulWidget {
//   MyListingItem({Key? key, this.item, this.onEditClick, this.onRemoveClick})
//       : super(key: key);
//   final Listing? item;
//   final VoidCallback? onRemoveClick;
//   final VoidCallback? onEditClick;

//   @override
//   State<MyListingItem> createState() => _MyListingItemState();
// }

// class _MyListingItemState extends State<MyListingItem> {
//   List<EventDescModel> eventDescList = [];

//   @override
//   void initState() {
//     super.initState();

//     var startDate = DateTime.parse(widget.item?.start_date?.date ?? "");
//     var endDate = (widget.item?.end_date != null)
//         ? DateTime.parse(widget.item?.end_date?.date ?? "")
//         : null;
//     String formattedStartDate = DateFormat('dd-MM-yyyy').format(startDate);
//     String formattedEndDate =
//         (endDate != null) ? DateFormat('dd-MM-yyyy').format(endDate) : "-";

//     eventDescList.add(EventDescModel(
//         key: "STATUS",
//         value: widget.item?.status,
//         color: (widget.item?.status.toLowerCase() != "published")
//             ? Colors.red
//             : Colors.green,
//         icon: MyIcons.icStatus));
//     eventDescList.add(EventDescModel(
//         key: "START",
//         value: formattedStartDate,
//         color: Colors.black,
//         icon: MyIcons.icStart));
//     eventDescList.add(EventDescModel(
//         key: "EXPIRY",
//         value: formattedEndDate,
//         color: Colors.black,
//         icon: MyIcons.icTime));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border:
//             Border.all(width: 0.5, color: MyApp.resources.color.borderColor),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: InkWell(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => DetailListingContainerScreen(
//                       listingId: (widget.item?.id ?? 0).toString(),
//                     )),
//           );
//         },
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Row(children: [
//                   Icon(Icons.diamond_outlined,
//                       color: MyApp.resources.color.orange, size: 16),
//                   const SizedBox(width: 4),
//                   const Text(
//                     "ASSOCIATED PLAN ",
//                     style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.black,
//                         fontWeight: FontWeight.w600),
//                   ),
//                   Text(
//                     widget.item?.associated_plan ?? "Basic",
//                     style: TextStyle(
//                         fontSize: 12,
//                         color: MyApp.resources.color.orange,
//                         fontWeight: FontWeight.w600),
//                   ),
//                   const Spacer(),
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: MyApp.resources.color.background,
//                         border: Border.all(
//                             width: 0.5,
//                             color: MyApp.resources.color.borderColor)),
//                     child: Row(children: [
//                       SvgPicture.asset(
//                         MyIcons.icOwn,
//                         width: 16,
//                         height: 16,
//                         color: Colors.black,
//                       ),
//                       const SizedBox(width: 4),
//                       const Text(
//                         'upgrade',
//                         style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.black,
//                             fontWeight: FontWeight.w700),
//                       )
//                     ]),
//                   )
//                 ]),
//               ),
//               const SizedBox(height: 12),
//               Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: MyListingImageContainer(
//                     listing: widget.item,
//                   )),
//               const SizedBox(height: 12),
//               Row(children: [
//                 const SizedBox(width: 16),
//                 Text(
//                   widget.item?.title ?? "",
//                   style: const TextStyle(
//                       fontSize: 14,
//                       color: Colors.black,
//                       fontWeight: FontWeight.w600),
//                 ),
//                 const SizedBox(width: 4),
//                 const Icon(
//                   Icons.star,
//                   size: 16,
//                   color: Colors.amber,
//                 ),
//                 const SizedBox(width: 4),
//                 Text(
//                   (widget.item?.rating).toString(),
//                   style: const TextStyle(
//                       fontSize: 14,
//                       color: Colors.black,
//                       fontWeight: FontWeight.w600),
//                 ),
//                 const SizedBox(width: 16),
//               ]),
//               const SizedBox(height: 12),
//               Container(
//                 width: MediaQuery.of(context).size.width,
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade50.withOpacity(0.5),
//                   border: Border.symmetric(
//                     horizontal: BorderSide(
//                         width: 0.5, color: MyApp.resources.color.borderColor),
//                   ),
//                 ),
//                 child: Row(children: [
//                   Flexible(
//                     flex: 1,
//                     child: EventDescItem(
//                       eventDescModel: eventDescList[0],
//                     ),
//                   ),
//                   Flexible(
//                     flex: 1,
//                     child: EventDescItem(
//                       eventDescModel: eventDescList[1],
//                     ),
//                   ),
//                   Flexible(
//                     flex: 1,
//                     child: EventDescItem(
//                       eventDescModel: eventDescList[2],
//                     ),
//                   )
//                 ]),
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   const SizedBox(width: 16),
//                   Flexible(
//                     flex: 1,
//                     child: Container(
//                       height: 55,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(18),
//                           border: Border.all(
//                               width: 0.5,
//                               color: MyApp.resources.color.borderColor),
//                           color: MyApp.resources.color.background
//                               .withOpacity(0.7)),
//                       child: Material(
//                         color: Colors.transparent,
//                         child: InkWell(
//                           borderRadius: BorderRadius.circular(18),
//                           onTap: () {
//                             widget.onRemoveClick?.call();
//                           },
//                           child: Center(
//                             child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: const [
//                                   Icon(
//                                     Icons.delete_forever_outlined,
//                                     size: 20,
//                                     color: Colors.black,
//                                   ),
//                                   SizedBox(width: 4),
//                                   Text(
//                                     "Remove Listing",
//                                     style: TextStyle(
//                                         fontSize: 13,
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.w600),
//                                   )
//                                 ]),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Flexible(
//                     flex: 1,
//                     child: Container(
//                       height: 55,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(18),
//                           border: Border.all(
//                               width: 0.5,
//                               color: MyApp.resources.color.borderColor),
//                           color: MyApp.resources.color.orange),
//                       child: Material(
//                         color: Colors.transparent,
//                         child: InkWell(
//                           borderRadius: BorderRadius.circular(18),
//                           onTap: () async {
//                             bool? result = await Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (context) {
//                                 ChooseTemplateScreen.listingToAdd =
//                                     widget.item!;

//                                 return ListingScreen(
//                                   create: false,
//                                   listingToUpdate: widget.item!,
//                                   categorieModel: widget.item?.category == null
//                                       ? null
//                                       : CategorieModel(
//                                           id: widget.item!.category!.id,
//                                           title: widget.item!.title),
//                                 );
//                               }),
//                             );

//                             if (result == true) {
//                               widget.onEditClick?.call();
//                             }
//                           },
//                           child: Center(
//                             child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: const [
//                                   Icon(
//                                     Icons.edit_outlined,
//                                     size: 20,
//                                     color: Colors.white,
//                                   ),
//                                   SizedBox(width: 4),
//                                   Text(
//                                     "Edit Listing",
//                                     style: TextStyle(
//                                         fontSize: 13,
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.w600),
//                                   )
//                                 ]),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/categorie.dart';
import 'package:rakwa/model/listing.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/screens/add_listing/detail_listing.dart';
import 'package:rakwa/screens/add_listing/listing_screen.dart';
import 'package:rakwa/screens/my_listings/Components/my_listing_img_container.dart';

import '../../add_listing/components/tamplate.dart';
import '../../add_listing/listing_events/Components/listing_event_item.dart';

class MyListingItem extends StatefulWidget {
  MyListingItem({Key? key, this.item, this.onEditClick, this.onRemoveClick})
      : super(key: key);
  final Listing? item;
  final VoidCallback? onRemoveClick;
  final VoidCallback? onEditClick;

  @override
  State<MyListingItem> createState() => _MyListingItemState();
}

class _MyListingItemState extends State<MyListingItem> {
  List<EventDescModel> eventDescList = [];

  @override
  void didUpdateWidget(covariant MyListingItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    setupData();
  }

  @override
  void initState() {
    super.initState();
    setupData();
  }

  void setupData() {
    eventDescList = [];
    var startDate = DateTime.parse(widget.item?.start_date?.date ?? "");
    var endDate = (widget.item?.end_date != null)
        ? DateTime.parse(widget.item?.end_date?.date ?? "")
        : null;
    String formattedStartDate = DateFormat('dd-MM-yyyy').format(startDate);
    String formattedEndDate =
        (endDate != null) ? DateFormat('dd-MM-yyyy').format(endDate) : "-";

    eventDescList.add(EventDescModel(
        key: "STATUS",
        value: widget.item?.status,
        color: (widget.item?.status.toLowerCase() != "published")
            ? Colors.red
            : Colors.green,
        icon: MyIcons.icStatus));
    eventDescList.add(EventDescModel(
        key: "START",
        value: formattedStartDate,
        color: Colors.black,
        icon: MyIcons.icStart));
    eventDescList.add(EventDescModel(
        key: "EXPIRY",
        value: formattedEndDate,
        color: Colors.black,
        icon: MyIcons.icTime));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border:
            Border.all(width: 0.5, color: MyApp.resources.color.borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailListingContainerScreen(
                      listingId: (widget.item?.id ?? 0).toString(),
                    )),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(children: [
                  Icon(Icons.diamond_outlined,
                      color: MyApp.resources.color.orange, size: 16),
                  const SizedBox(width: 4),
                  const Text(
                    "ASSOCIATED PLAN ",
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    widget.item?.associated_plan ?? "Basic",
                    style: TextStyle(
                        fontSize: 12,
                        color: MyApp.resources.color.orange,
                        fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: MyApp.resources.color.background,
                        border: Border.all(
                            width: 0.5,
                            color: MyApp.resources.color.borderColor)),
                    child: Row(children: [
                      SvgPicture.asset(
                        MyIcons.icOwn,
                        width: 16,
                        height: 16,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'upgrade',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w700),
                      )
                    ]),
                  )
                ]),
              ),
              const SizedBox(height: 12),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: MyListingImageContainer(
                    listing: widget.item,
                  )),
              const SizedBox(height: 12),
              Row(children: [
                const SizedBox(width: 16),
                Text(
                  widget.item?.title ?? "",
                  style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.star,
                  size: 16,
                  color: Colors.amber,
                ),
                const SizedBox(width: 4),
                Text(
                  (widget.item?.rating).toString(),
                  style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 16),
              ]),
              const SizedBox(height: 12),
              Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50.withOpacity(0.5),
                  border: Border.symmetric(
                    horizontal: BorderSide(
                        width: 0.5, color: MyApp.resources.color.borderColor),
                  ),
                ),
                child: Row(children: [
                  Flexible(
                    flex: 1,
                    child: EventDescItem(
                      eventDescModel: eventDescList[0],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: EventDescItem(
                      eventDescModel: eventDescList[1],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: EventDescItem(
                      eventDescModel: eventDescList[2],
                    ),
                  )
                ]),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const SizedBox(width: 16),
                  Flexible(
                    flex: 1,
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                              width: 0.5,
                              color: MyApp.resources.color.borderColor),
                          color: MyApp.resources.color.background
                              .withOpacity(0.7)),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {
                            widget.onRemoveClick?.call();
                          },
                          child: Center(
                            child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.delete_forever_outlined,
                                    size: 20,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    "Remove Listing",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  )
                                ]),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    flex: 1,
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                              width: 0.5,
                              color: MyApp.resources.color.borderColor),
                          color: MyApp.resources.color.orange),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () async {
                            bool? result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                ChooseTemplateScreen.listingToAdd =
                                    widget.item!;

                                return ListingScreen(
                                  create: false,
                                  listingToUpdate: widget.item!,
                                  categorieModel: widget.item?.category == null
                                      ? null
                                      : CategorieModel(
                                          id: widget.item!.category!.id,
                                          title: widget.item!.title),
                                );
                              }),
                            );

                            if (result == true) {
                              widget.onEditClick?.call();
                            }
                          },
                          child: Center(
                            child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.edit_outlined,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    "Edit Listing",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  )
                                ]),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
