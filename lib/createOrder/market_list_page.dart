import 'package:dart_notification_center/dart_notification_center.dart';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:zm_supplier/createOrder/reviewOrder.dart';
import 'package:zm_supplier/models/createOrderModel.dart';
import 'package:zm_supplier/models/ordersResponseList.dart';
import 'package:zm_supplier/models/outletMarketList.dart';
import 'package:zm_supplier/models/supplierDeliveryDates.dart';
import 'package:zm_supplier/models/user.dart';
import 'package:zm_supplier/utils/color.dart';
import 'package:zm_supplier/utils/constants.dart';
import 'package:zm_supplier/utils/eventsList.dart';
import 'package:zm_supplier/utils/urlEndPoints.dart';
import 'dart:io' show Platform;

/**
 * Created by RajPrudhviMarella on 02/Mar/2021.
 */

class MarketListPage extends StatefulWidget {
  static const String tag = 'MarketListPage';
  final String outletId;
  final String outletName;
  List<Products> repeatOrderProducts;

  MarketListPage(this.outletId, this.outletName, this.repeatOrderProducts);

  @override
  State<StatefulWidget> createState() {
    return MarketListDesign(repeatOrderProducts);
  }
}

class MarketListDesign extends State<MarketListPage>
    with TickerProviderStateMixin {
  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _controller = new TextEditingController();
  final TextEditingController _textEditingController =
      new TextEditingController();
  final TextEditingController _txtSkuNotesEditController =
      new TextEditingController();
  final TextEditingController _txtOrderNotesEditController =
      new TextEditingController();
  Future<List<OutletMarketList>> favouriteOutletMarketListFuture;
  List<OutletMarketList> allOutletMarketList = [];
  List<OutletMarketList> selectedMarketList = [];
  String supplierID;
  String mudra;
  String searchedString;
  bool _isSearching = false;
  String searchQuery = "";
  var counter;
  bool _isShowLoader = false;
  List<DeliveryDateList> lstDeliveryDates;
  Future<List<DeliveryDateList>> deliveryDatesListFuture;
  String orderID = "";
  List<Products> repeatOrderProducts;
  String orderNotes = "Notes";

  MarketListDesign(this.repeatOrderProducts);

  Constants events = Constants();
  TextInputType keyboard;
  TextInputFormatter regExp;
  bool isValid = false;

  @override
  void initState() {
    loadSharedPrefs();
    super.initState();
    events.mixPanelEvents();
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
          deliveryDatesListFuture = callDeliveryDatesApi();
          favouriteOutletMarketListFuture = callOutletsMarket();
        }
      });
    } catch (Exception) {}
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: globalKey,
        backgroundColor: faintGrey,
        body: WillPopScope(
            onWillPop: () async {
              createDraftOrderAPI();
              return false;
            },
            child: ModalProgressHUD(
                inAsyncCall: _isShowLoader,
                child: FutureBuilder<List<DeliveryDateList>>(
                    future: deliveryDatesListFuture,
                    builder: (context, snapShot) {
                      if (snapShot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        if (snapShot.connectionState == ConnectionState.done &&
                            snapShot.hasData &&
                            snapShot.data.isNotEmpty) {
                          return Scaffold(
                            bottomNavigationBar: Container(
                                height: 80.0,
                                color: Colors.white,
                                child: Container(
                                    padding: EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: Row(children: <Widget>[
                                      FloatingActionButton.extended(
                                        backgroundColor: (orderNotes != null &&
                                                orderNotes.isNotEmpty &&
                                                orderNotes == "Notes")
                                            ? faintGrey
                                            : buttonBlue,
                                        foregroundColor: Colors.white,
                                        onPressed: () {
                                          events.mixpanel.track(Events
                                              .TAP_MARKET_LIST_SELECT_ORDER_NOTES);
                                          events.mixpanel.flush();
                                          createAddNotesOrder();
                                        },
                                        label: Container(
                                          width: 45.0,
                                          child: Text(
                                            orderNotes,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 16,
                                                letterSpacing: 0,
                                                fontFamily:
                                                    'SourceSansProSemiBold',
                                                color: (orderNotes != null &&
                                                        orderNotes.isNotEmpty &&
                                                        orderNotes == "Notes")
                                                    ? greyText
                                                    : Colors.white),
                                          ),
                                        ),
                                        icon: Image(
                                          image: AssetImage((orderNotes !=
                                                      null &&
                                                  orderNotes.isNotEmpty &&
                                                  orderNotes == "Notes")
                                              ? "assets/images/ic_notes.png"
                                              : "assets/images/icon_notes_white.png"),
                                        ),
                                        elevation: 0,
                                      ),
                                      new Spacer(),
                                      RaisedButton(
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: 7.0, right: 7.0),
                                          height: 50,
                                          child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text(
                                                  "Next",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily:
                                                          'SourceSansProSemiBold',
                                                      color: Colors.white),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: 5.0, top: 2.0),
                                                  child: Icon(
                                                    Icons
                                                        .arrow_forward_outlined,
                                                    color: Colors.white,
                                                    size: 22,
                                                  ),
                                                ),
                                              ]),
                                        ),
                                        color: lightGreen,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        onPressed: () {
                                          events.mixpanel.track(
                                              Events.TAP_MARKET_LIST_NEXT,
                                              properties: {
                                                'ItemCount':
                                                    selectedMarketList.length,
                                                'OrderNotes': (orderNotes !=
                                                            null &&
                                                        orderNotes.isNotEmpty &&
                                                        orderNotes != "Notes")
                                                    ? true
                                                    : false,
                                                'OutletID': widget.outletId,
                                                'OutletName': widget.outletName
                                              });
                                          events.mixpanel.flush();

                                          if (selectedMarketList != null &&
                                              selectedMarketList.isNotEmpty) {
                                            moveToReviewOrdersScreen();
                                            print(
                                                jsonEncode(selectedMarketList));
                                          } else {
                                            globalKey.currentState.showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Please select at least one product'),
                                                duration: Duration(seconds: 1),
                                              ),
                                            );
                                          }
                                        },
                                      )
                                    ]))),
                            body: displayList(context),
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
                                  onPressed: () => createDraftOrderAPI(),
                                ),
                              ),
                              title: _isSearching
                                  ? _buildSearchField()
                                  : Container(
                                      child: Column(
                                        children: [
                                          Text(
                                            widget.outletName,
                                            style: new TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0,
                                                fontFamily:
                                                    "SourceSansProBold"),
                                          ),
                                          Text(
                                            "Cutoff for earliest delivery: " +
                                                DateFormat('d MMM, hh:mm a')
                                                    .format(DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            lstDeliveryDates[0]
                                                                    .deliveryDates[
                                                                        0]
                                                                    .cutOffDate *
                                                                1000)),
                                            style: new TextStyle(
                                                color: grey_text,
                                                fontSize: 12.0,
                                                fontFamily:
                                                    "SourceSansProRegular"),
                                          ),
                                        ],
                                      ),
                                    ),
                              actions: _buildActions(),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }
                    }))));
  }

  Widget headers(context, String name, double size) {
    return Container(
      color: faintGrey,
      margin: EdgeInsets.only(top: 2.0),
      padding:
          EdgeInsets.only(left: 15.0, right: 20.0, top: 15.0, bottom: 10.0),
      child: Text(name,
          style: TextStyle(
            fontFamily: "SourceSansProBold",
            fontSize: size,
          )),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      maxLines: null,
      controller: _controller,
      autofocus: true,
      textInputAction: TextInputAction.go,
      cursorColor: Colors.blue,
      decoration: InputDecoration(
        prefixIcon: new Icon(Icons.search, color: Colors.black),
        hintText: Constants.txt_Search_sku,
        hintStyle: new TextStyle(
            color: greyText,
            fontSize: 16.0,
            fontFamily: "SourceSansProRegular"),
      ),
      style: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
          fontFamily: "SourceSansProRegular"),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(
            Icons.clear,
            color: Colors.black,
          ),
          onPressed: () {
            if (_controller == null || _controller.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search, color: Colors.black),
        onPressed: _startSearch,
      ),
    ];
  }

  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    events.mixpanel.track(Events.TAP_MARKET_LIST_SEARCH);
    events.mixpanel.flush();
    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _controller.clear();
      updateSearchQuery("");
    });
  }

  Widget displayList(BuildContext context) {
    return FutureBuilder<List<OutletMarketList>>(
        future: favouriteOutletMarketListFuture,
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapShot.connectionState == ConnectionState.done &&
                snapShot.hasData &&
                snapShot.data.isNotEmpty) {
              return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ListView(
                    children: <Widget>[
                      headers(context,
                          snapShot.data.length.toString() + " items", 18),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapShot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (_controller.text.isEmpty) {
                              return displaySearchedList(snapShot, index);
                            } else if (snapShot.data[index].productName
                                .toLowerCase()
                                .contains(_controller.text)) {
                              return displaySearchedList(snapShot, index);
                            } else {
                              return Container();
                            }
                          }),
                    ],
                  ));
            } else {
              return Container();
            }
          }
        });
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
                color: buttonBlue,
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
    if (text != null && text.isNotEmpty) {
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

  Widget displaySearchedList(
      AsyncSnapshot<List<OutletMarketList>> snapShot, int index) {
    return Card(
      margin: EdgeInsets.only(top: 2.0),
      child: GestureDetector(
          onTap: () {
            events.mixpanel.track(Events.TAP_MARKET_LIST_ADD_SKU);
            events.mixpanel.flush();
            if (snapShot
                .data[index].priceList[0].unitSizeAlias.isDecimalAllowed) {
              print(snapShot
                  .data[index].priceList[0].unitSizeAlias.isDecimalAllowed);
              if (snapShot.data[index].quantity != null &&
                  snapShot.data[index].quantity != 0) {
                counter = snapShot.data[index].quantity.toDouble();
              } else {
                counter = snapShot.data[index].priceList[0].moq.toDouble();
              }
              keyboard =
                  TextInputType.numberWithOptions(signed: false, decimal: true);
              regExp =
                  WhitelistingTextInputFormatter(RegExp(r'^\d+\.?\d{0,2}'));
            } else {
              if (snapShot.data[index].quantity != null &&
                  snapShot.data[index].quantity != 0) {
                counter = snapShot.data[index].quantity;
              } else {
                counter = snapShot.data[index].priceList[0].moq;
              }
              keyboard =
                  TextInputType.numberWithOptions(signed: true, decimal: true);
              regExp = FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
            }

            _textEditingController.value = TextEditingValue(
              text: this.counter.toString(),
              selection: TextSelection.fromPosition(
                TextPosition(offset: this.counter.toString().length),
              ),
            );
            _txtSkuNotesEditController.value = TextEditingValue(
              text: snapShot.data[index].skuNotes,
              selection: TextSelection.fromPosition(
                TextPosition(offset: snapShot.data[index].skuNotes.length),
              ),
            );
            setState(() {
              if (counter > 0 &&
                  counter > snapShot.data[index].priceList[0].moq - 1) {
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
                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setStates) {
                  return SingleChildScrollView(
                      child: Container(
                    padding: EdgeInsets.only(
                        top: 15.0, right: 10.0, left: 10.0, bottom: 15.0),
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
                                        snapShot.data[index].productName,
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
                                    if (snapShot.data[index].priceList[0]
                                        .unitSizeAlias.isDecimalAllowed) {
                                      counter = snapShot
                                          .data[index].priceList[0].moq
                                          .toDouble();
                                    } else {
                                      counter =
                                          snapShot.data[index].priceList[0].moq;
                                    }
                                    _txtSkuNotesEditController.text = "";
                                    snapShot.data[index].skuNotes =
                                        _txtSkuNotesEditController.text;
                                    snapShot.data[index].selectedQuantity = "+";
                                    snapShot.data[index].quantity = counter;
                                    snapShot.data[index].bgColor = faintGrey;
                                    snapShot.data[index].txtColor = buttonBlue;
                                    snapShot.data[index].txtSize = 30.0;
                                    snapShot.data[index].isSelected = false;
                                    if (selectedMarketList != null)
                                      selectedMarketList.removeWhere((it) =>
                                          it.productName.toLowerCase() ==
                                              snapShot.data[index].productName
                                                  .toLowerCase() &&
                                          it.sku.toLowerCase() ==
                                              snapShot.data[index].sku
                                                  .toLowerCase() &&
                                          snapShot.data[index].priceList[0]
                                                  .unitSize
                                                  .toLowerCase() ==
                                              it.priceList[0].unitSize
                                                  .toLowerCase());
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (counter > 0) this.counter--;
                                        _textEditingController.text =
                                            counter.toString();
                                        _txtSkuNotesEditController.text =
                                            snapShot.data[index].skuNotes
                                                .toString();
                                        setStates(() {
                                          if (counter > 0 &&
                                              counter >
                                                  snapShot.data[index]
                                                          .priceList[0].moq -
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
                                        margin: EdgeInsets.only(right: 5.0),
                                        height: 40.0,
                                        width: 40.0,
                                        child: Center(
                                          child: Icon(
                                            Icons.remove,
                                            color: buttonBlue,
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(200),
                                          ),
                                          color: faintGrey,
                                        ))),
                                Container(
                                    width: 200.0,
                                    child: TextFormField(
                                        autofocus: true,
                                        autovalidate: true,
                                        validator: (value) => (value != null &&
                                                value.isNotEmpty &&
                                                double.parse(
                                                        _textEditingController
                                                            .text) <
                                                    snapShot.data[index]
                                                        .priceList[0].moq)
                                            ? "Quantity is below MOQ"
                                            : null,
                                        controller: _textEditingController,
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                signed: false, decimal: true),
                                        inputFormatters: <TextInputFormatter>[
                                          regExp,
                                        ],
                                        textInputAction: TextInputAction.go,
                                        cursorColor: Colors.blue,
                                        maxLength: 7,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          counterText: "",
                                          errorText: (_textEditingController
                                                          .text !=
                                                      null &&
                                                  _textEditingController
                                                      .text.isNotEmpty &&
                                                  double.parse(
                                                          _textEditingController
                                                              .text) <
                                                      snapShot.data[index]
                                                          .priceList[0].moq)
                                              ? "Quantity is below MOQ"
                                              : null,
                                          fillColor: faintGrey,
                                          filled: true,
                                          focusedBorder: InputBorder.none,
                                          errorStyle: TextStyle(
                                              fontSize: 12.0,
                                              fontFamily:
                                                  "SourceSansProRegular"),
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
                                          if (query != null &&
                                              query.isNotEmpty) {
                                            if (snapShot
                                                .data[index]
                                                .priceList[0]
                                                .unitSizeAlias
                                                .isDecimalAllowed) {
                                              counter = double.parse(query);
                                              setStates(() {
                                                if (counter > 0 &&
                                                    counter >
                                                        snapShot
                                                                .data[index]
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
                                            } else {
                                              counter = int.parse(query);
                                              setStates(() {
                                                if (counter > 0 &&
                                                    counter >
                                                        snapShot
                                                                .data[index]
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
                                                  snapShot.data[index]
                                                          .priceList[0].moq -
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
                                        margin: EdgeInsets.only(right: 5.0),
                                        height: 40.0,
                                        width: 40.0,
                                        child: Center(
                                          child: Icon(
                                            Icons.add,
                                            color: buttonBlue,
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(200),
                                          ),
                                          color: faintGrey,
                                        )))
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
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
                                    fontSize: 14.0,
                                    fontFamily: "SourceSansProRegular"),
                              ),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
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
                                        snapShot.data[index].skuNotes =
                                            _txtSkuNotesEditController.text;

                                        snapShot.data[index].isSelected = true;
                                        if (counter != 0 ||
                                            counter >
                                                snapShot.data[index]
                                                    .priceList[0].moq) {
                                          snapShot.data[index].quantity =
                                              counter;
                                          if (snapShot.data[index].priceList[0]
                                              .unitSizeAlias.isDecimalAllowed) {
                                            snapShot.data[index]
                                                    .selectedQuantity =
                                                counter.toStringAsFixed(2);
                                          } else {
                                            snapShot.data[index]
                                                    .selectedQuantity =
                                                counter.toString();
                                          }
                                          snapShot.data[index].bgColor =
                                              buttonBlue;
                                          snapShot.data[index].txtColor =
                                              Colors.white;
                                          snapShot.data[index].txtSize = 16.0;
                                          selectedMarketList.removeWhere((it) =>
                                              it.productName.toLowerCase() ==
                                                  snapShot
                                                      .data[index].productName
                                                      .toLowerCase() &&
                                              it.sku.toLowerCase() ==
                                                  snapShot.data[index].sku
                                                      .toLowerCase() &&
                                              snapShot.data[index].priceList[0]
                                                      .unitSize
                                                      .toLowerCase() ==
                                                  it.priceList[0].unitSize
                                                      .toLowerCase());
                                          selectedMarketList
                                              .add(snapShot.data[index]);
                                        } else {
                                          snapShot.data[index].quantity =
                                              snapShot
                                                  .data[index].priceList[0].moq;
                                          snapShot.data[index]
                                              .selectedQuantity = "+";
                                          snapShot.data[index].bgColor =
                                              faintGrey;
                                          snapShot.data[index].txtColor =
                                              buttonBlue;
                                          snapShot.data[index].txtSize = 30.0;
                                          snapShot.data[index].isSelected =
                                              false;
                                          if (selectedMarketList != null)
                                            selectedMarketList.removeWhere(
                                                (it) =>
                                                    it.productName
                                                            .toLowerCase() ==
                                                        snapShot.data[index]
                                                            .productName
                                                            .toLowerCase() &&
                                                    it.sku.toLowerCase() ==
                                                        snapShot.data[index].sku
                                                            .toLowerCase() &&
                                                    snapShot
                                                            .data[index]
                                                            .priceList[0]
                                                            .unitSize
                                                            .toLowerCase() ==
                                                        it.priceList[0].unitSize
                                                            .toLowerCase());
                                          snapShot.data[index].quantity =
                                              counter;
                                        }
                                        Navigator.pop(context);
                                      });
                                    }
                                  : null,
                              child: Text(
                                "Done",
                                style: TextStyle(
                                    color: (isValid) ? Colors.white : greyText,
                                    fontSize: 16,
                                    fontFamily: "SourceSansProSemiBold"),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
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
                  contentPadding: EdgeInsets.only(
                      left: 15.0, right: 10.0, top: 5.0, bottom: 5.0),
                  title: RichText(
                    text: TextSpan(
                      children: highlightOccurrences(
                          snapShot.data[index].productName, _controller.text),
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                          fontFamily: "SourceSansProSemiBold"),
                    ),
                  ),
                  subtitle: displayPriceWithShortNames(snapShot.data[index]),
                  trailing: displayAddOrder(snapShot.data[index])))),
    );
  }

  List<TextSpan> highlightOccurrences(String source, String query) {
    if (query == null ||
        query.isEmpty ||
        !source.toLowerCase().contains(query.toLowerCase())) {
      return [TextSpan(text: source)];
    }
    final matches = query.toLowerCase().allMatches(source.toLowerCase());

    int lastMatchEnd = 0;

    final List<TextSpan> children = [];
    for (var i = 0; i < matches.length; i++) {
      final match = matches.elementAt(i);

      if (match.start != lastMatchEnd) {
        children.add(TextSpan(
          text: source.substring(lastMatchEnd, match.start),
        ));
      }

      children.add(TextSpan(
        text: source.substring(match.start, match.end),
        style: TextStyle(
            fontSize: 16.0,
            color: chartBlue,
            fontFamily: "SourceSansProSemiBold"),
      ));

      if (i == matches.length - 1 && match.end != source.length) {
        children.add(TextSpan(
          text: source.substring(match.end, source.length),
        ));
      }

      lastMatchEnd = match.end;
    }
    return children;
  }

  Future<List<OutletMarketList>> callOutletsMarket() async {
    _showLoader();
    OutletMarketBaseResponse marketList;
    OrdersBaseResponse ordersData;
    List<Products> draftOrdersList = [];
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart',
      'mudra': mudra,
      'supplierId': supplierID
    };
    Map<String, String> queryParams = {
      'supplierId': supplierID,
      'sortBy': "productName",
      "outletId": widget.outletId,
      "sortOrder": "ASC"
    };
    String queryString = Uri(queryParameters: queryParams).query;
    var requestUrl =
        URLEndPoints.retrieve_outlet_market_list + '?' + queryString;
    http.Response response = await http.get(requestUrl, headers: headers);
    Map results = json.decode(response.body);
    marketList = OutletMarketBaseResponse.fromJson(results);
    List<OutletMarketList> outletMarketList = marketList.data.data;

    for (var i = 0; i < outletMarketList.length; i++) {
      if (outletMarketList[i].priceList.length > 1) {
        for (var j = 0; j < outletMarketList[i].priceList.length; j++) {
          if (outletMarketList[i].priceList[j].status == ("visible")) {
            OutletMarketList productUom =
                OutletMarketList.fromJson(outletMarketList[i].toJson());
            List<PriceList> productPriceLists = [];
            productPriceLists.add(outletMarketList[i].priceList[j]);
            productUom.priceList = productPriceLists;
            allOutletMarketList.add(productUom);
          }
        }
      } else {
        if (outletMarketList[i].priceList[0].status == ("visible")) {
          OutletMarketList productUom =
              OutletMarketList.fromJson(outletMarketList[i].toJson());
          List<PriceList> productPriceLists = [];
          productPriceLists.add(outletMarketList[i].priceList[0]);
          productUom.priceList = productPriceLists;
          allOutletMarketList.add(productUom);
        }
      }
    }
    if (repeatOrderProducts != null && repeatOrderProducts.length > 0) {
      allOutletMarketList.forEach((elements) {
        repeatOrderProducts.forEach((element) {
          if (elements.sku == element.sku &&
              elements.priceList[0].unitSize == element.unitSize &&
              elements.productName == element.productName) {
            elements.isSelected = true;
            elements.quantity = element.quantity;
            elements.bgColor = buttonBlue;
            elements.skuNotes = element.notes;
            elements.txtColor = Colors.white;
            elements.txtSize = 16.0;
            print(elements.priceList[0].unitSizeAlias.isDecimalAllowed);
            print(element.unitSizeAlias.isDecimalAllowed);
            print(element.quantity);
            if (elements.priceList[0].unitSizeAlias.isDecimalAllowed) {
              elements.selectedQuantity = element.quantity.toStringAsFixed(2);
            } else {
              elements.selectedQuantity = element.quantity.toString();
            }
            selectedMarketList.removeWhere((it) =>
                it.productName.toLowerCase() ==
                    elements.productName.toLowerCase() &&
                it.sku.toLowerCase() == elements.sku.toLowerCase() &&
                elements.priceList[0].unitSize.toLowerCase() ==
                    it.priceList[0].unitSize.toLowerCase());
            selectedMarketList.add(elements);
          }
        });
      });
      _hideLoader();
    } else {
      Map<String, String> draftParams = {
        'supplierId': supplierID,
        'orderStatus': 'Draft',
        'outletId': widget.outletId
      };
      String draftqueryString = Uri(queryParameters: draftParams).query;

      var url =
          URLEndPoints.retrive_paginated_orders_url + '?' + draftqueryString;

      print(headers);
      print(url);
      var draftResponse = await http.get(url, headers: headers);
      if (draftResponse.statusCode == 200 ||
          draftResponse.statusCode == 201 ||
          draftResponse.statusCode == 202) {
        ordersData =
            OrdersBaseResponse.fromJson(json.decode(draftResponse.body));
        if (ordersData != null &&
            ordersData.data != null &&
            ordersData.data.data != null &&
            ordersData.data.data.length > 0) {
          draftOrdersList = ordersData.data.data[0].products;
          orderID = ordersData.data.data[0].orderId;
          if (ordersData.data.data[0].notes != null &&
              ordersData.data.data[0].notes.isNotEmpty) {
            orderNotes = ordersData.data.data[0].notes;
            _txtOrderNotesEditController.text = ordersData.data.data[0].notes;
            if (lstDeliveryDates != null && lstDeliveryDates.length > 0) {
              lstDeliveryDates[0].deliveryDates.forEach((deliveryDate) {
                if (ordersData.data.data[0].timeDelivered ==
                    deliveryDate.deliveryDate) {
                  deliveryDate.isSelected = true;
                }
              });
            }
          }
        }
      } else {
        print('failed get customers reports');
      }
      if (draftOrdersList != null && draftOrdersList.length > 0)
        allOutletMarketList.forEach((elements) {
          draftOrdersList.forEach((element) {
            if (elements.sku == element.sku &&
                elements.priceList[0].unitSize == element.unitSize &&
                elements.productName == element.productName) {
              elements.isSelected = true;
              elements.quantity = element.quantity;
              elements.bgColor = buttonBlue;
              elements.skuNotes = element.notes;
              elements.txtColor = Colors.white;
              elements.txtSize = 16.0;
              if (elements.priceList[0].unitSizeAlias.isDecimalAllowed) {
                elements.selectedQuantity = element.quantity.toStringAsFixed(2);
              } else {
                elements.selectedQuantity = element.quantity.toString();
              }
              selectedMarketList.removeWhere((it) =>
                  it.productName.toLowerCase() ==
                      elements.productName.toLowerCase() &&
                  it.sku.toLowerCase() == elements.sku.toLowerCase() &&
                  elements.priceList[0].unitSize.toLowerCase() ==
                      it.priceList[0].unitSize.toLowerCase());
              selectedMarketList.add(elements);
            }
          });
        });
      _hideLoader();
    }
    return allOutletMarketList;
  }

  void createAddNotesOrder() {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SingleChildScrollView(
              child: Container(
            padding: EdgeInsets.only(
                top: 15.0, right: 10.0, left: 10.0, bottom: 15.0),
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 5, left: 20.0, bottom: 10.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Notes or special requests",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontFamily: "SourceSansProSemiBold"))),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    margin: EdgeInsets.only(top: 20.0),
                    child: TextField(
                      controller: _txtOrderNotesEditController,
                      keyboardType: TextInputType.text,
                      maxLines: null,
                      maxLength: 150,
                      autofocus: true,
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
                            fontFamily: "SourceSansProRegular"),
                      ),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontFamily: "SourceSansProRegular"),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        if (_txtOrderNotesEditController.text != null &&
                            _txtOrderNotesEditController.text.isNotEmpty) {
                          setState(() {
                            orderNotes = _txtOrderNotesEditController.text;
                          });
                        } else {
                          setState(() {
                            orderNotes = "Notes";
                          });
                        }
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
  }

  createDraftOrderAPI() async {
    if (selectedMarketList != null && selectedMarketList.length > 0) {
      _showLoader();
      CreateOrderModel createOrderModel = new CreateOrderModel();
      createOrderModel.notes = _txtOrderNotesEditController.text.toString();
      bool isAnyDateSelected = false;
      int selectedDate = 0;
      for (var i = 0; i < lstDeliveryDates[0].deliveryDates.length; i++) {
        if (lstDeliveryDates[0].deliveryDates[i].isSelected) {
          isAnyDateSelected = true;
          selectedDate = lstDeliveryDates[0].deliveryDates[i].deliveryDate;
        }
      }
      if (!isAnyDateSelected) {
        lstDeliveryDates[0].deliveryDates[0].isSelected = true;
        selectedDate = lstDeliveryDates[0].deliveryDates[0].deliveryDate;
      }

      createOrderModel.timeDelivered = selectedDate;
      List<Product> productslist = [];
      for (var i = 0; i < selectedMarketList.length; i++) {
        Product products = new Product();
        products.sku = selectedMarketList[i].sku;
        products.notes = selectedMarketList[i].skuNotes;
        products.quantity = selectedMarketList[i].quantity;
        products.unitSize = selectedMarketList[i].priceList[0].unitSize;
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
      var requestUrl = URLEndPoints.create_draft_orders + '?' + queryString;
      print("url" + requestUrl);
      print("ms" + createOrderModel.toJson().toString());
      final msg = jsonEncode(createOrderModel);

      http.Response response =
          await http.post(requestUrl, headers: headers, body: msg);
      print("ms" + response.statusCode.toString());
      print("ms" + response.body.toString());
      if (response.statusCode == 200) {
        DartNotificationCenter.post(channel: Constants.draft_notifier);
        _hideLoader();
        Navigator.of(context).pop();
      } else {
        _hideLoader();
        Navigator.of(context).pop();
      }
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<List<DeliveryDateList>> callDeliveryDatesApi() async {
    _showLoader();
    SupplierDeliveryDates deliveryDateList;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart',
      'mudra': mudra,
      'supplierId': supplierID
    };
    Map<String, String> queryParams = {
      'supplierId': supplierID,
      'outletId': widget.outletId,
      "orderEnabled": "true",
    };
    String queryString = Uri(queryParameters: queryParams).query;
    var requestUrl =
        URLEndPoints.retrieve_supplier_delivery_dates + '?' + queryString;
    print("url" + requestUrl);

    http.Response response = await http.get(requestUrl, headers: headers);
    Map results = json.decode(response.body);
    deliveryDateList = SupplierDeliveryDates.fromJson(results);
    lstDeliveryDates = deliveryDateList.data;
    _hideLoader();
    return lstDeliveryDates;
  }

  Future<void> moveToReviewOrdersScreen() async {
    // start the SecondScreen and wait for it to finish with a result
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => new ReviewOrderPage(
                selectedMarketList,
                widget.outletId,
                widget.outletName,
                (orderNotes != null &&
                        orderNotes.isNotEmpty &&
                        orderNotes != "Notes")
                    ? orderNotes
                    : "",
                lstDeliveryDates,
                orderID)));
    if (result != null) {
      setState(() {
        String notes = result as String;
        if (notes != null && notes.isNotEmpty) {
          orderNotes = result as String;
          _txtOrderNotesEditController.text = orderNotes;
        } else {
          orderNotes = "Notes";
          _txtOrderNotesEditController.text = "";
        }
      });
    }
  }

  Widget displayAddOrder(OutletMarketList snapShot) {
    if (snapShot.isSelected) {
      if (snapShot.selectedQuantity.length < 4) {
        return Container(
            margin: EdgeInsets.only(right: 5.0),
            height: 40.0,
            width: 40.0,
            child: Center(
              child: Text(
                snapShot.selectedQuantity,
                style: TextStyle(
                    fontSize: snapShot.txtSize,
                    color: snapShot.txtColor,
                    fontFamily: "SourceSansProSemiBold"),
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(200),
              ),
              color: snapShot.bgColor,
            ));
      } else {
        return UnconstrainedBox(
            child: Container(
                margin: EdgeInsets.only(right: 5.0),
                height: 40.0,
                padding: EdgeInsets.only(right: 10.0, left: 10.0),
                child: Expanded(
                    child: Center(
                        child: Text(
                  snapShot.selectedQuantity,
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: snapShot.txtSize,
                      color: snapShot.txtColor,
                      fontFamily: "SourceSansProSemiBold"),
                ))),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(200),
                  ),
                  color: snapShot.bgColor,
                )));
      }
    } else {
      return Container(
          margin: EdgeInsets.only(right: 5.0),
          height: 40.0,
          width: 40.0,
          child: Center(
            child: Text(
              snapShot.selectedQuantity,
              style: TextStyle(
                  fontSize: snapShot.txtSize,
                  color: snapShot.txtColor,
                  fontFamily: "SourceSansProSemiBold"),
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(200),
            ),
            color: snapShot.bgColor,
          ));
    }
  }
}
