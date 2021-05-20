import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:zm_supplier/createOrder/market_list_page.dart';
import 'package:zm_supplier/models/ordersResponseList.dart';
import 'package:zm_supplier/models/user.dart';
import 'package:zm_supplier/services/ordersApi.dart';
import 'package:zm_supplier/utils/color.dart';
import 'package:zm_supplier/utils/constants.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:zm_supplier/utils/eventsList.dart';
import 'package:zm_supplier/utils/pdfViewerPage.dart';
import 'package:zm_supplier/utils/customDialog.dart';
import 'dart:math' as math;

import 'package:zm_supplier/utils/webview.dart';

import '../utils/color.dart';
import 'orderActivityPage.dart';
import 'dart:io' show Platform;

class OrderDetailsPage extends StatefulWidget {
  String orderId;
  Orders order;

  OrderDetailsPage(this.order);

  @override
  State<StatefulWidget> createState() {
    return OrderDetailsDesign();
  }
}

class OrderDetailsDesign extends State<OrderDetailsPage>
    with TickerProviderStateMixin {
  Widget appBarTitle = new Text(
    "Order details",
    style: TextStyle(
        color: Colors.black, fontFamily: "SourceSansProBold", fontSize: 18),
  );
  Icon icon = new Icon(
    Icons.more_horiz,
    color: Colors.black,
  );
  final TextEditingController _controller = new TextEditingController();
  final globalKey = new GlobalKey<ScaffoldState>();

  Orders order;
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
  LoginResponse userData;

  String selectedReason = 'Other reason';
  Constants events = Constants();

  @override
  void initState() {
    loadSharedPrefs();
    order = widget.order;
    super.initState();
    events.mixPanelEvents();
  }

  @override
  void dispose() {
    // controller.removeListener(_scrollListener);
    super.dispose();
  }

  SharedPref sharedPref = SharedPref();

  loadSharedPrefs() async {
    try {
      LoginResponse loginResponse = LoginResponse.fromJson(
          await sharedPref.readData(Constants.login_Info));
      setState(() {
        userData = loginResponse;
        if (loginResponse.mudra != null) {
          mudra = loginResponse.mudra;
        }
        if (loginResponse.user.supplier.elementAt(0).supplierId != null) {
          supplierID = loginResponse.user.supplier.elementAt(0).supplierId;
          // ordersList = callRetreiveOrdersAPI();
        }
      });
    } catch (Exception) {
      // do something

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: buildAppBar(context),
      bottomNavigationBar: Container(
          height: 80.0,
          color: Colors.white,
          child: Center(
              child: Container(
                  height: 50,
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Row(children: <Widget>[
                    FloatingActionButton.extended(
                      heroTag: "btn1",
                      backgroundColor: faintGrey,
                      foregroundColor: Colors.white,
                      onPressed: () {
                        events.mixpanel
                            .track(Events.TAP_ORDER_DETAILS_REPEAT_ORDER);
                        events.mixpanel.flush();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new MarketListPage(
                                    order.outlet.outletId,
                                    order.outlet.outletName,
                                    order.products)));
                      },
                      label: Text(
                        'Repeat order',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'SourceSansProSemiBold',
                            color: azul_blue),
                      ),
                      icon: Icon(
                        Icons.repeat_one_rounded,
                        size: 22,
                        color: buttonBlue,
                      ),
                      elevation: 0,
                    ),
                    new Spacer(),
                    if (order.isAcknowledged == null ||
                        order.orderStatus != 'Void')
                      FloatingActionButton.extended(
                        heroTag: "btn2",
                        backgroundColor: azul_blue,
                        foregroundColor: Colors.white,
                        onPressed: () {
                          _openBottomSheet();
                        },
                        label: Text(
                          'Respond',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'SourceSansProSemiBold',
                              color: Colors.white),
                        ),
                        elevation: 0,
                      ),
                  ])))),
      backgroundColor: faintGrey,
      body: ListView(
        children: <Widget>[
          banner(context),
          deliveryBanner(context),
          skuBanner(context),

          // if (order.notes != null && order.notes.isNotEmpty)
          //   notesBanner(context),
          //
          // skuDetails(context),
          priceDetails(context),
          smallSpaceBanner(context),
          contactDetails(context),
          smallSpaceBanner(context),
          // displayList(context),
        ],
      ),
    );
  }

  // Widget buildAppBar(BuildContext context) {
  //   return new AppBar(
  //       centerTitle: true,
  //       title: appBarTitle,
  //       backgroundColor: Colors.white,
  //       bottomOpacity: 0.0,
  //       elevation: 0.0,
  //       leading: IconButton(
  //         icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
  //         onPressed: () => Navigator.of(context).pop(),
  //       ),
  //       actions: <Widget>[
  //         new IconButton(
  //           icon: icon,
  //           onPressed: () {
  //             _moreActionBottomSheet(context);
  //           },
  //         ),
  //       ]);
  // }

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
              events.mixpanel.track(Events.TAP_ORDER_DETAILS_MORE_OPTIONS);
              events.mixpanel.flush();
              _moreActionBottomSheet(context);
            },
          ),
        ]);
  }

  Widget isAcknowledged() {
    if (order.isAcknowledged != null && order.isAcknowledged) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                //  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Text("#" + order.orderId,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "SourceSansProBold",
                        color: greyText))),
            SizedBox(
              width: 6,
            ),
            Image.asset(
              "assets/images/icon-tick-green.png",
              width: 12,
              height: 12,
            ),
            SizedBox(
              width: 2,
            ),
            Text(
              'Acknowledged',
              style: TextStyle(
                  fontSize: 12,
                  color: green,
                  fontFamily: 'SourceSansProRegular'),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                //  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Text("#" + order.orderId,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "SourceSansProBold",
                        color: greyText))),
          ],
        ),
      );
    }
  }

  void _openBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          // return StatefulBuilder(
          // builder: (BuildContext context, StateSetter setState) {
          return Container(
            color: Colors.white,
            child: new Wrap(
              children: <Widget>[
                Container(
                  height: 40,
                  child: new ListTile(
                      title: new Text(
                        'Respond to this order (optional)',
                        style: TextStyle(
                            fontSize: 14, fontFamily: 'SourceSansProSemibold'),
                      ),
                      onTap: () => {}),
                ),

                if (order.isAcknowledged == null)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.of(context).pop();
                        acknowledgeOrder();
                      });
                    },
                    child: Container(
                      color: Colors.white,
                      margin: EdgeInsets.fromLTRB(17, 10, 17, 0),
                      height: 40,
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/icon_tick_grey.png',
                            width: 22,
                            height: 22,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Acknowledge',
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'SourceSansProRegular'),
                          ),
                        ],
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(17, 0, 17, 0),
                  child: Divider(thickness: 2, color: faintGrey),
                ),

                if (order.orderStatus != 'Void')
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.of(context).pop();
                        voidOrderReasons();
                      });
                    },
                    child: Container(
                      color: Colors.white,
                      margin: EdgeInsets.fromLTRB(17, 0, 17, 0),
                      height: 40,
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/icon_close-red.png',
                            width: 22,
                            height: 22,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Void order',
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'SourceSansProRegular',
                                color: warningRed),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Container(
                //   height: 30,
                //   child: new ListTile(
                //     leading: Image.asset(
                //       'assets/images/icon_close-red.png',
                //       width: 22,
                //       height: 22,
                //     ),
                //     title: Transform.translate(
                //       offset: Offset(-25, 0),
                //       child: new Text('Void order',
                //           style: TextStyle(
                //               fontSize: 16,
                //               fontFamily: 'SourceSansProRegular',
                //               color: warningRed)),
                //     ),
                //     onTap: () {
                //       Navigator.of(context).pop();
                //       voidOrderReasons();
                //
                //     },
                //   ),
                // ),
                Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 10)),
              ],
            ),
            // }
          );
        });
  }

  acknowledgeOrder() {
    OrderApi acknowledge = new OrderApi();
    acknowledge
        .acknowledgeOrder(
            userData.mudra, userData.supplier.first.supplierId, order.orderId)
        .then((value) async {
      if (value == Constants.status_success) {
        print('isAcknowledged success');

        Fluttertoast.showToast(
            msg: "Order acknowledged",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        setState(() {
          order.isAcknowledged = true;
          DartNotificationCenter.post(channel: Constants.acknowledge_notifier);
        });
      }
    });
  }

  Widget trailingIcon(String name) {
    if (selectedReason == name) {
      return ImageIcon(
        AssetImage('assets/images/icon-tick-green.png'),
        size: 22,
        color: buttonBlue,
      );
    } else {
      return Container();
    }
  }

  void voidOrderReasons() {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
                child: Container(
              padding: (Platform.isAndroid)
                  ? EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom)
                  : EdgeInsets.only(
                      top: 15.0, right: 10.0, left: 10.0, bottom: 15.0),
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 5, left: 17.0, bottom: 0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Add a reason",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontFamily: "SourceSansProSemiBold"))),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedReason = 'Can’t fulfil the order';
                          });
                        },
                        child: Container(
                          color: Colors.white,
                          margin: EdgeInsets.fromLTRB(17, 0, 17, 0),
                          height: 40,
                          child: Row(
                            children: [
                              Text(
                                'Can’t fulfil the order',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'SourceSansProRegular'),
                              ),
                              Spacer(),
                              trailingIcon('Can’t fulfil the order')
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(17, 0, 17, 0),
                      child: Divider(thickness: 2, color: faintGrey),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedReason = 'Requested by buyer';
                        });
                      },
                      child: Container(
                        color: Colors.white,
                        margin: EdgeInsets.fromLTRB(17, 0, 17, 0),
                        height: 40,
                        child: Row(
                          children: [
                            Text(
                              'Requested by buyer',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'SourceSansProRegular'),
                            ),
                            Spacer(),
                            trailingIcon('Requested by buyer')
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(17, 0, 17, 0),
                      child: Divider(thickness: 2, color: faintGrey),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedReason = 'Other reason';
                        });
                      },
                      child: Container(
                        color: Colors.white,
                        margin: EdgeInsets.fromLTRB(17, 0, 17, 0),
                        height: 40,
                        child: Row(
                          children: [
                            Text(
                              'Other reason (type below)',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'SourceSansProRegular'),
                            ),
                            Spacer(),
                            trailingIcon('Other reason')
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Container(
                        padding: EdgeInsets.only(left: 15.0, right: 10.0),
                        margin: EdgeInsets.only(top: 10.0),
                        decoration: BoxDecoration(
                          color: faintGrey,
                          // border: Border.all(
                          //   color: keyLineGrey,
                          // ),
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        child: TextField(
                          controller: _controller,
                          keyboardType: TextInputType.text,
                          maxLines: null,
                          //  maxLength: 150,
                          autofocus: true,
                          cursorColor: Colors.blue,
                          decoration: InputDecoration(
                            // fillColor: Colors.orange,
                            // filled: true,
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            // hintText: Constants.txt_add_notes,
                            // hintStyle: new TextStyle(
                            //     color: greyText,
                            //     fontSize: 16.0,
                            //     fontFamily: "SourceSansProRegular"),
                          ),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontFamily: "SourceSansProRegular"),
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          if (selectedReason == 'Other reason')
                            selectedReason = _controller.text;

                          print(selectedReason);
                          voidOrder(selectedReason);
                          print(_controller.text);
                          Navigator.pop(context);
                        },
                        child: Container(
                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            margin: EdgeInsets.only(
                                top: 20.0, right: 20.0, left: 20.0),
                            height: 47.0,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: buttonBlue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            child: Center(
                                child: Text(
                              "Done",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: "SourceSansProSemiBold"),
                            ))))
                  ],
                ),
              ),
            ));
          });
        });
  }

  voidOrder(String reason) {
    OrderApi reject = OrderApi();

    reject
        .voidOrder(
            mudra, supplierID, order.orderId, order.outlet.outletId, reason)
        .then((value) async {
      if (value == Constants.status_success) {
        print('order voided');
        Fluttertoast.showToast(
            msg: "Order voided",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        setState(() {
          order.orderStatus = 'Void';
          DartNotificationCenter.post(channel: Constants.acknowledge_notifier);
        });
      }
    });
  }

  Widget banner(BuildContext context) {
    return new Container(
      padding:
          new EdgeInsets.only(top: 20, left: 10.0, bottom: 8.0, right: 10.0),
      decoration: new BoxDecoration(color: faintGrey),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          new Card(
            child: new Column(
              children: <Widget>[
                Center(child: isAcknowledged()),

                // Container(
                //     padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                //     child: Text("#" + order.orderId,
                //         textAlign: TextAlign.center,
                //         style: TextStyle(
                //             fontSize: 14,
                //             fontFamily: "SourceSansProBold",
                //             color: greyText))),
                Center(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                        child: Text(order.outlet.outletName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 24,
                                fontFamily: "SourceSansProBold")))),
                Center(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Text("Placed: " + order.getDatePlaced(),
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: "SourceSansProRegular")))),
                Constants.OrderStatusColor(order),
                Center(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Text('', style: TextStyle(fontSize: 4)))),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget deliveryBanner(BuildContext context) {
    return new Container(
      padding: new EdgeInsets.only(top: 0, left: 0.0, bottom: 0.0, right: 0.0),
      decoration: new BoxDecoration(color: faintGrey),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          new Card(
            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 5.0),
                      color: faintGrey,
                      height: 26.0,
                      width: 26.0,
                      child: ImageIcon(
                          AssetImage('assets/images/icon_delivery_truck.png')),
                    ),
                    Text(order.getDeliveryDay(),
                        style: TextStyle(
                            color: grey_text,
                            fontSize: 12.0,
                            fontFamily: "SourceSansProRegular")),
                  ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("                ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontFamily: "SourceSansProBold")),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                          child: Text(order.getDeliveryDateMonthYear(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontFamily: "SourceSansProBold")),
                        ),
                      ]),
                  Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 5)),
                  if (order.deliveryInstruction != null &&
                      order.deliveryInstruction.isNotEmpty)
                    new Card(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      color: keyLineGrey,
                      child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 20, 0, 5)),
                              Text("    Delivery instructions",
                                  style: TextStyle(
                                      color: greyText,
                                      fontSize: 10.0,
                                      fontFamily: "SourceSansProBold")),
                            ]),
                            Padding(padding: EdgeInsets.fromLTRB(20, 5, 20, 0)),
                            Row(children: <Widget>[
                              Text("     " + order.deliveryInstruction,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                      fontFamily: "SourceSansProRegular")),
                            ]),
                            Padding(padding: EdgeInsets.fromLTRB(20, 5, 20, 0)),
                          ]),
                    ),
                ]),
          )
        ],
      ),
    );
  }

  Widget skuBanner(BuildContext context) {
    int count = order.products.length;
    return StickyHeader(
      header: Container(
        height: 40,
        width: MediaQuery.of(context).size.width,
        color: faintGrey,
        child: Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text('$count items',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontFamily: "SourceSansProBold"))),
      ),
      content: Column(
        children: [
          if (order.notes != null && order.notes.isNotEmpty)
            notesBanner(context),
          skuDetails(context),
        ],
      ),
    );
  }

  Widget notesBanner(BuildContext context) {
    return new Card(
      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
      color: yellow,
      child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(children: <Widget>[
              Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10)),
              Text("       Notes or Special request",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 10.0,
                      fontFamily: "SourceSansProBold")),
            ]),
            Row(children: <Widget>[
              Padding(padding: EdgeInsets.fromLTRB(0, 5, 15, 0)),
              Expanded(
                child: Text(order.notes,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontFamily: "SourceSansProRegular")),
              ),
            ]),
            Padding(padding: EdgeInsets.fromLTRB(10, 5, 20, 5)),
          ]),
    );
  }

  Widget skuDetails(BuildContext context) {
    List<Products> products = order.products;
    var listView = ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            LeftRightAlign(
                                left: Text(products[index].productName,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontFamily: "SourceSansProBold")),
                                right: Text(
                                    products[index].quantity.toString() +
                                        " " +
                                        products[index].unitSizeAlias.shortName,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontFamily: "SourceSansProRegular"))),
                            Padding(padding: EdgeInsets.fromLTRB(10, 5, 20, 0)),
                            Row(children: <Widget>[
                              Text(products[index].totalPrice.getDisplayValue(),
                                  style: TextStyle(
                                      color: grey_text,
                                      fontSize: 12.0,
                                      fontFamily: "SourceSansProRegular")),
                            ])
                          ]),
                      if (products[index].notes != null &&
                          products[index].notes.isNotEmpty)
                        new Card(
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          color: faintGrey,
                          child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(children: <Widget>[
                                  Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 15, 0, 10)),
                                  Container(
                                    margin: EdgeInsets.only(left: 15),
                                    child: Text("Special notes",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10.0,
                                            fontFamily: "SourceSansProBold")),
                                  )
                                ]),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0)),
                                Row(children: <Widget>[
                                  Expanded(
                                      child: Container(
                                          margin: EdgeInsets.only(left: 15),
                                          child: Text(products[index].notes,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14.0,
                                                  fontFamily:
                                                      "SourceSansProRegular")))),
                                ]),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(20, 5, 20, 5)),
                              ]),
                        ),
                      Divider(color: greyText)
                    ]),
              ],
            ),
          );
        });

    // return listView;
    return Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0), child: listView);
  }

  Widget spaceBanner(BuildContext context) {
    return Padding(padding: EdgeInsets.fromLTRB(20, 5, 20, 20));
  }

  Widget smallSpaceBanner(BuildContext context) {
    return Padding(padding: EdgeInsets.fromLTRB(10, 5, 10, 5));
  }

  Widget priceDetails(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
                      Row(children: <Widget>[
                        Expanded(
                          child: LeftRightAlign(
                              left: Text("Subtotal",
                                  style: TextStyle(
                                      color: greyText,
                                      fontSize: 16.0,
                                      fontFamily: "SourceSansProRegular")),
                              right: Text(
                                  order.amount.subTotal.getDisplayValue(),
                                  style: TextStyle(
                                      color: greyText,
                                      fontSize: 16.0,
                                      fontFamily: "SourceSansProRegular"))),
                        )
                      ])
                    ]),
                Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 5)),
                if (order.promoCode != null && order.promoCode.isNotEmpty)
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(children: <Widget>[
                          Expanded(
                            child: LeftRightAlign(
                                left: Text("Promocode",
                                    style: TextStyle(
                                        color: greyText,
                                        fontSize: 16.0,
                                        fontFamily: "SourceSansProRegular")),
                                right: Text(
                                    getAmountDisplayValue(
                                        order.amount.subTotal.amountV1),
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 16.0,
                                        fontFamily: "SourceSansProRegular"))),
                          )
                        ])
                      ]),
                if (order.amount.deliveryFee != null &&
                    order.amount.deliveryFee.amountV1 != null)
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(children: <Widget>[
                          Expanded(
                            child: LeftRightAlign(
                                left: Text("Delivery fee",
                                    style: TextStyle(
                                        color: greyText,
                                        fontSize: 16.0,
                                        fontFamily: "SourceSansProRegular")),
                                right: Text(
                                    order.amount.deliveryFee.getDisplayValue(),
                                    style: TextStyle(
                                        color: greyText,
                                        fontSize: 16.0,
                                        fontFamily: "SourceSansProRegular"))),
                          )
                        ])
                      ]),
                Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 5)),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(children: <Widget>[
                        Expanded(
                          child: LeftRightAlign(
                              left: Text("GST ",
                                  style: TextStyle(
                                      color: greyText,
                                      fontSize: 16.0,
                                      fontFamily: "SourceSansProRegular")),
                              right: Text(order.amount.gst.getDisplayValue(),
                                  style: TextStyle(
                                      color: greyText,
                                      fontSize: 16.0,
                                      fontFamily: "SourceSansProRegular"))),
                        )
                      ])
                    ]),
                Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
                Divider(color: greyText),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
                      Row(children: <Widget>[
                        Expanded(
                          child: LeftRightAlign(
                              left: Text("Total ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontFamily: "SourceSansProBold")),
                              right: Text(order.amount.total.getDisplayValue(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontFamily: "SourceSansProBold"))),
                        )
                      ])
                    ]),
              ]),
          Padding(padding: EdgeInsets.fromLTRB(20, 5, 20, 20)),
        ],
      ),
    );
  }

  String getAmountDisplayValue(var amount) {
    return "\$$amount";
  }

  Widget contactDetails(BuildContext context) {
    return ListTile(
      //contentPadding: EdgeInsets.all(<some value here>),//change for side padding
      title: Row(
        children: <Widget>[
          if (order.createdBy != null &&
              order.createdBy.id != userData.user.userId)
          Expanded(
              child: RaisedButton(
                  color: Colors.white,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  onPressed: () {
                    events.mixpanel.track(Events.TAP_ORDER_DETAILS_CONTACT);
                    events.mixpanel.flush();
                    _newTaskModalBottomSheet(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ImageIcon(AssetImage('assets/images/icon_phone.png'),
                          color: buttonBlue),
                      Text(
                        ' Contact',
                        style: TextStyle(
                            color: buttonBlue,
                            fontSize: 16.0,
                            fontFamily: "SourceSansProSemiBold"),
                      ),
                    ],
                  ))),
          Padding(padding: EdgeInsets.fromLTRB(0, 0, 10, 0)),
          Expanded(
              child: RaisedButton(
                  color: Colors.white,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  onPressed: () {
                    events.mixpanel.track(Events.TAP_ORDER_DETAILS_VIEW_AS_PDF);
                    events.mixpanel.flush();
                    openPdf(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ImageIcon(AssetImage('assets/images/icon_view_pdf.png'),
                          color: buttonBlue),
                      Text(
                        ' View as PDF',
                        style: TextStyle(
                            color: buttonBlue,
                            fontSize: 16.0,
                            fontFamily: "SourceSansProSemiBold"),
                      ),
                    ],
                  )))
        ],
      ),
    );
  }

  openPdf(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => PdfViewerPage(order.pdfURL)));
  }

  void _newTaskModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                if (order.outlet.company.email != null &&
                    order.outlet.company.email.isNotEmpty)
                  new ListTile(
                      leading: new Icon(Icons.email),
                      title: new Text(order.outlet.company.email),
                      onTap: () => {
                            Clipboard.setData(new ClipboardData(
                                text: order.outlet.company.email)),
                            showSuccessDialog()
                          }),
                if (order.outlet.company.phone != null &&
                    order.outlet.company.phone.isNotEmpty)
                  new ListTile(
                    leading: new Icon(Icons.phone),
                    title: new Text(order.outlet.company.phone),
                    onTap: () => {
                      Clipboard.setData(
                          new ClipboardData(text: order.outlet.company.phone)),
                      showSuccessDialog()
                    },
                  ),
                Padding(padding: EdgeInsets.fromLTRB(20, 5, 20, 20)),
              ],
            ),
          );
        });
  }

  Future<void> showSuccessDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return CustomDialogBox(
            title: "Copied",
            imageAssets: 'assets/images/tick_receive_big.png',
            time: 1000,
          );
        }).then((value) {
      Navigator.of(context, rootNavigator: true).pop();
    });
  }

  void _moreActionBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Padding(padding: EdgeInsets.fromLTRB(15, 5, 0, 0)),

                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text("More options",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "SourceSansProSemiBold",
                          fontSize: 14)),
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    moveToOrderActivityPage(order);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text("Activity history",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "SourceSansProRegular",
                            fontSize: 16)),
                  ),
                )
              ],
            ),
          );
        });
  }

  moveToOrderActivityPage(Orders element) {
    events.mixpanel.track(Events.TAP_ORDER_DETAILS_ACTIVITY_HISTORY);
    events.mixpanel.flush();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => new OrderActivityPage(element.orderId)));
  }
}

class LeftRightAlign extends MultiChildRenderObjectWidget {
  LeftRightAlign({
    Key key,
    @required Widget left,
    @required Widget right,
  }) : super(key: key, children: [left, right]);

  @override
  RenderLeftRightAlign createRenderObject(BuildContext context) {
    return RenderLeftRightAlign();
  }
}

class LeftRightAlignParentData extends ContainerBoxParentData<RenderBox> {}

class RenderLeftRightAlign extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, LeftRightAlignParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, LeftRightAlignParentData> {
  RenderLeftRightAlign({
    List<RenderBox> children,
  }) {
    addAll(children);
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! LeftRightAlignParentData)
      child.parentData = LeftRightAlignParentData();
  }

  @override
  void performLayout() {
    final BoxConstraints childConstraints = constraints.loosen();

    final RenderBox leftChild = firstChild;
    final RenderBox rightChild = lastChild;

    leftChild.layout(childConstraints, parentUsesSize: true);
    rightChild.layout(childConstraints, parentUsesSize: true);

    final LeftRightAlignParentData leftParentData = leftChild.parentData;
    final LeftRightAlignParentData rightParentData = rightChild.parentData;

    final bool wrapped =
        leftChild.size.width + rightChild.size.width > constraints.maxWidth;

    leftParentData.offset = Offset.zero;
    rightParentData.offset = Offset(
        constraints.maxWidth - rightChild.size.width,
        wrapped ? leftChild.size.height : 0);

    size = Size(
        constraints.maxWidth,
        wrapped
            ? leftChild.size.height + rightChild.size.height
            : math.max(leftChild.size.height, rightChild.size.height));
  }

  @override
  bool hitTestChildren(HitTestResult result, {Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }
}
