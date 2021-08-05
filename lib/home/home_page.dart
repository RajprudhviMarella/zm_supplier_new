import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zm_supplier/models/ordersResponseList.dart';
import 'package:zm_supplier/models/response.dart';
import 'package:zm_supplier/models/user.dart';
import 'package:zm_supplier/orders/orderDetailsPage.dart';
import 'package:zm_supplier/settings/settings_page.dart';
import 'package:zm_supplier/dashBoard/dash_board_page.dart';
import 'package:zm_supplier/customers/customers_page.dart';
import 'package:zm_supplier/utils/color.dart';
import 'package:zm_supplier/utils/constants.dart';
import 'package:zm_supplier/utils/eventsList.dart';
import 'package:zm_supplier/utils/urlEndPoints.dart';
import 'package:http/http.dart' as http;

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
      'Account',
      style: TextStyle(fontSize: 12, fontFamily: 'SourceSansProSemiBold', color: greyText),
    ),
  ];
  final _pageOptions = [DashboardPage(), CustomersPage(), SettingsPage()];

  Mixpanel mixpanel;
  OrderDetailsResponse notifyOrderResponse;
  Orders notifyOrder;

  void mixPanelEvents() async {
    mixpanel = await Constants.initMixPanel();
  }

  @override
  void initState() {
    super.initState();
    sharedPref.saveBool(Constants.isFromReviewOrder, false);
    mixPanelEvents();

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if(message != null){
        NotificationUri uri =
        NotificationUri.fromJson(json.decode(message.data['uri']));
        String orderId = uri.parameters.orderId;
        print("OrderId" + uri.parameters.orderId);
        goToOrderDetails(orderId);
      }
    });
  }
  goToOrderDetails(String orderId) async {
    LoginResponse user =
    LoginResponse.fromJson(await sharedPref.readData(Constants.login_Info));

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart',
      'mudra': user.mudra,
      'supplierId': user.supplier.first.supplierId
    };

    Map<String, String> queryParams = {
      'orderId': orderId,
    };

    String queryString = Uri(queryParameters: queryParams).query;

    var url = URLEndPoints.retrive_specific_order_details + '?' + queryString;
    print(headers);
    print(url);
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      // Map results = json.decode(response.body);
      notifyOrderResponse =
          OrderDetailsResponse.fromJson(json.decode(response.body));
    } else {
      print('failed get order detail');
    }

    notifyOrder = notifyOrderResponse.data;

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => OrderDetailsPage(notifyOrder)));

    //return order;
  }
  SharedPref sharedPref = SharedPref();

  void _onItemTapped(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _selectedIndex = index;
      prefs.setBool(Constants.isFromReviewOrder, false);
      if (index == 0) {
        mixpanel.track(Events.TAP_ORDERS_TAB);
      } else if (index == 1) {
       // mixpanel.track(Events.TAP_CUSTOMERS_TAB);
      } else {
        mixpanel.track(Events.TAP_SETTINGS_TAB);
      }
      mixpanel.flush();
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
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedFontSize: 12,
        selectedItemColor: buttonBlue,
        onTap: _onItemTapped,
      ),
    );
  }
}
