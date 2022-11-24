import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/res/images/MyImages.dart';
import 'package:rakwa/screens/filter/filter.dart';
import 'package:rakwa/views/search_container.dart';

class HeaderCollapsed extends StatelessWidget {
  const HeaderCollapsed(
      {Key? key,
      this.isNotHome = false,
      this.headerTitre = "",
      this.onDrawerClick,
      this.hint,
      this.searchedValue = "",
      this.onSearchClick})
      : super(key: key);

  final bool isNotHome;
  final String headerTitre;
  final String? hint;
  final String? searchedValue;
  final VoidCallback? onDrawerClick;
  final Function(String)? onSearchClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      color: (!isNotHome) ? Colors.white : MyApp.resources.color.background,
      child: Stack(children: [
        Column(children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 41.0,
            ),
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              //drawer button
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    border: Border.all(
                        width: 0.5, color: MyApp.resources.color.borderColor),
                    color: Colors.white),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    onTap: () {
                      (isNotHome)
                          ? Navigator.pop(context)
                          : onDrawerClick!.call();
                    },
                    child: Center(
                      child: Icon(
                        (!isNotHome) ? Icons.menu : Icons.arrow_back_ios_new,
                        color: MyApp.resources.color.iconColor,
                        size: (isNotHome) ? 22 : 26,
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              // header center text
              (!isNotHome)
                  ? Image.asset(
                      MyImages.rakwaLogo,
                      color: Colors.black,
                    )
                  : Text(headerTitre,
                      style: TextStyle(
                          color: MyApp.resources.color.iconColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
              const Spacer(),
              //filter button
              (!isNotHome)
                  ? Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          border: Border.all(
                              width: 0.5,
                              color: MyApp.resources.color.borderColor),
                          color: Colors.white),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            onTap: () {
                              if (!isNotHome) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Filter()),
                                );
                              }
                            },
                            child: Center(
                              child: SvgPicture.asset(
                                (!isNotHome)
                                    ? 'lib/res/icons/ic_filter.svg'
                                    : MyIcons.icNotif,
                                //MyIcons.filter,
                                width: 22,
                                height: 22,
                              ),
                            )),
                      ),
                    )
                  : Container(
                      height: 42,
                      width: 42,
                    )
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(
                bottom: 16, left: 0.0, right: 0.0, top: 16),
            child: SearchContainer(
              isCollapsed: (isNotHome) ? false : true,
              isHome: (isNotHome) ? false : true,
              hint: (hint == null) ? "Search for listing" : hint ?? "",
              onSubmitQuery: (query) => onSearchClick!(query),
              textController: TextEditingController(text: searchedValue),
            ),
          )
        ]),
        /* Visibility(
          visible: isNotHome,
          child: Positioned(
            right: 11,
            top: 36,
            child: Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orange.shade700.withOpacity(0.7)),
              child: const Center(
                  child: Text(
                '5',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              )),
            ),
          ),
        ),*/
      ]),
    );
  }
}
