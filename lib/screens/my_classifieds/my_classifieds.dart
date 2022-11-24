import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/classfield_to_ws.dart';
import 'package:rakwa/model/classified.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/screens/add_classified/add_classified.dart';
import 'package:rakwa/screens/home/home.dart';
import 'package:rakwa/screens/my_classifieds/Components/my_classified_item.dart';
import 'package:rakwa/views/empty_content.dart';
import 'package:rakwa/views/header_back_btn.dart';
import 'package:rakwa/views/not_registred.dart';

import 'Components/header.dart';

class MyClassifieds extends StatefulWidget {
  const MyClassifieds({Key? key}) : super(key: key);

  @override
  State<MyClassifieds> createState() => _MyClassifiedsState();
}

class _MyClassifiedsState extends State<MyClassifieds> {
  List<Classified>? list;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (MyApp.isConnected) _fetchClassified();
  }

  _fetchClassified() {
    MyApp.classifiedRepo
        .myClassified()
        .then((WebServiceResult<List<Classified>> value) {
      setState(() {
        isLoading = false;
      });
      switch (value.status) {
        case WebServiceResultStatus.success:
          print(value.data!);
          setState(() {
            list = value.data!;
          });
          break;
        case WebServiceResultStatus.error:
          mySnackBar(context,
              title: 'fetch classified failed',
              message: value.message,
              status: SnackBarStatus.error);

          break;
        case WebServiceResultStatus.loading:
          break;
        case WebServiceResultStatus.unauthorized:
          break;
      }
    });
  }

  _deleteClassified(String classifiedId) {
    print('delete my classified data started');
    setState(() {
      isLoading = true;
    });

    MyApp.classifiedRepo
        .deleteClassified(classifiedId)
        .then((WebServiceResult<String> value) {
      setState(() {
        list?.removeWhere((e) => e.id.toString() == classifiedId);
        isLoading = false;
      });

      switch (value.status) {
        case WebServiceResultStatus.success:
          print(value.data!);

          mySnackBar(context,
              title: 'Remove classified',
              message: "Classified removed successfully",
              status: SnackBarStatus.success);
          _fetchClassified();
          break;
        case WebServiceResultStatus.error:
          mySnackBar(context,
              title: 'delete classified failed',
              message: value.message,
              status: SnackBarStatus.error);

          break;
        case WebServiceResultStatus.loading:
          break;
        case WebServiceResultStatus.unauthorized:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyApp.resources.color.background,
      body: SafeArea(
        child: !MyApp.isConnected
            ? Column(
                children: [
                  const SizedBox(
                    height: 64,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: HeaderWithBackScren(
                      title: 'My Classified',
                    ),
                  ),
                  Flexible(
                      child: Align(
                          alignment: Alignment.center,
                          child: RequireRegistreScreen(
                            postFunction: () {
                              if (MyApp.isConnected) _fetchClassified();
                            },
                          ))),
                ],
              )
            : ((isLoading)
                ? MyProgressIndicator(
                    color: MyApp.resources.color.orange,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        const Header(),
                        const SizedBox(height: 8),
                        (list != null && list!.isNotEmpty)
                            ? Expanded(
                                child: ListView.builder(
                                  itemBuilder: (_, index) {
                                    return MyClassifiedItem(
                                        onRefresh: () {
                                          _fetchClassified();
                                        },
                                        item: list?[index],
                                        onDelete: () {
                                          _deleteClassified(
                                              list?[index].id.toString() ??
                                                  "0");
                                        });
                                  },
                                  itemCount: list?.length,
                                  shrinkWrap: true,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  scrollDirection: Axis.vertical,
                                ),
                              )
                            : Expanded(
                                child: Align(
                                    alignment: Alignment.center,
                                    child: EmpyContentScreen(
                                      title: "Classifieds",
                                      description:
                                          "Click the button below to add the first classified",
                                    )),
                              ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration:
                              BoxDecoration(color: Colors.white, boxShadow: [
                            BoxShadow(
                                blurRadius: 5,
                                spreadRadius: 5,
                                offset: Offset(
                                  0.0, // Move to right 10  horizontally
                                  -6.0, // Move to bottom 10 Vertically
                                ),
                                color: Colors.black.withOpacity(0.2))
                          ]),
                          padding: const EdgeInsets.symmetric(
                              vertical: 18, horizontal: 16),
                          child: ElevatedButton(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddClassified(
                                          classified: ClassifiedToWs(),
                                        )),
                              );
                              _fetchClassified();
                            },
                            child: const Text(
                              'إنشاء إعلان مبوب',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize:
                                  Size(MediaQuery.of(context).size.width, 55),
                              primary: MyApp.resources.color.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12), // <-- Radius
                              ),
                            ),
                          ),
                        ),
                      ])),
      ),
    );
  }
}
