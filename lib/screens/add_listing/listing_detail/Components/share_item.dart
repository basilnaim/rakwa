import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';

class ShareItem extends StatelessWidget {
  const ShareItem({Key? key, this.onClick, this.titre, this.icon})
      : super(key: key);
  final String? titre;
  final VoidCallback? onClick;
  final String? icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border:
              Border.all(width: 0.5, color: MyApp.resources.color.borderColor),
          color: Colors.white,
          borderRadius: BorderRadius.circular(12)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onClick?.call(),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding:
                const EdgeInsets.only(top: 12, bottom: 12, right: 8, left: 8),
            decoration: BoxDecoration(
                border: Border.all(
                    width: 0.5, color: MyApp.resources.color.borderColor),
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12)),
            child: Center(
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Image.asset(
                  icon ?? "",
                  width: 30,
                  height: 30,
                  fit: BoxFit.fill,
                ),
                const SizedBox(width: 12),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        titre ?? "",
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Share now",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ])
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
