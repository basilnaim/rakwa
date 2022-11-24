import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/views/progressing_button.dart';
import 'package:rakwa/res/fonts/fonts.dart';

class BottomButtons extends StatelessWidget {
  Function neutralButtonClick;
  String neutralButtonText;
  Function submitButtonClick;
  String submitButtonText;
  GlobalKey<ProgressingButtonState>? progressingButton;

  BottomButtons(
      {Key? key,
       this.progressingButton,
      required this.neutralButtonText,
      required this.submitButtonText,
      required this.neutralButtonClick,
      required this.submitButtonClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 56),
                elevation: 1,
                shadowColor: MyApp.resources.color.grey1,
                primary: MyApp.resources.color.grey1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    side: BorderSide(
                        color: MyApp.resources.color.grey1, width: 0.8))),
            onPressed: () {
                print('ttttt');
              
              neutralButtonClick();
            },

            child: Text(neutralButtonText , style: Theme.of(context).textTheme.button?.copyWith(fontWeight: FontFamily.regular.fontWeight(),color: MyApp.resources.color.black2 ),),
          ),
        ),
        SizedBox(width: 16),
        Flexible(
          flex: 1,
          child: ProgressingButton(
            key: progressingButton,
            buttonText: submitButtonText,
              onSubmitForm: ()=> submitButtonClick(),
              color: MyApp.resources.color.orange),
        )
      ],
    );
  }
}
