import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/res/fonts/fonts.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/screens/home/home.dart';
import 'package:rakwa/screens/home_container/home_container_screen.dart';

class NoConnectionView extends StatefulWidget {
  const NoConnectionView({Key? key}) : super(key: key);

  @override
  State<NoConnectionView> createState() => _NoConnectionViewState();
}

class _NoConnectionViewState extends State<NoConnectionView> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyApp.resources.color.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(MyIcons.icNotFound),
            const SizedBox(height: 32),
            Text(
              "Oups, Something went wrong",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: MyApp.resources.color.black1),
            ),
            const SizedBox(height: 16),
            const Text(
              "It seems your internet connection is lost!",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 26),
            (!isLoading)
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(150, 56),
                        elevation: 1,
                        shadowColor: MyApp.resources.color.orange,
                        primary: MyApp.resources.color.orange,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            side: BorderSide(
                                color: MyApp.resources.color.grey1,
                                width: 0.8))),
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      Future.delayed(
                        const Duration(milliseconds: 2000),
                        () async {
                          if (await hasNetwork()) {
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const HomeContainerScreen()),
                            );
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                      );
                    },
                    child: Text(
                      "Try Again",
                      style: Theme.of(context).textTheme.button?.copyWith(
                          fontWeight: FontFamily.regular.fontWeight(),
                          color: Colors.white),
                    ),
                  )
                : MyProgressIndicator(color: MyApp.resources.color.orange),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
