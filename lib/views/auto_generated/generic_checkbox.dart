import 'package:flutter/material.dart';

class GenericCheckBox extends StatefulWidget {


  const GenericCheckBox({ Key? key }) : super(key: key);

  @override
  State<GenericCheckBox> createState() => _GenericCheckBoxState();
}

class _GenericCheckBoxState extends State<GenericCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          onChanged: (value) {},
          value: null,
        ),
      ],
    );
  }
}