import 'package:flutter/material.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/main.dart';
import 'package:rakwa/model/location.dart';
import 'package:rakwa/model/profile.dart';
import 'package:rakwa/model/web_service_result.dart';
import 'package:rakwa/screens/home/Components/drawer.dart';
import 'package:rakwa/screens/user/profile/components/base_info.dart';
import 'package:rakwa/screens/user/profile/components/camera.dart';
import 'package:rakwa/screens/user/profile/components/header.dart';
import 'package:rakwa/screens/user/profile/components/tab_bar.dart';
import 'package:rakwa/views/not_registred.dart';
import 'package:rakwa/views/progressing_button.dart';
import 'components/update_location.dart';
import 'components/update_password.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  static ValueNotifier<bool?> editable = ValueNotifier<bool?>(true);

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  static UserProfile user = UserProfile();
  bool loading = false;
  final GlobalKey<BasicInfoScreenFormState> _profileState =
      GlobalKey<BasicInfoScreenFormState>();

  final GlobalKey<UpdatePasswordScreenState> _updatePwdState =
      GlobalKey<UpdatePasswordScreenState>();

  final GlobalKey<UpdateLocationScreenState> _locationState =
      GlobalKey<UpdateLocationScreenState>();

  Location location = Location();
  static String token = "";
  refreshUser() {
    loading = true;
    MyApp.userRepo.getToken().then((value) {
      token = value;
      MyApp.userRepo
          .profile(value)
          .then((WebServiceResult<UserProfile> result) {
        loading = false;

        switch (result.status) {
          case WebServiceResultStatus.success:
            user = result.data ?? UserProfile();
            location.stateDownValue = user.state;
            location.cityDownValue = user.city;
            // location.address = user.address;
            break;
          case WebServiceResultStatus.error:
            mySnackBar(context,
                title: 'User failed',
                message: result.message,
                status: SnackBarStatus.error);

            break;
          case WebServiceResultStatus.loading:
            break;
          case WebServiceResultStatus.unauthorized:
            break;
        }
        setState(() {});
      });
    });
  }

  onEditChanged() {
    ProfileScreen.editable.addListener(() {
      _profileState.currentState
          ?.editableForm(ProfileScreen.editable.value ?? false);
      _locationState.currentState
          ?.editableForm(ProfileScreen.editable.value ?? false);
      _updatePwdState.currentState
          ?.editableForm(ProfileScreen.editable.value ?? false);
    });
  }

  int selectedPosition = 0;
  _onTabCanged(int pos) {
    setState(() {
      selectedPosition = pos;
    });
  }

  isConnected() {}

  @override
  initState() {
    super.initState();
    initScreen();
  }

  initScreen() {
    if (MyApp.isConnected) {
      refreshUser();
      onEditChanged();
    }
  }

  updateProfile(GlobalKey<ProgressingButtonState> progressingButton) {
    user.state = location.stateDownValue;
    user.city = location.cityDownValue;
    //user.address = location.address;

    MyApp.userRepo.updateProfile(token, user).then((result) {
      progressingButton.currentState!.showProgress(false);
      ProfileScreen.editable.value = true;

      switch (result.status) {
        case WebServiceResultStatus.success:
          mySnackBar(context,
              title: 'Update profile',
              message: "User profile updated",
              status: SnackBarStatus.success);

          break;
        case WebServiceResultStatus.error:
          mySnackBar(context,
              title: 'Update profile',
              message: "Failed to update your infos",
              status: SnackBarStatus.error);

          break;
        case WebServiceResultStatus.loading:
          break;
        case WebServiceResultStatus.unauthorized:
          DrawerPageState.disconnect(context);

          break;
      }
    });
  }

  Widget _switchForm() {
    switch (selectedPosition) {
      case 0:
        return BasicInfoScreen(
          key: _profileState,
          updateProfile: updateProfile,
        );
      case 1:
        return UpdateLocationScreen(
          key: _locationState,
          updateProfile: updateProfile,
          location: location,
        );
      case 2:
        return UpdatePasswordScreen(
          key: _updatePwdState,
        );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: MyApp.resources.color.background,
        child: !MyApp.isConnected
            ? Column(
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: ProfileHeader(
                      showEdit: false,
                    ),
                  ),
                  Flexible(
                      child: Align(
                          alignment: Alignment.center,
                          child: RequireRegistreScreen(
                            postFunction: () {
                              initScreen();
                            },
                          ))),
                ],
              )
            : (loading
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: MyApp.resources.color.colorBackground,
                      color: MyApp.resources.color.orange,
                      strokeWidth: 3,
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                            // height: 50,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ProfileHeader()),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(children: [
                              const SizedBox(height: 20),
                              const CameraScreen(),
                              Text(
                                "${user.firstname} ${user.lastname}",
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    ?.copyWith(
                                        fontSize: 28,
                                        color: MyApp.resources.color.blue3),
                              ),
                              SizedBox(height: 24),
                              MyTabBar(onTabChanged: _onTabCanged),
                              SizedBox(height: 30),
                              _switchForm(),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  )));
  }
}
