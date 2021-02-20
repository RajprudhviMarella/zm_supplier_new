import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:zm_supplier/models/ordersResponseList.dart';
import 'package:zm_supplier/models/user.dart';
import 'package:zm_supplier/utils/color.dart';
import 'package:zm_supplier/utils/constants.dart';
import 'package:zm_supplier/utils/urlEndPoints.dart';
import 'package:http/http.dart' as http;
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

/**
 * Created by RajPrudhviMarella on 18/Feb/2021.
 */

class ViewOrdersPage extends StatefulWidget {
  static const String tag = 'ViewOrdersPage';

  @override
  State<StatefulWidget> createState() {
    return ViewOrdersDesign();
  }
}

class ViewOrdersDesign extends State<ViewOrdersPage>
    with TickerProviderStateMixin {
  Widget appBarTitle = new Text(
    Constants.txt_orders,
    style: new TextStyle(color: Colors.black),
  );
  Icon icon = new Icon(
    Icons.search,
    color: Colors.black,
  );
  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _controller = new TextEditingController();
  Future<List<Orders>> ordersList;
  List<dynamic> _list;
  bool _isSearching;
  String _searchText = "";
  List searchresult = new List();

  String supplierID;
  String mudra;
  bool _isShowLoader = false;

  @override
  void initState() {
    super.initState();
    loadSharedPrefs();
  }

  void _showLoader() {
    setState(() {
      _isShowLoader = true;
    });
  }

  void _hideLoader() {
    setState(() {
      _isShowLoader = false;
    });
  }

  SharedPref sharedPref = SharedPref();

  loadSharedPrefs() async {
    try {
      LoginResponse loginResponse = LoginResponse.fromJson(
          await sharedPref.readData(Constants.login_Info));
      setState(() {
        if (loginResponse.mudra != null) {
          mudra = loginResponse.mudra;
        }
        if (loginResponse.user.supplier.elementAt(0).supplierId != null) {
          supplierID = loginResponse.user.supplier.elementAt(0).supplierId;
          ordersList = callRetreiveOrdersAPI();
        }
      });
    } catch (Exception) {
      // do something

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: faintGrey,
      body: ModalProgressHUD(
        inAsyncCall: _isShowLoader,
        child: ListView(
          children: <Widget>[
            buildAppBar(context),
            displayList(context),
          ],
        ),
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(
        centerTitle: true,
        title: appBarTitle,
        backgroundColor: Colors.white,
        bottomOpacity: 0.0,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          new IconButton(
            icon: icon,
            onPressed: () {
              setState(() {
                if (this.icon.icon == Icons.search) {
                  this.icon = new Icon(
                    Icons.close,
                    color: Colors.black,
                  );
                  this.appBarTitle = new TextField(
                    controller: _controller,
                    style: new TextStyle(
                      color: Colors.black,
                    ),
                    decoration: new InputDecoration(
                        prefixIcon: new Icon(Icons.search, color: Colors.black),
                        hintText: "Search",
                        hintStyle: new TextStyle(color: Colors.black)),
                    onChanged: searchOperation,
                  );
                  _handleSearchStart();
                } else {
                  _handleSearchEnd();
                }
              });
            },
          ),
        ]);
  }

  Widget displayList(BuildContext context) {
    return FutureBuilder<List<Orders>>(
        future: ordersList,
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapShot.connectionState == ConnectionState.done &&
                snapShot.hasData &&
                snapShot.data.isNotEmpty) {
              return SizedBox(
                  height: double.maxFinite,
                  child: StickyGroupedListView<Orders, DateTime>(
                    elements: snapShot.data,
                    order: StickyGroupedListOrder.ASC,
                    groupComparator: (DateTime value1, DateTime value2) =>
                        value2.compareTo(value1),
                    groupBy: (Orders element) => DateTime(
                        element.getTimeCompare().year,
                        element.getTimeCompare().month,
                        element.getTimeCompare().day),
                    itemComparator: (Orders element1, Orders element2) =>
                        element1
                            .getTimeCompare()
                            .compareTo(element2.getTimeCompare()),
                    floatingHeader: true,
                    groupSeparatorBuilder: (Orders element) => Container(
                      height: 50,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.blue[300],
                            border: Border.all(
                              color: Colors.blue[300],
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${element.getTimeCompare().day}. ${element.getTimeCompare().month}, ${element.getTimeCompare().year}',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    itemBuilder: (context, element) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        elevation: 8.0,
                        margin: new EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 6.0),
                        child: Container(
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            // leading: Icon(element.),
                            title: Text(element.orderId),
                            // trailing: Text('${element.date.hour}:00'),
                          ),
                        ),
                      );
                    },
                  ));
            } else {
              return Container();
            }
          }
        });
  }

  void searchOperation(String searchText) {
    searchresult.clear();
    if (_isSearching != null) {
      for (int i = 0; i < _list.length; i++) {
        String data = _list[i];
        if (data.toLowerCase().contains(searchText.toLowerCase())) {
          searchresult.add(data);
        }
      }
    }
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.icon = new Icon(
        Icons.search,
        color: Colors.black,
      );
      this.appBarTitle = new Text(
        Constants.txt_orders,
        style: new TextStyle(color: Colors.black),
      );
      _isSearching = false;
      _controller.clear();
    });
  }

  Future<List<Orders>> callRetreiveOrdersAPI() async {
    var ordersModel = OrdersBaseResponse();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart',
      'mudra': mudra,
      'supplierId': supplierID
    };
    Map<String, String> queryParams = {'supplierId': supplierID};
    String queryString = Uri(queryParameters: queryParams).query;
    var requestUrl = URLEndPoints.retrieve_orders + '?' + queryString;
    print(requestUrl);
    var response = await http.get(requestUrl, headers: headers);
    print(response.body);
    var jsonMap = json.decode(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      ordersModel = OrdersBaseResponse.fromJson(jsonMap);
      return ordersModel.data.data;
    }
  }
}
