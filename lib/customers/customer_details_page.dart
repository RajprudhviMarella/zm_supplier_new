import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zm_supplier/models/buyerUserResponse.dart';
import 'package:zm_supplier/models/orderSummary.dart';
import 'package:zm_supplier/models/orderSummary.dart';
import 'package:zm_supplier/models/ordersResponseList.dart';
import 'package:zm_supplier/models/outletResponse.dart';
import 'package:zm_supplier/models/user.dart';
import 'package:zm_supplier/orders/viewOrder.dart';
import 'package:zm_supplier/services/favouritesApi.dart';
import 'package:zm_supplier/utils/color.dart';
import 'package:zm_supplier/utils/constants.dart';
import 'package:zm_supplier/utils/urlEndPoints.dart';

import 'package:http/http.dart' as http;

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

  OrderSummaryResponse summaryData;
  Future<SummaryData> orderSummaryData;
  LoginResponse userResponse;

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

  @override
  void initState() {
    super.initState();
    buyerDetailsFuture = _retrivePeople();
    orderSummaryData = getSummaryDataApiCalling();
    recentOrders = _retriveRecentOrders();
  }

  Future<SummaryData> getSummaryDataApiCalling() async {
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
    // print(url);

    //print(headers);
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
      buyerResponse = BuyerUserResponse.fromJson(json.decode(response.body));
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
      body: ListView(
        children: <Widget>[
          orderSummaryBanner(),
          headers(context),
          list(),
          header(context),
          peopleList()
        ],
      ),
    );
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
      padding: const EdgeInsets.only(top: 30.0, left: 20, right: 20),
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
                                snapshot.data.totalSpendingCurrMonth.toString(),
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
                                          snapshot.data.totalSpendingLastMonth
                                              .toString(),
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
                                          snapshot
                                              .data.totalSpendingLastTwoMonths
                                              .toString(),
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

  Widget headers(context) {
    return Container(
      color: faintGrey,
      margin: EdgeInsets.only(top: 2.0),
      padding:
          EdgeInsets.only(left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
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
    );
  }

  Widget header(context) {
    return Container(
      color: faintGrey,
      margin: EdgeInsets.only(top: 2.0),
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
        ],
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
            future: recentOrders,
            builder:
                (BuildContext context, AsyncSnapshot<List<Orders>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
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
                                      child: Text(snapshot.data[index].orderId,
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontFamily:
                                                  "SourceSansProRegular",
                                              color: greyText),
                                          maxLines: 1),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2.0, bottom: 10),
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
                                          width: (snapshot.data[index]
                                                      .orderStatus ==
                                                  "Cancelled")
                                              ? 70
                                              : 0,
                                          margin:
                                              EdgeInsets.fromLTRB(0, 0, 10, 0),
                                          decoration: BoxDecoration(
                                              color: warningRed,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Center(
                                            child: Text(
                                              '  cancelled  '.toUpperCase(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
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
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                  snapshot.data[index].amount.total
                                      .getDisplayValue(),
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                      fontFamily: "SourceSansProRegular")),
                            ],
                          ),

                          //profile.imgUrl == null) ? AssetImage('images/user-avatar.png') : NetworkImage(profile.imgUrl)
                          leading: leadingImage(snapshot.data[index]),
                          tileColor: Colors.white,
                          onTap: () {}),
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

  String timestamp(int timestamp) {
    var date1 = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var formattedDate = DateFormat('yyyy-MM-dd').format(date1);

    return formattedDate;
  }

  int timeDiff(int timeStamp) {
    final birthday = DateTime.parse(timestamp(timeStamp));
    final date2 = DateTime.now();
    final difference = date2.difference(birthday).inDays;
    return difference;
  }

  Widget leadingImage(Orders img) {
    if (img.outlet.logoURL != null && img.outlet.logoURL.isNotEmpty) {
      return Container(
          height: 40.0,
          width: 40.0,
          decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(
                  fit: BoxFit.fill, image: NetworkImage(img.outlet.logoURL))));
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
        .then((value) async {});
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
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            snapshot.data[index].firstName,
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'SourceSansProSemiBold',
                                color: Colors.black),
                          ),
                        ),

                        subtitle: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            'Last ordered ' +
                                    timeDiff(snapshot.data[index].lastOrdered)
                                        .toString() +
                                    ' days ago' ??
                                "",
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'SourceSansProRegular',
                                color: greyText),
                          ),
                        ),

                        trailing: trailingIcon(snapshot.data[index]),
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
        spacing: 12, // space between two icons
        children: <Widget>[
          // Image(image: AssetImage("assets/images/Sort-blue.png"),),
          Image(
            image: AssetImage("assets/images/phone-grey.png"),
            height: 22,
            width: 22,
          ),
          Image(
            image: AssetImage("assets/images/phone-grey.png"),
            height: 22,
            width: 22,
          ),

          // ImageIcon(AssetImage('assets/images/envolope_grey.png')),
          // Image(image: ImageIcon(AssetImage('assets/images/phone_grey.png')))
          // // Icon(Icons.message),
          // Icon(Icons.call), // icon-1
          // icon-2
        ],
      );
    } else {
      return Wrap(
        spacing: 12, // space between two icons
        children: <Widget>[
          ImageIcon(
            AssetImage('assets/images/envolope_grey.png'),
            size: 22,
          ),
          ImageIcon(
            AssetImage('assets/images/envolope_grey.png'),
            size: 12,
          ),
          //Icon(Icons.message),
          // icon-2
        ],
      );
    }
  }

  String outletPlaceholder(String name) {
    Constants value = Constants();
    var placeholder = value.getInitialWords(name);
    return placeholder;
  }
}
