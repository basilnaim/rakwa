import 'package:flutter/material.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/likeModel.dart';
import 'package:rakwa/model/saved_listing.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/screens/home/home.dart';
import 'package:rakwa/screens/saved/components/item_saved.dart';
import 'package:rakwa/views/empty_content.dart';
import 'package:rakwa/views/header_back_btn.dart';
import 'package:rakwa/views/not_registred.dart';

class SavedListingScreen extends StatefulWidget {
  const SavedListingScreen({Key? key}) : super(key: key);

  @override
  State<SavedListingScreen> createState() => _SavedListingScreenState();
}

class _SavedListingScreenState extends State<SavedListingScreen> {
  List<SavedListing> savedListings = [];

  @override
  void initState() {
    super.initState();
    initScreen();
  }

  initScreen() {
    if (MyApp.isConnected) _fetchSaved();
  }

  var isLoading = true;

  loading(bool progress) {
    if (isLoading != progress) {
      setState(() {
        isLoading = progress;
      });
    }
  }

  _fetchSaved() {
    setState(() {
      isLoading = true;
    });
    MyApp.appRepo
        .mySavedListings()
        .then((WebServiceResult<List<SavedListing>> value) {
      switch (value.status) {
        case WebServiceResultStatus.success:
          print(value.data!);
          setState(() {
            isLoading = false;
            savedListings = value.data!;
          });
          break;
        case WebServiceResultStatus.error:
          setState(() {
            isLoading = false;
          });
          mySnackBar(context,
              title: 'Saved listing failed',
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

  void _addToFavorite(SavedListing saved) {
    LikeModel likeModel = LikeModel();
    int type = 0;

    MyApp.homeRepo
        .favorite(saved.listing.id, type, MyApp.token)
        .then((WebServiceResult<String> value) {
      switch (value.status) {
        case WebServiceResultStatus.success:
          savedListings.remove(saved);

          setState(() {});
          break;
        case WebServiceResultStatus.error:
          mySnackBar(context,
              title: 'Favorite failed',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyApp.resources.color.background,
      body: !MyApp.isConnected
          ? Column(
              children: [
                const SizedBox(
                  height: 64,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: HeaderWithBackScren(
                    title: 'Saved',
                  ),
                ),
                Flexible(
                    child: Align(
                        alignment: Alignment.center,
                        child: RequireRegistreScreen(
                          postFunction: () {
                            if (MyApp.isConnected) {
                              initScreen();
                            }
                          },
                        ))),
              ],
            )
          : SafeArea(
              child: isLoading
                  ? const Center(
                      child: MyProgressIndicator(
                      color: Colors.orange,
                    ))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 28.0, left: 16, right: 16, bottom: 16),
                            child: HeaderWithBackScren(title: "Saved"),
                          ),
                          Expanded(
                              child: (savedListings.isEmpty
                                  ? Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.5,
                                      alignment: Alignment.center,
                                      child: EmpyContentScreen(
                                        title: "Saved Listing",
                                        description: "",
                                      ))
                                  : ListView(children: [
                                      GridView.builder(
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 16, bottom: 40),
                                        itemCount: savedListings.length,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                childAspectRatio: 0.8,
                                                crossAxisSpacing: 8.0,
                                                mainAxisSpacing: 8.0),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return ItemSavedWidget(
                                              onFavoriteClick: _addToFavorite,
                                              saved: savedListings[index]);
                                        },
                                      ),
                                    ]))),
                        ]),
            ),
    );
  }
}
