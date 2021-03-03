import 'package:flutter/material.dart';
import 'package:zm_supplier/models/outletMarketList.dart';
import 'package:zm_supplier/models/outletResponse.dart';
import 'package:zm_supplier/utils/constants.dart';
import 'package:zm_supplier/utils/color.dart';
import 'package:zm_supplier/models/user.dart';
import 'package:zm_supplier/utils/urlEndPoints.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';

/**
 * Created by RajPrudhviMarella on 02/Mar/2021.
 */

class MarketListPage extends StatefulWidget {
  static const String tag = 'MarketListPage';
  Outlet outletList;

  MarketListPage(this.outletList);

  @override
  State<StatefulWidget> createState() {
    return MarketListDesign();
  }
}

class MarketListDesign extends State<MarketListPage>
    with TickerProviderStateMixin {
  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _controller = new TextEditingController();
  final TextEditingController _textEditingController =
      new TextEditingController();
  Future<List<OutletMarketList>> favouriteOutletMarketListFuture;
  List<OutletMarketList> allOutletMarketList;
  String supplierID;
  String mudra;
  String searchedString;
  bool _isSearching = false;
  String searchQuery = "";
  String _homeDate = "+";
  int counter = 0;

  @override
  void initState() {
    loadSharedPrefs();
    super.initState();
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
          favouriteOutletMarketListFuture = callOutletsMarket();
        }
      });
    } catch (Exception) {}
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: globalKey,
      backgroundColor: faintGrey,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        bottomOpacity: 0.0,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: _isSearching
            ? _buildSearchField()
            : Text(
                widget.outletList.outletName,
                style: new TextStyle(
                    color: Colors.black, fontFamily: "SourceSansProSemiBold"),
              ),
        actions: _buildActions(),
      ),
      body: displayList(context),
    );
  }

  Widget headers(context, String name, double size) {
    return Container(
      color: faintGrey,
      margin: EdgeInsets.only(top: 2.0),
      padding:
          EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
      child: Text(name,
          style: TextStyle(
            fontFamily: "SourceSansProSemiBold",
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
        hintText: Constants.txt_Search_order_number,
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
    return Row(children: <Widget>[
      Text(
        marketList.priceList[0].price.getDisplayValue() + " / ",
        style: TextStyle(
          fontSize: 12.0,
          color: greyText,
          fontFamily: "SourceSansProRegular",
        ),
      ),
      Text(
        marketList.priceList[0].unitSize.toString(),
        style: TextStyle(
          fontSize: 12.0,
          color: azul_blue,
          fontFamily: "SourceSansProRegular",
        ),
      ),
    ]);
  }

  Widget displaySearchedList(
      AsyncSnapshot<List<OutletMarketList>> snapShot, int index) {
    return Card(
        margin: EdgeInsets.only(top: 1.0),
        child: Container(
            color: Colors.white,
            child: ListTile(
              focusColor: Colors.white,
              contentPadding: EdgeInsets.only(left: 15.0, right: 10.0),
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
              trailing: GestureDetector(
                  onTap: () {
                    counter = snapShot.data[index].quantity;
                    _textEditingController.value = TextEditingValue(
                      text: this.counter.toString(),
                      selection: TextSelection.fromPosition(
                        TextPosition(offset: this.counter.toString().length),
                      ),
                    );

                    showModalBottomSheet<void>(
                      context: context,
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
                                  margin: EdgeInsets.only(
                                      top: 5, left: 20.0, bottom: 10.0),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          snapShot.data[index].productName,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black,
                                              fontFamily:
                                                  "SourceSansProSemiBold"))),
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
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(200),
                                                ),
                                                color: snapShot
                                                    .data[index].bgColor,
                                              ))),
                                      Container(
                                          width: 200.0,
                                          height: 40.0,
                                          child: TextField(
                                              maxLines: null,
                                              controller:
                                                  _textEditingController,
                                              textInputAction:
                                                  TextInputAction.go,
                                              keyboardType:
                                                  TextInputType.number,
                                              cursorColor: Colors.blue,
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                fillColor: faintGrey,
                                                filled: true,
                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                disabledBorder:
                                                    InputBorder.none,
                                                hintText: Constants
                                                    .txt_Search_order_number,
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
                                                counter = int.parse(query);
                                              })),
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              this.counter++;
                                              _textEditingController.text =
                                                  counter.toString();
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
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(200),
                                                ),
                                                color: snapShot
                                                    .data[index].bgColor,
                                              )))
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                    child: const Text('Close BottomSheet'),
                                    onPressed: () {
                                      print("$counter");
                                      setState(() {
                                        _textEditingController.text =
                                            counter.toString();
                                        snapShot.data[index].quantity = counter;
                                        snapShot.data[index].selectedQuantity =
                                            counter.toString();
                                        snapShot.data[index].bgColor =
                                            Colors.blue;
                                        snapShot.data[index].txtColor =
                                            Colors.white;
                                      });
                                      Navigator.pop(context);
                                    })
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
                          snapShot.data[index].selectedQuantity,
                          style: TextStyle(
                              fontSize: 30.0,
                              color: snapShot.data[index].txtColor,
                              fontFamily: "SourceSansProSemiBold"),
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(200),
                        ),
                        color: snapShot.data[index].bgColor,
                      ))),
            )));
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
    OutletMarketBaseResponse marketList;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart',
      'mudra': mudra,
      'supplierId': supplierID
    };
    Map<String, String> queryParams = {
      'supplierId': supplierID,
      'sortBy': "productName",
      "outletId": widget.outletList.outletId,
      "sortOrder": "ASC"
    };
    String queryString = Uri(queryParameters: queryParams).query;
    var requestUrl =
        URLEndPoints.retrieve_outlet_market_list + '?' + queryString;
    http.Response response = await http.get(requestUrl, headers: headers);
    Map results = json.decode(response.body);
    marketList = OutletMarketBaseResponse.fromJson(results);
    allOutletMarketList = marketList.data.data;
    // dummyList.forEach((element) {
    //   print("products" + allOutletMarketList.length.toString());
    //   element.priceList.forEach((elements) {
    //     print("pricelist" + allOutletMarketList.length.toString());
    //     if (element.status == "visible") {
    //       print("visible" + allOutletMarketList.length.toString());
    //       OutletMarketList productUom =
    //           OutletMarketList.fromJson(element.toJson());
    //       List<PriceList> productPriceLists;
    //       productPriceLists.add(elements);
    //       allOutletMarketList.add(productUom);
    //     }
    //   });
    // });

    // for (var i = 0; i < dummyList.asMap().length; i++) {
    //   for (var j = 0; j < dummyList.asMap()[i].priceList.asMap().length; j++) {
    //     print("camehere" + allOutletMarketList.length.toString());
    //     if (dummyList[i].priceList[j].status == ("visible")) {
    //       print("camehere" + allOutletMarketList.length.toString());
    //       OutletMarketList productUom =
    //           OutletMarketList.fromJson(dummyList[i].toJson());
    //       List<PriceList> productPriceLists;
    //       productPriceLists.add(dummyList[i].priceList[j]);
    //       allOutletMarketList.add(productUom);
    //       print("camehere" + allOutletMarketList.length.toString());
    //     }
    //   }
    // }

    return allOutletMarketList;
  }

  newProductObject(OutletMarketList marketList) {}
}
