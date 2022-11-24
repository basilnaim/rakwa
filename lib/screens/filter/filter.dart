import 'package:flutter/material.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/categorie.dart';
import 'package:rakwa/model/filter.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/screens/categories/categorie_detail.dart';
import 'package:rakwa/screens/filter/Components/header.dart';
import 'package:rakwa/views/bottom_btns.dart';
import 'package:rakwa/views/text_field/my_text_field.dart';

import '../home/home.dart';
import 'Components/map_container.dart';
import 'Components/my_drop_down.dart';
import 'Components/rate_container.dart';
import 'Components/show_container.dart';
import 'Components/sort_item.dart';

class Filter extends StatefulWidget {
  const Filter({Key? key}) : super(key: key);

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  int selectedSortIndex = 0;
  String textQuery = "";
  final GlobalKey<FormFieldState> _whatFieldState = GlobalKey<FormFieldState>();

  ScrollPhysics physics = const AlwaysScrollableScrollPhysics();

  Map<String, List<CategorieModel>> modules = {};
  String listingModule = "listing";

  @override
  void initState() {
    super.initState();
    _getModules();
  }

  ValueNotifier<CategorieModel?> selectedCatgory = ValueNotifier(null);
  ValueNotifier<String?> selectedModule = ValueNotifier(null);

  bool isLoading = false;
  setLoading(bool loading) {
    if (isLoading != loading) {
      setState(() {
        isLoading = loading;
      });
    }
  }

  initModules({Map<String, List<CategorieModel>> mModules = const {}}) {
    modules.clear();
    modules.addAll(mModules);

    if (mModules.isEmpty) {
      modules.putIfAbsent("Module (Listing , event ...)", () => []);
      selectedModule.value = "Module (Listing , event ...)";
      selectedCatgory.value = null;
    } else {
      if (mModules.keys.contains(listingModule)) {
        selectedModule.value = listingModule;
      } else {
        selectedModule.value = mModules.keys.first;
      }
      selectedCatgory.value = null;
    }
  }

  _getModules() {
    initModules();
    setLoading(true);
    MyApp.homeRepo
        .modules()
        .then((WebServiceResult<Map<String, List<CategorieModel>>> value) {
      switch (value.status) {
        case WebServiceResultStatus.success:
          if (modules.isNotEmpty) {
            initModules(mModules: value.data ?? {});
          }
          break;
        case WebServiceResultStatus.error:
          mySnackBar(context,
              title: 'fetch filter failed',
              message: value.message,
              status: SnackBarStatus.error);

          break;
        case WebServiceResultStatus.loading:
          break;
        case WebServiceResultStatus.unauthorized:
          break;
      }
      setLoading(false);
    });
  }

  _goToSearch() async {
    FilterModel filterModel = FilterModel();

    if (selectedSortIndex == 0) {
      filterModel.sort_by = "most_reviewed";
    } else if (selectedSortIndex == 1) {
      filterModel.sort_by = "most_viewed";
    } else if (selectedSortIndex == 3) {
      filterModel.sort_by = "highest_rated";
    }

    _whatFieldState.currentState?.save();
    filterModel.keyword = textQuery;

    filterModel.module = selectedModule.value.toString();

    if (selectedCatgory.value != null && selectedCatgory.value?.id != -1) {
      filterModel.category = selectedCatgory.value?.id.toString();
    }

    filterModel.lat = MapContainer.location == null
        ? null
        : (MapContainer.location?.latitude.toString());
    filterModel.long = MapContainer.location == null
        ? null
        : (MapContainer.location?.longitude.toString());
    filterModel.is_open = ShowContainer.isOpen.toString();
    if (RateContainer.rate > 0.0) {
      filterModel.rate = RateContainer.rate.toString();
    }
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategorieDetail(
          //categorieModel: cat,
          filterModel: filterModel,
        ),
      ),
    );
    setState(() {
      textQuery = filterModel.keyword ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyApp.resources.color.background,
        body: SafeArea(
          child: isLoading
              ? const Center(
                  child: MyProgressIndicator(
                  color: Colors.orange,
                ))
              : Column(mainAxisSize: MainAxisSize.min, children: [
                  HeaderFilter(titre: "Filter"),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: physics,
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding:
                                  EdgeInsets.only(left: 16, right: 16, top: 10),
                              child: Text(
                                "Sort by",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(height: 16),
                            //sort by items
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: Row(children: [
                                SortItem(
                                  isSelected:
                                      (selectedSortIndex == 0) ? true : false,
                                  titre: "Most Reviewed",
                                  onClick: () {
                                    setState(() {
                                      selectedSortIndex = 0;
                                    });
                                  },
                                ),
                                const SizedBox(width: 12),
                                SortItem(
                                  isSelected:
                                      (selectedSortIndex == 1) ? true : false,
                                  titre: "Most Viewed",
                                  onClick: () {
                                    setState(() {
                                      selectedSortIndex = 1;
                                    });
                                  },
                                ),
                                const SizedBox(width: 12),
                                SortItem(
                                  isSelected:
                                      (selectedSortIndex == 2) ? true : false,
                                  titre: "Highest Rated",
                                  onClick: () {
                                    setState(() {
                                      selectedSortIndex = 2;
                                    });
                                  },
                                ),
                              ]),
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            //search keyword
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: MyTextField(
                                initial: textQuery,
                                prefixWidget: Icon(
                                  Icons.search,
                                  size: 32,
                                  color: MyApp.resources.color.iconColor,
                                ),
                                formFieldeKey: _whatFieldState,
                                textInputAction: TextInputAction.done,
                                onSubmit: (onSubmmit) {},
                                onSave: (onSave) {
                                  textQuery = onSave ?? "";
                                },
                                hint: "What",
                                subHint: "Search keyword",
                              ),
                            ),
                            const SizedBox(height: 16),
                            ValueListenableBuilder(
                                valueListenable: selectedModule,
                                builder: (context, String? module, w) {
                                  return MyDropDown<String>(
                                      label: 'Type',
                                      value: module,
                                      items: modules.keys
                                          .map<DropdownMenuItem<String>>(
                                              (String state) {
                                        return DropdownMenuItem<String>(
                                          value: state,
                                          child: Text(
                                            state,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                ?.copyWith(
                                                    color: MyApp.resources.color
                                                        .colorText),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String? module) {
                                        selectedModule.value = module;
                                        selectedCatgory.value = null;
                                        setState(() {});
                                      });
                                }),
                            const SizedBox(height: 10),
                            ValueListenableBuilder(
                                valueListenable: selectedCatgory,
                                builder:
                                    (context, CategorieModel? category, s) {
                                  List<CategorieModel> categories = [];
                                  CategorieModel empty = CategorieModel(
                                      id: -1, title: "Category name");

                                  categories.add(empty);
                                  categories.addAll(
                                      modules[selectedModule.value] ?? []);

                                  category ??= empty;
                                  return MyDropDown<CategorieModel?>(
                                      label: 'From',
                                      value: category,
                                      items: categories.map<
                                              DropdownMenuItem<
                                                  CategorieModel?>>(
                                          (CategorieModel? state) {
                                        return DropdownMenuItem<
                                            CategorieModel?>(
                                          value: state,
                                          child: Text(
                                            state?.title ?? "-",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                ?.copyWith(
                                                    color: MyApp.resources.color
                                                        .colorText),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (CategorieModel? data) {
                                        selectedCatgory.value = data;
                                        setState(() {});
                                      });
                                }),

                            const SizedBox(height: 48),
                            //map container
                            MapContainer(),
                            if (selectedModule.value == listingModule)
                              const SizedBox(height: 16),
                            if (selectedModule.value == listingModule)
                              const Padding(
                                padding: EdgeInsets.only(left: 24, right: 16),
                                child: Text(
                                  "Show",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            const SizedBox(height: 6),
                            if (selectedModule.value == listingModule)
                              const ShowContainer(),
                            if (selectedModule.value == listingModule)
                              const SizedBox(height: 16),
                            if (selectedModule.value == listingModule)
                              const Padding(
                                padding: EdgeInsets.only(left: 24, right: 16),
                                child: Text(
                                  "Rate",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            if (selectedModule.value == listingModule)
                              const SizedBox(height: 6),
                            if (selectedModule.value == listingModule)
                              const RateContainer(),
                            const SizedBox(height: 20),
                          ]),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(
                        left: 40, right: 40, top: 24, bottom: 24),
                    color: Colors.white,
                    child: BottomButtons(
                        neutralButtonText: "back",
                        submitButtonText: "Search",
                        neutralButtonClick: () {
                          Navigator.of(context).pop(0);
                        },
                        submitButtonClick: () {
                          _goToSearch();
                        }),
                  )
                ]),
        ));
  }
}
