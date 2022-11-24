import 'package:flutter/material.dart';
import 'package:rakwa/model/sumitted_reviews_model.dart';
import 'package:rakwa/screens/my_reviews/Components/submitted_reviews.dart';
import 'package:rakwa/views/empty_content.dart';
import 'package:rakwa/views/my_customScroll_behavior.dart';

class ReceivedReviews extends StatefulWidget {
  const ReceivedReviews({Key? key, this.list}) : super(key: key);
  final List<SubmittedReviewsModel>? list;

  @override
  State<ReceivedReviews> createState() => _ReceivedReviewsState();
}

class _ReceivedReviewsState extends State<ReceivedReviews> {
  @override
  Widget build(BuildContext context) {
    return (widget.list != null && widget.list!.isNotEmpty)
        ? Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ScrollConfiguration(
                behavior: MyCustomScrollBehavior(),
                child: ListView.builder(
                  cacheExtent: 20,
                  shrinkWrap: true,
                  itemCount: widget.list?.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, i) {
                    return SubmittedReviewItem(
                      review: widget.list?[i],
                    );
                  },
                ),
              ),
            ),
          )
        : Padding(
          padding: const EdgeInsets.only(top:24),
          child: Align(
                  alignment: Alignment.center,
                  child: EmpyContentScreen(
                    title: "Received Reviews",
                    description: "",
                  ),
            ),
        );
  }
}
