import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zm_supplier/models/categoryResponse.dart';
import 'package:zm_supplier/models/user.dart';
import 'package:zm_supplier/utils/color.dart';
import 'package:zm_supplier/utils/constants.dart';
import 'package:zm_supplier/utils/urlEndPoints.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class SubCategoryFilterPage extends StatefulWidget {
  List<Children> selectedFilters = [];
  String categoryId;
  List<String> selectedCategoryIds = [];

  SubCategoryFilterPage(
      this.selectedFilters, this.categoryId, this.selectedCategoryIds);

  @override
  State<StatefulWidget> createState() => SubCategoryFilterState(
      this.selectedFilters, this.categoryId, this.selectedCategoryIds);
}

class SubCategoryFilterState extends State<SubCategoryFilterPage> {
  bool isPresent(Children categoryId) {
    for (Children e in selectedStatus) {
      if (e.categoryId == categoryId.categoryId) return true;
    }
    return false;
  }

  bool isPresentCategoryId(String categoryId) {
    print(selectedCategoryIds);
    return selectedCategoryIds.contains(categoryId);
  }

  List<Children> selectedStatus = [];
  List<String> selectedCategoryIds =
      []; //<String>['Not yet due', 'Overdue', 'Paid'];
  String categoryId;
  LoginResponse userData;
  SharedPref sharedPref = SharedPref();

  SubCategoryFilterState(
      this.selectedStatus, this.categoryId, List<String> selectedCategoryIds);

  SubCategoryBaseResponse subCategoryBaseResponse;
  List<SubCategoryData> subCategoryResponse;
  Future<List<Children>> categoriesData;
  List<Children> categoriesDataList;

  @override
  void initState() {
    if (selectedStatus == null) {
      selectedStatus = [];
    }
    super.initState();
    categoriesData = getCategoriesAPI(false, false);
    if (widget.selectedFilters != null && widget.selectedFilters.length > 0)
      selectedStatus = widget.selectedFilters;
    selectedCategoryIds = widget.selectedCategoryIds;
  }

  Future<List<Children>> getCategoriesAPI(
      bool isUpdating, bool isFilterApplied) async {
    userData =
        LoginResponse.fromJson(await sharedPref.readData(Constants.login_Info));

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart',
      'mudra': userData.mudra,
      'supplierId': userData.supplier.first.supplierId
    };

    Map<String, String> queryParams = {'categoryId': this.categoryId};

    String queryString = Uri(queryParameters: queryParams).query;

    var url = URLEndPoints.retrieve_subCategories + '?' + queryString;

    // var url = URLEndPoints.customers_report_data;
    print(headers);
    print(url);
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      // print(response.body);
      print('Success response');
      print(response.body.toString());
      var jsonMap = json.decode(response.body);
      print("jsonmap: " + jsonMap.toString());
      subCategoryBaseResponse = SubCategoryBaseResponse.fromJson(jsonMap);
      print("reposnedjfnf:" + json.encode(subCategoryBaseResponse));
      // subCategoryResponse =  json.decode(response.body)['data'];
      categoriesDataList = subCategoryBaseResponse.data[0].children;
      print("categoryList:" + json.encode(categoriesDataList));
    } else {
      print('failed get categories');
    }

    return categoriesDataList;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      //  key: globalKey,
      backgroundColor: faintGrey,
      appBar: buildAppBar(context),
      body: ListView(
        children: <Widget>[headers(), statusList(), button()],
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Filter',
          style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'SourceSansProBold'),
        ),
        bottomOpacity: 0.0,
        elevation: 0.0,
        leading: Center(
            child: GestureDetector(
          onTap: () {
            setState(() {
              selectedStatus = [];
              selectedCategoryIds = [];
            });
          },
          child: Text(
            '   Reset',
            style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'SourceSansProRegular'),
          ),
        )),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close, color: Colors.black), //Image(

            onPressed: () {
              Navigator.of(context).pop(selectedStatus);
            },
          ),
        ]);
  }

  Widget headers() {
    return Container(
      color: faintGrey,
      padding: const EdgeInsets.only(left: 15.0, top: 22),
      height: 20,
    );
  }

  Widget statusList() {
    return FutureBuilder<List<Children>>(
        future: categoriesData,
        builder:
            (BuildContext context, AsyncSnapshot<List<Children>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else if (snapshot.hasError) {
            return Center(child: Text('failed to load'));
          } else {
            return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: categoriesDataList.length,
                itemBuilder: (BuildContext context, int index) {
                  return new Column(children: <Widget>[
                    ListTile(
                      tileColor: Colors.white,
                      title: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          categoriesDataList[index].name,
                          style: TextStyle(
                              fontSize: 16, fontFamily: "SourceSansProRegular"),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          if (isPresent(categoriesDataList[index])) {
                            for (int i = 0; i < selectedStatus.length; i++) {
                              if (categoriesDataList[index].categoryId ==
                                  selectedStatus[i].categoryId) {
                                selectedStatus.remove(selectedStatus[i]);
                              }
                            }
                            selectedCategoryIds
                                .remove(categoriesDataList[index].categoryId);
                          } else {
                            selectedStatus.add(categoriesDataList[index]);
                            selectedCategoryIds
                                .add(categoriesDataList[index].categoryId);
                          }
                        });
                      },
                      trailing: trailingIcon(index),
                    ),
                    Divider(
                      height: 1.5,
                      color: faintGrey,
                    )
                  ]);
                });
          }
        });
  }

  Widget trailingIcon(int index) {
    if (isPresent(categoriesDataList[index])) {
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

  Widget button() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 100, right: 20),
      child: Container(
        height: 50,
        child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          onPressed: () {
            Navigator.of(context).pop(selectedStatus);
          },
          child: const Text('Save',
              style:
                  TextStyle(fontSize: 16, fontFamily: 'SorceSansProSemiBold')),
          color: buttonBlue,
          textColor: Colors.white,
        ),
      ),
    );
  }
}
