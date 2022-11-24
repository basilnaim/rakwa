import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/categorie.dart';
import 'package:rakwa/model/error.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/screens/categories/Components/categorie_item.dart';
import 'package:rakwa/screens/home/home.dart';
import 'package:rakwa/screens/add_listing/listing_screen.dart';
import 'package:rakwa/views/bottom_btns.dart';
import 'package:rakwa/views/error_widget.dart';

class CategoriesScreen extends StatefulWidget {
  List<CategorieModel> listingCategories;
  CategoriesScreen({
    Key? key,
    required this.listingCategories,
  }) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<CategorieModel> categories = [];
  bool isLoading = false;
  bool errorLodingCategories = false;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  _fetchCategories() {
    print('fetch categires data started');
    setState(() {
      isLoading = true;
      errorLodingCategories = false;
    });

    MyApp.homeRepo
        .categories("listing")
        .then((WebServiceResult<List<CategorieModel>> value) {
      switch (value.status) {
        case WebServiceResultStatus.success:
          errorLodingCategories = false;
          categories = value.data!;

          break;
        case WebServiceResultStatus.error:
          errorLodingCategories = true;

          break;
        case WebServiceResultStatus.loading:
          break;
        case WebServiceResultStatus.unauthorized:
          break;
      }

      setState(() {
        isLoading = false;
      });
    });
  }

  onNexClick() {
    if (widget.listingCategories.isEmpty) {
      mySnackBar(context,
          showInBottom: false,
          title: 'Step 1',
          message: 'Please choose category first',
          status: SnackBarStatus.error);
      return;
    }
    ListingScreenState.bottomTabNavigation.moveToNext();
  }

  CategorieModel selectedCategorie = CategorieModel(id: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyApp.resources.color.background,
        body: SafeArea(
          child: (isLoading)
              ? MyProgressIndicator(
                  color: Colors.orange.shade700,
                )
              : errorLodingCategories
                  ? MyErrorWidget(
                      errorModel: ErrorModel(
                          btnText: 'try again',
                          text: "Couldn't fetch categories, please try again",
                          btnClickListener: () {
                            _fetchCategories();
                          }))
                  : Stack(
                      children: [
                        Positioned(
                          top: 0,
                          right: 0,
                          left: 0,
                          bottom: 50,
                          child: ListView(children: [
                            GridView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, bottom: 40),
                              itemCount: categories.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 8.0,
                                      mainAxisSpacing: 8.0),
                              itemBuilder: (BuildContext context, int index) {
                                return CategorieItem(
                                  selectable: true,
                                  selected: widget.listingCategories
                                      .any((c) => c.id == categories[index].id),
                                  item: categories[index],
                                  onClick: (CategorieModel categorie) {
                                    widget.listingCategories.clear();
                                    widget.listingCategories.add(categorie);
                                    setState(() {
                                      
                                    });
                                    //multi choice

                                    //if (widget.listingCategories
                                    //     .any((c) => c.id == categorie.id)) {
                                    //   widget.listingCategories.removeWhere(
                                    //       (c) => c.id == categorie.id);
                                    // } else {
                                    //   widget.listingCategories.add(categorie);
                                    // }
                                  },
                                );
                              },
                            ),
                          ]),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.only(
                                left: 40, right: 40, top: 16, bottom: 16),
                            //  width: double.infinity,
                            child: BottomButtons(
                                neutralButtonText: "Previous",
                                submitButtonText: "Next",
                                neutralButtonClick: () {
                                  Navigator.maybePop(context);
                                },
                                submitButtonClick: () => onNexClick()),
                          ),
                        ),
                      ],
                    ),
        ));
  }
}
