import 'dart:ui';

/// Flutter code sample for BottomNavigationBar

// This example shows a [BottomNavigationBar] as it is used within a [Scaffold]
// widget. The [BottomNavigationBar] has three [BottomNavigationBarItem]
// widgets and the [currentIndex] is set to index 0. The selected item is
// amber. The `_onItemTapped` function changes the selected item's index
// and displays a corresponding message in the center of the [Scaffold].
//
// ![A scaffold with a bottom navigation bar containing three bottom navigation
// bar items. The first one is selected.](https://flutter.github.io/assets-for-api-docs/assets/material/bottom_navigation_bar.png)

import 'package:flutter/material.dart';
import 'package:zm_supplier/settings/settings_page.dart';
import 'package:zm_supplier/dashBoard/dash_board_page.dart';
import 'package:zm_supplier/customers/customers_page.dart';
import 'package:zm_supplier/utils/color.dart';

void main() => runApp(HomePage());

/// This is the main application widget.
class HomePage extends StatelessWidget {
  static const String tag = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: tag,
      home: MyStatefulWidget(),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    Text(
      'Orders',
      style: TextStyle(fontSize: 12, fontFamily: 'SourceSansProSemiBold', color: buttonBlue),
    ),
    Text(
      'Customers',
      style: TextStyle(fontSize: 12, fontFamily: 'SourceSansProSemiBold', color: greyText),
    ),
    Text(
      'Settings',
      style: TextStyle(fontSize: 12, fontFamily: 'SourceSansProSemiBold', color: greyText),
    ),
  ];
  final _pageOptions = [DashboardPage(), CustomersPage(), SettingsPage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pageOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/orders_blue.png'), size: 22,),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/Customers_grey.png'), size: 22,),//Icon(Icons.supervisor_account_outlined),
            label: 'Customers',

          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/user_grey.png'), size: 22,),//Icon(Icons.account_circle_outlined),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: buttonBlue,
        onTap: _onItemTapped,
      ),
    );
  }
}
