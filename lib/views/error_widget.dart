import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:rakwa/main.dart';
import 'package:rakwa/model/error.dart';
import 'package:rakwa/res/fonts/fonts.dart';
import 'package:rakwa/res/icons/my_icons.dart';

class MyErrorWidget extends StatelessWidget {
  final ErrorModel errorModel;
  
  const MyErrorWidget({
    Key? key,
    required this.errorModel,
   
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(MyIcons.icNotFound),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              errorModel.text,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: MyApp.resources.color.black1),
            ),
          ),
          const SizedBox(height: 26),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(150, 56),
                elevation: 1,
                shadowColor: MyApp.resources.color.orange,
                primary: MyApp.resources.color.orange,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    side: BorderSide(
                        color: MyApp.resources.color.grey1, width: 0.8))),
            onPressed: () => errorModel.btnClickListener(),
            child: Text(
             errorModel.btnText,
              style: Theme.of(context).textTheme.button?.copyWith(
                  fontWeight: FontFamily.regular.fontWeight(),
                  color: Colors.white),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
