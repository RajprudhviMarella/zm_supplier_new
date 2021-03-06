import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:zm_supplier/createOrder/market_list_page.dart';
import 'package:zm_supplier/createOrder/outletSelection.dart';
import 'package:zm_supplier/deliveries/deliveries_page.dart';
import 'package:zm_supplier/models/ordersResponseList.dart';
import 'package:zm_supplier/models/user.dart';
import 'package:zm_supplier/orders/SearchOrders.dart';
import 'package:zm_supplier/orders/orderDetailsPage.dart';
import 'package:zm_supplier/orders/viewOrder.dart';
import 'package:zm_supplier/utils/constants.dart';
import 'package:zm_supplier/models/orderSummary.dart';
import 'package:zm_supplier/utils/urlEndPoints.dart';
import '../utils/color.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class DashboardPage extends StatefulWidget {
  @override
  DashboardState createState() => new DashboardState();
}

class DashboardState extends State<DashboardPage> {
  int currentIndex = 0;
  var arra = [1]; // add more values, for new cards.

  OrdersBaseResponse ordersData;
  LoginResponse userResponse;

  OrderSummaryResponse summaryData;
  Future<OrderSummaryResponse> orderSummaryData;

  Future<List<Orders>> ordersListToday;
  Future<List<Orders>> ordersListYesterday;
  List<Orders> arrayOrderList;

  var selectedTab = 'Today';
  Widget appBarTitle = new Text(
    "  Orders",
    style: TextStyle(
        color: Colors.black, fontFamily: "SourceSansProBold", fontSize: 30),
    textAlign: TextAlign.left,
  );
  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.black,
  );

  double height;
  double width;

  SharedPref sharedPref = SharedPref();

  Future<List<OrderSummaryResponse>> getJobFuture;

  Future<List<Orders>> draftOrdersFuture;
  List<Orders> draftOrdersList;

  @override
  void initState() {
    super.initState();
    orderSummaryData = getSummaryDataApiCalling();
    ordersListToday = _retriveTodayOrders();
    ordersListYesterday = _retriveYesterdayOrders();
    draftOrdersFuture = getDraftOrders();
  }

  Future<OrderSummaryResponse> getSummaryDataApiCalling() async {
    LoginResponse user =
        LoginResponse.fromJson(await sharedPref.readData(Constants.login_Info));

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart',
      'mudra': user.mudra,
      'supplierId': user.supplier.first.supplierId
    };

    var response =
        await http.get(URLEndPoints.order_summary_url, headers: headers);
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      print(response.body);
      print('Success response');
      summaryData = OrderSummaryResponse.fromJson(json.decode(response.body));
    } else {
      print('failed get summary data');
    }
    return summaryData;

    // print(user.mudra);
    // orders
    //     .getSummaryData(user.supplier.first.supplierId, user.mudra)
    //     .then((value) async {
    //   if (value == null) {
    //     showAlert(Constants.txt_change_password, Constants.txt_something_wrong);
    //   }
    //   print('call back');
    //   if (value.status == 200) {
    //     print('summary data successful');
    //     //  orderSummary = value;
    //     setState(() {
    //       orderSummary = value;
    //     });
    //   } else {
    //     showAlert(Constants.txt_change_password, Constants.txt_something_wrong);
    //   }
    //   return value;
    // });
  }

  Future<List<Orders>> getDraftOrders() async {
    LoginResponse user =
        LoginResponse.fromJson(await sharedPref.readData(Constants.login_Info));

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart',
      'mudra': user.mudra,
      'supplierId': user.supplier.first.supplierId
    };

    Map<String, String> queryParams = {
      'supplierId': user.supplier.first.supplierId,
      'orderStatus': 'Draft'
    };
    String queryString = Uri(queryParameters: queryParams).query;

    var url = URLEndPoints.retrive_paginated_orders_url + '?' + queryString;

    print(headers);
    print(url);
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      ordersData = OrdersBaseResponse.fromJson(json.decode(response.body));
    } else {
      print('failed get customers reports');
    }

    draftOrdersList = ordersData.data.data;
    return draftOrdersList;
  }

  Future<List<Orders>> _retriveYesterdayOrders() async {
    final now = DateTime.now();

    var yesterdayStartTime = DateTime(now.year, now.month, now.day - 1);
    var epochStartTime = yesterdayStartTime.millisecondsSinceEpoch / 1000;
    var startDate =
        epochStartTime.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");

    var yesterdayEndTime =
        DateTime(now.year, now.month, now.day - 1, 23, 59, 59);
    var epochEndTime = yesterdayEndTime.millisecondsSinceEpoch / 1000;
    var endDate =
        epochEndTime.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");

    LoginResponse user =
        LoginResponse.fromJson(await sharedPref.readData(Constants.login_Info));

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart',
      'mudra': user.mudra,
      'supplierId': user.supplier.first.supplierId
    };

    Map<String, String> queryParams = {
      'supplierId': user.supplier.first.supplierId,
      'orderPlacedStartDate': startDate,
      'orderPlacedEndDate': endDate
    };
    String queryString = Uri(queryParameters: queryParams).query;

    var url = URLEndPoints.retrive_paginated_orders_url + '?' + queryString;
    print(url);

    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      ordersData = OrdersBaseResponse.fromJson(json.decode(response.body));
    } else {
      print('failed get orders data');
    }

    arrayOrderList = ordersData.data.data;
    return arrayOrderList;
  }

  Future<List<Orders>> _retriveTodayOrders() async {
    final now = DateTime.now();

    var todayStartTime = DateTime(now.year, now.month, now.day);
    var todayEpochStartTime = todayStartTime.millisecondsSinceEpoch / 1000;
    var todayStartDate = todayEpochStartTime
        .toString()
        .replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");

    var todayEndTime = DateTime(now.year, now.month, now.day, 23, 59, 59);
    var todayEpochEndTime = todayEndTime.millisecondsSinceEpoch / 1000;
    var todayEndDate =
        todayEpochEndTime.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");

    LoginResponse user =
        LoginResponse.fromJson(await sharedPref.readData(Constants.login_Info));

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart',
      'mudra': user.mudra,
      'supplierId': user.supplier.first.supplierId
    };

    Map<String, String> queryParams = {
      'supplierId': user.supplier.first.supplierId,
      'orderPlacedStartDate': todayStartDate,
      'orderPlacedEndDate': todayEndDate
    };
    String queryString = Uri(queryParameters: queryParams).query;

    var url = URLEndPoints.retrive_paginated_orders_url + '?' + queryString;
    print(url);

    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      ordersData = OrdersBaseResponse.fromJson(json.decode(response.body));
    } else {
      print('failed get orders data');
    }

    arrayOrderList = ordersData.data.data;
    return arrayOrderList;
  }

  void showAlert(String title, String message) {
    BuildContext dialogContext;
    // set up the button
    Widget okButton = FlatButton(
      child: Text(Constants.txt_ok),
      onPressed: () async {
        // Navigator.pop(context);
        Navigator.of(dialogContext, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    BasicDialogAlert alert = BasicDialogAlert(
      title: Text(title),
      content: Text(message),
      actions: [okButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        dialogContext = context;
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return new Scaffold(
      appBar: new AppBar(
          centerTitle: false,
          title: appBarTitle,
          backgroundColor: faintGrey,
          elevation: 0,
          actions: <Widget>[
            new IconButton(
              icon: actionIcon,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new SearchOrderPage()));
              },
            ),
          ]),
      floatingActionButton: new FloatingActionButton.extended(
        backgroundColor: buttonBlue,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new OutletSelectionPage()));
        },
        icon: Icon(
          Icons.add,
          size: 22,
        ),
        elevation: 0,
        label: Text(
          'New order',
          style: TextStyle(fontSize: 16, fontFamily: 'SourceSansProSemiBold'),
        ),
      ),
      body: Container(
        color: faintGrey,
        child: ListView(
          children: [
            banner(context),
            //dots(context),

            draftsHeader(),
            bannerList(),

            Header(),
            tabs(),
            list(),
          ],
        ),
      ),
    );
  }

  Widget banner(context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 13),
      child: FutureBuilder<OrderSummaryResponse>(
          future: orderSummaryData,
          builder: (context, AsyncSnapshot<OrderSummaryResponse> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Text(""));
            } else if (snapshot.hasError) {
              return Center(child: Text('failed to load'));
            } else {
              return Column(
                children: <Widget>[
                  CarouselSlider(
                    //  height: 200,

                    options: CarouselOptions(
                        //autoPlay: true,
                        viewportFraction: 0.9,
                        enableInfiniteScroll: false,
                        aspectRatio: 2.5,
                        initialPage: 0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentIndex = index;
                            print(index);
                            print(reason);
                          });
                        }),

                    items: arra.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              color: Colors.white,
                            ),

                            //        margin: EdgeInsets.all(20),
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            // width: width,
                            //  height: 250.0,
                            child: Column(
                              children: [
                                Container(
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 15),
                                        child: Align(
                                            alignment: Alignment.topLeft,
                                            child: new Text(
                                              currentIndex == 0
                                                  ? "Total orders".toUpperCase()
                                                  : 'East coast team'
                                                      .toUpperCase(),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontFamily:
                                                      "SourceSansProBold"),
                                            )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 30),
                                        child: Align(
                                            alignment: Alignment.topLeft,
                                            child: new Text(
                                              currentIndex == 0
                                                  ? 'S\$' +
                                                          snapshot.data.data
                                                              .totalSpendingCurrMonth
                                                              .toString() ??
                                                      ""
                                                  : '',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 30,
                                                  fontFamily:
                                                      "SourceSansProBold"),
                                            )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 70),
                                        child: Align(
                                            alignment: Alignment.topLeft,
                                            child: new Text(
                                              "this month",
                                              style: TextStyle(
                                                  color: greyText,
                                                  fontSize: 14,
                                                  fontFamily:
                                                      "SourceSansProSemiBold"),
                                            )),
                                      ),

                                      /*
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 240, top: 40, right: 20),
                                    child: Container(
                                      // alignment: Alignment.centerRight,
                                      height: 48,
                                      width: 120,
                                      // color: Colors.yellow,

                                      decoration: BoxDecoration(
                                          color: greyText,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(24))),

                                      child: FlatButton(
                                        onPressed: () {
                                          print('set a goal tapped.');
                                        },
                                        color: faintGrey,
                                        child: new Text(
                                          "Set a goal",
                                          style: TextStyle(
                                              color: buttonBlue,
                                              fontSize: 16,
                                              fontFamily: "SourceSansProSemiBold"),
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(24)),
                                      ),
                                    ),
                                  ),*/

                                      Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20, top: 110),
                                          child: Container(
                                            height: 1,
                                            color: faintGrey,
                                          )),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 10, top: 120),
                                          child: Container(
                                            height: 30,
                                            //color: faintGrey,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  (snapshot.data.data
                                                              .todayPendingDeliveries >
                                                          0)
                                                      ? snapshot.data.data
                                                              .todayPendingDeliveries
                                                              .toString() +
                                                          ' deliveries today'
                                                      : 'No deliveries today',
                                                  style: TextStyle(
                                                      color: greyText,
                                                      fontSize: 14,
                                                      fontFamily:
                                                          "SourceSansProSemiBold"),
                                                ),
                                                FlatButton(
                                                  onPressed: () {
                                                    print(
                                                        'view deliveries tapped');

                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                DeliveriesPage()));
                                                  },
                                                  child: Text(
                                                    'View deliveries',
                                                    style: TextStyle(
                                                        color: buttonBlue,
                                                        fontFamily:
                                                            "SourceSansProRegular",
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }).toList(),
                  )
                ],
              );
            }
          }),
    );
  }

  Widget dots(context) {
    return Container(
      height: 20,
      color: faintGrey,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: arra.map((url) {
            int index = arra.indexOf(url);
            return Container(
              width: 6,
              height: 6,
              margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentIndex == index ? buttonBlue : greyText),
            );
          }).toList()),
    );
  }

  Widget leadingImage(Orders order) {
    if (order.outlet.logoURL != null && order.outlet.logoURL.isNotEmpty) {
      return Container(
          height: 40.0,
          width: 40.0,
         child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Image.network(order.outlet.logoURL, fit: BoxFit.fill,),
          )
    );
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
            outletPlaceholder(order.outlet.outletName),
            style: TextStyle(fontSize: 14, fontFamily: "SourceSansProSemiBold"),
          ),
        ),
      );
    }
  }

  String outletPlaceholder(String name) {
    Constants value = Constants();
    var placeholder = value.getInitialWords(name);
    return placeholder;
  }

  Widget draftsHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, top: 20, right: 15),
      child: Container(
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Continue ordering',
              style: TextStyle(fontFamily: 'SourceSansProBold', fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget bannerList() {
    return FutureBuilder<List<Orders>>(
        future: draftOrdersFuture,
        builder: (BuildContext context, AsyncSnapshot<List<Orders>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else if (snapshot.hasError) {
            return Center(child: Text('failed to load'));
          } else {
            return SizedBox(
              height: 90,
              child: ListView.builder(
                  itemCount: snapshot.data.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    bool last = 5 == (index + 1);
                    bool first = -1 == (index - 1);
                    bool second = 0 == (index - 1);
                    return Padding(
                      padding:
                          first ? EdgeInsets.only(left: 15) : EdgeInsets.all(0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => new MarketListPage(
                                        snapshot.data[index].outlet.outletId,
                                        snapshot.data[index].outlet.outletName,null,
                                      )));
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: last
                                  ? EdgeInsets.only(right: 15)
                                  : EdgeInsets.all(0),
                              child: Container(

                                  //  padding: last ? EdgeInsets.only(left: 20): null,
                                  width: 180,
                                  height: 70,
                                  margin: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 12,
                                              top: 15.0,
                                            ),
                                            child: leadingImage(snapshot.data[index]),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                  top: 12,
                                                  right: 15),
                                              child: Text(
                                                snapshot.data[index].outlet
                                                    .outletName,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily:
                                                      'SourceSansProRegular',
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            );
          }
        });
  }

  Widget Header() {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, top: 20, right: 15),
      child: Container(
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent orders',
              style: TextStyle(fontFamily: 'SourceSansProBold', fontSize: 18),
            ),
            FlatButton(
              onPressed: () {
                print('View all orders tapped');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewOrdersPage(null)));
              },
              child: Text(
                'View all orders',
                style: TextStyle(
                    color: buttonBlue,
                    fontFamily: "SourceSansProRegular",
                    fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget tabs() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: DefaultTabController(
        length: 2,
        child: Container(
          height: 50.0,
          decoration: BoxDecoration(
              //This is for background color
              color: Colors.white,
              //This is for bottom border that is needed
              border: Border(bottom: BorderSide(color: faintGrey, width: 1.5))),
          child: new TabBar(
            indicatorColor: Colors.black,
            unselectedLabelColor: greyText,
            labelColor: Colors.black,
            labelStyle:
                TextStyle(fontFamily: 'SourceSansProBold', fontSize: 14),
            tabs: [
              Tab(
                text: "Today",
              ),
              Tab(
                text: "Yesterday",
              ),
            ],
            onTap: (index) {
              print('Tab index $index');
              setState(() {
                if (index == 0) {
                  selectedTab = "Today";
                } else {
                  selectedTab = "Yesterday";
                }
              });
            },
          ),
        ),
      ),
    );
  }

  String readTimestamp(int timestamp) {
    var date1 = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var formattedDate = DateFormat('E d MMM').format(date1);

    return formattedDate;
  }

  Widget list() {
    return Column(
      children: [
        FutureBuilder<List<Orders>>(
            future:
                selectedTab == "Today" ? ordersListToday : ordersListYesterday,
            builder:
                (BuildContext context, AsyncSnapshot<List<Orders>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('failed to load'));
              } else {
                // if (snapshot.data == null) {
                //   return Center(child: Text('loading...'),);
                // } else {
                //   child:
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new Column(children: <Widget>[
                      ListTile(
                        title: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            snapshot.data[index].outlet.outletName,
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: "SourceSansProSemiBold"),
                          ),
                        ),
                        isThreeLine: true,
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ImageIcon(
                                    AssetImage("assets/images/Truck-black.png"),
                                    size: 14,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    readTimestamp(
                                        snapshot.data[index].timeDelivered),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: "SourceSansProRegular",
                                        color: Colors.black),
                                  ),

                                  SizedBox(width: 5),
                                  Flexible(
                                    child: Text(snapshot.data[index].orderId,
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontFamily: "SourceSansProRegular",
                                            color: greyText),
                                        maxLines: 1),
                                  ),

                                  SizedBox(width: 5),
                                  if (snapshot.data[index].isAcknowledged !=
                                      null)
                                    Container(
                                      width: snapshot.data[index].isAcknowledged
                                          ? 12
                                          : 0,
                                      child: InkResponse(
                                        child: Image.asset(
                                          "assets/images/icon-tick-green.png",
                                          width: 12,
                                          height: 12,
                                        ),
                                      ),
                                    ),

                                  //Icon(Icons.navigate_next, size: 12,),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 80.0, right: 0),
                                    child: Container(
                                      child: Text(
                                          'S\$' +
                                              snapshot.data[index].amount.total
                                                  .amountV1
                                                  .toString(),
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily:
                                                  "SourceSansProRegular",
                                              color: Colors.black)),
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 2.0, bottom: 10),
                                child: Container(
                                  height: (snapshot.data[index].orderStatus ==
                                              "Void" ||
                                          snapshot.data[index].orderStatus ==
                                              "Cancelled" ||
                                          snapshot.data[index].orderStatus ==
                                              "Invoiced")
                                      ? 20
                                      : 0,
                                  //  margin: EdgeInsets.symmetric(horizontal: 5.0),

                                  // color: Colors.blue,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width:
                                            (snapshot.data[index].orderStatus ==
                                                    "Void")
                                                ? 50
                                                : 0,
                                        margin:
                                            EdgeInsets.fromLTRB(0, 0, 10, 0),

                                        decoration: BoxDecoration(
                                            color: warningRed,
                                            // border: Border.all(
                                            //   color: Colors.red[500],
                                            // ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Center(
                                          child: Text(
                                            '  Voided  '.toUpperCase(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontFamily:
                                                    "SourceSansProSemiBold"),
                                          ),
                                        ),
                                        //  color: Colors.grey,
                                      ),
                                      Container(
                                        width:
                                            (snapshot.data[index].orderStatus ==
                                                    "Cancelled")
                                                ? 50
                                                : 0,
                                        margin:
                                            EdgeInsets.fromLTRB(0, 0, 10, 0),
                                        decoration: BoxDecoration(
                                            color: warningRed,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Text(
                                          '  cancelled  '.toUpperCase(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontFamily:
                                                  "SourceSansProSemiBold"),
                                        ),
                                      ),
                                      Container(
                                        width:
                                            (snapshot.data[index].orderStatus ==
                                                    "Invoiced")
                                                ? 50
                                                : 0,
                                        decoration: BoxDecoration(
                                            color: lightGreen,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Text(
                                            '  Invoiced  '.toUpperCase(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontFamily:
                                                    "SourceSansProSemiBold")),
                                        // color: Colors.pink,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        //profile.imgUrl == null) ? AssetImage('images/user-avatar.png') : NetworkImage(profile.imgUrl)
                        leading: leadingImage(snapshot.data[index]),

                        tileColor: Colors.white,
                        onTap: () {
                          print('item tapped $index');
                          moveToOrderDetailsPage(snapshot.data[index]);
                        },
                      ),
                      // ListTile(
                      //
                      // ),
                      Divider(
                        height: 1.5,
                        color: faintGrey,
                      ),
                    ]);
                  },
                );
              }
            }),
      ],
    );
  }

  moveToOrderDetailsPage(Orders element) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => new OrderDetailsPage(element)));
  }
}
