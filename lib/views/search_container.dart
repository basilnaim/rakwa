import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/screens/filter/filter.dart';

class SearchContainer extends StatelessWidget {
  SearchContainer(
      {Key? key,
      this.isCollapsed = false,
      this.isHome = false,
      this.isDetail = false,
      this.onSubmitQuery,
      this.hint = 'Search for listing',
      this.textController,
      this.onChanged,
      this.height = 48})
      : super(key: key);
  final bool isCollapsed;
  final bool isHome;
  final bool isDetail;
  final double height;
  final String hint;
  Function(String query)? onSubmitQuery;
  Function(String query)? onChanged;

  TextEditingController? textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border:
            Border.all(width: 0.5, color: MyApp.resources.color.borderColor),
        color: (isCollapsed)
            ? MyApp.resources.color.background
            : (isHome)
                ? (isDetail)
                    ? Colors.white
                    : MyApp.resources.color.background
                : Colors.white,
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        //search icon button
        SizedBox(
          height: height,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16)),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Icon(
                  Icons.search,
                  color: MyApp.resources.color.darkIconColor,
                ),
              ),
            ),
          ),
        ),
        // divider
        Container(
            height: height,
            width: 1,
            color: MyApp.resources.color.dividerColor),
        //search textfield
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: TextField(
              textInputAction: TextInputAction.search,
              onSubmitted: (val) {
                if(val.isNotEmpty) onSubmitQuery?.call(val);
              },
              onChanged: (value) => onChanged?.call(value),
              controller: textController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle: TextStyle(
                      color: MyApp.resources.color.hintColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
            ),
          ),
        ),
        // divider
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Container(
              height: height,
              width: 1,
              color: MyApp.resources.color.dividerColor),
        ),
        // filter button
        Visibility(
          visible: (isHome) ? false : true,
          child: SizedBox(
            height: height,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Filter()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 14, right: 14),
                    child: Center(
                      child: SvgPicture.asset(
                        'lib/res/icons/ic_filter.svg',
                        height: 20,
                        width: 20,
                      ),
                    ),
                  )),
            ),
          ),
        ),
        Visibility(
          visible: (isHome) ? false : true,
          child: Container(
              height: height,
              width: 1,
              color: MyApp.resources.color.dividerColor),
        ),
        // serach text button
        SizedBox(
          height: height,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16)),
              onTap: () {
                print("rrrrr  ${textController?.text}");
                if((textController?.text ?? "").isNotEmpty) onSubmitQuery?.call(textController?.text ?? "");
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Center(
                  child: Text(
                    MyApp.resources.strings.search,
                    style: TextStyle(
                        fontSize: 12,
                        color: MyApp.resources.color.darkGrey,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
