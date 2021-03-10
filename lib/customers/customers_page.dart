import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:zm_supplier/customers/customer_details_page.dart';
import 'package:zm_supplier/customers/search_customers_page.dart';
import 'package:zm_supplier/models/customersResponse.dart';
import 'package:zm_supplier/models/ordersResponseList.dart';
import 'package:zm_supplier/models/user.dart';
import 'package:zm_supplier/orders/SearchOrders.dart';
import 'package:zm_supplier/services/favouritesApi.dart';
import 'package:zm_supplier/utils/urlEndPoints.dart';

import '../utils/color.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class CustomersPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new CustomerState();
}

Widget appBarTitle = new Text(
  "  Customers",
  style: TextStyle(
      color: Colors.black, fontFamily: "SourceSansProBold", fontSize: 30),
  textAlign: TextAlign.left,
);

class CustomerState extends State<CustomersPage> {
  CustomersReportResponse customersReportResponse;
  Future<List<CustomersData>> customersData;
  List<CustomersData> customerDataList;

  CustomersData selectedCustomerData;
  Future<CustomersData> selectedCustomersDataFuture;

  SharedPref sharedPref = SharedPref();
  LoginResponse userData;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    customersData = getCustomersReportApiCalling(false);
    selectedCustomersDataFuture = getCustomersListCalling(false);
  }

  Future<List<CustomersData>> getCustomersReportApiCalling(
      bool isUpdating) async {
    userData =
        LoginResponse.fromJson(await sharedPref.readData(Constants.login_Info));

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart',
      'mudra': userData.mudra,
      'supplierId': userData.supplier.first.supplierId
    };

    var url = URLEndPoints.customers_report_data;
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

  Future<CustomersData> getCustomersListCalling(bool isUpdating) async {
    userData =
        LoginResponse.fromJson(await sharedPref.readData(Constants.login_Info));

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart',
      'mudra': userData.mudra,
      'supplierId': userData.supplier.first.supplierId
    };

    var url = URLEndPoints.customers_report_data;
    print(headers);
    print(url);
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      customersReportResponse =
          CustomersReportResponse.fromJson(json.decode(response.body));
    } else {
      print('failed get customers reports');
    }

    selectedCustomerData = customersReportResponse.data[selectedIndex];
    //refresh the list when tap on starred.
    if (isUpdating) {
      setState(() {
        selectedCustomersDataFuture = selectedD(selectedCustomerData);
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

  int timeDiff(int timeStamp) {
    //the birthday's date
    final birthday = DateTime.parse(readTimestamp(timeStamp));
    final date2 = DateTime.now();
    final difference = date2.difference(birthday).inDays;
    return difference;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: false,
        title: appBarTitle,
        backgroundColor: faintGrey,
        elevation: 0,
      ),
      body: Container(
        color: faintGrey,
        child: ListView(children: [
          buildSearchBar(context),
          Headers(),
          bannerList(),
          list()
        ]),
      ),
    );
  }

  Widget buildSearchBar(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(5.0),
        color: faintGrey,
        height: 60,
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
              // controller: _controller,
              // onSubmitted: searchOperation,
              // autofocus: true,
              // controller: _controller,
              // onSubmitted: searchOperation,
              style: new TextStyle(
                color: Colors.black,
              ),
              onTap: () async {
                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            new SearchCustomersPage(customerDataList.first)));

                print(result);
                //  setState(() {
                getCustomersReportApiCalling(true);
                getCustomersListCalling(true);
                // });
              },
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: new Icon(Icons.search, color: Colors.grey),
                  hintText: Constants.txt_search_outlet,
                  hintStyle: new TextStyle(color: greyText)),
              // onChanged: searchOperation,
            ),
          ),
        ));
  }

  Widget Headers() {
    return Padding(
      padding: const EdgeInsets.only(left: 21.0, right: 21, top: 20),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Outlets',
              style: TextStyle(fontSize: 18, fontFamily: "SourceSansProBold"),
            ),
            new RaisedButton(
              color: Colors.transparent,
              elevation: 0,
              onPressed: () {},
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
                    'Recently ordered',
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
    );
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
              height: 130,
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

  Color selectedColor(int index) {
    if (index == selectedIndex) {
      return buttonBlue;
    }
    return greyText;
  }

  Widget list() {
    return Column(
      children: [
        FutureBuilder<CustomersData>(
            future: selectedCustomersDataFuture,
            builder:
                (BuildContext context, AsyncSnapshot<CustomersData> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('failed to load'));
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data.outlets.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new Column(children: <Widget>[
                      ListTile(
                          title: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              snapshot.data.outlets[index].outlet.outletName,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "SourceSansProSemiBold"),
                            ),
                          ),
                          //  isThreeLine: true,

                          subtitle: Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Row(
                                children: [
                                  Text(
                                    'Last ordered ' +
                                            timeDiff(snapshot.data
                                                    .outlets[index].lastOrdered)
                                                .toString() +
                                            ' days ago' ??
                                        "",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'SourceSansProRegular',
                                        color: timeDiff(snapshot
                                                    .data
                                                    .outlets[index]
                                                    .lastOrdered) >
                                                30
                                            ? warningRed
                                            : greyText),
                                  ),
                                ],
                              )),

                          //profile.imgUrl == null) ? AssetImage('images/user-avatar.png') : NetworkImage(profile.imgUrl)
                          leading: Container(
                            height: 38,
                            width: 38,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              color: Colors.blue.withOpacity(0.5),
                            ),
                            child: Center(
                              child: Text(
                                outletPlaceholder(snapshot
                                    .data.outlets[index].outlet.outletName),
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "SourceSansProSemiBold"),
                              ),
                            ),
                          ),
                          // ),
                          trailing: IconButton(
                              icon: snapshot.data.outlets[index].isFavourite
                                  ? Image(
                                      image: AssetImage(
                                          'assets/images/Star_yellow.png'),
                                      fit: BoxFit.fill,
                                      width: 25,
                                      height: 25,
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
                          tileColor: Colors.white,
                          onTap: () async {
                            var outletName =
                                snapshot.data.outlets[index].outlet.outletName;
                            var outletId =
                                snapshot.data.outlets[index].outlet.outletId;
                            var lastOrderd = 'Last ordered ' +
                                    timeDiff(snapshot
                                            .data.outlets[index].lastOrdered)
                                        .toString() +
                                    ' days ago' ??
                                "";
                            var isStarred =
                                snapshot.data.outlets[index].isFavourite;
                            print(snapshot.data.outlets[index].outlet.outletId);
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        new CustomerDetailsPage(outletName,
                                            outletId, lastOrderd, isStarred)));

                            setState(() {
                              snapshot.data.outlets[index].isFavourite = result;
                            });
                          }),
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

  tapOnFavourite(int index, Customers customers) {
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
      getCustomersReportApiCalling(true);
      getCustomersListCalling(true);
    });
  }

  String outletPlaceholder(String name) {
    Constants value = Constants();
    var placeholder = value.getInitialWords(name);
    return placeholder;
  }
}
