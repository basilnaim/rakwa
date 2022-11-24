import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';

Dialog defaultDialog(
 BuildContext context, String title,String desc , String btnText , Function btnClick
) => Dialog(

  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
  child: Container(
    width: 340.0,
    height: 200.0,
    padding: EdgeInsets.all(18),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(title,style: Theme.of(context).textTheme.bodyText1?.copyWith(color: MyApp.resources.color.black2),),
        Text(desc,textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline4?.copyWith(color: MyApp.resources.color.black4),),
         ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 56),
                elevation: 1,
                shadowColor: MyApp.resources.color.orange,
                primary: MyApp.resources.color.orange,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    side: BorderSide(
                        color: MyApp.resources.color.orange, width: 0.8))),
            onPressed: () {
              btnClick();
            },

            child: Text(btnText , style: Theme.of(context).textTheme.button?.copyWith(color: Colors.white ),),
          )
      ],
    ),
  ),
);
