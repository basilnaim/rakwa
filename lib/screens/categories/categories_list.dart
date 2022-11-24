import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/categorie.dart';
import 'package:rakwa/model/filter.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/screens/categories/Components/categorie_item.dart';
import 'package:rakwa/screens/categories/categorie_detail.dart';
import 'package:rakwa/screens/home/Components/header_collapsed.dart';
import 'package:rakwa/screens/home/home.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<CategorieModel> categories = [];
  bool isLoading = false;
  List<CategorieModel> searchedCatgories = [];
  String searchedValue = "";
  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  _fetchCategories() {
    print('fetch categires data started');
    setState(() {
      isLoading = true;
    });

    MyApp.homeRepo
        .categories("listing")
        .then((WebServiceResult<List<CategorieModel>> value) {
      setState(() {
        isLoading = false;
      });
      switch (value.status) {
        case WebServiceResultStatus.success:
          print(value.data!);
          setState(() {
            categories = value.data!;
          });
          break;
        case WebServiceResultStatus.error:
          mySnackBar(context,
              title: "fetch data home failed",
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

  _gotToDetailCategorie(CategorieModel categorieModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CategorieDetail(
              filterModel: FilterModel(
                  module: "listing", category: categorieModel.id.toString()))),
    );
  }

  CategorieModel selectedCategorie = CategorieModel(id: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyApp.resources.color.background,
      body: SafeArea(
        child: (isLoading)
            ? MyProgressIndicator(
                color: MyApp.resources.color.orange,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                    HeaderCollapsed(
                      isNotHome: true,
                      headerTitre: "Categories",
                      hint: "Search for category",
                      searchedValue: searchedValue,
                      onSearchClick: (value) {
                        searchedValue = value;
                        print(value);
                        if (value == null || value.isEmpty) {
                          setState(() {
                            searchedCatgories.clear();
                          });
                        } else {
                          setState(() {
                            searchedCatgories.clear();
                            for (int i = 0; i < categories.length; i++) {
                              if (categories[i]
                                  .title!
                                  .toLowerCase()
                                  .contains(value.toLowerCase())) {
                                searchedCatgories.add(categories[i]);
                              }
                            }
                          });
                        }
                      },
                    ),
                    (searchedValue != null &&
                            searchedValue.isNotEmpty &&
                            searchedCatgories.isEmpty)
                        ? Expanded(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: double.maxFinite,
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 80),
                                    SvgPicture.asset(
                                      MyIcons.icError,
                                      height: 100,
                                      width: 80,
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'There is no categories to show',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Please enter a valid category name',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ]),
                            ),
                          )
                        : Expanded(
                            child: ListView(children: [
                              GridView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, bottom: 40),
                                itemCount: (searchedValue != null &&
                                        searchedValue.isNotEmpty)
                                    ? searchedCatgories.length
                                    : categories.length,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        crossAxisSpacing: 8.0,
                                        mainAxisSpacing: 8.0),
                                itemBuilder: (BuildContext context, int index) {
                                  return CategorieItem(
                                    item: (searchedValue != null &&
                                            searchedValue.isNotEmpty)
                                        ? searchedCatgories[index]
                                        : categories[index],
                                    onClick: (CategorieModel cat) {
                                      _gotToDetailCategorie(cat);
                                    },
                                  );
                                },
                              ),
                            ]),
                          ),
                  ]),
      ),
    );
  }
}
