import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:zm_supplier/deliveries/deliveries_page.dart';
import 'package:zm_supplier/models/user.dart';
import 'package:zm_supplier/orders/viewOrder.dart';
import 'package:zm_supplier/utils/constants.dart';
import 'package:zm_supplier/models/orderSummary.dart';
import 'package:zm_supplier/utils/urlEndPoints.dart';
import 'package:zm_supplier/models/activityResponse.dart';
import '../utils/color.dart';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class OrderActivityPage extends StatefulWidget {
  final orderId;

  OrderActivityPage(this.orderId);

  @override
  ActivityState createState() => new ActivityState(this.orderId);
}

class ActivityState extends State<OrderActivityPage> {
  final orderId;

  ActivityState(this.orderId);

  ActivityResponse activityRespone;
  Future<List<ActivityData>> activityList;
  List<ActivityData> arrayActivityList;

  SharedPref sharedPref = SharedPref();

  @override
  void initState() {
    super.initState();

    activityList = _retriveActivityHistory();
  }

  Future<List<ActivityData>> _retriveActivityHistory() async {
    LoginResponse user =
        LoginResponse.fromJson(await sharedPref.readData(Constants.login_Info));

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart',
      'mudra': user.mudra,
      'supplierId': user.supplier.first.supplierId
    };

    print(headers);

    // final body = {
    //       "orderId": orderId,
    //       "includeOrderChanges": true,
    //     };

    Map<String, String> queryParams = {
      'orderId': orderId,
      'includeOrderChanges': false.toString()
    };

    String queryString = Uri(queryParameters: queryParams).query;

    var url = URLEndPoints.order_activity_url + '?' + queryString;
    print(url);

    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      activityRespone = ActivityResponse.fromJson(json.decode(response.body));
    } else {
      print('failed get orders data');
    }

    arrayActivityList = activityRespone.data;
    print(arrayActivityList.length);
    return arrayActivityList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: faintGrey,
      appBar: AppBar(
        centerTitle: true,
        title: appBarTitle,
        backgroundColor: Colors.white,
        bottomOpacity: 0.0,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          activityInfo()
          // displayList(context),
        ],
      ),
    );
  }

  Widget appBarTitle = new Text(
    "Activity history",
    style: TextStyle(
        color: Colors.black, fontFamily: "SourceSansProBold", fontSize: 18),
  );

  String readTimestamp(int timestamp) {
    var date1 = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var formattedDate = DateFormat('d MMM yyyy • HH:mm').format(date1);

    return formattedDate;
  }

  Widget activityInfo() {
    return FutureBuilder<List<ActivityData>>(
        future: activityList,
        builder:
            (BuildContext context, AsyncSnapshot<List<ActivityData>> snapshot) {
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
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return new Column(children: <Widget>[
                    // Theme(
                    //   data: ThemeData(canvasColor: Colors.lightBlue),
                    //   child: Container(
                    //     // color: Colors.yellow,
                    //     child: Stepper(
                    //       controlsBuilder: (BuildContext context,
                    //               {VoidCallback onStepContinue,
                    //               VoidCallback onStepCancel}) =>
                    //           Container(height: 0,),
                    //       type: StepperType.vertical,
                    //       physics: ClampingScrollPhysics(),
                    //       steps: [
                    //         Step(
                    //
                    //           isActive: (index == 0) ? true : false,
                    //
                    //           title: Column(
                    //             children: [
                    //               Text(snapshot.data[index].activityMessage),
                    //             ],
                    //           ),
                    //
                    //           subtitle: Text('yes'),
                    //           content: Column(
                    //             children: [
                    //               Row(
                    //                 children: [
                    //                   Text(
                    //                     readTimestamp(
                    //                         snapshot.data[index].timeActivity),
                    //                     textAlign: TextAlign.left,
                    //                     style: TextStyle(
                    //                         fontSize: 12,
                    //                         fontFamily: "SourceSansProRegular",
                    //                         color: greyText),
                    //                   ),
                    //                 ],
                    //               ),
                    //               Row(
                    //                 children: [
                    //                   Text(
                    //                     snapshot
                    //                         .data[index].activityUser.firstName,
                    //                     style: TextStyle(
                    //                         fontSize: 12,
                    //                         fontFamily: "SourceSansProRegular",
                    //                         color: greyText),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ],
                    //           ),
                    //
                    //
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),

                    ListTile(
                      tileColor: Colors.white,
                      title: Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 20),
                        child: Text(
                          snapshot.data[index].activityMessage,
                          style: TextStyle(
                              fontSize: (index == 0) ? 18 : 16,
                              fontFamily: (index == 0)
                                  ? "SourceSansProBold"
                                  : "SourceSansProRegular"),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  readTimestamp(
                                      snapshot.data[index].timeActivity),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: "SourceSansProRegular",
                                      color: greyText),
                                ),
                              ],
                            ),

                            checkRemark(snapshot.data[index]),
                            checkActivityUser(snapshot.data[index])

                          ],
                        ),
                      ),
                    ),
                  ]);
                });
          }
        });
  }

  Widget checkRemark(ActivityData arr) {

    if (arr.activityRemark != null && arr.activityRemark.isNotEmpty) {
      return Container(
        height: 20,
        child: Row(children: [
          Text('"' + (arr.activityRemark) + '"', style: TextStyle(fontSize: 12, fontFamily: 'SourceSansProItalic', color: greyText),)
        ]),
      );
    } else {
      return Container(
        height: 0,
      );
    }

  }


  Widget checkActivityUser(ActivityData arr) {

    if (arr.activityUser != null && arr.activityUser.firstName.isNotEmpty) {
      return Container(
        height: 20,
        child: Row(children: [
          Text(arr.activityUser.firstName, style: TextStyle(fontSize: 12, fontFamily: 'SourceSansProRegular', color: greyText),)
        ]),
      );
    } else {
      return Container(
        height: 0,
      );
    }

  }
}
