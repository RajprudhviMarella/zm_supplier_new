import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zm_supplier/models/customersResponse.dart';
import 'package:zm_supplier/models/user.dart';
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
  CustomersResponse customerResponse;
  Future<List<Customers>> customers;
  List<Customers> arrayOfCustomers;

  SharedPref sharedPref = SharedPref();

  LoginResponse userData;

  @override
  void initState() {
    super.initState();

    customers = getCustomersListApiCalling();
  }

  Future<List<Customers>> getCustomersListApiCalling() async {
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
      'userId': userData.user.userId,
      // 'orderPlacedEndDate': endDate
    };
    String queryString = Uri(queryParameters: queryParams).query;

    var url = URLEndPoints.customersList_url + '?' + queryString;
    print(headers);
    print(url);
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      print(response.body);
      print('Success response');
      customerResponse = CustomersResponse.fromJson(json.decode(response.body));
    } else {
      print('failed get summary data');
    }
    arrayOfCustomers = customerResponse.data;
    return arrayOfCustomers;
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
    final difference = date2
        .difference(birthday)
        .inDays;
    return difference;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: false,
        title: appBarTitle,
        backgroundColor: faintGrey,
        elevation: 0,
      ),
      body: Container(
        color: faintGrey,
        child: ListView(children: [buildSearchBar(context), Headers(), list()]),
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
              autofocus: true,
              // controller: _controller,
              // onSubmitted: searchOperation,
              style: new TextStyle(
                color: Colors.black,
              ),
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
      padding: const EdgeInsets.all(21.0),
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

            // Padding(f
            //   padding: const EdgeInsets.only(left: 100.0, right: 10),
            //   child: Image.asset(
            //     "assets/images/Sort-blue.png",
            //     width: 12,
            //     height: 12,
            //   ),
            // ),
            // Text(
            //   'Recently ordered',
            //   style: TextStyle(
            //       color: buttonBlue,
            //       fontSize: 12,
            //       fontFamily: 'SourceSansProRegular'),
            // )
          ],
        ),
      ),
    );
  }

  Widget list() {
    return Column(
      children: [
        FutureBuilder<List<Customers>>(
            future: customers,
            builder: (BuildContext context,
                AsyncSnapshot<List<Customers>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('failed to load'));
              } else {
                // if (snapshot.data == null) {
                //   return Center(child: Text('loading...'),);
                // } else {
                //   child:
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
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Row(
                                children: [
                                  Text(
                                    'Last ordered ' +
                                        timeDiff(snapshot
                                            .data[index].lastOrdered)
                                            .toString() +
                                        ' days ago' ??
                                        "",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'SourceSansProRegular',
                                        color: timeDiff(snapshot
                                            .data[index].lastOrdered) >
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

                            child: Center(child: Text(outletPlaceholder(
                                snapshot.data[index].outlet.outletName),

                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "SourceSansProSemiBold"
                              ),
                            ),
                            ),
                            //child: Text(snapshot.data[index].outlet.outletName.substring(snapshot.data[index].outlet.outletName.lastIndexOf(' ')+1)),
                            //child: Center(child: Text(getInitials(snapshot.data[index].outlet.outletName))),
                            // child: snapshot.data[index].outlet.logoURL == null
                            //     ? ImageIcon(
                            //         AssetImage('assets/images/Truck-black.png'))
                            //     : Image.network(
                            //         snapshot.data[index].outlet.logoURL,
                            //         fit: BoxFit.fill,
                            //       ),
                              ),
                          // ),
                          trailing: IconButton(
                            icon: snapshot.data[index].isFavourite
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
                              tapOnFavourite(index, snapshot.data[index]);
                              //   _onDeleteItemPressed(index);
                            },
                          ),
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
        .then((value) async {});
  }

  String outletPlaceholder(String name) {
    Constants value = Constants();
    var placeholder = value.getInitialWords(name);
    return placeholder;
  }
}