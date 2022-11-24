import 'package:flutter/material.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/screens/add_listing/listing_detail/Components/tick_container.dart';

class DescContainer extends StatefulWidget {
  const DescContainer({Key? key, this.desc, this.amenities}) : super(key: key);
  final String? desc;
  final List<String>? amenities;

  @override
  State<DescContainer> createState() => _DescContainerState();
}

class _DescContainerState extends State<DescContainer> {
  List<String>? amenity = [];
  @override
  void initState() {
    widget.amenities?.forEach((element) {
      if (element.isNotEmpty) {
        amenity?.add(element);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          border:
              Border.all(width: 0.5, color: MyApp.resources.color.borderColor),
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(12))),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                child: Text(
                  HtmlParser.parseHTML(widget.desc ?? '').text,
                  //  widget.desc ?? "",
                  style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (amenity!.isNotEmpty)
              Container(
                width: MediaQuery.of(context).size.width,
                height: 1,
                color: MyApp.resources.color.borderColor,
              ),
            if (amenity!.isNotEmpty)
              Flexible(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12))),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      primary: false,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: amenity?.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 1,
                          crossAxisSpacing: 2,
                          childAspectRatio: (amenity!.length > 2)
                              ? 2.5
                              : (amenity!.length == 2)
                                  ? 6
                                  : 9,
                          crossAxisCount: (amenity!.length > 2)
                              ? 3
                              : (amenity!.length == 2)
                                  ? 2
                                  : 1),
                      itemBuilder: (_, int index) {
                        return TickItem(name: amenity?[index]);
                      },
                    ),
                  ),
                ),
              )
          ]),
    );
  }
}

class DescItem extends StatelessWidget {
  const DescItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(children: [
        Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                  width: 0.5, color: MyApp.resources.color.borderColor)),
          child: const Center(
            child: Icon(
              Icons.cake_outlined,
              size: 24,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Column(mainAxisSize: MainAxisSize.min, children: const [
            Text(
              "Pay through",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                  fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 8),
            Text(
              "Credit cards",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 11,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
          ]),
        ),
      ]),
    );
  }
}
