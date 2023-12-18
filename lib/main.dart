import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:rideoptions/firebase_options.dart';
import 'package:rideoptions/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Component/Model/Authentication/driver_user_model.dart';
import 'Component/Model/Authentication/user_model.dart';
import 'Component/Provider/activity_provider.dart';
import 'Component/Provider/audio_provider.dart';
import 'Component/Provider/auth_provider.dart';
import 'Component/Provider/chat_provider.dart';
import 'Component/Provider/connectivity_provider.dart';
import 'Component/Provider/earning_provider.dart';
import 'Component/Provider/home_provider.dart';
import 'Component/Provider/package_provider.dart';
import 'Component/Provider/ride_provider.dart';
import 'Component/Services/push_notification_service.dart';
import 'Component/constant.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  getUID();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  AwesomeNotifications().initialize("resource://drawable/car_trip", [
    NotificationChannel(
      channelKey: "basic_channel",
      channelName: "basic_channel",
      channelDescription: "channelDescription",
      enableVibration: true,
      onlyAlertOnce: true,
      playSound: true,
      vibrationPattern: highVibrationPattern,
      soundSource: 'resource://raw/noti_tune.mp3',
      importance: NotificationImportance.Max,
    )
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RideProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => AudioMessageController()),
        ChangeNotifierProvider(create: (_) => ActivityProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => EarningProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => PackageProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    super.initState();

    PushNotificationService p = PushNotificationService(context);
    p.initFirebaseMessaging();
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ride Options',
        navigatorKey: Constant.navState,
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
      ),
    );
  }
}

var random;
DriverUserModel? DriverCurrent;
UserModel? userCurrent;
var currentUid;

void getUID() async {
  final prefs = await SharedPreferences.getInstance();
  var uid = prefs.getString('uid');
  currentUid = uid;
}
