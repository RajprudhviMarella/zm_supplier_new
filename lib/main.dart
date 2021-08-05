import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:zm_supplier/utils/constants.dart';
import 'login/login_page.dart';
import 'home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'models/user.dart';
import 'utils/constants.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

Future<void> main() async {
  Constants.setEnvironment(Environment.PROD);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await Intercom.initialize('lzmzad7p',
      iosApiKey: 'ios_sdk-3089316353932af1f13250c1743f44f1df7db154',
      androidApiKey: 'android_sdk-8489ca5c3a3f6865ef14e664df8dd2e738bdece4');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLogged = false;
  final isLoggedIn = prefs.getBool(Constants.is_logged);
  if (isLoggedIn != null) {
    isLogged = isLoggedIn;
    SharedPref.registerIntercomUser();
  }
  final ZmApp myApp = ZmApp(
    initialRoute: isLogged ? '/home' : '/login',
  );
  runApp(myApp);
}

class ZmApp extends StatelessWidget {
  final String initialRoute;

  ZmApp({this.initialRoute});

  @override
  Widget build(BuildContext context) {
    Constants.setEnvironment(Environment.PROD);
    print(initialRoute);

    return MaterialApp(
      title: 'Supplier',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
