import 'package:flutter/material.dart';
import 'package:zm_supplier/utils/constants.dart';
import 'login/login_page.dart';
import 'home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils/constants.dart';

void main() async {
  Constants.setEnvironment(Environment.DEV);
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLogged = false;
  final isLoggedIn = prefs.getBool(Constants.is_logged);
  if (isLoggedIn != null) {
    isLogged = isLoggedIn;
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
