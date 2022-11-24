import 'package:flutter/material.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/screens/home/home.dart';
import 'package:rakwa/views/no_connection_view.dart';

class ConnectionDialog extends StatefulWidget {
  ConnectionDialog({
    this.context,
    this.title,
    this.desc,
    this.btnText,
  });
  final BuildContext? context;
  final String? title;
  final String? desc;
  final String? btnText;

  @override
  State<ConnectionDialog> createState() => _ConnectionDialogState();
}

class _ConnectionDialogState extends State<ConnectionDialog> {
  bool progressing = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return connectionDialog(
        widget.context!, widget.title!, widget.desc!, widget.btnText!);
  }

  Dialog connectionDialog(
          BuildContext context, String title, String desc, String btnText) =>
      Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0)), //this right here
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 200.0,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(color: MyApp.resources.color.black2),
              ),
              Text(
                desc,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: MyApp.resources.color.black4,
                    fontWeight: FontWeight.w400,
                    fontSize: 14),
              ),
              (!progressing)
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 56),
                          elevation: 1,
                          shadowColor: MyApp.resources.color.orange,
                          primary: MyApp.resources.color.orange,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              side: BorderSide(
                                  color: MyApp.resources.color.orange,
                                  width: 0.8))),
                      onPressed: () async {
                        setState(() {
                          progressing = true;
                        });
                        if (await hasNetwork()) {
                          Navigator.pop(context);
                        } else {
                          Future.delayed(const Duration(milliseconds: 2000),
                              () {
                            setState(() {
                              progressing = false;
                            });
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const NoConnectionView()),
                            );
                          });
                        }
                      },
                      child: Text(
                        btnText,
                        style: Theme.of(context)
                            .textTheme
                            .button
                            ?.copyWith(color: Colors.white),
                      ),
                    )
                  : MyProgressIndicator(color: MyApp.resources.color.orange)
            ],
          ),
        ),
      );
}
