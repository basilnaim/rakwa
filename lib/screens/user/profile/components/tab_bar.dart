import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';

class MyTabBar extends StatefulWidget {
  Function(int position) onTabChanged;

  MyTabBar({
    Key? key,
    required this.onTabChanged,
  }) : super(key: key);
  @override
  _MyTabBarState createState() => _MyTabBarState();
}

class _MyTabBarState extends State<MyTabBar> {
  Color selectedColor = MyApp.resources.color.orange;
  Color unselectedColor = MyApp.resources.color.blue2;

  Color selectedTextColor = Colors.black;
  Color unSelectedTextColor = MyApp.resources.color.blue2;

  Color splashColor = MyApp.resources.color.orange;

  int selectedPosition = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          createTab(
            context,
            0,
            "المعلومات الأساسية",
          ),
          SizedBox(
            width: 12,
          ),
          createTab(
            context,
            1,
            "العنوان",
          ),
          SizedBox(
            width: 12,
          ),
          createTab(
            context,
            2,
            "كلمة المرور",
          ),
        ],
      ),
    );
  }

  Widget createTab(context, position, title) {
    return Expanded(
      child: Material(
        child: InkWell(
          onTap: () {
            selectedPosition = position;
            widget.onTabChanged(position);
            setState(() {});
          },
          borderRadius: BorderRadius.all(Radius.circular(20)),
          splashColor: splashColor,
          child: SizedBox(
            height: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.subtitle2?.copyWith(
                      fontSize: 12,
                      color: (position == selectedPosition)
                          ? selectedTextColor
                          : unSelectedTextColor),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 2,
                  color: (position == selectedPosition)
                      ? selectedColor
                      : unselectedColor,
                  width: 100,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
