import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/views/my_radio_list_tale.dart';

class ShowContainer extends StatefulWidget {
  const ShowContainer({Key? key}) : super(key: key);

  static int isOpen = 0;
  @override
  _ShowContainerState createState() => _ShowContainerState();
}

class _ShowContainerState extends State<ShowContainer> {
  bool _checkValue = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        border:
            Border.all(width: 0.5, color: MyApp.resources.color.borderColor),
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(children: [
        Expanded(
          flex: 1,
          child: MyRadioListTile<int>(
            value: _checkValue,
            groupValue: 0,
            leading: Icons.done,
            title: Text(
              'Open Now',
              style: TextStyle(
                  color: (_checkValue) ? Colors.black : Colors.grey,
                  fontSize: 14,
                  fontWeight:
                      (_checkValue) ? FontWeight.w600 : FontWeight.normal),
            ),
            onChanged: (value) => setState(() {
              _checkValue = value!;
              if (value) {
                ShowContainer.isOpen = 1;
              } else {
                ShowContainer.isOpen = 0;
              }
            }),
          ),
        ),
      ]),
    );
  }
}
