import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';

import 'components/form.dart';

class ContactUsScreen extends StatelessWidget {
  ContactUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyApp.resources.color.background,
      body: SafeArea(child: ContactFormScreen()),
    );
  }
}
