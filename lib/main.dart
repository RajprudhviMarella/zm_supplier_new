import 'package:flutter/material.dart';
import 'package:zm_supplier/utils/constants.dart';
import 'login/login_page.dart';
import 'home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zm_supplier/models/user.dart';

//void main() => runApp(ZmApp());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLogged = false;
  final isLoggedIn = prefs.getBool(Constants.is_logged);
  if (isLoggedIn != null) {
    isLogged = isLoggedIn;
  }
  final ZmApp myApp = ZmApp(
    initialRoute: isLogged ? '/home' : '/',
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
      title: 'Kodeversitas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        //fontFamily: 'Nunito',
      ),
      //home: _decideMainPage() ,
      initialRoute: initialRoute,
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
