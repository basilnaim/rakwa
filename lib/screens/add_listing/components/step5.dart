import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/listing/contact.dart';
import 'package:rakwa/views/bottom_btns.dart';
import 'package:rakwa/views/text_field/my_text_field.dart';
import 'package:rakwa/views/text_field/my_text_field_normal.dart';
import '../listing_screen.dart';

class AddListingStep5 extends StatefulWidget {
  ListingContact listingContact;
  AddListingStep5({Key? key, required this.listingContact}) : super(key: key);

  @override
  State<AddListingStep5> createState() => _AddListingStep5State();
}

class _AddListingStep5State extends State<AddListingStep5> {
  final GlobalKey<FormFieldState> _phoneFieldForm = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _urlFieldForm = GlobalKey<FormFieldState>();

  final Map<SocialMedia, GlobalKey<FormFieldState>> _socialMediaFielsForm = {};
  onNexClick() {
    if (!checkFields([_phoneFieldForm, _urlFieldForm])) {
      return;
    }

    try {
      for (var element in _socialMediaFielsForm.values) {

        element.currentState?.save();
      }
     
    } catch (e) {
      //
    }
  ListingScreenState.bottomTabNavigation.moveToNext();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 80,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyNormalTextField(
                      isRequired: true,
                      initial: widget.listingContact.phone,
                      textInputType: TextInputType.phone,
                      formFieldeKey: _phoneFieldForm,
                      hint: "Phone",
                      onSave: (String? text) {
                        if (text != null) {
                          widget.listingContact.phone = text;
                        }
                      },
                      textInputAction: TextInputAction.next),
                  SizedBox(
                    height: 8,
                  ),
                  MyNormalTextField(
                      initial: widget.listingContact.website,
                      textInputType: TextInputType.url,
                      formFieldeKey: _urlFieldForm,
                      hint: "Web-site url",
                      onSave: (String? text) {
                        if (text != null) {
                          widget.listingContact.website = text;
                        }
                      },
                      textInputAction: TextInputAction.next),
                  SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Social media",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          ?.copyWith(fontSize: 14, color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 16),
                  Column(
                      children: SocialMedia.values.map((SocialMedia e) {
                    _socialMediaFielsForm.putIfAbsent(
                        e, () => GlobalKey<FormFieldState>());
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: MyTextField(
                          hint: e.label(),
                          prefixWidget: Image.asset(
                            e.icon(),
                            width: 36,
                            height: 36,
                          ),
                          texthint: "paste the link ",
                          initial: widget.listingContact.socialMedia[e] ?? '',
                          textInputType: TextInputType.url,
                          textInputAction: TextInputAction.go,
                          formFieldeKey: _socialMediaFielsForm[e]!,
                          onSave: (String? link) {
                            if (link != null) {
                              widget.listingContact.socialMedia
                                  .addAll({e: link});
                            }
                          }),
                    );
                  }).toList()),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 40, right: 40, top: 16, bottom: 16),
            //  width: double.infinity

            child: BottomButtons(
                neutralButtonText: "Previous",
                submitButtonText: "Next",
                neutralButtonClick: () {
                  Navigator.maybePop(context);
                },
                submitButtonClick: () => onNexClick()),
          ),
        ),
      ],
    );
  }

  Widget dropDownContainer(title, String icon, Widget? dropdownButton) {
    return Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          border: Border.all(
            color: MyApp.resources.color.borderColor,
            width: 0.8,
          ),
        ),
        padding: EdgeInsets.only(left: 26, right: 26),
        child: Row(children: [
          SvgPicture.asset(icon),
          SizedBox(
            width: 20,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(color: MyApp.resources.color.darkColor),
              ),
              SizedBox(
                width: 8,
              ),
              SizedBox(
                  width: double.infinity,
                  height: 30,
                  child: dropdownButton ??
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Loading...",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                ?.copyWith(color: MyApp.resources.color.black3),
                          )))
            ],
          ))
        ]));
  }
}
