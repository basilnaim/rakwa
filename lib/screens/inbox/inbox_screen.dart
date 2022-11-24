import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/screens/inbox/components/list.dart';
import 'package:rakwa/views/header_back_btn.dart';
import 'package:rakwa/views/not_registred.dart';

class InboxScreen extends StatefulWidget {
  InboxScreen({Key? key}) : super(key: key);

  static ValueNotifier<String> query = ValueNotifier("");

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  TextEditingController? textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyApp.resources.color.background,
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16, top: 24),
            child: HeaderWithBackScren(title: 'Inbox'),
          ),
          const SizedBox(
            height: 16,
          ),
          Expanded(
              child: MyApp.isConnected
                  ? const ListInboxScreen()
                  : RequireRegistreScreen(
                      postFunction: () {
                        setState(() {});
                      },
                    ))
        ]),
      ),
    );
  }
}
