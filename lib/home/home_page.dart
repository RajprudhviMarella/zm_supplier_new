import 'package:flutter/material.dart';
import 'package:zm_supplier/settings/settings_page.dart';
import 'package:zm_supplier/dashBoard/dash_board_page.dart';
import 'package:zm_supplier/customers/customers_page.dart';
import 'package:zm_supplier/utils/color.dart';

class HomePage extends StatefulWidget {
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<HomePage> {
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
