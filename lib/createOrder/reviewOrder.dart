import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:zm_supplier/home/home_page.dart';
import 'package:zm_supplier/models/createOrderModel.dart';
import 'package:zm_supplier/models/outletMarketList.dart';
import 'package:zm_supplier/models/supplierDeliveryDates.dart';
import 'package:zm_supplier/orders/orderDetailsPage.dart';
import 'package:zm_supplier/utils/color.dart';
import 'package:zm_supplier/utils/constants.dart';
import 'package:zm_supplier/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:zm_supplier/utils/customDialog.dart';
import 'dart:convert';
import 'dart:ui';
import 'package:zm_supplier/utils/urlEndPoints.dart';

import 'outletSelection.dart';

/**
 * Created by RajPrudhviMarella on 04/Mar/2021.
 */

class ReviewOrderPage extends StatefulWidget {
  static const String tag = 'MarketListPage';
  List<OutletMarketList> marketList;
  String outletId;
  String orderNotes;
  String orderId;
  List<DeliveryDateList> lstDeliveryDates;

  ReviewOrderPage(this.marketList, this.outletId, this.orderNotes,
      this.lstDeliveryDates, this.orderId);

  @override
  State<StatefulWidget> createState() {
    return ReviewOrderDesign(lstDeliveryDates);
  }
}

class ReviewOrderDesign extends State<ReviewOrderPage>
    with TickerProviderStateMixin {
  int counter = 0;
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

  @override
  void initState() {
    loadSharedPrefs();
    lstDeliveryDates[0].deliveryDates[0].isSelected = true;
    selectedDate = lstDeliveryDates[0].deliveryDates[0].deliveryDate;
    calculatePrice();
    super.initState();
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
              elevation: 0.0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                "Review order",
                style: new TextStyle(
                    color: Colors.black, fontFamily: "SourceSansProSemiBold"),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.delete_forever_outlined,
                      color: Colors.black),
                ),
              ],
            ),
            bottomNavigationBar: Container(
                height: 80.0,
                color: Colors.white,
                child: Container(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Row(children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 7.0, right: 7.0),
                        height: 50,
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'Total',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'SourceSansProSemiBold',
                                    color: Colors.black),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5.0, top: 2.0),
                                child: Text(
                                  "\$${totalPrice.toStringAsFixed(2)}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'SourceSansProSemiBold',
                                      color: Colors.black),
                                ),
                              ),
                            ]),
                      ),
                      new Spacer(),
                      RaisedButton(
                        child: Container(
                            padding: EdgeInsets.only(left: 7.0, right: 7.0),
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
                        color: green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        onPressed: () {
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
                Headers(widget.marketList.length.toString() + " items"),
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
      padding: EdgeInsets.all(20.0),
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
      margin: EdgeInsets.only(top: 30),
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
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
                      Row(children: <Widget>[
                        Expanded(
                          child: LeftRightAlign(
                              left: Text("Subtotal",
                                  style: TextStyle(
                                      color: greyText,
                                      fontSize: 16.0,
                                      fontFamily: "SourceSansProRegular")),
                              right: Text(
                                  "\$${totalSkusPrice.toStringAsFixed(2)}",
                                  style: TextStyle(
                                      color: greyText,
                                      fontSize: 16.0,
                                      fontFamily: "SourceSansProRegular"))),
                        )
                      ])
                    ]),
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
                                    "\$${totalDeliveryPrice.toStringAsFixed(2)}",
                                    style: TextStyle(
                                        color: greyText,
                                        fontSize: 16.0,
                                        fontFamily: "SourceSansProRegular"))),
                          )
                        ])
                      ]),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(children: <Widget>[
                        Expanded(
                          child: LeftRightAlign(
                              left: Text(
                                  "Gst" +
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
                                  "\$${totalGstPrice.toStringAsFixed(2)}",
                                  style: TextStyle(
                                      color: greyText,
                                      fontSize: 16.0,
                                      fontFamily: "SourceSansProRegular"))),
                        )
                      ])
                    ]),
              ]),
          Padding(padding: EdgeInsets.fromLTRB(20, 5, 20, 20)),
        ],
      ),
    );
  }

  Widget EditNotes() {
    return Container(
        padding: EdgeInsets.all(20.0),
        height: 80.0,
        color: Colors.white,
        margin: EdgeInsets.only(top: 2.0),
        child: TextField(
            controller: _txtSpecialRequest,
            decoration: InputDecoration(
              fillColor: Colors.white,
              hintText: "eg. Please prepare or pack item in certain way",
              filled: true,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintStyle: new TextStyle(
                  color: greyText,
                  fontSize: 16.0,
                  fontFamily: "SourceSansProRegular"),
            ),
            style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontFamily: "SourceSansProSemiBold"),
            onChanged: (query) {
              counter = int.parse(query);
            }));
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
                child: Container(
                    color: Colors.white,
                    child: ListTile(
                      focusColor: Colors.white,
                      contentPadding: EdgeInsets.only(
                          left: 15.0, right: 10.0, top: 5.0, bottom: 5.0),
                      title: Text(
                        widget.marketList[index].productName,
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            fontFamily: "SourceSansProSemiBold"),
                      ),
                      subtitle:
                          displayPriceWithShortNames(widget.marketList[index]),
                      trailing: GestureDetector(
                          onTap: () {
                            if (widget.marketList[index].quantity != 0) {
                              counter = widget.marketList[index].quantity;
                            } else {
                              counter =
                                  widget.marketList[index].priceList[0].moq;
                            }
                            _textEditingController.value = TextEditingValue(
                              text: this.counter.toString(),
                              selection: TextSelection.fromPosition(
                                TextPosition(
                                    offset: this.counter.toString().length),
                              ),
                            );
                            _txtSkuNotesEditController.value = TextEditingValue(
                              text: widget.marketList[index].skuNotes,
                              selection: TextSelection.fromPosition(
                                TextPosition(
                                    offset: widget
                                        .marketList[index].skuNotes.length),
                              ),
                            );

                            showModalBottomSheet<void>(
                              context: context,
                              builder: (context) {
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 5, left: 20.0, bottom: 10.0),
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  widget.marketList[index]
                                                      .productName,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.black,
                                                      fontFamily:
                                                          "SourceSansProSemiBold"))),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      if (counter >
                                                          widget
                                                              .marketList[index]
                                                              .priceList[0]
                                                              .moq)
                                                        this.counter--;
                                                      _textEditingController
                                                              .text =
                                                          counter.toString();
                                                      _txtSkuNotesEditController
                                                              .text =
                                                          widget
                                                              .marketList[index]
                                                              .skuNotes
                                                              .toString();
                                                    });
                                                  },
                                                  child: Container(
                                                      margin: EdgeInsets.only(
                                                          right: 5.0),
                                                      height: 40.0,
                                                      width: 40.0,
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.remove,
                                                          color: Colors.blue,
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
                                                  height: 40.0,
                                                  child: TextField(
                                                      controller:
                                                          _textEditingController,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      textInputAction:
                                                          TextInputAction.go,
                                                      cursorColor: Colors.blue,
                                                      textAlign:
                                                          TextAlign.center,
                                                      decoration:
                                                          InputDecoration(
                                                        fillColor: faintGrey,
                                                        filled: true,
                                                        border:
                                                            InputBorder.none,
                                                        focusedBorder:
                                                            InputBorder.none,
                                                        enabledBorder:
                                                            InputBorder.none,
                                                        errorBorder:
                                                            InputBorder.none,
                                                        disabledBorder:
                                                            InputBorder.none,
                                                        hintStyle: new TextStyle(
                                                            color: greyText,
                                                            fontSize: 16.0,
                                                            fontFamily:
                                                                "SourceSansProRegular"),
                                                      ),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16.0,
                                                          fontFamily:
                                                              "SourceSansProSemiBold"),
                                                      onChanged: (query) {
                                                        counter =
                                                            int.parse(query);
                                                      })),
                                              GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      this.counter++;
                                                      _textEditingController
                                                              .text =
                                                          counter.toString();
                                                    });
                                                  },
                                                  child: Container(
                                                      margin: EdgeInsets.only(
                                                          right: 5.0),
                                                      height: 40.0,
                                                      width: 40.0,
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.add,
                                                          color: Colors.blue,
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
                                              left: 15.0, right: 15.0),
                                          margin: EdgeInsets.only(top: 20.0),
                                          child: TextField(
                                            controller:
                                                _txtSkuNotesEditController,
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
                                              hintStyle: new TextStyle(
                                                  color: greyText,
                                                  fontSize: 16.0,
                                                  fontFamily:
                                                      "SourceSansProRegular"),
                                            ),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.0,
                                                fontFamily:
                                                    "SourceSansProRegular"),
                                          ),
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              print("$counter");
                                              setState(() {
                                                _textEditingController.text =
                                                    counter.toString();
                                                widget.marketList[index]
                                                    .quantity = counter;
                                                if (widget.marketList[index]
                                                        .quantity ==
                                                    0) {
                                                  widget.marketList[index]
                                                      .selectedQuantity = "+";
                                                  widget.marketList[index]
                                                      .bgColor = faintGrey;
                                                  widget.marketList[index]
                                                      .txtColor = Colors.blue;
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
                                                          .selectedQuantity =
                                                      counter.toString();
                                                  widget.marketList[index]
                                                      .bgColor = Colors.blue;
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
                                            },
                                            child: Container(
                                                padding: EdgeInsets.only(
                                                    left: 20.0, right: 20.0),
                                                margin: EdgeInsets.only(
                                                    top: 20.0,
                                                    right: 20.0,
                                                    left: 20.0),
                                                height: 47.0,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                    color: buttonBlue,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                30))),
                                                child: Center(
                                                    child: Text(
                                                  "Done",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontFamily:
                                                          "SourceSansProSemiBold"),
                                                ))))
                                      ],
                                    ),
                                  ),
                                ));
                              },
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 5.0),
                            height: 40.0,
                            width: 40.0,
                            child: Center(
                              child: Text(
                                widget.marketList[index].selectedQuantity +
                                    " " +
                                    widget.marketList[index].priceList[0]
                                        .unitSizeAlias,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: azul_blue,
                                    fontFamily: "SourceSansProSemiBold"),
                              ),
                            ),
                          )),
                    )),
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
              marketList.priceList[0].unitSizeAlias,
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
    if (response.statusCode == 200) {
      showSuccessDialog();
    } else {
      showFailureDialog();
    }
  }

  void showAlert(context) {
    BuildContext dialogContext;
    // set up the button
    Widget okButton = FlatButton(
      child: Text(Constants.txt_ok),
      onPressed: () {
        Navigator.pop(dialogContext);
        createOrderAPI();
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
                    margin: EdgeInsets.all(10.0),
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
                    height: 55.0,
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
                    margin: EdgeInsets.all(10.0),
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(10.0),
                      color: faintGrey,
                    ),
                    alignment: Alignment.center,
                    height: 55.0,
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

  void showFailureDialog() {
    _hideLoader();
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          Future.delayed(Duration(seconds: 2), () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          });
          return CustomDialogBox(
            title: "Can’t create this order",
            imageAssets: 'assets/images/img_exclaimation_red.png',
          );
        });
  }

  void showSuccessDialog() {
    _hideLoader();
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          Future.delayed(Duration(seconds: 2), () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage(), fullscreenDialog: true));
          });
          return CustomDialogBox(
            title: "Order Created",
            imageAssets: 'assets/images/tick_receive_big.png',
          );
        });
  }
}
