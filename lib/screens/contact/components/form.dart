import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/contact.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/views/header_back_btn.dart';
import 'package:rakwa/views/progressing_button.dart';
import 'package:rakwa/views/text_field/email_text_field.dart';
import 'package:rakwa/views/text_field/my_text_field.dart';
import 'package:rakwa/views/text_field/required_text_field.dart';

class ContactFormScreen extends StatefulWidget {
  ContactFormScreen({Key? key}) : super(key: key);

  @override
  State<ContactFormScreen> createState() => ContactFormScreenState();
}

class ContactFormScreenState extends State<ContactFormScreen> {
  Contact contact = Contact();
  final GlobalKey<FormFieldState> _firstNameFieldState =
      GlobalKey<FormFieldState>();

  final GlobalKey<FormFieldState> _lastNameFieldState =
      GlobalKey<FormFieldState>();

  final GlobalKey<FormFieldState> _emailFieldState =
      GlobalKey<FormFieldState>();

  final GlobalKey<FormFieldState> _phoneFieldState =
      GlobalKey<FormFieldState>();

  final GlobalKey<FormFieldState> _msgFieldState = GlobalKey<FormFieldState>();
  GlobalKey<ProgressingButtonState> progressingKey = GlobalKey();

  Contact? submitForm() {
    return contact;
  }

  onSubmit(context) {
    if (!checkFields([
      _firstNameFieldState,
      _lastNameFieldState,
      _emailFieldState,
      _phoneFieldState,
      _msgFieldState,
    ])) {
      return null;
    }

    _firstNameFieldState.currentState?.didChange("");
    _lastNameFieldState.currentState?.didChange("");
    _msgFieldState.currentState?.didChange("");
    _phoneFieldState.currentState?.didChange("");
    _emailFieldState.currentState?.didChange("");
    progressingKey.currentState!.showProgress(true);
    MyApp.appRepo.contactUs(contact).then((value) {
      progressingKey.currentState!.showProgress(false);

      switch (value.status) {
        case WebServiceResultStatus.success:
          mySnackBar(context,
              title: 'Contact Us',
              message: 'Message sent successfully',
              status: SnackBarStatus.success);

          break;
        case WebServiceResultStatus.error:
          mySnackBar(context,
              title: 'Contact Us',
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
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 28.0, left: 16, right: 16),
          child: HeaderWithBackScren(title: "Contact Us"),
        ),
        Positioned(
          top: 120,
          left: 0,
          right: 0,
          bottom: 80,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RequiredTextField(
                      initial: MyApp.userConnected?.firstname ?? "",
                      prefixWidget: SvgPicture.asset(MyIcons.icPerson),
                      formFieldeKey: _firstNameFieldState,
                      hint: "الإسم الأول",
                      onSave: (String? firstname) {
                        if (firstname != null) {
                          contact.firstname = firstname;
                        }
                      },
                      textInputAction: TextInputAction.next),
                  SizedBox(height: 8),
                  RequiredTextField(
                      initial: MyApp.userConnected?.lastname ?? "",
                      prefixWidget: SvgPicture.asset(MyIcons.icPerson),
                      formFieldeKey: _lastNameFieldState,
                      hint: "Last Name",
                      onSave: (String? text) {
                        if (text != null) {
                          contact.lastname = text;
                        }
                      },
                      textInputAction: TextInputAction.next),
                  SizedBox(height: 8),
                  EmailTextField(
                    textInputAction: TextInputAction.next,
                    initialValue: MyApp.userConnected?.username ?? "",
                    formFieldeKey: _emailFieldState,
                    onSave: (String? email) {
                      if (email != null) {
                        contact.email = email;
                      }
                    },
                  ),
                  SizedBox(height: 8),
                  MyTextField(
                      initial: MyApp.userConnected?.phone ?? "",
                      textInputType: TextInputType.phone,
                      formFieldeKey: _phoneFieldState,
                      prefixWidget: Icon(Icons.phone_outlined),
                      hint: "Phone",
                      validator: (String? value) {
                        if (value?.isEmpty ?? false) {
                          return MyApp.resources.strings.mandatoryField;
                        }
                        return null;
                      },
                      onSave: (String? text) {
                        if (text != null) {
                          contact.phone = text;
                        }
                      },
                      textInputAction: TextInputAction.done),
                  SizedBox(height: 12),
                  MyTextField(
                      textInputType: TextInputType.multiline,
                      formFieldeKey: _msgFieldState,
                      hint: "Message",
                      minLines: 6,
                      maxLines: 12,
                      texthint: "describe your message ...",
                      onSave: (String? text) {
                        if (text != null) {
                          contact.message = text;
                        }
                      },
                      textInputAction: TextInputAction.newline),
                  SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white,
            height: 80,
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: ProgressingButton(
              key: progressingKey,
              buttonText: "Save",
              color: MyApp.resources.color.orange,
              onSubmitForm: () => onSubmit(context),
              textColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
