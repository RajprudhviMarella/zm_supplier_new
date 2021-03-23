import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zm_supplier/models/invoiceDetailsResponse.dart';
import 'package:zm_supplier/models/invoicesResponse.dart';
import 'package:zm_supplier/models/user.dart';
import 'package:zm_supplier/orders/orderDetailsPage.dart';
import 'package:zm_supplier/utils/color.dart';
import 'package:zm_supplier/utils/constants.dart';
import 'package:zm_supplier/utils/eventsList.dart';
import 'package:zm_supplier/utils/urlEndPoints.dart';
import 'package:http/http.dart' as http;
import 'package:zm_supplier/utils/webview.dart';

import '../models/ordersResponseList.dart';

class InvoiceDetailsPage extends StatefulWidget {
  Invoices invoice;

  InvoiceDetailsPage(this.invoice);

  @override
  State<StatefulWidget> createState() => new InvoiceDetailsState();
}

class InvoiceDetailsState extends State<InvoiceDetailsPage> {
  Invoices invoice;

  SharedPref sharedPref = SharedPref();

  InvoiceDetailsResponse invoicesDetailsResponse;
  InvoiceDetails invoiceDetails;
  Future<InvoiceDetails> invoiceDetailsFuture;

  OrderDetailsResponse orderResponse;
  Orders order;
  String pdfUrl;

  Constants events = Constants();

  @override
  void initState() {
    invoice = widget.invoice;
    super.initState();

    events.mixPanelEvents();
    invoiceDetailsFuture = retriveInvoiceDetails();
  }

  Future<InvoiceDetails> retriveInvoiceDetails() async {
    LoginResponse user =
        LoginResponse.fromJson(await sharedPref.readData(Constants.login_Info));

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart',
      'mudra': user.mudra,
      'supplierId': user.supplier.first.supplierId
    };

    Map<String, String> queryParams = {
      'id': invoice.invoiceId,
    };

    String queryString = Uri(queryParameters: queryParams).query;

    var url = URLEndPoints.retrive_specific_invoice + '?' + queryString;
    print(headers);
    print(url);
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      // Map results = json.decode(response.body);
      invoicesDetailsResponse =
          InvoiceDetailsResponse.fromJson(json.decode(response.body));
      pdfUrl = invoicesDetailsResponse.data.pdfUrl;
    } else {
      print('failed get invoices');
    }

    invoiceDetails = invoicesDetailsResponse.data;

    return invoiceDetails;
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
      orderResponse =
          OrderDetailsResponse.fromJson(json.decode(response.body));
    } else {
      print('failed get invoices');
    }

    order = orderResponse.data;

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => OrderDetailsPage(order)));


    //return order;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      //key: globalKey,
      backgroundColor: faintGrey,
      appBar: buildAppBar(context),
      body: ListView(
        children: <Widget>[
          detailsBanner(),
          itemsCount(),
          notes(),
          spaceBanner(context),
          skuDetails(),
          spaceBanner(context),
          priceDetails(context),
          spaceBanner(context),
          contactDetails(context),
          spaceBanner(context)
        ],
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return PreferredSize(

      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: faintGrey,
            offset: Offset(0, 2.0),
            blurRadius: 4.0,
          )
        ]),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text(
        'Invoice details',
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontFamily: 'SourceSansProBold'),
      ),
        ),
      ),
      preferredSize: Size.fromHeight(kToolbarHeight),
    );
  }

  Widget detailsBanner() {
    return FutureBuilder<InvoiceDetails>(
        future: invoiceDetailsFuture,
        builder:
            (BuildContext context, AsyncSnapshot<InvoiceDetails> snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return Center(
                // child: CircularProgressIndicator(),
                );
          } else {
            if (snapShot.connectionState == ConnectionState.done &&
                snapShot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  height: 260,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        invoice.invoiceNum,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'SourceSansProBold',
                            color: greyText),
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      Flexible(
                        child: Text(invoice.outlet.outletName,overflow:
                        TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 22,
                                fontFamily: 'SourceSansProBold',
                                color: Colors.black)),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Issued: ' +
                            DateFormat('d MMM yyyy')
                                .format(invoice.getInvoiceDate()),
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'SourceSansProRegular',
                            color: greyText),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 2,
                        color: faintGrey,
                      ),
                      SizedBox(height: 5),
                      Row(
                        //mainAxisSize: MainAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 5.0),
                            height: 18.0,
                            width: 18.0,
                            child: ImageIcon(
                                AssetImage('assets/images/Calendar_grey.png')),
                          ),
                          Text('Due date',
                              style: TextStyle(
                                  color: greyText,
                                  fontSize: 14.0,
                                  fontFamily: "SourceSansProRegular")),
                          if (invoice.paymentDueDate != null)
                            Container(
                                margin: EdgeInsets.fromLTRB(30.0, 0, 0, 0),
                                child: Text(
                                    DateFormat('d MMM yyyy')
                                        .format(invoice.getPaymentDueDate()),
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'SourceSansProSemiBold')))
                        ],
                      ),
                      Container(
                        height: 1,
                        color: faintGrey,
                        margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                      ),
                      Row(
                        //mainAxisSize: MainAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 5.0),
                            height: 18.0,
                            width: 18.0,
                            child: ImageIcon(
                                AssetImage('assets/images/Location_grey.png')),
                          ),
                          Text('Deliver to',
                              style: TextStyle(
                                  color: greyText,
                                  fontSize: 14.0,
                                  fontFamily: "SourceSansProRegular")),
                          Container(
                            margin: EdgeInsets.fromLTRB(30.0, 0, 0, 0),
                            //  height: 18.0,
                            //  width: 18.0,
                            child: Text(
                              invoice.outlet.outletName,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'SourceSansProSemiBold'),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 1,
                        color: faintGrey,
                        margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                      ),
                      Row(
                        //mainAxisSize: MainAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 5.0),
                            height: 18.0,
                            width: 18.0,
                            child: ImageIcon(
                                AssetImage('assets/images/Link_grey.png')),
                          ),
                          Text('Linked to',
                              style: TextStyle(
                                  color: greyText,
                                  fontSize: 14.0,
                                  fontFamily: "SourceSansProRegular")),
                          if (snapShot.data.orderIds != null)
                            Container(
                                margin:
                                    EdgeInsets.fromLTRB(30.0, 10.0, 10.0, 5.0),
                                child: linkedOrders(snapShot.data))
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Container();
            }
          }
        });
  }

  Widget linkedOrders(InvoiceDetails inv) {
    print(inv.orderIds.length);
    if (inv.orderIds.length > 1) {
      for (var i in inv.orderIds) {
        Expanded(
            child: GestureDetector(
              onTap: () {
                events.mixpanel.track(Events.TAP_INVOICES_LINKED_ORDER);
                events.mixpanel.flush();
                goToOrderDetails(i);
              },
              child: Text('Order #' + i + '\n',
                  style: TextStyle(
                      fontSize: 14,
                      color: buttonBlue,
                      fontFamily: 'SourceSansProSemiBold')),
            ));
      }
    } else {
      return GestureDetector(
        onTap: () {
          events.mixpanel.track(Events.TAP_INVOICES_LINKED_ORDER);
          events.mixpanel.flush();
          goToOrderDetails(inv.orderIds.first);
        },
        child: Text('Order #' + inv.orderIds.first,
            style: TextStyle(
                fontSize: 14,
                color: buttonBlue,
                fontFamily: 'SourceSansProSemiBold')),
      );
    }
  }

  Widget itemsCount() {
    return FutureBuilder<InvoiceDetails>(
        future: invoiceDetailsFuture,
        builder:
            (BuildContext context, AsyncSnapshot<InvoiceDetails> snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapShot.connectionState == ConnectionState.done &&
                snapShot.hasData) {
              if (snapShot.data.products != null) {
                return Container(
                  margin: EdgeInsets.only(left: 20, bottom: 10),
                  child: Text(snapShot.data.products.length > 1 ?
                    (snapShot.data.products.length ?? 0).toString() + ' Items' : (snapShot.data.products.length ?? 0).toString() + ' Item',
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'SourceSansProBold',
                        color: Colors.black),
                  ),
                );
              } else {
                return Container();
              }
            } else {
              return Container();
            }
          }
        });
  }

  Widget notes() {
    return FutureBuilder<InvoiceDetails>(
        future: invoiceDetailsFuture,
        builder:
            (BuildContext context, AsyncSnapshot<InvoiceDetails> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(); //Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('failed to load'));
          } else {
            return Container(
                color: Colors.white, child: checkNotes(snapshot.data));
          }
        });
  }

  Widget checkNotes(InvoiceDetails inv) {
    if (inv.notes != null && inv.notes != "") {

      return Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: notesyellow,
        ),
        margin: EdgeInsets.all(15),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left : 10.0),
                  child: Text(
                    'NOTES',
                    style:
                        TextStyle(fontSize: 10, fontFamily: 'SourceSansProBold'),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(inv.notes,
                    style: TextStyle(
                        fontSize: 14, fontFamily: 'SourceSansProRegular'),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    } else {
      return Container(
        width: 0,
        height: 0,
      );
    }
  }

  Widget spaceBanner(BuildContext context) {
    return Padding(padding: EdgeInsets.fromLTRB(20, 5, 20, 10));
  }

  Widget skuDetails() {
    return FutureBuilder<InvoiceDetails>(
        future: invoiceDetailsFuture,
        builder:
            (BuildContext context, AsyncSnapshot<InvoiceDetails> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(); //Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('failed to load'));
          } else {
            if (snapshot.data.products != null) {
              return ListView.builder(
                  itemCount: snapshot.data.products.length ?? 0,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      color: Colors.white,
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //  SizedBox(height: 20,),
                          LeftRightAlign(
                              left: Text(
                                  snapshot.data.products[index].productName,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      fontFamily: "SourceSansProBold")),
                              right: Text(
                                  getAmountDisplayValue(snapshot.data
                                      .products[index].totalPrice),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      fontFamily: "SourceSansProRegular"))),

                          Padding(padding: EdgeInsets.fromLTRB(10, 5, 20, 0)),
                          Row(children: <Widget>[
                            Text(
                                snapshot.data.products[index].quantity
                                        .toString() +
                                    ' ' +
                                    snapshot.data.products[index].unitSize,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                    fontFamily: "SourceSansProRegular")),
                          ]),

                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            height: 2,
                            thickness: 2,
                            color: faintGrey,
                          )
                        ],
                      ),
                    );
                  });
            } else {
              return Container();
            }
          }
        });
  }

  String getAmountDisplayValue(DeliveryFee amount) {
    if (amount != null) {
      return amount.getDisplayValue();
    } else {
      return '';
    }
  }

  Widget priceDetails(BuildContext context) {
    return FutureBuilder<InvoiceDetails>(
        future: invoiceDetailsFuture,
        builder:
            (BuildContext context, AsyncSnapshot<InvoiceDetails> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(); //Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('failed to load'));
          } else {
            return Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (snapshot.data.subTotal != null &&
                            snapshot.data.subTotal.amountV1 != null)
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(children: <Widget>[
                                  Expanded(
                                    child: LeftRightAlign(
                                        left: Text("Subtotal",
                                            style: TextStyle(
                                                color: greyText,
                                                fontSize: 16.0,
                                                fontFamily:
                                                    "SourceSansProRegular")),
                                        right: Text(
                                            getAmountDisplayValue(snapshot
                                                .data.subTotal),
                                            style: TextStyle(
                                                color: greyText,
                                                fontSize: 16.0,
                                                fontFamily:
                                                    "SourceSansProRegular"))),
                                  )
                                ])
                              ]),
                        Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
                        if (snapshot.data.deliveryFee != null &&
                            snapshot.data.deliveryFee.amountV1 != null)
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
                                                fontFamily:
                                                    "SourceSansProRegular")),
                                        right: Text(
                                            getAmountDisplayValue(snapshot.data
                                                    .deliveryFee ??
                                                0),
                                            style: TextStyle(
                                                color: greyText,
                                                fontSize: 16.0,
                                                fontFamily:
                                                    "SourceSansProRegular"))),
                                  )
                                ])
                              ]),

                        Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
                        if (snapshot.data.promoCodeDiscount != null &&
                            snapshot.data.promoCodeDiscount.amountV1 != null)
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(children: <Widget>[
                                  Expanded(
                                    child: LeftRightAlign(
                                        left: Text("Promo code",
                                            style: TextStyle(
                                                color: greyText,
                                                fontSize: 16.0,
                                                fontFamily:
                                                "SourceSansProRegular")),
                                        right: Text(
                                            getAmountDisplayValue(snapshot.data
                                                .promoCodeDiscount ??
                                                0),
                                            style: TextStyle(
                                                color: greyText,
                                                fontSize: 16.0,
                                                fontFamily:
                                                "SourceSansProRegular"))),
                                  )
                                ])
                              ]),

                        Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
                        if (snapshot.data.discount != null &&
                            snapshot.data.discount.amountV1 != null)
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(children: <Widget>[
                                  Expanded(
                                    child: LeftRightAlign(
                                        left: Text("Discount",
                                            style: TextStyle(
                                                color: greyText,
                                                fontSize: 16.0,
                                                fontFamily:
                                                    "SourceSansProRegular")),
                                        right: Text(
                                            getAmountDisplayValue(snapshot
                                                .data.discount),
                                            style: TextStyle(
                                                color: greyText,
                                                fontSize: 16.0,
                                                fontFamily:
                                                    "SourceSansProRegular"))),
                                  )
                                ])
                              ]),
                        Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
                        if (snapshot.data.others != null &&
                            snapshot.data.others.charge.amountV1 != null &&
                            snapshot.data.others.name != "")
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(children: <Widget>[
                                  Expanded(
                                    child: LeftRightAlign(
                                        left: Text(snapshot.data.others.name,
                                            style: TextStyle(
                                                color: greyText,
                                                fontSize: 16.0,
                                                fontFamily:
                                                    "SourceSansProRegular")),
                                        right: Text(
                                            getAmountDisplayValue(snapshot
                                                .data.others.charge),
                                            style: TextStyle(
                                                color: greyText,
                                                fontSize: 16.0,
                                                fontFamily:
                                                    "SourceSansProRegular"))),
                                  )
                                ])
                              ]),
                        Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
                        if (snapshot.data.gst != null &&
                            snapshot.data.gst.amountV1 != null)
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(children: <Widget>[
                                  Expanded(
                                    child: LeftRightAlign(
                                        left: Text(
                                            "GST " +
                                                snapshot.data.gstPercentage
                                                    .toString() +
                                                '%',
                                            style: TextStyle(
                                                color: greyText,
                                                fontSize: 16.0,
                                                fontFamily:
                                                    "SourceSansProRegular")),
                                        right: Text(
                                            getAmountDisplayValue(
                                                snapshot.data.gst),
                                            style: TextStyle(
                                                color: greyText,
                                                fontSize: 16.0,
                                                fontFamily:
                                                    "SourceSansProRegular"))),
                                  )
                                ])
                              ]),
                        SizedBox(height: 10,),
                        Divider(
                          color: faintGrey,
                          thickness: 2,
                        ),
                        if (snapshot.data.totalCharge != null &&
                            snapshot.data.totalCharge.amountV1 != null)
                          Padding(
                            padding: const EdgeInsets.only(top:5.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(children: <Widget>[
                                    Expanded(
                                      child: LeftRightAlign(
                                          left: Text("Total",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16.0,
                                                  fontFamily:
                                                      "SourceSansProBold")),
                                          right: Text(
                                              getAmountDisplayValue(snapshot
                                                  .data.totalCharge),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16.0,
                                                  fontFamily:
                                                      "SourceSansProBold"))),
                                    )
                                  ])
                                ]),
                          ),
                      ]),
                  Padding(padding: EdgeInsets.fromLTRB(20, 5, 20, 10)),
                ],
              ),
            );
          }
        });
  }

  // Widget button(BuildContext context) {
  //   return Container(
  // child: RaisedButton.icon(onPressed: null, icon: ImageIcon(AssetImage('assets/images/Document_blue.png')), label: Text('View as PDF'))
  //   );
  //
  // }
  Widget contactDetails(BuildContext context) {
    return ListTile(
      //contentPadding: EdgeInsets.all(<some value here>),//change for side padding
      title: Container(
        // color: Colors.yellow,
        height: 50,
        child: Row(
          children: <Widget>[
            Expanded(
                child: ButtonTheme(
              height: 50,
              child: RaisedButton(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0)),
                  color: Colors.white,
                  onPressed: () {
                    //  _newTaskModalBottomSheet(context);

                    events.mixpanel.track(Events.TAP_INVOICES_VIEW_AS_PDF);
                    events.mixpanel.flush();

                    openPdf(pdfUrl);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Icon(Icons.phone, color: buttonBlue,),

                      Image(
                        image:
                            new AssetImage("assets/images/Document_blue.png"),
                        width: 22,
                        height: 22,
                        color: null,
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.center,
                      ),

                      // ImageIcon(AssetImage('assets/images/Document_blue.png')),
                      Text(
                        ' View as PDF',
                        style: TextStyle(
                            color: buttonBlue,
                            fontSize: 16.0,
                            fontFamily: "SourceSansProSemiBold"),
                      ),
                    ],
                  )),
            )),
          ],
        ),
      ),
    );
  }

  openPdf(String url) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url, "")));
  }
}
