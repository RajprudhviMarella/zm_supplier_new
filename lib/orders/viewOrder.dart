import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:zm_supplier/models/ordersResponseList.dart';
import 'package:zm_supplier/models/user.dart';
import 'package:zm_supplier/orders/orderDetailsPage.dart';
import 'package:zm_supplier/utils/color.dart';
import 'package:zm_supplier/utils/constants.dart';
import 'package:zm_supplier/utils/eventsList.dart';
import 'package:zm_supplier/utils/urlEndPoints.dart';
import 'package:http/http.dart' as http;

/**
 * Created by RajPrudhviMarella on 18/Feb/2021.
 */

class ViewOrdersPage extends StatefulWidget {
  static const String tag = 'ViewOrdersPage';

  final outletId;

  ViewOrdersPage(this.outletId);

  @override
  State<StatefulWidget> createState() {
    return ViewOrdersDesign(this.outletId);
  }
}

class ViewOrdersDesign extends State<ViewOrdersPage>
    with TickerProviderStateMixin {
  Widget appBarTitle = new Text(
    Constants.txt_orders,
    style: new TextStyle(
        color: Colors.black, fontFamily: "SourceSansProBold", fontSize: 18.0),
  );
  Icon icon = new Icon(
    Icons.search,
    color: Colors.black,
  );

  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _controller = new TextEditingController();
  Future<List<Orders>> ordersList;
  List<Orders> arrayOrderList;
  bool _isSearching;
  String supplierID;
  String mudra;
  int totalNoRecords = 0;
  int pageNum = 1;
  bool isPageLoading = false;
  int totalNumberOfPages = 0;
  int pageSize = 50;
  ScrollController controller;
  String searchedString;

  final outletId;

  ViewOrdersDesign(this.outletId);

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Mixpanel mixpanel;

  void mixPanelEvents() async {
    mixpanel = await Constants.initMixPanel();
  }

  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);
    loadSharedPrefs();
    super.initState();

    mixPanelEvents();
    print('outletid --- $outletId');
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
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
      appBar: buildAppBar(context),
      body: ListView(
        children: <Widget>[
          displayList(context),
        ],
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
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        actions: <Widget>[
          new IconButton(
            icon: icon,
            onPressed: () {
              setState(() {
                if (this.icon.icon == Icons.search) {
                  mixpanel.track(Events.TAP_VIEW_ORDERS_SEARCH);
                  mixpanel.flush();
                  this.icon = new Icon(
                    Icons.close,
                    color: Colors.black,
                  );
                  this.appBarTitle = new TextField(
                    cursorColor: Colors.blue,
                    maxLines: null,
                    textInputAction: TextInputAction.go,
                    controller: _controller,
                    onSubmitted: searchOperation,
                    autofocus: true,
                    style: new TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontFamily: "SourceSansProRegular"),
                    decoration: new InputDecoration(
                        prefixIcon: new Icon(Icons.search, color: Colors.black),
                        hintText: Constants.txt_Search_order_number,
                        hintStyle: new TextStyle(
                            color: greyText,
                            fontSize: 16.0,
                            fontFamily: "SourceSansProRegular")),
                    // onChanged: searchOperation,
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
            return Padding(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Center(
                  child: SpinKitThreeBounce(
                    color: Colors.blueAccent,
                    size: 24,
                  ),
                ));
          } else {
            if (snapShot.connectionState == ConnectionState.done &&
                snapShot.hasData &&
                snapShot.data.isNotEmpty) {
              isPageLoading = false;
              return SizedBox(
                  height: MediaQuery.of(context).size.height - 85,
                  child: RefreshIndicator(
                      key: refreshKey,
                      child: GroupedListView<Orders, DateTime>(
                        controller: controller,
                        elements: snapShot.data,
                        physics: AlwaysScrollableScrollPhysics(),
                        order: GroupedListOrder.ASC,
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
                        useStickyGroupSeparators: true,
                        groupSeparatorBuilder: (DateTime element) => Container(
                          height: 50.0,
                          color: faintGrey,
                          child: Padding(
                            padding: EdgeInsets.only(left: 15.0, top: 5.0),
                            child: Row(children: <Widget>[
                              Text(DateFormat('d MMM yyyy').format(element),
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                      fontFamily: "SourceSansProBold")),
                              Text(" " + DateFormat('EEE').format(element),
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: greyText,
                                      fontFamily: "SourceSansProRegular")),
                            ]),
                          ),
                        ),
                        indexedItemBuilder: (context, element, index) {
                          if (snapShot.data.length >= pageSize &&
                              index == snapShot.data.length - 1) {
                            return Container(
                              height: 80,
                              child: Center(
                                child: SpinKitThreeBounce(
                                  color: Colors.blueAccent,
                                  size: 24,
                                ),
                              ),
                            );
                          } else {
                            return Card(
                                margin: EdgeInsets.only(top: 0.5),
                                child: Container(
                                    color: Colors.white,
                                    child: ListTile(
                                        onTap: () {
                                          moveToOrderDetailsPage(element);
                                        },
                                        contentPadding: EdgeInsets.only(
                                            top: 10.0,
                                            bottom: 10.0,
                                            left: 15.0,
                                            right: 10.0),
                                        leading: displayImage(element.outlet),
                                        title: Text(
                                          element.outlet.outletName,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black,
                                            fontFamily: "SourceSansProSemiBold",
                                          ),
                                        ),
                                        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                        subtitle: Container(
                                          margin: EdgeInsets.only(top: 2.0),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Row(children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 2.0),
                                                    height: 14.0,
                                                    width: 14.0,
                                                    child: ImageIcon(AssetImage(
                                                        'assets/images/truck.png')),
                                                  ),
                                                  Text(
                                                      " " +
                                                          element
                                                              .getTimeDelivered(),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12.0,
                                                          fontFamily:
                                                              "SourceSansProRegular")),
                                                  Text(
                                                    " " +
                                                        '# ${element.orderId}',
                                                    style: TextStyle(
                                                        color: greyText,
                                                        fontSize: 12.0,
                                                        fontFamily:
                                                            "SourceSansProRegular"),
                                                  ),
                                                ]),
                                                Constants.OrderStatusColor(
                                                    element),
                                              ]),
                                        ),
                                        trailing: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              Text(
                                                  element.amount.total
                                                      .getDisplayValue(),
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.black,
                                                      fontFamily:
                                                          "SourceSansProRegular")),
                                            ]))));
                          }
                        },
                      ),
                      color: azul_blue,
                      onRefresh: refreshList));
            } else {
              return Container();
            }
          }
        });
  }

  Future<Null> refreshList() async {
    print("refreshing");
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 0));

    setState(() {
      _handleSearchEnd();
    });

    return null;
  }

  void searchOperation(String searchText) {
    arrayOrderList.clear();
    ordersList = null;
    if (_isSearching != null) {
      searchedString = searchText;
      pageNum = 1;
      ordersList = callRetreiveOrdersAPI();
    }
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  Widget displayImage(Outlet outlet) {
    if (outlet != null && outlet.logoURL != null && outlet.logoURL.isNotEmpty) {
      return Container(
          height: 38.0,
          width: 38.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Image.network(
              outlet.logoURL,
              fit: BoxFit.fill,
            ),
          ));
    } else {
      return Container(
        height: 38,
        width: 38,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: Colors.blue.withOpacity(0.5),
        ),
        child: Center(
          child: Text(
            outletPlaceholder(outlet.outletName),
            style: TextStyle(fontSize: 14, fontFamily: "SourceSansProSemiBold"),
          ),
        ),
      );
    }
  }

  void _handleSearchEnd() {
    setState(() {
      this.icon = new Icon(
        Icons.search,
        color: Colors.black,
      );
      this.appBarTitle = new Text(
        Constants.txt_orders,
        style: new TextStyle(
            color: Colors.black,
            fontFamily: "SourceSansProBold",
            fontSize: 18.0),
      );
      _isSearching = false;
      _controller.clear();
      searchedString = "";
      pageNum = 1;
      ordersList = callRetreiveOrdersAPI();
    });
  }

  Future<List<Orders>> callRetreiveOrdersAPI() async {
    isPageLoading = true;
    var ordersModel = OrdersBaseResponse();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart',
      'mudra': mudra,
      'supplierId': supplierID
    };

    Map<String, String> queryParams = {
      'supplierId': supplierID,
      'outletId': outletId,
      'pageNumber': pageNum.toString(),
      'pageSize': pageSize.toString(),
      'sortBy': 'timeUpdated',
      'sortOrder': 'DESC',
      'orderStatus': 'Placed,Void,Cancelled',
      if (searchedString != null && searchedString.isNotEmpty)
        'orderIdText': searchedString,
    };
    String queryString = Uri(queryParameters: queryParams).query;
    var requestUrl = URLEndPoints.retrieve_orders + '?' + queryString;
    print(requestUrl);
    var response = await http.get(requestUrl, headers: headers);
    print(response.body);
    var jsonMap = json.decode(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      ordersModel = OrdersBaseResponse.fromJson(jsonMap);
      totalNoRecords = ordersModel.data.numberOfPages;
      setState(() {
        if (pageNum == 1) {
          arrayOrderList = ordersModel.data.data;
        } else {
          arrayOrderList.addAll(ordersModel.data.data);
        }
      });
      return arrayOrderList;
    }
  }

  _scrollListener() {
    print("on scroll current page number $pageNum");
    print("on scroll  total page numbers $totalNoRecords");
    if (controller.position.maxScrollExtent == controller.offset) {
      if (pageNum < totalNoRecords && !isPageLoading) {
        pageNum++;
        print("PAGE NUMBER $pageNum");
        print("getting data");
        callRetreiveOrdersAPI(); // Hit API to get new data
      }
    }
  }

  String outletPlaceholder(String name) {
    Constants value = Constants();
    var placeholder = value.getInitialWords(name);
    return placeholder;
  }

  moveToOrderDetailsPage(Orders element) {
    mixpanel.track(Events.TAP_VIEW_ORDERS_ORDER_FOR_DETAILS);
    mixpanel.flush();
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => new OrderDetailsPage(element)));
  }
}
