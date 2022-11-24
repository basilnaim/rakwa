import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';

class HeaderFilter extends StatelessWidget {
   HeaderFilter({Key? key, this.titre}) : super(key: key);
  String? titre;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 25),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          //drawer button
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                border: Border.all(
                    width: 1, color: MyApp.resources.color.borderColor),
                color: Colors.white),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                onTap: () {
                  Navigator.pop(context);
                },
                child: Center(
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: MyApp.resources.color.iconColor,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
          Spacer(),
          // header center text
          Text(titre??"",
              style: TextStyle(
                  color: MyApp.resources.color.iconColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          Spacer(),
          //filter button
          Container(
            height: 42,
            width: 42,
          )
        ]),
      ),
    );
  }
}
