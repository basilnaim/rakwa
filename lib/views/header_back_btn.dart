import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/res/icons/my_icons.dart';

class HeaderWithBackScren extends StatelessWidget {
  bool backEnabled = true;
  bool menuEnabled = true;

  Function? onClick;
  HeaderWithBackScren(
      {Key? key,
      required this.title,
      this.backEnabled = true,
      this.menuEnabled = false,
      this.onClick})
      : super(key: key);

  String title;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: 48,
        margin: const EdgeInsets.only(top: 16),
        child: Stack(
          children: [
            Visibility(
              visible: backEnabled || menuEnabled,
              child: Container(
                width: 42,
                height: 42,
                child: Material(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    color: Colors.transparent,
                    child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          if (onClick == null)
                            Navigator.pop(context);
                          else {
                            onClick!();
                          }
                        },
                        //splashColor: MyApp.resources.color.orange,
                        child: Center(
                            child: (backEnabled)
                                ? SvgPicture.asset(
                                    MyIcons.icBack,
                                    color: MyApp.resources.color.darkColor,
                                    width: 16,
                                    height: 16,
                                  )
                                : const Icon(Icons.menu)))),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                  border: Border.all(
                    color: MyApp.resources.color.borderColor,
                    width: 0.5,
                  ),
                ),
              ),
            ),
            Center(
              child: Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(color: MyApp.resources.color.darkColor)),
            )
          ],
        ),
      ),
    );
  }
}
