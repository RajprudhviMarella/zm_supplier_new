import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:zm_supplier/models/invoicesResponse.dart';
import 'package:zm_supplier/models/ordersResponseList.dart';
import 'package:zm_supplier/models/user.dart';
import 'dart:convert';

import 'package:zm_supplier/models/customersResponse.dart';
import 'package:zm_supplier/utils/urlEndPoints.dart';

import '../utils/color.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import 'invoices_filter_page.dart';

class InvoicesSearchPage extends StatefulWidget {
  final outletId;
  final outletName;

  InvoicesSearchPage(this.outletId, this.outletName);

  @override
  State<StatefulWidget> createState() =>
      new InvoicesSearchState(this.outletId, this.outletName);
}

class InvoicesSearchState extends State<InvoicesSearchPage> {
  final outletId;
  final outletName;

  InvoicesSearchState(this.outletId, this.outletName);

  var includeFields = [
    'invoiceDate',
    'supplier',
    'status',
    'invoiceNum',
    'outlet',
    'invoiceId',
    'paymentDueDate',
    'totalCharge',
    'paymentStatus'
  ];
  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _controller = new TextEditingController();

  InvoicesResponse invoicesResponse;
  List<Invoices> invoices;
  Future<List<Invoices>> invoicesFuture;

  bool _isSearching;
  String searchedString;

  SharedPref sharedPref = SharedPref();

  @override
  void initState() {
    super.initState();

//    invoicesFuture = retriveInvoices();
  }

  Future<List<Invoices>> retriveInvoices() async {
    LoginResponse user =
        LoginResponse.fromJson(await sharedPref.readData(Constants.login_Info));

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart',
      'mudra': user.mudra,
      'supplierId': user.supplier.first.supplierId
    };

    Map<String, String> queryParams = {
      'outletId': outletId,
      'invoiceNumSearchText': searchedString,
      'includeFields': includeFields.join(',')
    };

    String queryString = Uri(queryParameters: queryParams).query;

    var url = URLEndPoints.retrive_invoices_url + '?' + queryString;
    print(headers);
    print(url);
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      invoicesResponse = InvoicesResponse.fromJson(json.decode(response.body));
    } else {
      print('failed get invoices');
    }

    invoices = invoicesResponse.data.data;

    return invoices;
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
            fontSize: 12.0,
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: globalKey,
      backgroundColor: faintGrey,
      appBar: buildAppBar(context),
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          // buildSearchBar(context),
          invoicesList()
        ],
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: ListTile(
          leading: null,
          title: Container(
            margin: EdgeInsets.only(top: 3, bottom: 10),
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
              onSubmitted: searchOperation,
              controller: _controller,
              style: new TextStyle(
                color: Colors.black,
              ),
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: new Icon(Icons.search, color: Colors.grey),
                  hintText: 'Search invoice number',
                  hintStyle: new TextStyle(color: greyText)),
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

  Widget buildSearchBar(BuildContext context) {
    return Container(
        // padding: EdgeInsets.all(5.0),
        color: Colors.white,
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
              textInputAction: TextInputAction.go,
              onSubmitted: searchOperation,
              controller: _controller,
              // onSubmitted: searchOperation,
              // autofocus: true,
              // controller: _controller,
              // onSubmitted: searchOperation,
              style: new TextStyle(
                color: Colors.black,
              ),
              // onTap: () async {
              //   final result = await Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) =>
              //           new SearchCustomersPage(customerDataList.first)));
              //
              //   print(result);
              //   //  setState(() {
              //
              //   // });
              // },
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: new Icon(Icons.search, color: Colors.grey),
                  hintText: 'Search invoice number',
                  hintStyle: new TextStyle(color: greyText)),
              // _handleSearchStart()
              // onChanged: searchOperation,
            ),
          ),
        ));
  }

  void searchOperation(String searchText) {
    //invoices.clear();
    //invoices = null;
    print('searchText');
    if (searchText.length > 0) {
      _handleSearchStart();
    }
    // if (_isSearching != null) {
    print(searchText);
    searchedString = searchText;
    invoicesFuture = retriveInvoices();
    //}
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  Widget invoicesList() {
    final height = AppBar().preferredSize.height;

    print(height);
    return FutureBuilder<List<Invoices>>(
        future: invoicesFuture,
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapShot.connectionState == ConnectionState.done &&
                snapShot.hasData &&
                snapShot.data.isNotEmpty) {
              // isPageLoading = false;
              return SizedBox(
                  height: MediaQuery.of(context).size.height-100,
                  child: GroupedListView<Invoices, DateTime>(
                    // controller: controller,
                    elements: snapShot.data,
                    physics: BouncingScrollPhysics(),
                    order: GroupedListOrder.DESC,
                    groupComparator: (DateTime value1, DateTime value2) =>
                        value1.compareTo(value2),
                    groupBy: (Invoices element) => DateTime(
                      element.getInvoiceDate().year,
                      element.getInvoiceDate().month,
                    ),
                    itemComparator: (Invoices element1, Invoices element2) =>
                        element1
                            .getInvoiceDate()
                            .compareTo(element2.getInvoiceDate()),
                    floatingHeader: true,
                    groupSeparatorBuilder: (DateTime element) => Container(
                      height: 50,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 10.0, top: 5.0, bottom: 5.0),
                          height: 70.0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(children: <Widget>[
                              Text(DateFormat('MMMM yyyy').format(element),
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                      fontFamily: "SourceSansProBold")),
                            ]),
                          ),
                        ),
                      ),
                    ),
                    itemBuilder: (context, element) {

                      return Column(
                        children: [
                          ListTile(
                            tileColor: Colors.white,
                            onTap: () {
                              // moveToOrderDetailsPage(element);
                            },
                            // contentPadding: EdgeInsets.only(
                            //     top: 10.0,
                            //     bottom: 10.0,
                            //     left: 15.0,
                            //     right: 10.0),
                            leading: leadingImage(element),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  element.outlet.outletName,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                    fontFamily: "SourceSansProSemiBold",
                                  ),
                                ),
                                Text(
                                    DateFormat('d MMM')
                                        .format(element.getInvoiceDate()),
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        color: greyText,
                                        fontFamily: "SourceSansProRegular")),
                              ],
                            ),

                            subtitle: Row(children: <Widget>[

                              checkPaymentStatus(element),
                              Text(' #'),
                              RichText(
                                text: TextSpan(
                                  children: highlightOccurrences(
                                      element.invoiceNum, _controller.text),
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.black,
                                      fontFamily: "SourceSansProRegular"),
                                ),
                              ),

                              Spacer(),
                              Text(
                                totalAmount(element.totalCharge),
                                style: TextStyle(
                                    color: isExpired(element) ? warningRed : Colors.black,
                                    fontSize: 16.0,
                                    fontFamily: "SourceSansProRegular"),
                              ),
                            ]),
                          ),

                          checkInvoiceStatus(element),
                          Divider(
                            height: 1.5,
                            color: faintGrey,
                          )
                        ],
                      );
                    },
                  ));
            } else {
              if (searchedString !=  null) {

              return Container(

                height: MediaQuery
                    .of(context)
                    .size
                    .height - (height + 150),
                color: faintGrey,

                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Container(
                      child: Image(
                        image: new AssetImage(
                            'assets/images/no_orders_icon.png'),
                        width: 70,
                        height: 70,
                        color: null,
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.center,
                      ),
                    ),
                    // ImageIcon(AssetImage('assets/images/orders_icon.png')),
                    SizedBox(height: 15),
                    Text('No invoices', style: TextStyle(
                        fontSize: 16, fontFamily: 'SourceSansProSemiBold'),),
                  ],
                ),
              );
            } else {
                return Container();
              }

            }
          }
        });
  }

  Widget checkPaymentStatus(Invoices inv) {
    if (inv.paymentStatus == 'Paid') {
      return Text('Paid', style: TextStyle(fontSize: 12, fontFamily: 'SourceSansProRegular', color: lightGreen),);
    } else {
      if (inv.paymentDueDate != null) {
        return Text('Due ' +
            DateFormat('d MMM').format(
                inv.getPaymentDueDate()),
            style: TextStyle(
                color: isExpired(inv) ? warningRed : Colors.black,
                fontSize: 12.0,
                fontFamily:
                "SourceSansProRegular"));
      } else {
        return Text('');
      }
    }
  }

  bool isExpired(Invoices inv) {
    if (inv.paymentStatus == 'Paid') {
      return false;
    }
    if (inv.paymentDueDate != null) {
      final now = DateTime.now();
      final expirationDate = inv.getPaymentDueDate();
      if (expirationDate.isBefore(now)) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Widget checkInvoiceStatus(Invoices inv) {
    if (inv.status == 'Void') {
      return Padding(
        padding: const EdgeInsets.only(top: 3.0, bottom: 10),
        child: Container(
          height: 21,
          child: Row(
            children: [
              Container(
                width: 60,
                child: Center(
                    child: Text(
                      'VOIDED',
                      style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'SourceSansProSemiBold',
                          color: Colors.white),
                    )),
                decoration: BoxDecoration(
                    color: warningRed,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  String totalAmount(TotalCharge value) {
    if (value != null) {
      return value.getDisplayValue();
    } else {
      return '';
    }
  }

  Widget leadingImage(Invoices inv) {
    if (inv.outlet.logoURL != null && inv.outlet.logoURL.isNotEmpty) {
      return Container(
          height: 40.0,
          width: 40.0,
          decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(
                  fit: BoxFit.fill, image: NetworkImage(inv.outlet.logoURL))));
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
            outletPlaceholder(inv.outlet.outletName),
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
}
