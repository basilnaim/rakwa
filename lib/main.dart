import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:launch_review/launch_review.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rakwa/communs.dart';
import 'package:rakwa/model/contact_room.dart';
import 'package:rakwa/model/listing.dart';
import 'package:rakwa/model/notification%20copy.dart';
import 'package:rakwa/model/user.dart';
import 'package:rakwa/model/version.dart';
import 'package:rakwa/repositories/ad_repo.dart';
import 'package:rakwa/repositories/app_repo.dart';
import 'package:rakwa/repositories/classified_repo.dart';
import 'package:rakwa/repositories/firebase_repo.dart';
import 'package:rakwa/repositories/home_repo.dart';
import 'package:rakwa/repositories/listing_repo.dart';
import 'package:rakwa/repositories/user_repo.dart';
import 'package:rakwa/res/context/Resources.dart';
import 'package:rakwa/res/fonts/fonts.dart';
import 'package:rakwa/screens/chats/components/messaging.dart';
import 'package:rakwa/screens/chats/inbox_screen.dart';
import 'package:rakwa/screens/chats_classifield/inbox_screen.dart';
import 'package:rakwa/screens/home/home.dart';
import 'package:rakwa/screens/home_container/home_container_screen.dart';
import 'package:rakwa/screens/inbox/inbox_screen.dart';
import 'package:rakwa/screens/user/login/login.dart';
import 'package:rakwa/update_app/update_screen.dart';
import 'package:rakwa/utils/pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'model/classified.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  FirebaseMessaging.instance
      .requestPermission(sound: true, badge: true, alert: true);

  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  static late Resources resources;
  static late UserRepo userRepo;
  static late HomeRepo homeRepo;
  static late AppRepo appRepo;
  static late AdRepo adRepo;
  static late ListingRepo listingRepo;
  static late ClassifiedRepo classifiedRepo;

  static late bool isConnected = false;
  static late User? userConnected;
  static late String token = "";
  static late int id = 0;
  static late FirebaseRepo fireRepo;
  static late BuildContext mContext;
  const MyApp({Key? key}) : super(key: key);
  static ScaffoldMessengerState? snack;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  late PackageInfo packageInfo;
  @override
  void initState() {
    super.initState();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('bg_notification');
    IOSInitializationSettings initializationSettingsIOS =
        const IOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    MyApp.resources = Resources(context);
    MyApp.userRepo = UserRepo();
    MyApp.appRepo = AppRepo();
    MyApp.fireRepo = FirebaseRepo();
    MyApp.adRepo = AdRepo();
    MyApp.classifiedRepo = ClassifiedRepo();

    MyApp.homeRepo = HomeRepo();
    MyApp.listingRepo = ListingRepo();

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) showNotification(message);
    });

    initPackageInfo();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("message" + message.data.toString());
      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          'A new onMessageOpenedApp event was published!' + message.toString());

      NoifictionData notifData = NoifictionData.fromMap(message.data);
      onSelectNotification(notifData.toJson().toString());
    });

    initialization();
  }

  Future<dynamic> onSelectNotification(payload) async {
    NoifictionData data = NoifictionData.fromJson(payload);

    switch (data.type) {
      case "1":
        {
          LaunchReview.launch(
              writeReview: false,
              androidAppId: "com.app.rakwa",
              iOSAppId: "585027354");
          break;
        }
      case "2":
        {
          if (data.extraData?.isNotEmpty == true) {
            if (data.extraData?['type'] == 0) {
              Future.delayed(
                  const Duration(milliseconds: 1000),
                  () => navigatorKey.currentState?.push(MaterialPageRoute(
                      builder: (context) => ChatScreen(
                          loadListing: true,
                          otherUser: User(
                              id: data.extraData?['user_id'] ?? 0,
                              firstname: data.extraData?['user_name'] ?? "",
                              image: data.extraData?['user_image'] ?? ""),
                          listing: Listing(
                            id: data.extraData?['id'] ?? 0,
                          )))));
            }
            if (data.extraData?['type'] == 1) {
              Future.delayed(
                  const Duration(milliseconds: 1000),
                  () => navigatorKey.currentState?.push(MaterialPageRoute(
                      builder: (context) => ChatClassifieldScreen(
                            otherUser: User(
                                id: data.extraData?['user_id'] ?? 0,
                                firstname: data.extraData?['user_name'] ?? "",
                                image: data.extraData?['user_image'] ?? ""),
                            classified:
                                Classified(id: data.extraData?['id'] ?? 0),
                          ))));
            }
          } else {
            Future.delayed(
                const Duration(milliseconds: 1000),
                () => navigatorKey.currentState?.push(
                    MaterialPageRoute(builder: (context) => InboxScreen())));
          }

          break;
        }
    }
  }

  showNotification(RemoteMessage message) {
    SharedPreferences.getInstance().then((prefs) {
      NoifictionData notifData = NoifictionData.fromMap(message.data);

      String? data = prefs.getString(PrefKeys.user);
      User? user;
      if (data != null) {
        user = User.fromMap(json.decode(data));
      }

      if (notifData.type == "1" || (user != null)) {
        flutterLocalNotificationsPlugin.show(
            notifData.hashCode,
            notifData.title,
            notifData.body,
            NotificationDetails(
              //   iOS: message.notification?.apple == null ? null :,
              android: !Platform.isAndroid
                  ? null
                  : AndroidNotificationDetails(
                      channel.id,
                      channel.name,
                      channel.description,
                      icon: 'bg_notification',
                    ),
            ),
            payload: notifData.toJson().toString());
      }
    });
  }

  initPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 2));
    FlutterNativeSplash.remove();
  }

  Future<bool> verifVersion(AppVersion appVersion) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    double? version = double.tryParse(appVersion.version);
    double currentVersion = double.tryParse(packageInfo.version) ?? 1.0;

    return version != null && version > currentVersion;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        title: MyApp.resources.strings.appName,
        localizationsDelegates: const [
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          MonthYearPickerLocalizations.delegate,
        ],
        theme: ThemeData(
          fontFamily: "Montaseraat",
          textTheme: TextTheme(
            headline1: TextStyle(
                fontSize: 24.0, fontWeight: FontFamily.bold.fontWeight()),
            headline2: TextStyle(
                fontSize: 20.0, fontWeight: FontFamily.bold.fontWeight()),
            headline3: TextStyle(
                fontSize: 16.0, fontWeight: FontFamily.medium.fontWeight()),
            headline4: TextStyle(
                fontSize: 14.0, fontWeight: FontFamily.medium.fontWeight()),
            bodyText1: TextStyle(
                fontSize: 16.0, fontWeight: FontFamily.bold.fontWeight()),
            bodyText2: TextStyle(
                fontSize: 14.0, fontWeight: FontFamily.regular.fontWeight()),
            subtitle1: TextStyle(
                fontSize: 12.0, fontWeight: FontFamily.medium.fontWeight()),
            subtitle2: TextStyle(
                fontSize: 14.0, fontWeight: FontFamily.bold.fontWeight()),
            caption: TextStyle(
                fontSize: 14.0, fontWeight: FontFamily.regular.fontWeight()),
            button: TextStyle(
                fontSize: 16.0, fontWeight: FontFamily.bold.fontWeight()),
          ),
          primarySwatch: MyApp.resources.color.colorPrimary,
        ),
        home: StreamBuilder(
          stream: SharedPreferences.getInstance().asStream(),
          builder: (BuildContext context,
              AsyncSnapshot<SharedPreferences> snapshot) {
            MyApp.mContext = context;
            MyApp.snack = ScaffoldMessenger.of(context);
            String? data = snapshot.data?.getString(PrefKeys.user);
            User? user;
            if (data != null) {
              user = User.fromMap(json.decode(data));
            }
            MyApp.isConnected = user != null;
            MyApp.token = user?.token ?? "";
            MyApp.id = user?.id ?? 0;
            MyApp.userConnected = user;

            getLoc();

            return (snapshot.connectionState == ConnectionState.waiting)
                ? const Scaffold(
                    body: Center(
                        child: MyProgressIndicator(
                      color: Colors.orange,
                    )),
                  )
                : FutureBuilder(
                    future: MyApp.fireRepo.getVersion(),
                    builder: ((context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return Scaffold(
                          body: Center(
                              child: MyProgressIndicator(
                            color: Colors.orange,
                          )),
                        );
                      }
                      if (snapshot.hasData) {
                        try {
                          AppVersion appVersion = AppVersion.fromMap(
                              ((snapshot.data as DocumentSnapshot).data())
                                  as Map<String, dynamic>);
                          double? version = double.tryParse(appVersion.version);
                          double currentVersion =
                              double.tryParse(packageInfo.version) ?? 1.0;

                          if (version != null && version > currentVersion) {
                            return UpdateAppScreen(
                                isRequired: appVersion.required);
                          }
                        } catch (e) {
                          print("11111" + snapshot.data.toString());
                        }
                      }

                      return (MyApp.isConnected
                          ? const HomeContainerScreen()
                          : LoginScreen());
                    }),
                  );
          },
        ),
      ),
    );
  }
}

class MyConnectivity {
  MyConnectivity._();

  static final _instance = MyConnectivity._();
  static MyConnectivity get instance => _instance;
  final _connectivity = Connectivity();
  final _controller = StreamController.broadcast();
  Stream get myStream => _controller.stream;

  void initialise() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    _checkStatus(result);
    _connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('www.google.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }
    _controller.sink.add({result: isOnline});
  }

  void disposeStream() => _controller.close();
}
