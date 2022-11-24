// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/contact_message.dart';
import 'package:rakwa/model/user.dart';
import 'package:rakwa/views/progressing_button.dart';
import 'package:rakwa/views/text_field/my_text_field_none.dart';

class SendMessage extends StatelessWidget {
  String roomId;
  User otherUser;
  GlobalKey<ProgressingButtonState> progressingButtonState = GlobalKey();
  SendMessage({Key? key, required this.roomId, required this.otherUser})
      : super(key: key);

  final GlobalKey<FormFieldState> _messageFieldForm =
      GlobalKey<FormFieldState>();
  String message = "";

  sendMessage() {
    if (!checkFields([_messageFieldForm])) {
      return;
    }

    progressingButtonState.currentState?.showProgress(true);
    _messageFieldForm.currentState?.didChange("");

    MyApp.fireRepo
        .sendMessage(
            ContactMessage(
                content: message,
                created: DateTime.now(),
                recipientName: otherUser.firstname,
                recipientID: otherUser.id,
                recipientProfilePictureURL: otherUser.image,
                senderProfilePictureURL: MyApp.userConnected?.image ?? "",
                senderName:
                    "${MyApp.userConnected?.firstname ?? ""} ${MyApp.userConnected?.lastname ?? ""}",
                senderID: MyApp.userConnected?.id ?? 0,
                id: ''),
            roomId)
        .then((value) =>
            progressingButtonState.currentState?.showProgress(false));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.only(left: 24, right: 24, top: 10, bottom: 10),
      child: TextFieldNone(
          textInputType: TextInputType.multiline,
          formFieldeKey: _messageFieldForm,
          suffixWidget: buttonSendMessage(context),
          maxLines: 5,
          hint: "Type something...",
          validator: (String? value) {
            if (value?.isEmpty ?? false) {
              return MyApp.resources.strings.mandatoryField;
            }
            return null;
          },
          onSave: (String? text) {
            if (text != null) {
              message = text;
            }
          },
          textInputAction: TextInputAction.newline),
    );
  }

  Widget buttonSendMessage(context) {
    return SizedBox(
      width: 80,
      height: 40,
      child: ProgressingButton(
        buttonText: 'Send',
        color: MyApp.resources.color.orange,
        onSubmitForm: () {
          sendMessage();
        },
        key: progressingButtonState,
        suffix: Icon(
          Icons.navigate_next,
          color: Colors.white,
          size: 20,
        ),
        textStyle: Theme.of(context)
            .textTheme
            .subtitle2
            ?.copyWith(fontSize: 12, color: Colors.white),
      ),
    );
  }
}
