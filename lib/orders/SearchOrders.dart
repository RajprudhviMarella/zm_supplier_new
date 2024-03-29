import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:zm_supplier/models/ordersResponseList.dart';
import 'package:zm_supplier/utils/color.dart';
import 'package:zm_supplier/utils/constants.dart';
import 'package:zm_supplier/utils/urlEndPoints.dart';
import 'package:http/http.dart' as http;
import 'orderDetailsPage.dart';
import 'package:zm_supplier/models/user.dart';

/**
 * Created by RajPrudhviMarella on 25/Feb/2021.
 */

class SearchOrderPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchOrderDesign();
  }
}

class SearchOrderDesign extends State<SearchOrderPage>
    with TickerProviderStateMixin {
  final TextEditingController _controller = new TextEditingController();
  Future<List<Orders>> ordersList;
  List<Orders> arrayOrderList;
  String supplierID;
  String mudra;
  int totalNoRecords = 0;
  int pageNum = 1;
  bool isPageLoading = false;
  int totalNumberOfPages = 0;
  int pageSize = 50;
  ScrollController controller;
  String searchedString;

  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);
    loadSharedPrefs();
    super.initState();
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
      body: ListView(
        children: <Widget>[
          buildAppBar(context),
          displayList(context),
        ],
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(5.0),
        color: Colors.white,
        child: ListTile(
          leading: null,
          title: Container(
            margin: EdgeInsets.only(top: 3),
            decoration: BoxDecoration(
              color: keyLineGrey,
              border: Border.all(
                color: keyLineGrey,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: TextField(
              cursorColor: Colors.blue,
              maxLines: null,
              textInputAction: TextInputAction.go,
              controller: _controller,
              onSubmitted: searchOperation,
              autofocus: true,
              // controller: _controller,
              // onSubmitted: searchOperation,
              style: new TextStyle(
                color: Colors.black,
              ),
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: new Icon(Icons.search, color: Colors.grey),
                  hintText: Constants.txt_Search_order_number,
                  hintStyle: new TextStyle(color: greyText)),
              // onChanged: searchOperation,
            ),
          ),
          trailing: InkWell(
            child: Text("Cancel",
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    fontFamily: "SourceSansProRegular")),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ));
  }

  Widget displayList(BuildContext context) {
    return FutureBuilder<List<Orders>>(
        future: ordersList,
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapShot.connectionState == ConnectionState.done &&
                snapShot.hasData &&
                snapShot.data.isNotEmpty) {
              isPageLoading = false;
              return SizedBox(
                  height: MediaQuery.of(context).size.height - 100,
                  child: GroupedListView<Orders, DateTime>(
                    controller: controller,
                    elements: snapShot.data,
                    physics: BouncingScrollPhysics(),
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
                    groupSeparatorBuilder: (DateTime element) => Container(
                      height: 50,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 10.0, top: 5.0, bottom: 5.0),
                          height: 70.0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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
                      ),
                    ),
                    itemBuilder: (context, element) {
                      return Card(
                          margin: EdgeInsets.only(top: 1.0),
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
                                leading: displayImage(element.outlet.logoURL),
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
                                  margin: EdgeInsets.only(top: 3.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(top: 2.0),
                                            height: 14.0,
                                            width: 14.0,
                                            child: ImageIcon(AssetImage(
                                                'assets/images/truck.png')),
                                          ),
                                          Text(" " + element.getTimeDelivered(),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12.0,
                                                  fontFamily:
                                                      "SourceSansProRegular")),
                                          Text(
                                            " " + '# ${element.orderId}',
                                            style: TextStyle(
                                                color: greyText,
                                                fontSize: 12.0,
                                                fontFamily:
                                                    "SourceSansProRegular"),
                                          ),
                                        ]),
                                        Constants.OrderStatusColor(element),
                                      ]),
                                ),
                                trailing: Text(
                                    element.amount.total.getDisplayValue(),
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontFamily: "SourceSansProRegular")),
                              )));
                    },
                  ));
            } else {
              return Container();
            }
          }
        });
  }

  void searchOperation(String searchText) {
    if (arrayOrderList != null) {
      arrayOrderList.clear();
    }
    ordersList = null;
    searchedString = searchText;
    if (searchedString.isNotEmpty) ordersList = callRetreiveOrdersAPI();
  }

  Widget displayImage(String Url) {
    if (Url != null && Url.isNotEmpty) {
      return Container(
          height: 38.0,
          width: 38.0,
          decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              image:
                  DecorationImage(fit: BoxFit.fill, image: NetworkImage(Url))));
    } else {
      return Container(
          height: 38.0,
          width: 38.0,
          decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/icon_place_holder.png'))));
    }
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
      'pageNumber': pageNum.toString(),
      'pageSize': pageSize.toString(),
      'sortBy': 'timeUpdated',
      'sortOrder': 'DESC',
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

  moveToOrderDetailsPage(Orders element) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => new OrderDetailsPage(element)));
  }
}
