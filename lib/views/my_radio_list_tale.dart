import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';

class MyRadioListTile<T> extends StatelessWidget {
  final bool value;
  final T groupValue;
  final IconData? leading;
  final Widget? title;
  final ValueChanged<bool?> onChanged;

  const MyRadioListTile({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.leading,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final title = this.title;
    return Container(
      height: 56,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: Colors.white),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          onTap: () {
            if (value) {
              onChanged(false);
            } else {
              onChanged(true);
            }
          },
          child: Row(
            children: [
              const SizedBox(width: 16,),
              _customRadioButton,
              const SizedBox(width: 12),
              if (title != null) title,
            ],
          ),
        ),
      ),
    );
  }

  Widget get _customRadioButton {
    final isSelected = value;
    return Container(
        height: 22,
        width: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              isSelected ? MyApp.resources.color.orange : Colors.grey.shade200,
        ),
        child: (isSelected)
            ? Center(
                child: Icon(
                  leading,
                  size: 14,
                  color: Colors.white,
                ),
              )
            : Container());
  }
}
