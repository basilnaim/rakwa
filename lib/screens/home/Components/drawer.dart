import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:rakwa/main.dart';
import 'package:rakwa/model/home_user.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/res/icons/my_icons.dart';
import 'package:rakwa/res/images/MyImages.dart';
import 'package:rakwa/screens/home/home.dart';
import 'package:rakwa/screens/home_container/home_container_screen.dart';
import 'package:rakwa/screens/user/login/login.dart';
import 'package:rakwa/utils/pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerPage extends StatefulWidget {
  static ValueNotifier<DrawerItems> selectedMenuTab =
      ValueNotifier<DrawerItems>(DrawerItems.home);

  DrawerPage({
    Key? key,
  }) : super(key: key);

  @override
  State<DrawerPage> createState() => DrawerPageState();
}

class DrawerPageState extends State<DrawerPage> {
  static disconnect(context) {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Anauthorized',
            desc: 'Your session has been expired ! .. try to login ',
            btnOkText: "Login",
            btnOkOnPress: () => disconnectUSer(context),
            btnOkColor: MyApp.resources.color.orange,
            btnCancel: null)
        .show();
  }

  static disconnectUSer(context) async {
    if (MyApp.id > 0) {
      MyApp.fireRepo.loginUserFcm(MyApp.id, login: false);
    }

    SharedPreferences.getInstance()
        .then((prefs) => prefs.remove(PrefKeys.user));

    MyApp.isConnected = false;
    MyApp.userConnected = null;
    MyApp.id = 0;
    MyApp.token = "";
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width - 80,
        color: MyApp.resources.color.background,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Flexible(
            child: ValueListenableBuilder(
                valueListenable: DrawerPage.selectedMenuTab,
                builder: (context, value, wid) {
                  return SingleChildScrollView(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Visibility(
                              visible: MyApp.isConnected,
                              child: DrawerUserContainer()),
                          SizedBox(height: (!MyApp.isConnected) ? 80 : 0),
                          DrawerItem(
                            drawerItemType: DrawerItems.home,
                            titre: "الرئيسية",
                            icon: MyIcons.icHome,
                          ),
                          DrawerItem(
                            drawerItemType: DrawerItems.dashboard,
                            titre: "لوحة التحكم",
                            icon: MyIcons.icDashboard,
                          ),
                          DrawerItem(
                            drawerItemType: DrawerItems.discover,
                            titre: "Discover",
                            icon: MyIcons.icDicover,
                          ),
                          DrawerItem(
                              drawerItemType: DrawerItems.profile,
                              titre: "الملف الشخصي",
                              icon: MyIcons.icPerson),
                          DrawerItem(
                              drawerItemType: DrawerItems.listing,
                              titre: "القوائم",
                              icon: MyIcons.icListing),
                          DrawerItem(
                              drawerItemType: DrawerItems.inbox,
                              titre: "الرسائل",
                              icon: MyIcons.icInbox),
                          /*  DrawerItem(
                              drawerItemType: DrawerItems.invoices,
                              titre: "Invoices",
                              icon: MyIcons.icInvoice),*/
                          DrawerItem(
                              drawerItemType: DrawerItems.saved,
                              titre: "المفضلة",
                              icon: MyIcons.icLike),
                          DrawerItem(
                              drawerItemType: DrawerItems.reviews,
                              titre: "التقييمات",
                              icon: MyIcons.icReviews),
                          DrawerItem(
                              drawerItemType: DrawerItems.contactus,
                              titre: "تواصل معنا",
                              icon: MyIcons.icContactUs),
                          const SizedBox(height: 16),
                        ]),
                  );
                }),
          ),
          (!MyApp.isConnected)
              ? Container(
                  width: double.maxFinite,
                  height: 1,
                  color: Colors.grey.withOpacity(0.1),
                )
              : const SizedBox(),
          (MyApp.isConnected)
              ? Container(
                  color: Colors.white,
                  width: double.maxFinite,
                  height: 80,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                      width: double.maxFinite,
                      height: 1,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context);
                            MyApp.userRepo
                                .logout()
                                .then((WebServiceResult<bool> value) {
                              switch (value.status) {
                                case WebServiceResultStatus.success:
                                  disconnectUSer(context);
                                  break;
                                case WebServiceResultStatus.unauthorized:
                                  disconnect(context);
                                  break;
                                case WebServiceResultStatus.error:
                                  AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.ERROR,
                                          animType: AnimType.BOTTOMSLIDE,
                                          title: 'Logout',
                                          desc: value.message,
                                          btnOk: null,
                                          btnCancel: null)
                                      .show();

                                  break;
                                case WebServiceResultStatus.loading:
                                  break;
                              }
                            });
                          },
                          child: Row(children: const [
                            SizedBox(width: 16),
                            Icon(
                              Icons.login,
                              size: 24,
                              color: Colors.black,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Log Out",
                              style: TextStyle(color: Colors.black),
                            )
                          ]),
                        ),
                      ),
                    ),
                  ]),
                )
              : Padding(
                  padding: const EdgeInsets.only(
                      left: 32, right: 32, top: 16, bottom: 32),
                  child: Container(
                    width: double.maxFinite,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade700,
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        onTap: () {
                          Navigator.pop(context);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen(
                                      fromHome: true,
                                    )),
                          );
                        },
                        child: const Center(
                          child: Text(
                            "تسجيل الدخول",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ]),
      ),
    );
  }
}

class DrawerUserContainer extends StatelessWidget {
  DrawerUserContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: HomeScreenState.homeUserObserver,
        builder: (context, HomeUser? value, wi) {
          return Container(
              width: double.maxFinite,
              padding: const EdgeInsets.only(top: 20),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 32, right: 32, top: 24, bottom: 24),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 2, color: Colors.white)),
                            child: ClipOval(
                              child: Image.network(
                                value?.image ?? "",
                                width: 100,
                                height: 100,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(MyImages.profilePic);
                                },
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Hello",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          const SizedBox(height: 6),
                          if (value != null)
                            Text(
                              value.name,
                              style: TextStyle(
                                  color: Colors.orange.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                        ]),
                  ),
                ),
              ));
        });
  }
}

class DrawerItem extends StatelessWidget {
  DrawerItem({Key? key, this.titre, this.icon, required this.drawerItemType})
      : super(key: key);

  final String? titre;
  final String? icon;
  DrawerItems drawerItemType;

  @override
  Widget build(BuildContext context) {
    bool isSelected = DrawerPage.selectedMenuTab.value == drawerItemType;
    return SizedBox(
      height: 60,
      width: double.maxFinite,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          onTap: () {
            Navigator.pop(context);
            HomeContainerScreenState.navigationFromDrawer(
                context, drawerItemType);
          },
          child: Row(children: [
            const SizedBox(width: 32),
            Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (isSelected)
                      ? Colors.orange.shade700
                      : Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: SvgPicture.asset(
                  icon!,
                  width: 24,
                  height: 24,
                  color: (isSelected)
                      ? Colors.grey.shade200
                      : Colors.grey.shade400,
                )),
            const SizedBox(width: 12),
            Text(
              titre!,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: (isSelected) ? FontWeight.bold : FontWeight.w500),
            ),
          ]),
        ),
      ),
    );
  }
}

enum DrawerItems {
  home,
  profile,
  dashboard,
  discover,
  listing,
  inbox,
  invoices,
  saved,
  reviews,
  contactus
}
