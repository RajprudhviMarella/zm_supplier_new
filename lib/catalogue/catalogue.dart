import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:zm_supplier/catalogue/productDetails.dart';
import 'package:zm_supplier/catalogue/searchCataloguePage.dart';
import 'package:zm_supplier/catalogue/subCategoryFilter.dart';
import 'package:zm_supplier/models/catalogueResponse.dart';
import 'package:zm_supplier/models/categoryResponse.dart';
import 'package:zm_supplier/models/products.dart';
import 'package:zm_supplier/models/user.dart';
import 'package:zm_supplier/services/favouritesApi.dart';
import 'package:zm_supplier/utils/constants.dart';
import 'package:zm_supplier/utils/color.dart';
import 'package:zm_supplier/utils/urlEndPoints.dart';
import 'package:http/http.dart' as http;

class Catalogue extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CatalogueDesign();
  }
}

class CatalogueDesign extends State<Catalogue> {
  CatalogueBaseResponse catalogueBaseResponse;
  CatalogueResponse catalogueResponse;
  Future<List<CatalogueProducts>> productsData;
  List<CatalogueProducts> productsDataList;
  List<Children> selectedFilters = [];

  CategoryResponse categoryResponse;
  Future<List<Categories>> categoriesData;
  List<Categories> categoriesDataList;

  SharedPref sharedPref = SharedPref();
  LoginResponse userData;

  int totalNoRecords = 0;
  int pageNum = 1;
  bool isPageLoading = false;
  int totalNumberOfPages = 0;
  int pageSize = 50;
  ScrollController controller;

  bool isAllSelected = true;
  Categories selectedCategory;

  Constants events = Constants();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  int selectedIndex = 0;
  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.black,
  );

  @override
  void initState() {
    super.initState();

    events.mixPanelEvents();

    categoriesData = getCategoriesAPI(false, false);
    productsData = getCataloguesAPI(false, false, "","");
    // productsData = getCatalogueApiCalling(false, false);
  }

  Future<List<Categories>> getCategoriesAPI(
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
      "sortOrder": "ASC",
      'supplierId': userData.supplier.first.supplierId
    };

    String queryString = Uri(queryParameters: queryParams).query;

    var url = URLEndPoints.retrieve_categories + '?' + queryString;

    // var url = URLEndPoints.customers_report_data;
    print(headers);
    print(url);
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      // print(response.body);
      print('Success response');

      categoryResponse = CategoryResponse.fromJson(json.decode(response.body));
      addAllCategory();
      categoriesDataList = categoryResponse.data;
    } else {
      print('failed get categories');
    }

    return categoriesDataList;
  }

  Future<List<CatalogueProducts>> getCataloguesAPI(
      bool isUpdating, bool isFilterApplied, String categoryId, String subcategoryId) async {
    catalogueBaseResponse = CatalogueBaseResponse();
    userData =
        LoginResponse.fromJson(await sharedPref.readData(Constants.login_Info));

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart',
      'mudra': userData.mudra,
      'supplierId': userData.supplier.first.supplierId
    };

    Map<String, String> queryParams = {
      'sortBy': "productName",
      "sortOrder": "ASC",
      'pageNumber': pageNum.toString(),
      'pageSize': pageSize.toString(),
    };

    if (categoryId.isNotEmpty) {
      queryParams['mainCategoryId'] = categoryId;
    }

    if (subcategoryId.isNotEmpty) {
      queryParams['categoryIds'] = subcategoryId;
    }

    String queryString = Uri(queryParameters: queryParams).query;

    var url = URLEndPoints.retrieve_catalogue + '?' + queryString;

    // var url = URLEndPoints.customers_report_data;
    print(headers);
    print(url);
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      // print(response.body);
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

  @override
  void dispose() {
    super.dispose();
    //DartNotificationCenter.unsubscribe(observer: Constants.favourite_notifier);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: faintGrey,
      appBar: buildAppBar(context),
      body: Container(
          color: faintGrey,
          child: RefreshIndicator(
            key: refreshKey,
            child: ListView(children: [
              bannerList(),
              spaceBanner(),
              headers(context),
            ]),
            color: azul_blue,
            onRefresh: refreshList,
          )),
    );
  }

  Widget headers(context) {
    String text = "";
    if (isAllSelected) {
      text = "All items";
    } else {
      text = selectedCategory.name;
    }
    return StickyHeader(
      header: Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 0.0),
        padding:
            EdgeInsets.only(left: 20.0, right: 10.0, top: 15, bottom: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text,
                style: TextStyle(
                  fontFamily: "SourceSansProBold",
                  fontSize: 18,
                )),
          ],
        ),
      ),
      content: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!isAllSelected) subCategoryBanner(),
            list(),
          ],
        ),
      ),
    );
  }

  Widget subCategoryBanner() {
    String names = "All categories";
    List<String> namesArray = [];
    if (selectedFilters.isNotEmpty) {
      selectedFilters.forEach((element) {
        namesArray.add(element.name);
      });
      names = namesArray.join(",");
    }

    return Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: new GestureDetector(
            onTap: () async {
              print("Container clicked");
              final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new SubCategoryFilterPage(
                          selectedFilters, selectedCategory.categoryId)));

              // isFilterApplied = true;
              // );
            },
            child: new Container(
              height: 60,
              margin: EdgeInsets.fromLTRB(5, 15, 5, 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Center(
                child: Text(
                  names,
                  style: TextStyle(
                      fontSize: 14, fontFamily: "SourceSansProSemiBold"),
                ),
              ),
            )));
  }

  Widget spaceBanner() {
    return Padding(padding: EdgeInsets.fromLTRB(20, 5, 20, 5));
  }

  Future<Null> refreshList() async {
    print("refreshing");
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 0));

    setState(() {
      categoriesData = getCategoriesAPI(false, true);
      productsData = getCataloguesAPI(false, false, "","");
      // selectedCustomersDataFuture =
      //     getCustomersListCalling(false, true);
    });

    return null;
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(Constants.txt_catalogue,
            style: TextStyle(
              color: Colors.black,
              fontFamily: "SourceSansProBold",
              fontSize: 18,
            )),
        backgroundColor: Colors.white,
        bottomOpacity: 0.0,
        elevation: 0.0,
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: new IconButton(
              icon: actionIcon,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new SearchCataloguePage()));
              },
            ),
          ),
        ]);
  }

  Widget bannerList() {
    return FutureBuilder<List<Categories>>(
        future: categoriesData,
        builder:
            (BuildContext context, AsyncSnapshot<List<Categories>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else if (snapshot.hasError) {
            return Center(child: Text('failed to load'));
          } else {
            return SizedBox(
              height: 135,
              child: ListView.builder(
                  key: const PageStorageKey<String>('scrollPosition'),
                  itemCount: categoryResponse.data.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.all(0),
                      child: GestureDetector(
                        onTap: () {
                          print('tapped $index');
                          if (index == 0) {
                            isAllSelected = true;
                            selectedCategory = categoryResponse.data[index];
                          } else {
                            isAllSelected = false;
                            selectedCategory = categoryResponse.data[index];
                          }
                          setState(() {
                            pageNum = 1;
                            selectedIndex = index;
                            productsData = getCataloguesAPI(
                                false,
                                false,
                                categoryResponse
                                    .data[selectedIndex].categoryId,"");
                            // selectedCustomersDataFuture = selectedD(a);
                          });
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(0),
                              child: Container(
                                  //  padding: last ? EdgeInsets.only(left: 20): null,
                                  width: 120,
                                  height: 120,
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
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                      ),
                                      displayImage(snapshot.data[index]),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                snapshot.data[index].name,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontFamily:
                                                      'SourceSansProSemiBold',
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
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

  Widget displayImage(Categories category) {
    if (category != null &&
        category.imageURL != null &&
        category.imageURL.isNotEmpty) {
      print(category.imageURL);

      return Container(
        height: 60.0,
        width: 60.0, child:  Image.network('https://i.imgur.com/P3bhVwb.png')
      );
    } else {
      return Container(
        height: 60.0,
        width: 60.0,
        child: Image.asset('assets/images/cat_icon_all.png'),
      );
    }
  }

  void addAllCategory() {
    Categories categories = new Categories("", "All", "");
    categoryResponse.data.insert(0, categories);
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
            child:  Image.network(url)
      );
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

  String outletPlaceholder(String name) {
    Constants value = Constants();
    var placeholder = value.getInitialWords(name);
    return placeholder;
  }

  Widget list() {
    return Column(
      children: [
        FutureBuilder<List<CatalogueProducts>>(
            future: productsData,
            builder: (BuildContext context,
                AsyncSnapshot<List<CatalogueProducts>> snapshot) {
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
                  itemCount: catalogueBaseResponse.data.data.length,
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
                                      tapOnFavourite(index, snapshot.data[index]);
                                    }),
                              ),
                              tileColor: Colors.white,
                              onTap: () async {
                                showDialog(context: context,
                                    builder: (BuildContext context){
                                      return Productdetails(
                                       catalogueProducts: snapshot.data[index],
                                      );
                                    }
                                );
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

    SkuFavourite skuFavourite = SkuFavourite(products.sku, products.isFavourite);
    FavouritesApi favourite = new FavouritesApi();
    favourite
        .updateProductFavourite(userData.mudra, userData.supplier.first.supplierId,
         skuFavourite)
        .then((value) async {
      // getCustomersReportApiCalling(true, false);
      // getCustomersListCalling(true, false);
    });
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
}
