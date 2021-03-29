import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:zm_supplier/home/home_page.dart';
import 'package:zm_supplier/models/createOrderModel.dart';
import 'package:zm_supplier/models/outletMarketList.dart';
import 'package:zm_supplier/models/placeOrderResponse.dart';
import 'package:zm_supplier/models/supplierDeliveryDates.dart';
import 'package:zm_supplier/orders/orderDetailsPage.dart';
import 'package:zm_supplier/utils/color.dart';
import 'package:zm_supplier/utils/constants.dart';
import 'package:zm_supplier/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:zm_supplier/utils/customDialog.dart';
import 'package:zm_supplier/utils/eventsList.dart';
import 'dart:convert';
import 'dart:ui';
import 'package:zm_supplier/utils/urlEndPoints.dart';
import 'package:dart_notification_center/dart_notification_center.dart';

/**
 * Created by RajPrudhviMarella on 04/Mar/2021.
 */

class ReviewOrderPage extends StatefulWidget {
  static const String tag = 'MarketListPage';
  List<OutletMarketList> marketList;
  String outletId;
  String outletName;
  String orderNotes;
  String orderId;
  List<DeliveryDateList> lstDeliveryDates;

  ReviewOrderPage(this.marketList, this.outletId, this.outletName,
      this.orderNotes, this.lstDeliveryDates, this.orderId);

  @override
  State<StatefulWidget> createState() {
    return ReviewOrderDesign(lstDeliveryDates);
  }
}

class ReviewOrderDesign extends State<ReviewOrderPage>
    with TickerProviderStateMixin {
  var counter;
  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _textEditingController =
      new TextEditingController();
  final TextEditingController _txtSkuNotesEditController =
      new TextEditingController();
  final TextEditingController _txtSpecialRequest = new TextEditingController();
  var totalSkusPrice = 0.0;
  var totalGstPrice = 0.0;
  var totalDeliveryPrice = 0.0;
  var totalPrice = 0.0;
  String error = "";
  bool isAddonOrder = false;
  List<DeliveryDateList> lstDeliveryDates;
  String supplierID;
  String mudra;
  var selectedDate = 0;
  bool _isShowLoader = false;

  ReviewOrderDesign(this.lstDeliveryDates);

  Constants events = Constants();
  TextInputType keyboard;
  TextInputFormatter regExp;
  bool isValid = false;

  @override
  void initState() {
    loadSharedPrefs();
    bool isAnyDateSelected = false;
    for (var i = 0; i < lstDeliveryDates[0].deliveryDates.length; i++) {
      if (lstDeliveryDates[0].deliveryDates[i].isSelected) {
        isAnyDateSelected = true;
      }
    }
    if (!isAnyDateSelected) {
      lstDeliveryDates[0].deliveryDates[0].isSelected = true;
      selectedDate = lstDeliveryDates[0].deliveryDates[0].deliveryDate;
    }

    calculatePrice();
    if (widget.orderNotes != null && widget.orderNotes.isNotEmpty) {
      _txtSpecialRequest.text = widget.orderNotes;
    }
    super.initState();
    events.mixPanelEvents();
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
        }
      });
    } catch (Exception) {}
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall: _isShowLoader,
        child: Scaffold(
            key: globalKey,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.white,
              bottomOpacity: 0.0,
              elevation: 2.0,
              leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                child: IconButton(
                    icon: Icon(Icons.arrow_back_ios_outlined,
                        color: Colors.black),
                    onPressed: () {
                      String textToSendBack = _txtSpecialRequest.text;
                      Navigator.pop(context, textToSendBack);
                      // events.mixpanel.track(Events.TAP_ORDER_REVIEW_BACK, properties: {'OrderId': widget.orderId});
                      //events.mixpanel.flush();
                      // Navigator.of(context).pop();
                    }),
              ),
              title: Container(
                child: Column(
                  children: [
                    Text(
                      "Review order",
                      style: new TextStyle(
                          color: Colors.black, fontFamily: "SourceSansProBold"),
                    ),
                    Text(
                      widget.outletName,
                      style: new TextStyle(
                          color: grey_text,
                          fontSize: 12.0,
                          fontFamily: "SourceSansProRegular"),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  icon: Image.asset("assets/images/icon_trash.png"),
                  onPressed: () =>
                      (widget.orderId != null && widget.orderId.isNotEmpty)
                          ? showDraftAlert(context)
                          : moveToDashBoard(),
                ),
              ],
            ),
            bottomNavigationBar: Container(
                height: 80.0,
                color: Colors.white,
                child: Container(
                    padding: EdgeInsets.only(left: 15.0, right: 10.0),
                    child: Row(children: <Widget>[
                      Container(
                        height: 50,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  'Total',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'SourceSansProRegular',
                                      color: Colors.black),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 2),
                                child: Text(
                                  NumberFormat.simpleCurrency()
                                      .format(totalPrice)
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'SourceSansProBold',
                                      color: Colors.black),
                                ),
                              ),
                            ]),
                      ),
                      new Spacer(),
                      RaisedButton(
                        child: Container(
                            padding: EdgeInsets.only(left: 10.0),
                            height: 50,
                            child: Center(
                              child: Text(
                                'Place order',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'SourceSansProSemiBold',
                                    color: Colors.white),
                              ),
                            )),
                        color: lightGreen,
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        onPressed: () {
                          events.mixpanel
                              .track(Events.TAP_ORDER_REVIEW_PLACE_ORDER);
                          events.mixpanel.flush();

                          if (widget.marketList != null &&
                              widget.marketList.isNotEmpty) {
                            showAlert(context);
                          } else {
                            globalKey.currentState.showSnackBar(
                              SnackBar(
                                content:
                                    Text('Please select atlease one product'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                      )
                    ]))),
            body: ListView(
              children: [
                Headers("Delivery date"),
                displayDeliveryDates(context),
                Headers(widget.marketList.length.toString() +
                    ((widget.marketList.length > 1) ? " items" : " item")),
                displayList(context),
                Headers("Notes / special requests"),
                EditNotes(),
                priceDetails(context)
              ],
            )));
  }

  Widget Headers(String name) {
    return Container(
      color: faintGrey,
      margin: EdgeInsets.only(top: 2.0),
      padding:
          EdgeInsets.only(left: 15.0, right: 20.0, top: 15.0, bottom: 10.0),
      child: Text(name,
          style: TextStyle(
            fontFamily: "SourceSansProBold",
            fontSize: 18.0,
          )),
    );
  }

  calculatePrice() {
    double totalPriceCentAllItems = 0.0;
    for (var i = 0; i < widget.marketList.length; i++) {
      double doubleTotalPriceCent =
          widget.marketList[i].priceList[0].price.amountV1.toDouble() *
              widget.marketList[i].quantity.toDouble();
      totalPriceCentAllItems = totalPriceCentAllItems + doubleTotalPriceCent;
    }
    totalSkusPrice = totalPriceCentAllItems;
    if (lstDeliveryDates[0].deliveryFeePolicy.type == "APPLY_FEE" &&
        !isAddonOrder) {
      if (lstDeliveryDates[0].deliveryFeePolicy.condition ==
          "BELOW_MINIMUM_ORDER") {
        if (totalSkusPrice <
            lstDeliveryDates[0]
                .deliveryFeePolicy
                .minOrder
                .amountV1
                .toDouble()) {
          totalDeliveryPrice =
              lstDeliveryDates[0].deliveryFeePolicy.fee.amountV1.toDouble();
          error =
              "Order can be placed, but supplier may reject the order or  \n delivery fee may have to be paid";
        }
      } else if (lstDeliveryDates[0].deliveryFeePolicy.condition ==
          "ALL_ORDERS") {
        totalDeliveryPrice =
            lstDeliveryDates[0].deliveryFeePolicy.fee.amountV1.toDouble();
        error =
            "Order can be placed, but supplier may reject the order or \n delivery fee may have to be paid";
      } else if (lstDeliveryDates[0].deliveryFeePolicy.condition ==
          "REJECT_BELOW_MIN_ORDER") {
        totalDeliveryPrice =
            lstDeliveryDates[0].deliveryFeePolicy.fee.amountV1.toDouble();
        error =
            "Order can be placed, but supplier may reject the order or \n delivery fee may have to be paid";
      } else {
        totalDeliveryPrice = 0;
      }
    } else {
      totalDeliveryPrice = 0;
    }
    totalGstPrice = (((totalSkusPrice + totalDeliveryPrice) *
        lstDeliveryDates[0].supplier.settings.gST.percent /
        100));
    totalPrice = totalDeliveryPrice + totalSkusPrice + totalGstPrice;
  }

  Widget priceDetails(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.fromLTRB(15, 15, 10, 15),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 3.0),
                    child: Row(children: <Widget>[
                      Expanded(
                        child: LeftRightAlign(
                            left: Text("Subtotal",
                                style: TextStyle(
                                    color: greyText,
                                    fontSize: 16.0,
                                    fontFamily: "SourceSansProRegular")),
                            right: Text(
                                NumberFormat.simpleCurrency()
                                    .format(totalSkusPrice)
                                    .toString(),
                                style: TextStyle(
                                    color: greyText,
                                    fontSize: 16.0,
                                    fontFamily: "SourceSansProRegular"))),
                      )
                    ])),
                // if (order.promoCode != null && order.promoCode.isNotEmpty)
                //   Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: <Widget>[
                //         Row(children: <Widget>[
                //           Expanded(
                //             child: LeftRightAlign(
                //                 left: Text("Promocode",
                //                     style: TextStyle(
                //                         color: greyText,
                //                         fontSize: 16.0,
                //                         fontFamily: "SourceSansProRegular")),
                //                 right: Text(
                //                     getAmountDisplayValue(
                //                         order.amount.subTotal.amountV1),
                //                     style: TextStyle(
                //                         color: greyText,
                //                         fontSize: 16.0,
                //                         fontFamily: "SourceSansProRegular"))),
                //           )
                //         ])
                //       ]),
                if (lstDeliveryDates[0].deliveryFeePolicy.type == "APPLY_FEE" &&
                    !isAddonOrder)
                  Container(
                      margin: EdgeInsets.only(top: 3.0),
                      child: Row(children: <Widget>[
                        Expanded(
                          child: LeftRightAlign(
                              left: Text("Delivery fee",
                                  style: TextStyle(
                                      color: greyText,
                                      fontSize: 16.0,
                                      fontFamily: "SourceSansProRegular")),
                              right: Text(
                                  NumberFormat.simpleCurrency()
                                      .format(totalDeliveryPrice)
                                      .toString(),
                                  style: TextStyle(
                                      color: greyText,
                                      fontSize: 16.0,
                                      fontFamily: "SourceSansProRegular"))),
                        )
                      ])),
                Container(
                    margin: EdgeInsets.only(top: 3.0),
                    child: Row(children: <Widget>[
                      Expanded(
                        child: LeftRightAlign(
                            left: Text(
                                "GST " +
                                    lstDeliveryDates[0]
                                        .supplier
                                        .settings
                                        .gst
                                        .percent
                                        .toString() +
                                    "%",
                                style: TextStyle(
                                    color: greyText,
                                    fontSize: 16.0,
                                    fontFamily: "SourceSansProRegular")),
                            right: Text(
                                NumberFormat.simpleCurrency()
                                    .format(totalGstPrice)
                                    .toString(),
                                style: TextStyle(
                                    color: greyText,
                                    fontSize: 16.0,
                                    fontFamily: "SourceSansProRegular"))),
                      )
                    ])),
              ]),
          Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0)),
        ],
      ),
    );
  }

  Widget EditNotes() {
    return Container(
        padding: EdgeInsets.only(left: 4, bottom: 10.0),
        color: Colors.white,
        margin: EdgeInsets.only(top: 2.0),
        child: TextField(
            maxLength: 150,
            controller: _txtSpecialRequest,
            maxLines: null,
            onTap: () {
              events.mixpanel.track(Events.TAP_ORDER_REVIEW_SPECIAL_REQUEST);
              events.mixpanel.flush();
            },
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              fillColor: Colors.white,
              hintText: "eg. Please prepare or pack item in certain way",
              filled: true,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              counterStyle: TextStyle(fontFamily: "SourceSansProRegular"),
              hintStyle: new TextStyle(
                  color: greyText,
                  fontSize: 16.0,
                  fontFamily: "SourceSansProRegular"),
            ),
            style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontFamily: "SourceSansProRegular"),
            onChanged: (query) {}));
  }

  Widget displayList(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.marketList.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                margin: EdgeInsets.only(top: 1.0),
                child: GestureDetector(
                  onTap: () {
                    if (widget.marketList[index].priceList[0].unitSizeAlias
                        .isDecimalAllowed) {
                      if (widget.marketList[index].quantity != null &&
                          widget.marketList[index].quantity != 0) {
                        counter = widget.marketList[index].quantity.toDouble();
                      } else {
                        counter = widget.marketList[index].priceList[0].moq
                            .toDouble();
                      }
                      keyboard = TextInputType.numberWithOptions(
                          signed: false, decimal: true);
                      regExp = WhitelistingTextInputFormatter(
                          RegExp(r'^\d+\.?\d{0,2}'));
                    } else {
                      if (widget.marketList[index].quantity != null &&
                          widget.marketList[index].quantity != 0) {
                        counter = widget.marketList[index].quantity;
                      } else {
                        counter = widget.marketList[index].priceList[0].moq;
                      }
                      keyboard = TextInputType.numberWithOptions(
                          signed: true, decimal: false);
                      regExp =
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
                    }
                    _textEditingController.value = TextEditingValue(
                      text: this.counter.toString(),
                      selection: TextSelection.fromPosition(
                        TextPosition(offset: this.counter.toString().length),
                      ),
                    );
                    _txtSkuNotesEditController.value = TextEditingValue(
                      text: widget.marketList[index].skuNotes,
                      selection: TextSelection.fromPosition(
                        TextPosition(
                            offset: widget.marketList[index].skuNotes.length),
                      ),
                    );
                    setState(() {
                      if (counter > 0 &&
                          counter >
                              widget.marketList[index].priceList[0].moq - 1) {
                        isValid = true;
                        // btnColor = lightGreen;
                      } else {
                        isValid = false;
                        //btnColor = lightGreen.withOpacity(0.5);
                      }
                    });
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return StatefulBuilder(builder:
                            (BuildContext context, StateSetter setStates) {
                          return SingleChildScrollView(
                              child: Container(
                            padding: EdgeInsets.only(
                                top: 15.0,
                                right: 10.0,
                                left: 10.0,
                                bottom: 15.0),
                            color: Colors.white,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 5, left: 10.0, bottom: 10.0),
                                        child: SizedBox(
                                            width: 250.0,
                                            child: Text(
                                                widget.marketList[index]
                                                    .productName,
                                                textAlign: TextAlign.start,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                softWrap: false,
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.black,
                                                    fontFamily:
                                                        "SourceSansProSemiBold"))),
                                      ),
                                      new Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (widget
                                                .marketList[index]
                                                .priceList[0]
                                                .unitSizeAlias
                                                .isDecimalAllowed) {
                                              counter = widget.marketList[index]
                                                  .priceList[0].moq
                                                  .toDouble();
                                            } else {
                                              counter = widget.marketList[index]
                                                  .priceList[0].moq;
                                            }
                                            widget.marketList[index].quantity =
                                                counter;
                                            _txtSkuNotesEditController.text =
                                                "";
                                            widget.marketList[index].skuNotes =
                                                _txtSkuNotesEditController.text;
                                            widget.marketList[index]
                                                .selectedQuantity = "+";
                                            widget.marketList[index].bgColor =
                                                faintGrey;
                                            widget.marketList[index].txtColor =
                                                buttonBlue;
                                            widget.marketList[index].txtSize =
                                                30.0;
                                            widget.marketList[index]
                                                .isSelected = false;
                                            widget.marketList.removeWhere(
                                                (it) =>
                                                    it.productName
                                                            .toLowerCase() ==
                                                        widget.marketList[index]
                                                            .productName
                                                            .toLowerCase() &&
                                                    it.sku.toLowerCase() ==
                                                        widget.marketList[index]
                                                            .sku
                                                            .toLowerCase() &&
                                                    widget
                                                            .marketList[index]
                                                            .priceList[0]
                                                            .unitSize
                                                            .toLowerCase() ==
                                                        it.priceList[0].unitSize
                                                            .toLowerCase());
                                            calculatePrice();
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: 5,
                                              left: 20.0,
                                              right: 10.0,
                                              bottom: 10.0),
                                          child: Align(
                                              alignment: Alignment.topRight,
                                              child: Text("Remove",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: buttonBlue,
                                                      fontFamily:
                                                          "SourceSansProRegular"))),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (counter > 0) this.counter--;
                                                _textEditingController.text =
                                                    counter.toString();
                                                _txtSkuNotesEditController
                                                        .text =
                                                    widget.marketList[index]
                                                        .skuNotes
                                                        .toString();
                                                setStates(() {
                                                  if (counter > 0 &&
                                                      counter >
                                                          widget
                                                                  .marketList[
                                                                      index]
                                                                  .priceList[0]
                                                                  .moq -
                                                              1) {
                                                    isValid = true;
                                                    // btnColor = lightGreen;
                                                  } else {
                                                    isValid = false;
                                                    //btnColor = lightGreen.withOpacity(0.5);
                                                  }
                                                });
                                              });
                                            },
                                            child: Container(
                                                margin:
                                                    EdgeInsets.only(right: 5.0),
                                                height: 40.0,
                                                width: 40.0,
                                                child: Center(
                                                  child: Icon(
                                                    Icons.remove,
                                                    color: buttonBlue,
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(200),
                                                  ),
                                                  color: faintGrey,
                                                ))),
                                        Container(
                                            width: 200.0,
                                            child: TextFormField(
                                                autofocus: true,
                                                autovalidate: true,
                                                validator: (value) => (value !=
                                                            null &&
                                                        value.isNotEmpty &&
                                                        double.parse(
                                                                _textEditingController
                                                                    .text) <
                                                            widget
                                                                .marketList[
                                                                    index]
                                                                .priceList[0]
                                                                .moq)
                                                    ? "Quantity is below MOQ"
                                                    : null,
                                                controller:
                                                    _textEditingController,
                                                keyboardType: keyboard,
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  regExp,
                                                ],
                                                maxLength: 7,
                                                textInputAction:
                                                    TextInputAction.go,
                                                cursorColor: Colors.blue,
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  counterText: "",
                                                  errorText: (_textEditingController
                                                                  .text !=
                                                              null &&
                                                          _textEditingController
                                                              .text
                                                              .isNotEmpty &&
                                                          double.parse(
                                                                  _textEditingController
                                                                      .text) <
                                                              widget
                                                                  .marketList[
                                                                      index]
                                                                  .priceList[0]
                                                                  .moq)
                                                      ? "Quantity is below MOQ"
                                                      : null,
                                                  fillColor: faintGrey,
                                                  filled: true,
                                                  errorStyle: TextStyle(
                                                      fontSize: 12.0,
                                                      fontFamily:
                                                          "SourceSansProRegular"),
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  hintStyle: new TextStyle(
                                                      color: greyText,
                                                      fontSize: 14.0,
                                                      fontFamily:
                                                          "SourceSansProRegular"),
                                                ),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14.0,
                                                    fontFamily:
                                                        "SourceSansProSemiBold"),
                                                onChanged: (query) {
                                                  if (query != null &&
                                                      query.isNotEmpty) {
                                                    if (widget
                                                        .marketList[index]
                                                        .priceList[0]
                                                        .unitSizeAlias
                                                        .isDecimalAllowed) {
                                                      counter =
                                                          double.parse(query);
                                                      setStates(() {
                                                        if (counter > 0 &&
                                                            counter >
                                                                widget
                                                                        .marketList[
                                                                            index]
                                                                        .priceList[
                                                                            0]
                                                                        .moq -
                                                                    1) {
                                                          isValid = true;
                                                          // btnColor = lightGreen;
                                                        } else {
                                                          isValid = false;
                                                          //btnColor = lightGreen.withOpacity(0.5);
                                                        }
                                                      });
                                                    } else {
                                                      counter =
                                                          int.parse(query);
                                                      setStates(() {
                                                        if (counter > 0 &&
                                                            counter >
                                                                widget
                                                                        .marketList[
                                                                            index]
                                                                        .priceList[
                                                                            0]
                                                                        .moq -
                                                                    1) {
                                                          isValid = true;
                                                          // btnColor = lightGreen;
                                                        } else {
                                                          isValid = false;
                                                          //btnColor = lightGreen.withOpacity(0.5);
                                                        }
                                                      });
                                                    }
                                                  }
                                                })),
                                        GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                this.counter++;
                                                _textEditingController.text =
                                                    counter.toString();
                                                setStates(() {
                                                  if (counter > 0 &&
                                                      counter >
                                                          widget
                                                                  .marketList[
                                                                      index]
                                                                  .priceList[0]
                                                                  .moq -
                                                              1) {
                                                    isValid = true;
                                                    // btnColor = lightGreen;
                                                  } else {
                                                    isValid = false;
                                                    //btnColor = lightGreen.withOpacity(0.5);
                                                  }
                                                });
                                              });
                                            },
                                            child: Container(
                                                margin:
                                                    EdgeInsets.only(right: 5.0),
                                                height: 40.0,
                                                width: 40.0,
                                                child: Center(
                                                  child: Icon(
                                                    Icons.add,
                                                    color: buttonBlue,
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(200),
                                                  ),
                                                  color: faintGrey,
                                                )))
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    margin: EdgeInsets.only(top: 20.0),
                                    child: TextField(
                                      controller: _txtSkuNotesEditController,
                                      keyboardType: TextInputType.text,
                                      maxLines: null,
                                      maxLength: 150,
                                      cursorColor: Colors.blue,
                                      decoration: InputDecoration(
                                        fillColor: faintGrey,
                                        filled: true,
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        hintText: Constants.txt_add_notes,
                                        counterStyle: TextStyle(
                                            fontFamily: "SourceSansProRegular"),
                                        hintStyle: new TextStyle(
                                            color: greyText,
                                            fontSize: 16.0,
                                            fontFamily: "SourceSansProRegular"),
                                      ),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                          fontFamily: "SourceSansProRegular"),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 20.0, right: 10.0, left: 10.0),
                                    height: 47.0,
                                    width: MediaQuery.of(context).size.width,
                                    child: FlatButton(
                                      disabledColor: faintGrey,
                                      color: (isValid) ? buttonBlue : faintGrey,
                                      onPressed: isValid
                                          ? () {
                                              FocusScope.of(context).unfocus();
                                              setState(() {
                                                _textEditingController.text =
                                                    counter.toString();

                                                if (widget.marketList[index]
                                                            .quantity ==
                                                        0 ||
                                                    widget.marketList[index]
                                                            .quantity <
                                                        widget.marketList[index]
                                                            .priceList[0].moq) {
                                                  widget.marketList[index]
                                                          .quantity =
                                                      widget.marketList[index]
                                                          .priceList[0].moq;
                                                  widget.marketList[index]
                                                      .selectedQuantity = "+";
                                                  widget.marketList[index]
                                                      .bgColor = faintGrey;
                                                  widget.marketList[index]
                                                      .txtColor = buttonBlue;
                                                  widget.marketList[index]
                                                      .txtSize = 30.0;
                                                  widget.marketList[index]
                                                      .isSelected = false;
                                                  widget.marketList.removeWhere((it) =>
                                                      it.productName
                                                              .toLowerCase() ==
                                                          widget
                                                              .marketList[index]
                                                              .productName
                                                              .toLowerCase() &&
                                                      it.sku.toLowerCase() ==
                                                          widget
                                                              .marketList[index]
                                                              .sku
                                                              .toLowerCase() &&
                                                      widget
                                                              .marketList[index]
                                                              .priceList[0]
                                                              .unitSize
                                                              .toLowerCase() ==
                                                          it.priceList[0]
                                                              .unitSize
                                                              .toLowerCase());
                                                } else {
                                                  widget.marketList[index]
                                                      .quantity = counter;
                                                  if (widget
                                                      .marketList[index]
                                                      .priceList[0]
                                                      .unitSizeAlias
                                                      .isDecimalAllowed) {
                                                    widget.marketList[index]
                                                            .selectedQuantity =
                                                        counter
                                                            .toStringAsFixed(2);
                                                  } else {
                                                    widget.marketList[index]
                                                            .selectedQuantity =
                                                        counter.toString();
                                                  }
                                                  widget.marketList[index]
                                                      .bgColor = buttonBlue;
                                                  widget.marketList[index]
                                                      .txtColor = Colors.white;
                                                  widget.marketList[index]
                                                      .txtSize = 16.0;
                                                  widget.marketList[index]
                                                          .skuNotes =
                                                      _txtSkuNotesEditController
                                                          .text;
                                                  widget.marketList[index]
                                                      .isSelected = true;
                                                }
                                                calculatePrice();
                                                Navigator.pop(context);
                                              });
                                            }
                                          : null,
                                      child: Text(
                                        "Done",
                                        style: TextStyle(
                                            color: (isValid)
                                                ? Colors.white
                                                : greyText,
                                            fontSize: 16,
                                            fontFamily:
                                                "SourceSansProSemiBold"),
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                        });
                      },
                    );
                  },
                  child: Container(
                      color: Colors.white,
                      child: ListTile(
                          focusColor: Colors.white,
                          contentPadding:
                              EdgeInsets.only(left: 15.0, right: 10.0),
                          title: Text(
                            widget.marketList[index].productName,
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontFamily: "SourceSansProSemiBold"),
                          ),
                          subtitle: displayPriceWithShortNames(
                              widget.marketList[index]),
                          trailing: Container(
                            margin: EdgeInsets.only(right: 5.0),
                            height: 40.0,
                            width: 100.0,
                            child: Text(
                              widget.marketList[index].selectedQuantity +
                                  " " +
                                  widget.marketList[index].priceList[0]
                                      .unitSizeAlias.shortName,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: azul_blue,
                                  fontFamily: "SourceSansProSemiBold"),
                            ),
                          ))),
                ),
              );
            }));
  }

  Widget displayPriceWithShortNames(OutletMarketList marketList) {
    return Container(
        margin: EdgeInsets.only(top: 3.0),
        child: Column(children: <Widget>[
          Row(children: <Widget>[
            Text(
              marketList.priceList[0].price.getDisplayValue() + " / ",
              style: TextStyle(
                fontSize: 12.0,
                color: greyText,
                fontFamily: "SourceSansProRegular",
              ),
            ),
            Text(
              marketList.priceList[0].unitSizeAlias.shortName,
              style: TextStyle(
                fontSize: 12.0,
                color: azul_blue,
                fontFamily: "SourceSansProRegular",
              ),
            ),
          ]),
          Align(
            alignment: Alignment.centerLeft,
            child: displaySkuNotesName(marketList.skuNotes),
          ),
        ]));
  }

  Widget displaySkuNotesName(String text) {
    if (text.isNotEmpty) {
      return Container(
          margin: EdgeInsets.only(top: 3.0, bottom: 3.0),
          child: Text(text,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 12.0,
                color: greyText,
                fontFamily: "SourceSansProRegular",
              )));
    } else {
      return Container();
    }
  }

  createOrderAPI() async {
    _showLoader();
    CreateOrderModel createOrderModel = new CreateOrderModel();
    createOrderModel.timeDelivered = selectedDate;
    createOrderModel.notes = widget.orderNotes;
    createOrderModel.orderId = widget.orderId;
    List<Product> productslist = [];
    for (var i = 0; i < widget.marketList.length; i++) {
      Product products = new Product();
      products.sku = widget.marketList[i].sku;
      products.notes = widget.marketList[i].skuNotes;
      products.quantity = widget.marketList[i].quantity;
      products.unitSize = widget.marketList[i].priceList[0].unitSize;
      productslist.add(products);
    }
    createOrderModel.products = productslist;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart',
      'mudra': mudra,
      'supplierId': supplierID
    };
    Map<String, String> queryParams = {
      'supplierId': supplierID,
      'outletId': widget.outletId,
    };

    String queryString = Uri(queryParameters: queryParams).query;
    var requestUrl;
    http.Response response;
    final msg = jsonEncode(createOrderModel);
    if (widget.orderId != null && widget.orderId.isNotEmpty) {
      requestUrl = URLEndPoints.edit_place_order + '?' + queryString;
      response = await http.put(requestUrl, headers: headers, body: msg);
    } else {
      requestUrl = URLEndPoints.retrieve_orders + '?' + queryString;
      response = await http.post(requestUrl, headers: headers, body: msg);
    }
    print("url" + requestUrl);
    print("ms" + createOrderModel.toJson().toString());
    print("ms" + response.statusCode.toString());
    print("ms" + response.body.toString());
    PlaceOrderResponse placeOrderResponse =
        PlaceOrderResponse.fromJson(jsonDecode(response.body));
    if (placeOrderResponse != null &&
        placeOrderResponse.status == 200 &&
        placeOrderResponse.data.status == "SUCCESS") {
      events.mixpanel.track(Events.TAP_ORDER_REVIEW_PLACE_ORDER);
      events.mixpanel.flush();
      showSuccessDialog();
    } else {
      showFailureDialog();
    }
  }

  deleteOrderAPI() async {
    _showLoader();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart',
      'mudra': mudra,
      'supplierId': supplierID
    };
    Map<String, String> queryParams = {
      'supplierId': supplierID,
      'orderId': widget.orderId,
      'outletId': widget.outletId,
    };

    String queryString = Uri(queryParameters: queryParams).query;
    var requestUrl = URLEndPoints.retrieve_orders + '?' + queryString;
    print("url" + requestUrl);
    http.Response response = await http.delete(requestUrl, headers: headers);
    moveToDashBoard();
    print("url" + requestUrl);
    print("ms" + response.statusCode.toString());
  }

  void moveToDashBoard() {
    DartNotificationCenter.post(channel: Constants.draft_notifier);
    DartNotificationCenter.unsubscribe(
        observer: 1, channel: Constants.draft_notifier);
    DartNotificationCenter.unsubscribe(
        observer: 1, channel: Constants.acknowledge_notifier);
    Navigator.pushNamed(context, '/home');
  }

  void showAlert(context) {
    FocusScope.of(context).unfocus();
    BuildContext dialogContext;
    // set up the button
    Widget okButton = FlatButton(
      child: Text(Constants.txt_ok),
      onPressed: () {
        Navigator.pop(dialogContext);
        createOrderAPI();
        events.mixpanel
            .track(Events.TAP_ORDER_REVIEW_PLACE_ORDER_CONFIRM, properties: {
          'ItemCount': widget.marketList.length,
          'OrderNotes':
              (widget.orderNotes != null && widget.orderNotes.isNotEmpty)
                  ? true
                  : false,
          'OutletID': widget.outletId,
          'OutletName': widget.outletName,
          'isAddonOrder': isAddonOrder,
        });
        events.mixpanel.flush();
      },
    );
    // set up the button
    Widget btnCancel = FlatButton(
      child: Text(Constants.txt_cancel),
      onPressed: () {
        events.mixpanel.track(Events.TAP_ORDER_REVIEW_PLACE_ORDER_CANCEL);
        events.mixpanel.flush();
        Navigator.pop(dialogContext);
      },
    );

    // set up the AlertDialog
    BasicDialogAlert alert = BasicDialogAlert(
      title: Text(Constants.txt_place_this_order),
      actions: [btnCancel, okButton],
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

  void showDraftAlert(context) {
    FocusScope.of(context).unfocus();
    BuildContext dialogContext;
    // set up the button
    Widget okButton = FlatButton(
      child: Text(Constants.txt_ok),
      onPressed: () {
        Navigator.pop(dialogContext);
        events.mixpanel.track(Events.TAP_ORDER_REVIEW_PAGE_DELETE_DRAFT);
        events.mixpanel.flush();
        deleteOrderAPI();
      },
    );
    // set up the button
    Widget btnCancel = FlatButton(
      child: Text(Constants.txt_cancel),
      onPressed: () {
        Navigator.pop(dialogContext);
      },
    );

    // set up the AlertDialog
    BasicDialogAlert alert = BasicDialogAlert(
      title: Text(Constants.txt_delete_draft),
      actions: [btnCancel, okButton],
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

  displayDeliveryDates(BuildContext context) {
    return Container(
        height: 100.0,
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: ClampingScrollPhysics(),
            itemCount: lstDeliveryDates[0].deliveryDates.length,
            itemBuilder: (BuildContext context, int index) {
              Container contianer;
              Text text;
              if (lstDeliveryDates[0].deliveryDates[index].isEvePH ||
                  lstDeliveryDates[0].deliveryDates[index].isPH) {
                text = Text(
                    DateFormat('d MMM').format(
                        DateTime.fromMillisecondsSinceEpoch(lstDeliveryDates[0]
                                .deliveryDates[index]
                                .deliveryDate *
                            1000)),
                    style: TextStyle(
                        fontFamily: "SourceSansProSemiBold",
                        fontSize: 16.0,
                        color: warning_red));
              } else {
                text = Text(
                    DateFormat('d MMM').format(
                        DateTime.fromMillisecondsSinceEpoch(lstDeliveryDates[0]
                                .deliveryDates[index]
                                .deliveryDate *
                            1000)),
                    style: TextStyle(
                        fontFamily: "SourceSansProSemiBold",
                        fontSize: 16.0,
                        color: grey_text));
              }
              if (lstDeliveryDates[0].deliveryDates[index].isSelected) {
                print("camehere" +
                    lstDeliveryDates[0]
                        .deliveryDates[index]
                        .isSelected
                        .toString());
                contianer = new Container(
                    margin: EdgeInsets.only(
                        top: 15.0, bottom: 15.0, left: 15.0, right: 5.0),
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(10.0),
                      border: Border.all(
                        color: azul_blue,
                        //                   <--- border color
                        width: 2.0,
                      ),
                      color: faintGrey,
                    ),
                    alignment: Alignment.center,
                    height: 40.0,
                    width: 100.0,
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                            DateFormat('EEEE').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    lstDeliveryDates[0]
                                            .deliveryDates[index]
                                            .deliveryDate *
                                        1000)),
                            style: TextStyle(
                                fontFamily: "SourceSansProRegular",
                                fontSize: 12.0,
                                color: azul_blue)),
                        Text(
                            DateFormat('d MMM').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    lstDeliveryDates[0]
                                            .deliveryDates[index]
                                            .deliveryDate *
                                        1000)),
                            style: TextStyle(
                                fontFamily: "SourceSansProSemiBold",
                                fontSize: 16.0,
                                color: azul_blue))
                      ],
                    )));
              } else {
                print("camehere" +
                    lstDeliveryDates[0]
                        .deliveryDates[index]
                        .isSelected
                        .toString());
                contianer = new Container(
                    margin: EdgeInsets.only(
                        top: 15.0, bottom: 15.0, left: 10.0, right: 10.0),
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(10.0),
                      color: faintGrey,
                    ),
                    alignment: Alignment.center,
                    height: 40.0,
                    width: 100.0,
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                            DateFormat('EEEE').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    lstDeliveryDates[0]
                                            .deliveryDates[index]
                                            .deliveryDate *
                                        1000)),
                            style: TextStyle(
                                fontFamily: "SourceSansProRegular",
                                fontSize: 12.0,
                                color: grey_text)),
                        text
                      ],
                    )));
              }

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (!lstDeliveryDates[0].deliveryDates[index].isSelected) {
                      selectedDate =
                          lstDeliveryDates[0].deliveryDates[index].deliveryDate;
                      lstDeliveryDates[0].deliveryDates[index].isSelected =
                          true;
                      for (var i = 0;
                          i < lstDeliveryDates[0].deliveryDates.length;
                          i++) {
                        if (lstDeliveryDates[0].deliveryDates[i].isSelected &&
                            i != index) {
                          lstDeliveryDates[0].deliveryDates[i].isSelected =
                              false;
                        }
                      }
                    }
                  });
                },
                child: contianer,
              );
            }));
  }

  Future<void> showFailureDialog() async {
    _hideLoader();
    await showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          Future.delayed(Duration(seconds: 2), () {
            Navigator.pop(dialogContext);
          });
          return CustomDialogBox(
            title: "Can’t create this order",
            imageAssets: 'assets/images/img_exclaimation_red.png',
          );
        }).then((value) {
      moveToDashBoard();
    });
  }

  Future<void> showSuccessDialog() async {
    _hideLoader();
    await showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          Future.delayed(Duration(seconds: 2), () {
            Navigator.pop(dialogContext);
          });
          return CustomDialogBox(
            title: "Order created",
            imageAssets: 'assets/images/tick_receive_big.png',
          );
        }).then((value) {
      moveToDashBoard();
    });
  }
}
