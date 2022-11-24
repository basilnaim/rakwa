import 'package:flutter/material.dart';

class MyDropDown<T> extends StatefulWidget {
  final List<DropdownMenuItem<T>>? items;
  final IconData? icon;
  final T? value;
  final String? hintText;
  final String? label;
  // ValueChanged with the passed type
  final ValueChanged<T?>? onChanged;

  const MyDropDown(
      {Key? key,
      @required this.items,
      this.icon,
      this.value,
      this.hintText,
      this.label,
      this.onChanged})
      : super(key: key);

  @override
  State<MyDropDown<T>> createState() => _MyDropDownState<T>();
}

class _MyDropDownState<T> extends State<MyDropDown<T>> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Text(
            widget.label ?? "",
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 6, left: 16, right: 16),
          padding: const EdgeInsets.only(left: 16, right: 16),
          height: 56,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 0.5,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
                value: widget.value,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.black, fontSize: 14),
                onChanged: widget.onChanged!,
                items: widget.items),
          ),
        ),
      ],
    );
  }
}
