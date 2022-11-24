import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/categorie.dart';
import 'package:rakwa/res/images/MyImages.dart';

class CategorieItem extends StatelessWidget {
  CategorieItem(
      {Key? key,
      required this.item,
      this.onClick,
      this.selectable = false,
      this.selected = false})
      : super(key: key);

  CategorieModel item;
  Function(CategorieModel category)? onClick;
  bool selectable = false;
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    print("icoooooon"+item.toString());
    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        border: Border.all(
            width: 1,
            color: selected
                ? Colors.orange
                : MyApp.resources.color.borderColor),
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          onTap: () {
            onClick!.call(item);
          },
          child: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Image.network(
                item.icon!,
                width: 32,
                height: 32,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Image.asset(MyImages.errorImage,
                      fit: BoxFit.cover, width: 32, height: 32);
                },
              ),
              const SizedBox(height: 8),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  child: Text(
                    item.title!,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: MyApp.resources.color.iconColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
