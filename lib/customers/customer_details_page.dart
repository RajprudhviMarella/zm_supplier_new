import 'dart:convert';

import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:zm_supplier/invoices/invoices_page.dart';
import 'package:zm_supplier/models/buyerUserResponse.dart';
import 'package:zm_supplier/models/invoicesResponse.dart';
import 'package:zm_supplier/models/orderSummary.dart';
import 'package:zm_supplier/models/ordersResponseList.dart';
import 'package:zm_supplier/models/outletResponse.dart';
import 'package:zm_supplier/models/response.dart';
import 'package:zm_supplier/models/user.dart';
import 'package:zm_supplier/orders/orderDetailsPage.dart';
import 'package:zm_supplier/orders/viewOrder.dart';
import 'package:zm_supplier/services/favouritesApi.dart';
import 'package:zm_supplier/utils/color.dart';
import 'package:zm_supplier/utils/constants.dart';
import 'package:zm_supplier/utils/eventsList.dart';
import 'package:zm_supplier/utils/urlEndPoints.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';

class CustomerDetailsPage extends StatefulWidget {
  final outletName;
  final outletId;
  final lastOrderd;
  bool isStarred;

  CustomerDetailsPage(
      this.outletName, this.outletId, this.lastOrderd, this.isStarred);

  @override
  State<StatefulWidget> createState() => new CustomerDetailsState(
      this.outletName, this.outletId, this.lastOrderd, this.isStarred);
}

class CustomerDetailsState extends State<CustomerDetailsPage> {
  final outletName;
  final outletId;
  final lastOrderd;
  bool isStarred;

  final globalKey = new GlobalKey<ScaffoldState>();

  ApiResponse specificUserInfo;
  dynamic userProperties;
  OrderSummaryResponse summaryData;
  Future<SummaryData> orderSummaryData;
  LoginResponse userResponse;

  InvoiceSummaryResponse invoicesData;
  Future<InvoiceSummaryData> invoicesSummaryData;

  OrdersBaseResponse ordersData;
  Future<List<Orders>> recentOrders;
  List<Orders> arrayRecentOrderList;

  BuyerUserResponse buyerResponse;
  List<BuyerDetails> buyerDetails;
  Future<List<BuyerDetails>> buyerDetailsFuture;

  SharedPref sharedPref = SharedPref();
  LoginResponse userData;

  CustomerDetailsState(
      this.outletName, this.outletId, this.lastOrderd, this.isStarred);

  Constants events = Constants();
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();

    events.mixPanelEvents();
    buyerDetailsFuture = _retrivePeople();
    orderSummaryData = getSummaryDataApiCalling();
    recentOrders = _retriveRecentOrders();
    invoicesSummaryData = _retriveInvoicesSummary();
  }

  Future<SummaryData> getSummaryDataApiCalling() async {
    userData =
        LoginResponse.fromJson(await sharedPref.readData(Constants.login_Info));

    specificUserInfo = ApiResponse.fromJson(
        await sharedPref.readData(Constants.specific_user_info));
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart',
      'mudra': userData.mudra,
      'supplierId': userData.supplier.first.supplierId
    };

    Map<String, String> queryParams = {'outletId': outletId};

    String queryString = Uri(queryParameters: queryParams).query;

    var url = URLEndPoints.order_summary_url + '?' + queryString;

    // print(url);
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      // summaryData = OrderSummaryResponse.fromJson(json.decode(response.body));
      Map results = jsonDecode(response.body);

      summaryData = OrderSummaryResponse.fromJson(results);
    } else {
      print('failed get summary data');
    }
    return summaryData.data;
  }

  Future<InvoiceSummaryData> _retriveInvoicesSummary() async {
    userData =
        LoginResponse.fromJson(await sharedPref.readData(Constants.login_Info));

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart',
      'mudra': userData.mudra,
      'supplierId': userData.supplier.first.supplierId
    };

    Map<String, String> queryParams = {
      'supplierId': userData.supplier.first.supplierId,
      'outletId': outletId
    };

    String queryString = Uri(queryParameters: queryParams).query;

    var url = URLEndPoints.retrive_invoices_summary + '?' + queryString;
    print(url);

    print(headers);
    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      invoicesData =
          InvoiceSummaryResponse.fromJson(json.decode(response.body));
    } else {
      print('failed get invoices summary data');
    }

    return invoicesData.data;
  }

  Future<List<Orders>> _retriveRecentOrders() async {
    userData =
        LoginResponse.fromJson(await sharedPref.readData(Constants.login_Info));

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart',
      'mudra': userData.mudra,
      'supplierId': userData.supplier.first.supplierId
    };

    Map<String, String> queryParams = {
      'supplierId': userData.supplier.first.supplierId,
      'outletId': outletId
    };
    String queryString = Uri(queryParameters: queryParams).query;

    var url = URLEndPoints.retrive_paginated_orders_url + '?' + queryString;
    print(url);

    print(headers);
    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      ordersData = OrdersBaseResponse.fromJson(json.decode(response.body));
    } else {
      print('failed get orders data');
    }

    arrayRecentOrderList = ordersData.data.data;
    arrayRecentOrderList = arrayRecentOrderList.take(5).toList();
    return arrayRecentOrderList;
  }

  Future<List<BuyerDetails>> _retrivePeople() async {
    userData =
        LoginResponse.fromJson(await sharedPref.readData(Constants.login_Info));
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart',
      'mudra': userData.mudra,
      'supplierId': userData.supplier.first.supplierId
    };

    Map<String, String> queryParams = {'outletId': outletId};
    String queryString = Uri(queryParameters: queryParams).query;

    var url = URLEndPoints.buyer_people_url + '?' + queryString;
    print(url);

    print(headers);
    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      print('retrived people');
      print(response.body);
      buyerResponse = BuyerUserResponse.fromJson(json.decode(response.body));
      print(buyerResponse.data.data.length);
    } else {
      print('failed get people');
    }

    buyerDetails = buyerResponse.data.data;
    return buyerDetails;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: globalKey,
        backgroundColor: faintGrey,
        appBar: buildAppBar(context),
        body: RefreshIndicator(
            key: refreshKey,
            child: ListView(
              children: <Widget>[
                orderSummaryBanner(),
                InvocesPanel(),
                headers(context),
                header(context),
              ],
            ),
            color: azul_blue,
            onRefresh: refreshList));
  }

  Future<Null> refreshList() async {
    print("refreshing");
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 0));

    setState(() {
      buyerDetailsFuture = _retrivePeople();
      orderSummaryData = getSummaryDataApiCalling();
      recentOrders = _retriveRecentOrders();
      invoicesSummaryData = _retriveInvoicesSummary();
    });

    return null;
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(
        backgroundColor: faintGrey,
        centerTitle: true,
        title: Column(children: [
          Text(
            outletName,
            style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: 'SourceSansProBold'),
          ),
          Text(lastOrderd,
              style: TextStyle(
                  color: greyText,
                  fontSize: 12,
                  fontFamily: 'SourceSansProRegular'))
        ]),
        bottomOpacity: 0.0,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(isStarred),
        ),
        actions: <Widget>[
          IconButton(
            icon: checkStarred(),
            onPressed: () {
              tapOnFavourite();
              // do something
            },
          ),
        ]);
  }

  Widget orderSummaryBanner() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 16, right: 16),
      child: FutureBuilder<SummaryData>(
          future: orderSummaryData,
          builder: (context, AsyncSnapshot<SummaryData> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Text(""));
            } else if (snapshot.hasError) {
              return Center(child: Text('failed to load'));
            } else {
              return Container(
                child: Stack(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 35.0),
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: Text(
                              'Orders this month',
                              style: TextStyle(
                                  color: buttonBlue,
                                  fontSize: 14,
                                  fontFamily: 'SourceSansProSemiBold'),
                            ),
                          ),
                          Text(
                            '\$' +
                                    snapshot.data.totalSpendingCurrMonth
                                        .toStringAsFixed(2)
                                        .replaceAllMapped(
                                            reg, (Match m) => '${m[1]},') ??
                                "",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontFamily: 'SourceSansProBold'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 20, right: 20),
                            child: Container(
                              height: 2,
                              color: faintGrey,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 16, left: 50.0, right: 50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'Last month',
                                      style: TextStyle(
                                          color: greyText,
                                          fontSize: 14,
                                          fontFamily: 'SourceSansProRegular'),
                                    ),
                                    Text(
                                      '\$' +
                                              snapshot
                                                  .data.totalSpendingLastMonth
                                                  .toStringAsFixed(2)
                                                  .replaceAllMapped(
                                                      reg,
                                                      (Match m) =>
                                                          '${m[1]},') ??
                                          "",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontFamily: 'SourceSansProBold'),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      '2 months ago',
                                      style: TextStyle(
                                          color: greyText,
                                          fontSize: 14,
                                          fontFamily: 'SourceSansProRegular'),
                                    ),
                                    Text(
                                      '\$' +
                                              snapshot.data
                                                  .totalSpendingLastTwoMonths
                                                  .toStringAsFixed(2)
                                                  .replaceAllMapped(
                                                      reg,
                                                      (Match m) =>
                                                          '${m[1]},') ??
                                          "",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontFamily: 'SourceSansProBold'),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: 70,
                      width: 70,
                      child: new Image(
                        image: new AssetImage('assets/images/orders_icon.png'),
                        width: 70,
                        height: 70,
                        color: null,
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                ]),
              );
            }
          }),
    );
  }

  Widget checkStarred() {
    if (isStarred) {
      Widget icon = new Image(
        image: new AssetImage('assets/images/Star_yellow.png'),
        width: 25,
        height: 25,
        color: null,
        fit: BoxFit.scaleDown,
        alignment: Alignment.center,
      );
      return icon;
    } else {
      Widget icon = new Image(
        image: new AssetImage('assets/images/Star_light_grey.png'),
        width: 25,
        height: 25,
        color: null,
        fit: BoxFit.scaleDown,
        alignment: Alignment.center,
      );
      return icon;
    }
  }

  Widget InvocesPanel() {
    return FutureBuilder<InvoiceSummaryData>(
        future: invoicesSummaryData,
        builder: (context, AsyncSnapshot<InvoiceSummaryData> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text(""));
          } else if (snapshot.hasError) {
            return Center(child: Text('failed to load'));
          } else {
            return Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 15),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        var selectedFilters = ['Not yet due', 'Overdue'];

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InvoicesPage(
                                    outletId, outletName, selectedFilters)));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                Image(
                                  image: new AssetImage(
                                      'assets/images/invoices_icon.png'),
                                  width: 50,
                                  height: 50,
                                  color: null,
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.center,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Unpaid invoices',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: buttonBlue,
                                          fontFamily: 'SourceSansProSemiBold'),
                                    ),
                                    Text(
                                      '\$' +
                                              snapshot.data.totalUnpaid
                                                  .toStringAsFixed(2)
                                                  .replaceAllMapped(
                                                      reg,
                                                      (Match m) =>
                                                          '${m[1]},') ??
                                          "",
                                      style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.black,
                                          fontFamily: 'SourceSansProBold'),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Container(
                        height: 2,
                        color: faintGrey,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20.0, top: 15, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Container(
                          //   width: MediaQuery.of(context).size.width * 0.5,
                          //   height: 50,
                          //   color: Colors.yellow,
                          // )

                          GestureDetector(
                            onTap: () {
                              var selectedFilters = ['Overdue'];
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => InvoicesPage(
                                          outletId,
                                          outletName,
                                          selectedFilters)));
                            },
                            child: Row(
                              children: [
                                Text(
                                    '\$' +
                                            snapshot.data.totalOverDue
                                                .toStringAsFixed(2)
                                                .replaceAllMapped(reg,
                                                    (Match m) => '${m[1]},') ??
                                        "",
                                    style: TextStyle(
                                        fontFamily: "SourceSansProBold",
                                        fontSize: 18,
                                        color: warningRed)),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('overdue',
                                    style: TextStyle(
                                        fontFamily: "SourceSansProRegular",
                                        fontSize: 14,
                                        color: warningRed))
                              ],
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                List<String> selectedFilters = [];
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => InvoicesPage(
                                            outletId,
                                            outletName,
                                            selectedFilters)));
                              },
                              child: Text(
                                'View all invoices',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: buttonBlue,
                                    fontFamily: 'SourceSansProRegular'),
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        });
  }

  Widget headers(context) {
    return StickyHeader(
      header: Container(
        color: faintGrey,
        margin: EdgeInsets.only(top: 0.0),
        padding: EdgeInsets.only(left: 16.0, right: 3, top: 10, bottom: 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent orders',
                style: TextStyle(
                  fontFamily: "SourceSansProBold",
                  fontSize: 18,
                )),
            new RaisedButton(
              color: Colors.transparent,
              elevation: 0,
              onPressed: () {
                events.mixpanel
                    .track(Events.TAP_CUSTOMERS_OUTLET_DETAILS_VIEW_ALL_ORDERS);
                events.mixpanel.flush();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewOrdersPage(outletId)));
              },
              child: new Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(width: 5),
                  new Text(
                    'View all orders',
                    style: TextStyle(
                        color: buttonBlue,
                        fontSize: 12,
                        fontFamily: 'SourceSansProRegular'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      content: Container(child: list()),
    );
  }

  Widget header(context) {
    return StickyHeader(
      header: Container(
        color: faintGrey,
        margin: EdgeInsets.only(top: 10.0),
        padding:
            EdgeInsets.only(left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('People',
                style: TextStyle(
                  fontFamily: "SourceSansProBold",
                  fontSize: 18,
                )),
            Text(
              ' (active for last 180 days)',
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'SourceSansProRegular',
                  color: greyText),
            )
          ],
        ),
      ),
      content: Container(
        child: peopleList(),
      ),
    );
  }

  String readTimestamp(int timestamp) {
    var date1 = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var formattedDate = DateFormat('E d MMM').format(date1);

    return formattedDate;
  }

  String displayAmount(Orders order) {
    if (order.orderStatus == 'Void' ||
        order.orderStatus == 'Cancelled' ||
        order.orderStatus == 'Invoiced') {
      return '';
    } else {
      return order.amount.total.getDisplayValue();
    }
  }

  Widget list() {
    return Column(
      children: [
        FutureBuilder<List<Orders>>(
            future: recentOrders,
            builder:
                (BuildContext context, AsyncSnapshot<List<Orders>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: SpinKitThreeBounce(
                  color: Colors.blueAccent,
                  size: 24,
                ));
              } else if (snapshot.hasError) {
                return Center(child: Text('failed to load'));
              } else {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData &&
                    snapshot.data.isNotEmpty) {
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
                            //  isThreeLine: true,

                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ImageIcon(
                                        AssetImage(
                                            "assets/images/Truck-black.png"),
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
                                        child: Text(
                                            snapshot.data[index].orderId,
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                fontFamily:
                                                    "SourceSansProRegular",
                                                color: greyText),
                                            maxLines: 1),
                                      ),
                                      Spacer(),
                                      Text(displayAmount(snapshot.data[index])),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 2.0, bottom: 10),
                                    child: Container(
                                      height:
                                          (snapshot.data[index].orderStatus ==
                                                      "Void" ||
                                                  snapshot.data[index]
                                                          .orderStatus ==
                                                      "Cancelled" ||
                                                  snapshot.data[index]
                                                          .orderStatus ==
                                                      "Invoiced")
                                              ? 20
                                              : 0,
                                      //  margin: EdgeInsets.symmetric(horizontal: 5.0),

                                      // color: Colors.blue,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: (snapshot.data[index]
                                                        .orderStatus ==
                                                    "Void")
                                                ? 50
                                                : 0,
                                            margin:
                                                EdgeInsets.fromLTRB(0, 0, 0, 0),

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
                                            width: (snapshot.data[index]
                                                        .orderStatus ==
                                                    "Cancelled")
                                                ? 70
                                                : 0,
                                            margin: EdgeInsets.fromLTRB(
                                                0, 0, 10, 0),
                                            decoration: BoxDecoration(
                                                color:
                                                    warningRed.withOpacity(0.5),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            child: Center(
                                              child: Text(
                                                '  cancelled  '.toUpperCase(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontFamily:
                                                        "SourceSansProSemiBold"),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: (snapshot.data[index]
                                                        .orderStatus ==
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
                                          ),
                                          Spacer(),
                                          Text(
                                              snapshot.data[index].amount.total
                                                  .getDisplayValue(),
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.black,
                                                  fontFamily:
                                                      "SourceSansProRegular")),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // trailing: Column(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   crossAxisAlignment: CrossAxisAlignment.center,
                            //   children: [
                            //     Text(
                            //         snapshot.data[index].amount.total
                            //             .getDisplayValue(),
                            //         style: TextStyle(
                            //             fontSize: 16.0,
                            //             color: Colors.black,
                            //             fontFamily: "SourceSansProRegular")),
                            //   ],
                            // ),

                            //profile.imgUrl == null) ? AssetImage('images/user-avatar.png') : NetworkImage(profile.imgUrl)
                            leading: leadingImage(snapshot.data[index]),
                            tileColor: Colors.white,
                            onTap: () {
                              moveToOrderDetailsPage(snapshot.data[index]);
                            }),
                        Divider(
                          height: 1.5,
                          color: faintGrey,
                        ),
                      ]);
                    },
                  );
                } else {
                  return Container(
                    color: Colors.white,
                    height: 230,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Image(
                            image: new AssetImage(
                                'assets/images/no_orders_icon.png'),
                            width: 70,
                            height: 70,
                            color: null,
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.center,
                          ),
                        ),
                        // ImageIcon(AssetImage('assets/images/orders_icon.png')),
                        SizedBox(height: 10),
                        Text(
                          'No orders',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'SourceSansProRegular',
                              color: greyText),
                        ),
                      ],
                    ),
                  );
                }
              }
            }),
      ],
    );
  }

  moveToOrderDetailsPage(Orders element) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => new OrderDetailsPage(element)));
  }

  String timestamp(int timestamp) {
    var date1 = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var formattedDate = DateFormat('yyyy-MM-dd').format(date1);

    return formattedDate;
  }

  String timeDiff(int timeStamp) {
    final birthday = DateTime.parse(timestamp(timeStamp));
    final date2 = DateTime.now();
    final difference = date2.difference(birthday).inDays;
    return dispalyTime(difference);
  }

  String dispalyTime(int diff) {
    if (diff == 0) {
      return 'Last ordered today';
    } else if (diff == 1) {
      return 'Last ordered yesterday';
    } else {
      return 'Last ordered ' + diff.toString() + ' days ago' ?? "";
    }
  }

  Widget leadingImage(Orders img) {
    if (img.outlet.logoURL != null && img.outlet.logoURL.isNotEmpty) {
      return Container(
          height: 38.0,
          width: 38.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Image.network(
              img.outlet.logoURL,
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
            outletPlaceholder(img.outlet.outletName),
            style: TextStyle(fontSize: 14, fontFamily: "SourceSansProSemiBold"),
          ),
        ),
      );
    }
  }

  tapOnFavourite() {
    if (isStarred) {
      setState(() {
        isStarred = false;
        userProperties = {
          "userName": specificUserInfo.data.fullName,
          "email": userData.user.email,
          "userId": userData.user.userId,
          "isFavourite": false
        };

        events.mixpanel.track(Events.TAP_CUSTOMERS_OUTLET_DETAILS_FAVOURITE,
            properties: userProperties);
        events.mixpanel.flush();
        globalKey.currentState
          ..showSnackBar(
            SnackBar(
              content: Text('Removed from starred'),
              duration: Duration(seconds: 1),
            ),
          );
      });
    } else {
      setState(() {
        isStarred = true;
        userProperties = {
          "userName": specificUserInfo.data.fullName,
          "email": userData.user.email,
          "userId": userData.user.userId,
          "isFavourite": true
        };
        events.mixpanel.track(Events.TAP_CUSTOMERS_OUTLET_DETAILS_FAVOURITE,
            properties: userProperties);
        events.mixpanel.flush();
        globalKey.currentState.showSnackBar(
          SnackBar(
            content: Text('Added to starred'),
            duration: Duration(seconds: 1),
          ),
        );
      });
    }

    FavouritesApi favourite = new FavouritesApi();
    favourite
        .updateFavourite(userData.mudra, userData.supplier.first.supplierId,
            outletId, isStarred)
        .then((value) async {
      DartNotificationCenter.post(channel: Constants.favourite_notifier);
    });
  }

  Widget peopleList() {
    return Column(children: [
      FutureBuilder<List<BuyerDetails>>(
          future: buyerDetailsFuture,
          builder: (BuildContext context,
              AsyncSnapshot<List<BuyerDetails>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(); // Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('failed to load'));
            } else {
              return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new Column(children: <Widget>[
                      ListTile(
                        tileColor: Colors.white,
                        title: Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            snapshot.data[index].firstName,
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'SourceSansProSemiBold',
                                color: Colors.black),
                          ),
                        ),

                        subtitle: Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            timeDiff(snapshot.data[index].lastOrdered),
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'SourceSansProRegular',
                                color: greyText),
                          ),
                        ),

                        trailing: trailingIcon(snapshot.data[index]),

                        onTap: () {
                          _moreActionBottomSheet(snapshot.data[index]);
                        },
                        //subtitle: Text(timeDiff(snapshot.data[index])),
                      ),
                      Divider(
                        height: 1,
                        color: faintGrey,
                      )
                    ]);
                  });
            }
          }),
    ]);
  }

  Widget trailingIcon(BuyerDetails userInfo) {
    if (userInfo.email != null && userInfo.phone != null) {
      return Wrap(
        spacing: 10, // space between two icons
        children: <Widget>[
          // Image(image: AssetImage("assets/images/Sort-blue.png"),),
          GestureDetector(
            onTap: () {
              showActionSheet(userInfo.email);
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: faintGrey,
              ),
              child: Center(
                child: Image(
                  image: AssetImage("assets/images/email_grey.png"),
                  height: 22,
                  width: 22,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              showActionSheetPhone(userInfo.phone);
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: faintGrey,
              ),
              child: Center(
                child: Image(
                  image: AssetImage("assets/images/phone-grey.png"),
                  height: 22,
                  width: 22,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Image(
        image: AssetImage("assets/images/email_grey.png"),
        height: 22,
        width: 22,
      );
    }
  }

  void _moreActionBottomSheet(BuyerDetails details) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                Container(
                  height: 40,
                  child: new ListTile(
                      title: new Text(
                        details.firstName,
                        style: TextStyle(
                            fontSize: 14, fontFamily: 'SourceSansProSemibold'),
                      ),
                      onTap: () => {}),
                ),
                Container(
                  height: 40,
                  child: new ListTile(
                      title: new Text(details.email,
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'SourceSansProRegular')),
                      onTap: () => {showActionSheet(details.email)}),
                ),
                Divider(
                  thickness: 1,
                  color: faintGrey,
                ),
                if (details.phone != null && details.phone.isNotEmpty)
                  // Container(
                  //   height: 40,
                  //   color: Colors.yellow,
                  //   child: Row(
                  //     children: [
                  //       new ListTile(
                  //         title: new Text(details.phone,
                  //             style: TextStyle(
                  //                 fontSize: 16, fontFamily: 'SourceSansProRegular')),
                  //         onTap: () => {
                  //           // moveToOrderActivityPage(order)
                  //           showActionSheetPhone(details.phone)
                  //         },
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  GestureDetector(
                    child: Container(
                      color: Colors.white,
                      margin: EdgeInsets.fromLTRB(17, 0, 17, 0),
                      height: 40,
                      child: Row(
                        children: [
                          // Image.asset(
                          //   'assets/images/icon_close-red.png',
                          //   width: 22,
                          //   height: 22,
                          // ),
                          // SizedBox(
                          //   width: 10,
                          // ),
                          Text(
                            details.phone,
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'SourceSansProRegular'),
                          ),
                        ],
                      ),
                    ),
                    onTap: () => {showActionSheetPhone(details.phone)},
                  ),
                Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 10)),
              ],
            ),
          );
        });
  }

  Widget showActionSheet(String email) {
    showAdaptiveActionSheet(
      context: context,
      title: Text(email,
          style: TextStyle(
              color: greyText,
              fontSize: 14,
              fontFamily: 'SourceSansProSemiBold')),
      actions: <BottomSheetAction>[
        // BottomSheetAction(title: const Text('Email'), onPressed: () {}),
        // BottomSheetAction(title: const Text('Email using Gmail'), onPressed: () {}),
        BottomSheetAction(
            title: Text('Copy address',
                style: TextStyle(
                    color: buttonBlue,
                    fontSize: 20,
                    fontFamily: 'SourceSansProRegular')),
            onPressed: () {
              Clipboard.setData(new ClipboardData(text: email));
              Navigator.of(context, rootNavigator: true).pop();
            }),
      ],
      cancelAction: CancelAction(
          title: Text('Cancel',
              style: TextStyle(
                  color: buttonBlue,
                  fontSize: 20,
                  fontFamily:
                      'SourceSansProSemiBold'))), // onPressed parameter is optional by default will dismiss the ActionSheet
    );
  }

  Widget showActionSheetPhone(String phone) {
    showAdaptiveActionSheet(
      context: context,
      title: Text(phone,
          style: TextStyle(
              color: greyText,
              fontSize: 14,
              fontFamily: 'SourceSansProSemiBold')),
      actions: <BottomSheetAction>[
        // BottomSheetAction(title: const Text('Call'), onPressed: () {}),
        // BottomSheetAction(title: const Text('Message'), onPressed: () {}),
        BottomSheetAction(
            title: Text('Copy number',
                style: TextStyle(
                    color: buttonBlue,
                    fontSize: 20,
                    fontFamily: 'SourceSansProRegular')),
            onPressed: () {
              Clipboard.setData(new ClipboardData(text: phone));
              Navigator.of(context, rootNavigator: true).pop();
            }),
      ],
      cancelAction: CancelAction(
          title: Text('Cancel',
              style: TextStyle(
                  color: buttonBlue,
                  fontSize: 20,
                  fontFamily:
                      'SourceSansProSemiBold'))), // onPressed parameter is optional by default will dismiss the ActionSheet
    );
  }

  String outletPlaceholder(String name) {
    Constants value = Constants();
    var placeholder = value.getInitialWords(name);
    return placeholder;
  }

  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
}
