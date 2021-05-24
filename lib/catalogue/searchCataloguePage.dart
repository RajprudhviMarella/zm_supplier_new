import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zm_supplier/models/catalogueResponse.dart';
import 'package:zm_supplier/models/products.dart';
import 'package:zm_supplier/models/user.dart';
import 'package:zm_supplier/orders/orderDetailsPage.dart';
import 'package:zm_supplier/services/favouritesApi.dart';
import 'package:zm_supplier/utils/color.dart';
import 'package:zm_supplier/utils/constants.dart';
import 'package:zm_supplier/utils/urlEndPoints.dart';
import 'package:http/http.dart' as http;
import 'package:zm_supplier/catalogue/productDetails.dart';

/**
 * Created by RajPrudhviMarella on 20/May/2021.
 */

class SearchCataloguePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchCatalogueDesign();
  }
}

class SearchCatalogueDesign extends State<SearchCataloguePage>
    with TickerProviderStateMixin {
  final TextEditingController _controller = new TextEditingController();
  String supplierID;
  String mudra;
  int totalNoRecords = 0;
  int pageNum = 1;
  bool isPageLoading = false;
  int totalNumberOfPages = 0;
  int pageSize = 50;
  ScrollController controller;
  String searchedString = "";
  List<String> recentSearchList = [];
  CatalogueBaseResponse catalogueBaseResponse;
  CatalogueResponse catalogueResponse;
  Future<List<CatalogueProducts>> productsData;
  List<CatalogueProducts> productsDataList;

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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        recentSearchList =
            prefs.getStringList(Constants.recent_search_info_Info);
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
          searchedString.isNotEmpty
              ? displayList(context)
              : displayRecentList(context),
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
            height: 50.0,
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
              onChanged: (value) {
                if (value.isEmpty) {
                  setState(() {
                    searchedString = "";
                  });
                }
              },
              style: new TextStyle(
                color: Colors.black,
              ),
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: new Icon(Icons.search, color: Colors.grey),
                  hintText: Constants.txt_Search_catalogue,
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

  void searchOperation(String searchText) {
    setState(() {
      searchedString = searchText;
      if (searchedString.isNotEmpty) {
        if (recentSearchList != null) {
          List<String> newList = recentSearchList;
          if (!newList.contains(searchedString)) newList.add(searchedString);
          recentSearchList = newList;
        } else {
          recentSearchList = [];
          List<String> newList = recentSearchList;
          if (!newList.contains(searchedString)) newList.add(searchedString);
          recentSearchList = newList;
        }
        SharedPref sharedPref = SharedPref();
        sharedPref.saveStringArrayList(
            Constants.recent_search_info_Info, recentSearchList);
      }
    });
    if (productsData != null) productsData = null;
    if (productsDataList != null && productsDataList.length > 0)
      productsDataList.clear();
    productsData = getCataloguesAPI();
  }

  _scrollListener() {
    print("on scroll current page number $pageNum");
    print("on scroll  total page numbers $totalNoRecords");
    if (controller.position.maxScrollExtent == controller.offset) {
      if (pageNum < totalNoRecords && !isPageLoading) {
        pageNum++;
        print("PAGE NUMBER $pageNum");
        print("getting data");
        // callRetreiveOrdersAPI(); // Hit API to get new data
      }
    }
  }

  Future<List<CatalogueProducts>> getCataloguesAPI() async {
    catalogueBaseResponse = CatalogueBaseResponse();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart',
      'mudra': mudra,
      'supplierId': supplierID
    };

    Map<String, String> queryParams = {
      'sortBy': "productName",
      "sortOrder": "ASC",
      'pageNumber': pageNum.toString(),
      'pageSize': pageSize.toString(),
    };

    if (searchedString.isNotEmpty) {
      queryParams['searchText'] = searchedString;
    }

    String queryString = Uri(queryParameters: queryParams).query;

    var url = URLEndPoints.retrieve_catalogue + '?' + queryString;

    print(headers);
    print(url);
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      print(response.body);
      print('Success response');
      var jsonMap = json.decode(response.body);
      catalogueBaseResponse = CatalogueBaseResponse.fromJson(jsonMap);
      totalNoRecords = catalogueBaseResponse.data.numberOfPages;
      setState(() {
        if (pageNum == 1) {
          productsDataList = catalogueBaseResponse.data.data;
        } else {
          productsDataList.addAll(catalogueBaseResponse.data.data);
        }
      });
    } else {
      print('failed get catalogues');
    }
    return productsDataList;
  }

  Widget displayRecentList(BuildContext context) {
    if (recentSearchList != null && recentSearchList.length > 0) {
      return Container(
          height: MediaQuery.of(context).size.height,
          child: ListView(children: [
            Container(
              margin: EdgeInsets.only(top: 5.0),
              height: 50.0,
              color: faintGrey,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15.0, top: 5, right: 2),
                    child: Container(
                      height: 30,
                      child: LeftRightAlign(
                          left: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text('Recently searched',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontFamily: "SourceSansProBold")),
                          ),
                          right: FlatButton(
                            onPressed: () {
                              setState(() {
                                recentSearchList.clear();
                                removeFromSharedPref();
                              });
                            },
                            child: Text(
                              'Clear',
                              style: TextStyle(
                                  color: buttonBlue,
                                  fontFamily: "SourceSansProRegular",
                                  fontSize: 12),
                            ),
                          )),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                padding: const EdgeInsets.all(5),
                itemCount: recentSearchList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () {
                        onTapOfRecentText(recentSearchList[index]);
                      },
                      child: Container(
                          margin: EdgeInsets.only(top: 2.0),
                          height: 50,
                          color: Colors.white,
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10.0, top: 2.0),
                                child: Icon(
                                  Icons.watch_later_outlined,
                                  color: Colors.grey,
                                  size: 22.0,
                                ),
                              ),
                              Center(
                                  child: Container(
                                      margin: EdgeInsets.only(left: 7.0),
                                      child: Text(recentSearchList[index],
                                          textAlign: TextAlign.start,
                                          style: new TextStyle(
                                              fontSize: 16.0,
                                              fontFamily:
                                                  "SourceSansProRegular",
                                              color: Colors.black)))),
                            ],
                          )));
                },
              ),
            )
          ]));
    } else {
      return Container(height: MediaQuery.of(context).size.height);
    }
  }

  onTapOfRecentText(String recentSearchList) {
    setState(() {
      _controller.text = recentSearchList;
      _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length));
      searchOperation(recentSearchList);
    });
  }

  removeFromSharedPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(Constants.recent_search_info_Info);
  }

  Widget displayList(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: FutureBuilder<List<CatalogueProducts>>(
          future: productsData,
          builder: (BuildContext context,
              AsyncSnapshot<List<CatalogueProducts>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child:
                      SpinKitThreeBounce(color: Colors.blueAccent, size: 24));
            } else {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData &&
                  snapshot.data.isNotEmpty) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: productsDataList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new Column(children: <Widget>[
                      Container(
                          color: Colors.white,
                          height: 100,
                          child: ListTile(
                              leading:
                                  displayProductImage(snapshot.data[index]),
                              title: Transform.translate(
                                offset: Offset(-5, 0),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    snapshot.data[index].productName,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "SourceSansProSemiBold"),
                                  ),
                                ),
                              ),
                              subtitle: SizedBox(
                                height: 43,
                                child: ListView.builder(
                                    key: const PageStorageKey<String>(
                                        'scrollPosition'),
                                    itemCount: snapshot
                                        .data[index].certifications.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder:
                                        (BuildContext context, int subIndex) {
                                      return Padding(
                                        padding: EdgeInsets.all(0),
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: Row(
                                            children: [
                                              Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 10),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 10.0,
                                                                left: 10),
                                                      ),
                                                      displayCertImage(snapshot
                                                          .data[index]
                                                          .certifications[
                                                              subIndex]
                                                          .name),
                                                    ],
                                                  )),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                              //  isThreeLine: true,

                              //  isThreeLine: true,

                              //profile.imgUrl == null) ? AssetImage('images/user-avatar.png') : NetworkImage(profile.imgUrl)
                              // leading:
                              // leadingImage(snapshot.data[index].sku),
                              trailing: Transform.translate(
                                offset: Offset(10, 0),
                                child: IconButton(
                                    icon: snapshot.data[index].isFavourite
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
                                          index, snapshot.data[index]);
                                    }),
                              ),
                              tileColor: Colors.white,
                              onTap: () async {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Productdetails(
                                        catalogueProducts: snapshot.data[index],
                                      );
                                    });
                              })),
                      Divider(
                        height: 1.5,
                        color: faintGrey,
                      ),
                    ]);
                  },
                );
              } else {
                return Container(
                  height: MediaQuery.of(context).size.height,
                );
              }
            }
          }),
    );
  }

  tapOnFavourite(int index, CatalogueProducts products) {
    if (products.isFavourite) {
      setState(() {
        products.isFavourite = false;
      });
    } else {
      setState(() {
        products.isFavourite = true;
      });
    }

    SkuFavourite skuFavourite =
        SkuFavourite(products.sku, products.isFavourite);
    FavouritesApi favourite = new FavouritesApi();
    favourite
        .updateProductFavourite(mudra, supplierID, skuFavourite)
        .then((value) async {
      // getCustomersReportApiCalling(true, false);
      // getCustomersListCalling(true, false);
    });
  }

  Widget displayProductImage(CatalogueProducts products) {
    if (products != null &&
        products.images != null &&
        products.images.isNotEmpty &&
        products.images[0].imageURL != null &&
        products.images[0].imageFileNames != null &&
        products.images[0].imageFileNames.isNotEmpty) {
      var url =
          products.images[0].imageURL + products.images[0].imageFileNames[0];
      return Container(
          height: 70,
          width: 70,
          margin: EdgeInsets.fromLTRB(5, 15, 5, 15),
          child: Image.network(url));
    } else {
      return Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: faintGrey.withOpacity(1),
        ),
        child: Center(
          child: Image.asset('assets/images/icon_sku_placeholder.png'),
        ),
      );
    }
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

  String outletPlaceholder(String name) {
    Constants value = Constants();
    var placeholder = value.getInitialWords(name);
    return placeholder;
  }

  Widget displayCertImage(String certName) {
    var assetName = 'assets/images/cert_vegan.png';
    Color color = Colors.blue;

    if (certName == 'Halal') {
      assetName = 'assets/images/cert_halal.png';
      color = litGreen;
    }
    if (certName == 'Vegetarian') {
      assetName = 'assets/images/cert_vegetarian.png';
      color = litGreen;
    }
    if (certName == 'Organic') {
      assetName = 'assets/images/cert_organic.png';
      color = litGreen;
    }
    if (certName == 'Vegan') {
      assetName = 'assets/images/cert_vegan.png';
      color = litGreen;
    }
    if (certName == 'Gluten-free') {
      assetName = 'assets/images/cert_gluten.png';
      color = sandal;
    }
    if (certName == 'Kosher') {
      assetName = 'assets/images/cert_halal.png';
      color = sandal;
    }
    if (certName == 'FDA') {
      assetName = 'assets/images/cert_fda.png';
      color = Colors.blue;
    }
    if (certName == 'Fairtrade') {
      assetName = 'assets/images/cert_fairtrade.png';
      color = sandal;
    }
    if (certName == 'GMP') {
      assetName = 'assets/images/cert_gmp.png';
      color = Colors.blue;
    }
    if (certName == 'HAACP') {
      assetName = 'assets/images/cert_haacp.png';
      color = Colors.blue;
    }

    return Container(
      height: 23,
      width: 23,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: color.withOpacity(1),
      ),
      child: Center(
        child: Image.asset(assetName),
      ),
    );
  }
// moveToOrderDetailsPage(Orders element) {
//   Navigator.push(
//       context,
//       MaterialPageRoute(
//           builder: (context) => new OrderDetailsPage(element)));
// }
}
