import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/review.dart';
import 'package:rakwa/res/images/MyImages.dart';

class ReviewItem extends StatelessWidget {
  const ReviewItem({Key? key, this.review, this.editReview, this.deleteReview}) : super(key: key);
  final Review? review;

  final VoidCallback? editReview;
  final VoidCallback? deleteReview;

  _showPopupMenu(BuildContext context, TapDownDetails details) {
    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        details.globalPosition.dx,
        details.globalPosition.dy,
        details.globalPosition.dx,
        details.globalPosition.dy,
      ), //position where you want to show the menu on screen
      items: [
        const PopupMenuItem<String>(child: Text('Edit'), value: '1'),
        const PopupMenuItem<String>(child: Text('Delete'), value: '2'),
      ],
      elevation: 8.0,
    ).then((value) {
      if(value == "1"){
          editReview?.call();
      }
      if(value == "2"){
        deleteReview?.call();
      }
      print("selecteddddd $value");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      decoration: BoxDecoration(
          border:
              Border.all(width: 0.5, color: MyApp.resources.color.borderColor),
          color: Colors.white,
          borderRadius: BorderRadius.circular(12)),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                (review?.user_pic != null)
                    ? CircleAvatar(
                        radius: 24.0,
                        backgroundImage: NetworkImage(review!.user_pic!),
                        backgroundColor: Colors.transparent,
                      )
                    : const Icon(
                        Icons.account_circle_rounded,
                        size: 54,
                        color: Colors.black,
                      ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          review?.user_name ?? "",
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        RatingBarIndicator(
                          rating: (review?.rating ?? 0.0).toDouble(),
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 18.0,
                          unratedColor: Colors.grey.shade100,
                          direction: Axis.horizontal,
                        ),
                      ]),
                ),
                Visibility(
                  visible: (MyApp.userConnected?.id == review?.user_id)? true: false,
                  child: GestureDetector(
                    onTapDown: (details) => _showPopupMenu(context, details),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                          color: MyApp.resources.color.background,
                          border: Border.all(
                              width: 0.5,
                              color: MyApp.resources.color.borderColor),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(13))),
                      child: Center(
                        child: Image.asset(MyImages.dots, height: 16, width: 16),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 12),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 1,
              color: MyApp.resources.color.borderColor,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                review?.comment ?? "",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w400),
              ),
            )
          ]),
    );
  }
}
