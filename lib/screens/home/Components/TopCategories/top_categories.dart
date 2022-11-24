import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/categorie.dart';
import 'package:rakwa/model/filter.dart';
import 'package:rakwa/screens/categories/categorie_detail.dart';
import 'package:rakwa/screens/categories/categories_list.dart';
import 'package:rakwa/screens/home/Components/TopCategories/top_categories_item.dart';

class TopCategories extends StatelessWidget {
  const TopCategories({Key? key, @required this.list}) : super(key: key);

  final List<CategorieModel>? list;

  void goToCategories(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Categories()),
    );
  }

  _gotToDetailCategorie(CategorieModel categorieModel, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CategorieDetail(
                filterModel: FilterModel(
                    module: "listing", category: categorieModel.id.toString()),
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(top: 16, left: 16),
        child: Text(
          MyApp.resources.strings.topCategories,
          style: TextStyle(
              color: MyApp.resources.color.textColor,
              fontWeight: FontWeight.w600),
        ),
      ),
      Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
          padding:
              const EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  width: 1, color: MyApp.resources.color.borderColor),
              borderRadius: const BorderRadius.all(Radius.circular(12))),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list?.length ?? 0,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, crossAxisSpacing: 8.0, mainAxisSpacing: 8.0),
            itemBuilder: (BuildContext context, int index) {
              return TopCatgorieItem(
                onCLick: () {
                  (index == list!.length - 1)
                      ? goToCategories(context)
                      : _gotToDetailCategorie(list![index], context);
                },
                item: list![index],
                isLast: (index == list!.length - 1) ? true : false,
              );
            },
          )),
    ]);
  }
}
