import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:zm_supplier/models/outletResponse.dart';
import 'package:zm_supplier/models/response.dart';
import 'package:zm_supplier/services/favouritesApi.dart';
import 'package:zm_supplier/utils/color.dart';
import 'package:zm_supplier/utils/constants.dart';
import 'package:zm_supplier/models/user.dart';
import 'package:zm_supplier/utils/eventsList.dart';
import 'package:zm_supplier/utils/urlEndPoints.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';

import 'market_list_page.dart';

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
    Constants.txt_select_outlet,
    style: new TextStyle(
        color: Colors.black, fontSize: 18, fontFamily: "SourceSansProBold"),
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

  Constants events = Constants();

  ApiResponse specificUserInfo;
  dynamic userProperties;
  LoginResponse loginResponse;

  @override
  void initState() {
    loadSharedPrefs();
    super.initState();
    events.mixPanelEvents();
  }

  SharedPref sharedPref = SharedPref();

  loadSharedPrefs() async {
    try {
      loginResponse = LoginResponse.fromJson(
          await sharedPref.readData(Constants.login_Info));
      specificUserInfo = ApiResponse.fromJson(
          await sharedPref.readData(Constants.specific_user_info));

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
    return new Scaffold(
      key: globalKey,
      appBar: buildAppBar(context),
      backgroundColor: faintGrey,
      body: ListView(
        children: <Widget>[
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
          EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0, bottom: 15.0),
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
        elevation: 2.0,
        leading: Container(
          padding: EdgeInsets.only(right: 8.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        actions: <Widget>[
          new IconButton(
            icon: icon,
            onPressed: () {
              setState(() {
                if (this.icon.icon == Icons.search) {
                  userProperties = {
                    "userName": specificUserInfo.data.fullName,
                    "email": loginResponse.user.email,
                    "userId": loginResponse.user.userId
                  };
                  events.mixpanel.track(
                      Events.TAP_NEW_ORDER_SELECT_OUTLET_SEARCH,
                      properties: userProperties);
                  events.mixpanel.flush();

                  this.icon = new Icon(
                    Icons.close,
                    color: Colors.black,
                  );
                  this.appBarTitle = new TextField(
                    maxLines: null,
                    textInputAction: TextInputAction.go,
                    controller: _controller,
                    onChanged: (value) {
                      setState(() {});
                    },
                    cursorColor: Colors.blue,
                    autofocus: true,
                    style: new TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontFamily: "SourceSansProRegular"),
                    decoration: new InputDecoration(
                        prefixIcon: new Icon(Icons.search, color: Colors.black),
                        hintText: Constants.txt_Search_outlet,
                        hintStyle: new TextStyle(
                            color: greyText,
                            fontSize: 16.0,
                            fontFamily: "SourceSansProRegular")),
                  );
                } else {
                  _handleSearchEnd();
                }
              });
            },
          ),
        ]);
  }

  void _handleSearchEnd() {
    setState(() {
      this.icon = new Icon(
        Icons.search,
        color: Colors.black,
      );
      this.appBarTitle = new Text(
        Constants.txt_select_outlet,
        style: new TextStyle(color: Colors.black),
      );
      _controller.clear();
      searchedString = "";
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
      "orderEnabled": "true",
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
      "orderEnabled": "true"
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
            if (bool) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Container();
            }
          } else {
            if (snapShot.connectionState == ConnectionState.done &&
                snapShot.hasData &&
                snapShot.data.isNotEmpty) {
              return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapShot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (_controller.text.isEmpty) {
                      return displaySearchedList(snapShot, index);
                    } else if (snapShot.data[index].outlet.outletName
                        .toLowerCase()
                        .contains(_controller.text)) {
                      return displaySearchedList(snapShot, index);
                    } else {
                      return Container();
                    }
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

  Widget displayImage(Outlet outlet) {
    if (outlet != null && outlet.logoUrl != null && outlet.logoUrl.isNotEmpty) {
      return Container(
          height: 38.0,
          width: 38.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Image.network(
              outlet.logoUrl,
              fit: BoxFit.fill,
            ),
          ));
    } else {
      return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: Colors.blue.withOpacity(0.5),
        ),
        child: Center(
          child: Text(
            outletPlaceholder(outlet.outletName),
            style: TextStyle(fontSize: 14, fontFamily: "SourceSansProSemiBold"),
          ),
        ),
      );
    }
  }

  String outletPlaceholder(String name) {
    Constants value = Constants();
    var placeholder = value.getInitialWords(name);
    return placeholder;
  }

  Widget displaySearchedList(
      AsyncSnapshot<List<FavouriteOutletsList>> snapShot, int index) {
    return Card(
        margin: EdgeInsets.only(top: 0.5),
        child: Container(
            color: Colors.white,
            child: ListTile(
                focusColor: Colors.white,
                contentPadding: EdgeInsets.only(left: 15.0, right: 3.0),
                leading: displayImage(snapShot.data[index].outlet),
                title: RichText(
                  text: TextSpan(
                    children: highlightOccurrences(
                        snapShot.data[index].outlet.outletName,
                        _controller.text),
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontFamily: "SourceSansProSemiBold"),
                  ),
                ),
                subtitle: Text(
                  snapShot.data[index].outlet.company.companyName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: greyText,
                    fontFamily: "SourceSansProRegular",
                  ),
                ),
                trailing: IconButton(
                  icon: snapShot.data[index].isFavourite
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
                    tapOnFavourite(index, snapShot.data[index]);
                    //   _onDeleteItemPressed(index);
                  },
                ),
                onTap: () {
                  userProperties = {
                    "userName": specificUserInfo.data.fullName,
                    "email": loginResponse.user.email,
                    "userId": loginResponse.user.userId,
                    'outletId': snapShot.data[index].outlet.outletId,
                    'outletName': snapShot.data[index].outlet.outletName
                  };
                  events.mixpanel.track(Events.TAP_NEW_ORDER_SELECT_OUTLET,
                      properties: {});
                  events.mixpanel.flush();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new MarketListPage(
                              snapShot.data[index].outlet.outletId,
                              snapShot.data[index].outlet.outletName,
                              null)));
                })));
  }

  tapOnFavourite(int index, FavouriteOutletsList customers) {
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

        globalKey.currentState
          ..showSnackBar(
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
        .then((value) async {});
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
}
