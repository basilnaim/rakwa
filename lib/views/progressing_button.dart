import 'package:flutter/material.dart';

import 'package:rakwa/main.dart';
import 'package:rakwa/res/fonts/fonts.dart';

class ProgressingButton extends StatefulWidget {
  Function onSubmitForm;
  Color color;
  Color textColor;
  String buttonText;
  TextStyle? textStyle;
  Widget? suffix; 

  ProgressingButton({
    Key? key,
    this.textColor = Colors.white,
    required this.buttonText,
    required this.onSubmitForm,
    required this.color,
    this.textStyle,
    this.suffix
  }) : super(key: key);
  @override
  ProgressingButtonState createState() => ProgressingButtonState();
}

class ProgressingButtonState extends State<ProgressingButton> {
  var progressing = false;

  showProgress(bool progress) {
    setState(() {
      progressing = progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.textStyle ??Theme.of(context).textTheme.button?.copyWith(fontWeight: FontFamily.regular.fontWeight(),color: widget.textColor);
    return Container(
      child: !progressing
          ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 56),
                  elevation: 1,
                  shadowColor: widget.color,
                  primary: widget.color,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      side: BorderSide(color: widget.color))),
              onPressed: () {
                widget.onSubmitForm();
              },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.buttonText , style: style,),
                if(widget.suffix != null )Flexible(child: widget.suffix!)
              ],
            ),
            )
          : Center(
            child: SizedBox(
              width : 38,
              height: 38,
              child: CircularProgressIndicator(
                 
                  backgroundColor: MyApp.resources.color.colorBackground,
                  color: widget.color,
                  strokeWidth: 3,
                ),
            ),
          ),
    );
  }
}
