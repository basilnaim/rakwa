import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/generic_form.dart';
import 'package:rakwa/model/listing.dart';
import 'package:rakwa/model/template.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/screens/home/home.dart';
import 'package:rakwa/screens/add_listing/listing_screen.dart';
import 'package:rakwa/views/bottom_btns.dart';
import 'package:rakwa/views/header_back_btn.dart';
import 'package:rakwa/views/not_registred.dart';
import 'package:rakwa/views/progressing_button.dart';

class ChooseTemplateScreen extends StatefulWidget {
  ChooseTemplateScreen({Key? key}) : super(key: key);
  static Listing listingToAdd = Listing();

  @override
  State<ChooseTemplateScreen> createState() => _ChooseTemplateScreenState();
}

class _ChooseTemplateScreenState extends State<ChooseTemplateScreen> {
  List<Template> templates = [];
  bool isLoading = false;

  GlobalKey<ProgressingButtonState> progressingButton =
      GlobalKey<ProgressingButtonState>();

  @override
  void initState() {
    super.initState();
    ChooseTemplateScreen.listingToAdd = Listing.withHomeWork();
    _fetchTemplates();
  }

  _fetchTemplates() {
    print('fetch templates data started');
    setState(() {
      isLoading = true;
    });

    MyApp.homeRepo.templates().then((WebServiceResult<List<Template>> value) {
      setState(() {
        isLoading = false;
      });
      switch (value.status) {
        case WebServiceResultStatus.success:
          print(value.data!);
          setState(() {
            templates = value.data!;
          });
          break;
        case WebServiceResultStatus.error:
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'fetch templates failed',
                  desc: value.message,
                  btnOk: null,
                  btnCancel: null)
              .show();
          break;
        case WebServiceResultStatus.loading:
          break;
        case WebServiceResultStatus.unauthorized:
          break;
      }
    });
  }

  _loadForm() {
    progressingButton.currentState?.showProgress(true);
    MyApp.homeRepo
        .formGenerator(ChooseTemplateScreen.listingToAdd.templateId)
        .then((WebServiceResult<List<GenericForm>> value) {
      progressingButton.currentState?.showProgress(false);
      List<GenericForm> form = [];
      if (value.status == WebServiceResultStatus.success) {
        form.addAll(value.data ?? []);

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ListingScreen(
                    form: form,
                  )),
        );
      } else {
        AwesomeDialog(
                context: context,
                dialogType: DialogType.ERROR,
                animType: AnimType.BOTTOMSLIDE,
                title: 'Create Listing',
                desc: value.message,
                btnOk: null,
                btnCancel: null)
            .show();
      }
    });
  }

  selectedTemplate(Template template) {
    ChooseTemplateScreen.listingToAdd.templateId = template.id;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyApp.resources.color.background,
      body: SafeArea(
        child: !MyApp.isConnected
            ? Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: HeaderWithBackScren(
                      title: 'إضافة عمل',
                    ),
                  ),
                  Flexible(
                      child: Align(
                          alignment: Alignment.center,
                          child: RequireRegistreScreen(postFunction: () {
                            ChooseTemplateScreen.listingToAdd =
                                Listing.withHomeWork();
                            _fetchTemplates();
                          }))),
                ],
              )
            : (isLoading)
                ? MyProgressIndicator(
                    color: Colors.orange.shade700,
                  )
                : Stack(children: [
                    Positioned(
                      top: 20,
                      left: 0,
                      right: 0,
                      bottom: 80,
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16),
                            child: HeaderWithBackScren(
                                title: 'إضافة عمل', backEnabled: true),
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, bottom: 40),
                            itemCount: templates.where((e) => e.status).length,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 8.0,
                                    mainAxisSpacing: 8.0),
                            itemBuilder: (BuildContext context, int index) {
                              return templateWidget(templates
                                  .where((e) => e.status)
                                  .toList()[index]);
                            },
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 80,
                        color: Colors.white,
                        padding: EdgeInsets.only(
                            left: 40, right: 40, top: 16, bottom: 16),
                        //  width: double.infinity

                        child: BottomButtons(
                            progressingButton: progressingButton,
                            neutralButtonText: "Cancel",
                            submitButtonText: "Start",
                            neutralButtonClick: () {
                              Navigator.pop(context);
                            },
                            submitButtonClick: () => _loadForm()),
                      ),
                    ),
                  ]),
      ),
    );
  }

  Widget templateWidget(Template template) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(
            width: ChooseTemplateScreen.listingToAdd.templateId == template.id
                ? 2
                : 1,
            color: ChooseTemplateScreen.listingToAdd.templateId == template.id
                ? Colors.orange
                : MyApp.resources.color.borderColor),
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.orange,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          onTap: () => selectedTemplate(template),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                template.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: MyApp.resources.color.black4,
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
