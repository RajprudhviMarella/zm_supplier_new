import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:zm_supplier/models/outletResponse.dart';
import 'package:zm_supplier/utils/color.dart';
import 'package:zm_supplier/utils/constants.dart';
import 'package:zm_supplier/models/user.dart';
import 'package:zm_supplier/utils/urlEndPoints.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';

/**
 * Created by RajPrudhviMarella on 02/Mar/2021.
 */

class OutletSelectionPage extends StatefulWidget {
  static const String tag = 'OutletSelectionPage';

  @override
  State<StatefulWidget> createState() {
    return OutletSelectionDesign();
  }
}

class OutletSelectionDesign extends State<OutletSelectionPage>
    with TickerProviderStateMixin {
  Widget appBarTitle = new Text(
    "Select outlet",
    style: new TextStyle(color: Colors.black),
  );
  Icon icon = new Icon(
    Icons.search,
    color: Colors.black,
  );
  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _controller = new TextEditingController();
  Future<List<FavouriteOutletsList>> favouriteOutletListFuture;
  List<FavouriteOutletsList> favouriteOutletList;
  Future<List<FavouriteOutletsList>> allOutletListFuture;
  List<FavouriteOutletsList> allOutletList;
  StarredOutletList favouriteOutletsResponse;
  StarredOutletList allOutletsResponse;
  String supplierID;
  String mudra;
  String searchedString;

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
          favouriteOutletListFuture = callFavouriteOutlets();
          allOutletListFuture = callAllOutlets();
        }
      });
    } catch (Exception) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: faintGrey,
      body: ListView(
        children: <Widget>[
          buildAppBar(context),
          headers(context, Constants.txt_starred, 18.0),
          displayList(context, true),
          headers(context, Constants.txt_all_outlets, 18.0),
          displayList(context, false)
        ],
      ),
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
            fontFamily: "SourceSansProBold",
            fontSize: size,
          )),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(
        centerTitle: true,
        title: appBarTitle,
        backgroundColor: Colors.white,
        bottomOpacity: 0.0,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          new IconButton(
            icon: icon,
            onPressed: () {
              setState(() {
                if (this.icon.icon == Icons.search) {
                  this.icon = new Icon(
                    Icons.close,
                    color: Colors.black,
                  );
                  this.appBarTitle = new TextField(
                    maxLines: null,
                    textInputAction: TextInputAction.go,
                    controller: _controller,
                    onChanged: searchOperation,
                    cursorColor: Colors.blue,
                    autofocus: true,
                    style: new TextStyle(
                      color: Colors.black,
                    ),
                    decoration: new InputDecoration(
                        prefixIcon: new Icon(Icons.search, color: Colors.black),
                        hintText: Constants.txt_Search_order_number,
                        hintStyle: new TextStyle(color: greyText)),
                    // onChanged: searchOperation,
                  );
                } else {
                  _handleSearchEnd();
                }
              });
            },
          ),
        ]);
  }

  void searchOperation(String searchText) {
    // filterSearchResults(searchText);
  }

  void _handleSearchEnd() {
    setState(() {
      this.icon = new Icon(
        Icons.search,
        color: Colors.black,
      );
      this.appBarTitle = new Text(
        Constants.txt_orders,
        style: new TextStyle(color: Colors.black),
      );
      _controller.clear();
      searchedString = "";
      // filterSearchResults(null);
      // ordersList = callRetreiveOrdersAPI();
    });
  }

  Future<List<FavouriteOutletsList>> callFavouriteOutlets() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart',
      'mudra': mudra,
      'supplierId': supplierID
    };

    Map<String, String> queryParams = {
      'supplierId': supplierID,
      'isFavourite': "true"
    };
    String queryString = Uri(queryParameters: queryParams).query;
    var requestUrl = URLEndPoints.retrieve_outlets + '?' + queryString;
    print(requestUrl);
    var response = await http.get(requestUrl, headers: headers);
    var jsonMap = json.decode(response.body);
    favouriteOutletsResponse = StarredOutletList.fromJson(jsonMap);
    favouriteOutletList = favouriteOutletsResponse.data;
    print("outlet model" + json.encode(favouriteOutletsResponse));
    favouriteOutletList.sort((a, b) {
      return a.outlet.outletName
          .toLowerCase()
          .compareTo(b.outlet.outletName.toLowerCase());
    });
    return favouriteOutletList;
  }

  Future<List<FavouriteOutletsList>> callAllOutlets() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart',
      'mudra': mudra,
      'supplierId': supplierID
    };
    Map<String, String> queryParams = {
      'supplierId': supplierID,
    };
    String queryString = Uri(queryParameters: queryParams).query;
    var requestUrl = URLEndPoints.retrieve_outlets + '?' + queryString;
    print(requestUrl);
    var response = await http.get(requestUrl, headers: headers);
    var jsonMap = jsonDecode(response.body);
    allOutletsResponse = StarredOutletList.fromJson(jsonMap);
    allOutletList = allOutletsResponse.data;
    print("outlet model" + json.encode(allOutletsResponse));
    allOutletList.sort((a, b) {
      return a.outlet.outletName
          .toLowerCase()
          .compareTo(b.outlet.outletName.toLowerCase());
    });
    return allOutletList;
  }

  Widget displayList(BuildContext context, bool bool) {
    return FutureBuilder<List<FavouriteOutletsList>>(
        future: getList(bool),
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapShot.connectionState == ConnectionState.done &&
                snapShot.hasData &&
                snapShot.data.isNotEmpty) {
              return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapShot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        margin: EdgeInsets.only(top: 1.0),
                        child: Container(
                            color: Colors.white,
                            child: ListTile(
                                focusColor: Colors.white,
                                onTap: () {
                                  moveToProductPage(
                                      snapShot.data[index].outlet);
                                },
                                contentPadding:
                                    EdgeInsets.only(left: 15.0, right: 10.0),
                                leading: displayImage(
                                    snapShot.data[index].outlet.logoUrl),
                                title: Text(
                                  snapShot.data[index].outlet.outletName,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                    fontFamily: "SourceSansProSemiBold",
                                  ),
                                ),
                                subtitle: Text(
                                  snapShot
                                      .data[index].outlet.company.companyName,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: greyText,
                                    fontFamily: "SourceSansProRegular",
                                  ),
                                ),
                                trailing: Icon(
                                  snapShot.data[index].isFavourite
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: snapShot.data[index].isFavourite
                                      ? Colors.yellow
                                      : null,
                                ))));
                  });
            } else {
              return Container();
            }
          }
        });
  }

  Future<List<FavouriteOutletsList>> getList(bool bool) {
    if (bool) {
      return favouriteOutletListFuture;
    } else {
      return allOutletListFuture;
    }
  }

  Widget displayImage(String Url) {
    if (Url != null && Url.isNotEmpty) {
      return Container(
          height: 40.0,
          width: 40.0,
          decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              image:
                  DecorationImage(fit: BoxFit.fill, image: NetworkImage(Url))));
    } else {
      return Container(
          height: 40.0,
          width: 40.0,
          decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/placeholder_all.png'))));
    }
  }

  void filterSearchResults(String query) {
    List<FavouriteOutletsList> dummySearchList = List<FavouriteOutletsList>();
    dummySearchList.addAll(allOutletList);
    if (query.isNotEmpty) {
      List<FavouriteOutletsList> dummyListData = List<FavouriteOutletsList>();
      for (var i = 0; i < dummySearchList.length; i++) {
        if (dummySearchList[i].outlet.outletName.contains(query)) {
          dummyListData.add(dummySearchList[i]);
        }
      }
      setState(() {
        allOutletListFuture =
            dummyListData as Future<List<FavouriteOutletsList>>;
      });
      return;
    } else {
      setState(() {
        allOutletListFuture =
            dummySearchList as Future<List<FavouriteOutletsList>>;
      });
    }
  }

  void moveToProductPage(Outlet outlet) {}
}