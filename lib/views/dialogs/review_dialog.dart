import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/views/bottom_btns.dart';
import 'package:rakwa/views/progressing_button.dart';

class ReviewDialog extends StatefulWidget {
  ReviewDialog(
      {Key? key,
      this.submit,
      this.progressingButton,
      this.isEdit = false,
      this.comment,
      this.oldRating})
      : super(key: key);
  final Function? submit;
  final bool isEdit;
  final String? comment;
  final int? oldRating;
  final GlobalKey<ProgressingButtonState>? progressingButton;

  @override
  State<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  final TextEditingController _controller = TextEditingController();

  int rate = 0;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      _controller.text = widget.comment!;
      rate = widget.oldRating!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: Colors.white,
        ),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Submit Review',
                style: TextStyle(
                    color: MyApp.resources.color.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 0.5, color: MyApp.resources.color.borderColor),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    color: Colors.grey.shade50),
                child: Center(
                  child: RatingBar.builder(
                    initialRating:
                        (widget.isEdit) ? widget.oldRating!.toDouble() : 0,
                    glowColor: Colors.amber,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemSize: 35,
                    unratedColor: Colors.grey.shade200,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      rate = rating.toInt();
                      // RateContainer.rate = rating;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 180,
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    border: Border.all(
                        width: 0.5, color: MyApp.resources.color.borderColor)),
                child: TextField(
                  minLines: 5,
                  maxLines: 10,
                  controller: _controller,
                  style: TextStyle(
                      fontSize: 16,
                      color: MyApp.resources.color.textColor,
                      fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle:
                        TextStyle(color: Colors.grey.shade700, fontSize: 14),
                    hintText: "Write your review here",
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BottomButtons(
                    progressingButton: widget.progressingButton,
                    neutralButtonText: "Close",
                    submitButtonText: "Submit",
                    neutralButtonClick: () {
                      Navigator.of(context).pop();
                    },
                    submitButtonClick: () {
                      widget.submit!(_controller.text, rate);
                    }),
              )
            ]),
      ),
    );
  }
}
