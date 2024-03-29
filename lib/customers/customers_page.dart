import 'dart:convert';

import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:zm_supplier/customers/customer_details_page.dart';
import 'package:zm_supplier/customers/search_customers_page.dart';
import 'package:zm_supplier/models/customersResponse.dart';
import 'package:zm_supplier/models/ordersResponseList.dart';
import 'package:zm_supplier/models/response.dart';
import 'package:zm_supplier/models/user.dart';
import 'package:zm_supplier/orders/SearchOrders.dart';
import 'package:zm_supplier/orders/orderDetailsPage.dart';
import 'package:zm_supplier/services/favouritesApi.dart';
import 'package:zm_supplier/utils/eventsList.dart';
import 'package:zm_supplier/utils/urlEndPoints.dart';

import '../utils/color.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class CustomersPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new CustomerState();
}

class CustomerState extends State<CustomersPage> {
  CustomersReportResponse customersReportResponse;
  Future<List<CustomersData>> customersData;
  List<CustomersData> customerDataList;

  CustomersData selectedCustomerData;
  Future<CustomersData> selectedCustomersDataFuture;

  SharedPref sharedPref = SharedPref();
  LoginResponse userData;
  ApiResponse specificUserInfo;
  dynamic userProperties;
  int selectedIndex = 0;

  String selectedFilterType = 'RecentOrdered';

  Constants events = Constants();
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();

    events.mixPanelEvents();
    customersData = getCustomersReportApiCalling(false, false);
    selectedCustomersDataFuture = getCustomersListCalling(false, false);

    DartNotificationCenter.subscribe(
      channel: Constants.favourite_notifier,
      observer: 1,
      onNotification: (result) {
        print('listener called');
        setState(() {
          customersData = getCustomersReportApiCalling(false, false);
          selectedCustomersDataFuture = getCustomersListCalling(false, false);
        });
      },
    );
  }

  @override
  void dispose() {
    DartNotificationCenter.unsubscribe(
        observer: 1, channel: Constants.favourite_notifier);
    super.dispose();
    //DartNotificationCenter.unsubscribe(observer: Constants.favourite_notifier);
  }

  Future<List<CustomersData>> getCustomersReportApiCalling(
      bool isUpdating, bool isFilterApplied) async {
    userData =
        LoginResponse.fromJson(await sharedPref.readData(Constants.login_Info));
    specificUserInfo = ApiResponse.fromJson(
        await sharedPref.readData(Constants.specific_user_info));
    userProperties = {
      "userName": specificUserInfo.data.fullName,
      "email": userData.user.email,
      "userId": userData.user.userId
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart',
      'mudra': userData.mudra,
      'supplierId': userData.supplier.first.supplierId
    };

    Map<String, String> queryParams = {
      'sortBy': selectedFilterType,
    };

    String queryString = Uri(queryParameters: queryParams).query;

    var url = URLEndPoints.customers_report_data + '?' + queryString;

    // var url = URLEndPoints.customers_report_data;
    print(headers);
    print(url);
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      print(response.body);
      print('Success response');

      customersReportResponse =
          CustomersReportResponse.fromJson(json.decode(response.body));
    } else {
      print('failed get customers reports');
    }
    customerDataList = customersReportResponse.data;
    if (isUpdating) {
      setState(() {
        customersData = updateData(customerDataList);
      });
    }
    return customerDataList;
  }

  Future<CustomersData> getCustomersListCalling(
      bool isUpdating, bool isFilterApplied) async {
    userData =
        LoginResponse.fromJson(await sharedPref.readData(Constants.login_Info));

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart',
      'mudra': userData.mudra,
      'supplierId': userData.supplier.first.supplierId
    };

    Map<String, String> queryParams = {
      'sortBy': selectedFilterType,
    };

    String queryString = Uri(queryParameters: queryParams).query;

    var url = URLEndPoints.customers_report_data + '?' + queryString;
    print(headers);
    print(url);
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      print('response available');
      customersReportResponse =
          CustomersReportResponse.fromJson(json.decode(response.body));
      print(customersReportResponse.data.first.outlets.length);
    } else {
      print('failed get customers reports');
    }

    selectedCustomerData = customersReportResponse.data[selectedIndex];

    var starredOutlets = customersReportResponse.data[1];
    var noRecentOutlets = customersReportResponse.data[4];
    //refresh the list when tap on starred.
    events.mixpanel.track(Events.TAP_CUSTOMERS_TAB, properties: {
      'AllOutletsCount': selectedCustomerData.outlets.length,
      'StarredCount': starredOutlets.outlets.length,
      'NoRecentOrdersCount': noRecentOutlets.outlets.length
    });
    events.mixpanel.flush();

    if (isUpdating) {
      setState(() {
        selectedCustomersDataFuture = selectedD(selectedCustomerData);
      });
    }

    if (isFilterApplied) {
      setState(() {
        selectedFilterType = selectedFilterType;
      });
    }

    return selectedCustomerData;
  }

  Future<List<CustomersData>> updateData(List<CustomersData> i) async {
    return i;
  }

  Future<CustomersData> selectedD(CustomersData i) async {
    return i;
  }

  String readTimestamp(int timestamp) {
    var date1 = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var formattedDate = DateFormat('yyyy-MM-dd').format(date1);

    return formattedDate;
  }

  timeDiff(int timeStamp) {
    //the birthday's date
    final birthday = DateTime.parse(readTimestamp(timeStamp));
    final date2 = DateTime.now();
    final difference = date2.difference(birthday).inDays;
    if (timeStamp > 0) {
      if (difference > 14) {
        return warningRed;
      } else {
        return greyText;
      }
    } else {
      return greyText;
    }
    return difference; //dispalyTime(difference);
  }

  String calculateTime(int timeStamp) {
    if (timeStamp > 0) {
      final birthday = DateTime.parse(readTimestamp(timeStamp));
      final date2 = DateTime.now();
      final difference = date2.difference(birthday).inDays;
      return dispalyTime(difference);
    } else {
      return 'N/A';
    }
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return new Scaffold(
      appBar: new AppBar(
        toolbarHeight: 60,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 1.0),
          child: Row(
            children: [
              Text(
                "Customers",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "SourceSansProBold",
                    fontSize: 30),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
        backgroundColor: faintGrey,
        elevation: 0,
      ),
      body: Container(
          color: faintGrey,
          child: RefreshIndicator(
            key: refreshKey,
            child: ListView(children: [
              buildSearchBar(context),
              Headers(),
              bannerList(),
              spaceBanner(),
              list()
            ]),
            color: azul_blue,
            onRefresh: refreshList,
          )),
    );
  }

  Future<Null> refreshList() async {
    print("refreshing");
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 0));

    setState(() {
      customersData = getCustomersReportApiCalling(false, true);
      selectedCustomersDataFuture = getCustomersListCalling(false, true);
    });

    return null;
  }

  Widget buildSearchBar(BuildContext context) {
    return Container(
        //padding: EdgeInsets.only(top: 5.0),
        color: faintGrey,
        height: 60,
        child: ListTile(
          leading: null,
          title: Container(
            margin: EdgeInsets.only(top: 3, bottom: 15),
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

              focusNode: AlwaysDisabledFocusNode(),
              textInputAction: TextInputAction.go,
              // controller: _controller,
              // onSubmitted: searchOperation,
              // autofocus: true,
              // controller: _controller,
              // onSubmitted: searchOperation,
              style: new TextStyle(
                color: Colors.black,
              ),
              onTap: () async {
                events.mixpanel.track(Events.TAP_CUSTOMERS_TAB_SEARCH,
                    properties: userProperties);
                events.mixpanel.flush();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            new SearchCustomersPage(customerDataList.first)));
              },
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: new Icon(Icons.search, color: Colors.grey),
                  hintText: Constants.txt_search_outlet,
                  hintStyle: new TextStyle(
                      color: greyText,
                      fontSize: 16,
                      fontFamily: 'SourceSansProRegular')),
              // onChanged: searchOperation,
            ),
          ),
        ));
  }

  Widget Headers() {
    return Padding(
        padding: const EdgeInsets.only(left: 17.0, right: 0, top: 5),
        child: Container(
          height: 35,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LeftRightAlign(
                  left: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      'Outlets',
                      style: TextStyle(
                          fontSize: 18, fontFamily: "SourceSansProBold"),
                    ),
                  ),
                  right: Container(
                    height: 35,
                    child: new RaisedButton(
                      elevation: 0,
                      color: Colors.transparent,
                      onPressed: () {
                        _openBottomSheet();
                      },
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image.asset(
                            "assets/images/Sort-blue.png",
                            width: 12,
                            height: 12,
                          ),
                          SizedBox(width: 5),
                          new Text(
                            selectedFilterType == 'RecentOrdered'
                                ? 'Recently ordered'
                                : 'A-Z',
                            style: TextStyle(
                                color: buttonBlue,
                                fontSize: 12,
                                fontFamily: 'SourceSansProRegular'),
                          ),
                        ],
                      ),
                    ),
                  )

                  // child: Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       'Outlets',
                  //       style: TextStyle(fontSize: 18, fontFamily: "SourceSansProBold"),
                  //     ),
                  //     new RaisedButton(
                  //       color: Colors.transparent,
                  //       elevation: 0,
                  //       onPressed: () {},
                  //       child: new Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         mainAxisSize: MainAxisSize.min,
                  //         children: <Widget>[
                  //           Image.asset(
                  //             "assets/images/Sort-blue.png",
                  //             width: 12,
                  //             height: 12,
                  //           ),
                  //           SizedBox(width: 5),
                  //           new Text(
                  //             'Recently ordered',
                  //             style: TextStyle(
                  //                 color: buttonBlue,
                  //                 fontSize: 12,
                  //                 fontFamily: 'SourceSansProRegular'),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  ),
            ],
          ),
        ));
  }

  Widget bannerList() {
    return FutureBuilder<List<CustomersData>>(
        future: customersData,
        builder: (BuildContext context,
            AsyncSnapshot<List<CustomersData>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else if (snapshot.hasError) {
            return Center(child: Text('failed to load'));
          } else {
            return SizedBox(
              height: 110,
              child: ListView.builder(
                  key: const PageStorageKey<String>('scrollPosition'),
                  itemCount: 5,
                  shrinkWrap: true,
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
                          print('tapped $index');
                          setState(() {
                            selectedIndex = index;
                            if (index == 0) {
                              events.mixpanel.track(
                                  Events.TAP_CUSTOMERS_TAB_ALL_OUTLETS_TAB,
                                  properties: userProperties);
                            } else if (index == 1) {
                              events.mixpanel.track(
                                  Events.TAP_CUSTOMERS_TAB_STARRED_OUTLETS_TAB,
                                  properties: userProperties);
                            } else if (index == 2) {
                              events.mixpanel.track(
                                  Events
                                      .TAP_CUSTOMERS_TAB_THIS_WEEK_OUTLETS_TAB,
                                  properties: userProperties);
                            } else if (index == 3) {
                              events.mixpanel.track(
                                  Events
                                      .TAP_CUSTOMERS_TAB_LAST_WEEK_OUTLETS_TAB,
                                  properties: userProperties);
                            } else {
                              events.mixpanel.track(
                                  Events
                                      .TAP_CUSTOMERS_TAB_NO_RECENT_ORDERED_OUTLETS_TAB,
                                  properties: userProperties);
                            }
                            events.mixpanel.flush();
                            var a = snapshot.data[index];
                            selectedCustomersDataFuture = selectedD(a);
                          });
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: last
                                  ? EdgeInsets.only(right: 15)
                                  : EdgeInsets.all(0),
                              child: Container(
                                  //  padding: last ? EdgeInsets.only(left: 20): null,
                                  width: 110,
                                  height: 102,
                                  margin: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    border: selectedIndex == index
                                        ? Border.all(
                                            width: 2, color: buttonBlue)
                                        : Border.all(
                                            width: 0,
                                            color: Colors.transparent),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: second
                                            ? const EdgeInsets.only(
                                                top: 15.0, left: 20, bottom: 16)
                                            : const EdgeInsets.only(
                                                top: 15.0, left: 20),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                snapshot
                                                    .data[index].customerType,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily:
                                                      'SourceSansProSemiBold',
                                                  color: selectedColor(index),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: first
                                            ? const EdgeInsets.only(
                                                left: 20.0, top: 20)
                                            : const EdgeInsets.only(
                                                left: 20.0, top: 5),
                                        child: Row(
                                          children: [
                                            Text(
                                              snapshot.data[index].count
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  fontFamily:
                                                      'SourceSansProBold',
                                                  color: (index == 4
                                                      ? warningRed
                                                      : Colors.black)),
                                            ),
                                          ],
                                        ),
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

  void _openBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          // return StatefulBuilder(
          // builder: (BuildContext context, StateSetter setState) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    title: new Text(
                      'Sort by',
                      style: TextStyle(
                          fontSize: 14, fontFamily: 'SourceSansProSemibold'),
                    ),
                    onTap: () => {}),
                new ListTile(
                  title: new Text('Recently ordered',
                      style: TextStyle(
                          fontSize: 16, fontFamily: 'SourceSansProRegular')),
                  onTap: () {
                    setState(() {
                      selectedFilterType = 'RecentOrdered';

                      customersData = getCustomersReportApiCalling(false, true);
                      selectedCustomersDataFuture =
                          getCustomersListCalling(false, true);
                    });
                    Navigator.of(context).pop();
                  },
                  trailing: selectedFilterType == 'RecentOrdered'
                      ? trailingIcon('RecentOrdered')
                      : null,
                ),
                Divider(
                  thickness: 1.5,
                  color: faintGrey,
                ),
                new ListTile(
                  title: new Text('A-Z',
                      style: TextStyle(
                          fontSize: 16, fontFamily: 'SourceSansProRegular')),
                  onTap: () {
                    setState(() {
                      selectedFilterType = 'A-Z';
                      customersData = getCustomersReportApiCalling(false, true);
                      selectedCustomersDataFuture =
                          getCustomersListCalling(false, true);
                    });
                    Navigator.of(context).pop();
                  },
                  trailing:
                      selectedFilterType == 'A-Z' ? trailingIcon('A-Z') : null,
                ),
                Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 20)),
              ],
            ),
            // }
          );
        });
  }

  Widget trailingIcon(String selected) {
    print(selectedFilterType);
    print(selected);
    if (selectedFilterType == selected) {
      return Container(
          height: 20,
          width: 20,
          child: ImageIcon(
            AssetImage('assets/images/icon-tick-green.png'),
            size: 22,
            color: buttonBlue,
          ));
    } else {
      return Container(height: 20, width: 20);
    }
  }

  Color selectedColor(int index) {
    if (index == selectedIndex) {
      return buttonBlue;
    }
    return greyText;
  }

  Widget spaceBanner() {
    return Padding(padding: EdgeInsets.fromLTRB(20, 5, 20, 5));
  }

  Widget list() {
    return Column(
      children: [
        FutureBuilder<CustomersData>(
            future: selectedCustomersDataFuture,
            builder:
                (BuildContext context, AsyncSnapshot<CustomersData> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child:
                        SpinKitThreeBounce(color: Colors.blueAccent, size: 24));
                // } else if (snapshot.hasError) {
                //   return Center(child: Text('failed to load'));
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data.outlets.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new Column(children: <Widget>[
                      Container(
                          color: Colors.white,
                          child: ListTile(
                              title: Transform.translate(
                                offset: Offset(-5, 0),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    snapshot
                                        .data.outlets[index].outlet.outletName,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "SourceSansProSemiBold"),
                                  ),
                                ),
                              ),
                              //  isThreeLine: true,

                              //  isThreeLine: true,

                              subtitle: Transform.translate(
                                offset: Offset(-5, 0),
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 2.0, bottom: 10),
                                    child: Row(
                                      children: [
                                        Text(
                                          calculateTime(snapshot
                                              .data.outlets[index].lastOrdered),
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily:
                                                  'SourceSansProRegular',
                                              color: timeDiff(snapshot.data
                                                  .outlets[index].lastOrdered)),
                                        ),
                                      ],
                                    )),
                              ),
                              //profile.imgUrl == null) ? AssetImage('images/user-avatar.png') : NetworkImage(profile.imgUrl)
                              leading:
                                  leadingImage(snapshot.data.outlets[index]),
                              trailing: Transform.translate(
                                offset: Offset(10, 0),
                                child: IconButton(
                                    icon:
                                        snapshot.data.outlets[index].isFavourite
                                            ? Image(
                                                image: AssetImage(
                                                    'assets/images/Star_yellow.png'),
                                                fit: BoxFit.fill,
                                                width: 22,
                                                height: 22,
                                              )
                                            : ImageIcon(
                                                AssetImage(
                                                    'assets/images/Star_light_grey.png'),
                                              ),
                                    onPressed: () {
                                      print('tapped $index');
                                      tapOnFavourite(
                                          index, snapshot.data.outlets[index]);
                                    }),
                              ),
                              tileColor: Colors.white,
                              onTap: () async {
                                var outletName = snapshot
                                    .data.outlets[index].outlet.outletName;
                                var outletId = snapshot
                                    .data.outlets[index].outlet.outletId;
                                var lastOrderd = calculateTime(
                                    snapshot.data.outlets[index].lastOrdered);
                                var isStarred =
                                    snapshot.data.outlets[index].isFavourite;
                                print(snapshot
                                    .data.outlets[index].outlet.outletId);

                                events.mixpanel.track(
                                    Events.TAP_CUSTOMERS_TAB_OUTLET_FOR_DETAILS,
                                    properties: userProperties);
                                events.mixpanel.flush();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            new CustomerDetailsPage(
                                                outletName,
                                                outletId,
                                                lastOrderd,
                                                isStarred)));
                              })),
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

  Widget leadingImage(Customers customer) {
    if (customer.outlet.logoURL != null && customer.outlet.logoURL.isNotEmpty) {
      return Container(
          height: 38.0,
          width: 38.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Image.network(
              customer.outlet.logoURL,
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
            outletPlaceholder(customer.outlet.outletName),
            style: TextStyle(fontSize: 14, fontFamily: "SourceSansProSemiBold"),
          ),
        ),
      );
    }
  }

  tapOnFavourite(int index, Customers customers) {
    events.mixpanel.track(Events.TAP_CUSTOMERS_TAB_OUTLET_FAVOURITE,
        properties: userProperties);
    events.mixpanel.flush();
    if (customers.isFavourite) {
      setState(() {
        customers.isFavourite = false;
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('Removed from starred'),
            duration: Duration(seconds: 1),
          ),
        );
      });
    } else {
      setState(() {
        customers.isFavourite = true;

        Scaffold.of(context).showSnackBar(
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
            customers.outlet.outletId, customers.isFavourite)
        .then((value) async {
      getCustomersReportApiCalling(true, false);
      getCustomersListCalling(true, false);
    });
  }

  String outletPlaceholder(String name) {
    Constants value = Constants();
    var placeholder = value.getInitialWords(name);
    return placeholder;
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
