import 'dart:convert';

import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:zm_supplier/models/customersResponse.dart';
import 'package:zm_supplier/models/ordersResponseList.dart';
import 'package:zm_supplier/services/favouritesApi.dart';
import 'package:zm_supplier/utils/color.dart';
import 'package:zm_supplier/utils/constants.dart';
import 'package:zm_supplier/utils/urlEndPoints.dart';
import 'package:http/http.dart' as http;
import 'package:zm_supplier/models/user.dart';

import 'customer_details_page.dart';

class SearchCustomersPage extends StatefulWidget {
  CustomersData customers;

  SearchCustomersPage(this.customers);

  @override
  State<StatefulWidget> createState() =>
      new SearchCustomersState(this.customers);
}

class SearchCustomersState extends State<SearchCustomersPage> {
  CustomersData customers;
  Future<CustomersData> allCustomers;
  final globalKey = new GlobalKey<ScaffoldState>();

  SearchCustomersState(this.customers);

  final TextEditingController _controller = new TextEditingController();
  Future<List<Orders>> ordersList;
  List<Orders> arrayOrderList;
  String supplierID;
  String mudra;

  String searchedString;
  bool show = false;

  @override
  void initState() {
    // controller = new ScrollController();
    loadSharedPrefs();
    super.initState();
  }

  @override
  void dispose() {
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
    } catch (Exception) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      backgroundColor: faintGrey,
      // appBar: buildAppBar(context),
      body: ListView(
        children: <Widget>[
          buildAppBar(context),
          // list()
          header(),
          displayList(context, true)
          // displayList(context),
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
              // onSubmitted: searchOperation,
              autofocus: true,
              onChanged: (value) {
                setState(() {
                  show = false;
                  if (value.length > 0) {
                    show = true;
                  }
                });
              },
              // controller: _controller,
              // onSubmitted: searchOperation,
              style: new TextStyle(
                color: Colors.black,
              ),
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: new Icon(Icons.search, color: Colors.grey),
                  hintText: 'Search outlet or people',
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

  String readTimestamp(int timestamp) {
    var date1 = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var formattedDate = DateFormat('yyyy-MM-dd').format(date1);

    return formattedDate;
  }

  String calculateTime(int timeStamp) {
    if (timeStamp > 0) {
      final birthday = DateTime.parse(readTimestamp(timeStamp));
      final date2 = DateTime.now();
      final difference = date2
          .difference(birthday)
          .inDays;
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

  timeDiff(int timeStamp) {
    //the birthday's date
    final birthday = DateTime.parse(readTimestamp(timeStamp));
    final date2 = DateTime.now();
    final difference = date2.difference(birthday).inDays;
    if (timeStamp > 0) {
      if (difference > 30) {
        return warningRed;
      } else {
        return greyText;
      }
    } else {
      return greyText;
    }
    return difference; //dispalyTime(difference);
  }

  Widget displayList(BuildContext context, bool bool) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: customers.outlets == null ? 0 : customers.outlets.length,
        //customers.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (_controller.text.isEmpty) {
            return Container(); //displaySearchedList(customers, index);
          } else if (customers.outlets[index].outlet.outletName
              .toLowerCase()
              .contains(_controller.text)) {
            return displaySearchedList(customers.outlets, index);
          } else {
            return Container();
          }
        });
  }

  Widget header() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 18),
      child: Visibility(
        visible: show,
        child: Container(
          height: 48,
          child: Text(
            'Outlets',
            style: TextStyle(fontSize: 20, fontFamily: 'SourceSansProBold'),
          ),
        ),
      ),
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

  Widget displaySearchedList(List<Customers> snapShot, int index) {
    print(snapShot.length);
    return Column(
      children: [
        Container(
            color: Colors.white,
            child: ListTile(
              focusColor: Colors.white,
              contentPadding: EdgeInsets.only(left: 15.0, right: 10.0),
              leading: leadingImage(snapShot[index]),
              title: RichText(
                text: TextSpan(
                  children: highlightOccurrences(
                      snapShot[index].outlet.outletName, _controller.text),
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                      fontFamily: "SourceSansProSemiBold"),
                ),
              ),
              subtitle: Text(
                        calculateTime(snapShot[index].lastOrdered),
                style: TextStyle(
                  fontSize: 12.0,
                  color: timeDiff(snapShot[index].lastOrdered),
                  fontFamily: "SourceSansProRegular",
                ),
              ),
              trailing: IconButton(
                icon: snapShot[index].isFavourite
                    ? Image(
                        image: AssetImage('assets/images/Star_yellow.png'),
                        fit: BoxFit.fill,
                        width: 25,
                        height: 25,
                      )
                    : ImageIcon(
                        AssetImage('assets/images/Star_light_grey.png'),
                      ),
                onPressed: () {
                  print('tapped $index');
                  tapOnFavourite(index, snapShot[index]);
                  //   _onDeleteItemPressed(index);
                },
              ),
              onTap: () async {
                var outletName = snapShot[index].outlet.outletName;
                var outletId = snapShot[index].outlet.outletId;
                var lastOrderd =
                        calculateTime(snapShot[index].lastOrdered);
                var isStarred = snapShot[index].isFavourite;
                print(snapShot[index].outlet.outletId);
                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new CustomerDetailsPage(
                            outletName, outletId, lastOrderd, isStarred)));

                setState(() {
                  snapShot[index].isFavourite = result;
                });
              },
            )),
        Divider(
          height: 1,
          color: faintGrey,
        )
      ],
    );
  }

  Widget leadingImage(Customers img) {
    if (img.outlet.logoURL != null && img.outlet.logoURL.isNotEmpty) {
      return Container(
          height: 40.0,
          width: 40.0,
          decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(
                  fit: BoxFit.fill, image: NetworkImage(img.outlet.logoURL))));
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
            outletPlaceholder(img.outlet.outletName),
            style: TextStyle(fontSize: 14, fontFamily: "SourceSansProSemiBold"),
          ),
        ),
      );
    }
  }

  tapOnFavourite(int index, Customers customers) {
    if (customers.isFavourite) {
      setState(() {
        customers.isFavourite = false;
        globalKey.currentState.showSnackBar(
          SnackBar(
            content: Text('Removed from starred'),
            duration: Duration(seconds: 1),
          ),
        );
      });
    } else {
      setState(() {
        customers.isFavourite = true;

        globalKey.currentState.showSnackBar(
          SnackBar(
            content: Text('Added to starred'),
            duration: Duration(seconds: 1),
          ),
        );
      });
    }

    FavouritesApi favourite = new FavouritesApi();
    favourite
        .updateFavourite(
            mudra, supplierID, customers.outlet.outletId, customers.isFavourite)
        .then((value) async {
      DartNotificationCenter.post(channel: Constants.favourite_notifier);
    });
  }

  String outletPlaceholder(String name) {
    Constants value = Constants();
    var placeholder = value.getInitialWords(name);
    return placeholder;
  }
}
