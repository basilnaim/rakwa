import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/res/icons/my_icons.dart';

class EmpyContentScreen extends StatelessWidget {
  String title;
  String description;
  EmpyContentScreen({Key? key, required this.title, this.description = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(MyIcons.icError),
          SizedBox(
            height: 24,
          ),
          Align(
            alignment: Alignment.center,
            child: RichText(
              text: TextSpan(
                text: 'you do not have any ',
                style: Theme.of(context).textTheme.bodyText1,
                children: <TextSpan>[
                  TextSpan(
                      text: title,
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: MyApp.resources.color.orange,
                          )),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText2?.copyWith(
                color: MyApp.resources.color.colorText.withOpacity(0.6)),
          )
        ],
      ),
    );
  }
}
