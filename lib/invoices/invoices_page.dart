import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:zm_supplier/invoices/invoice_details_page.dart';
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
import 'invoices_search_page.dart';

class InvoicesPage extends StatefulWidget {
  final outletId;
  final outletName;

  InvoicesPage(this.outletId, this.outletName);

  @override
  State<StatefulWidget> createState() =>
      new InvoicesState(this.outletId, this.outletName);
}

class InvoicesState extends State<InvoicesPage> {
  final outletId;
  final outletName;

  InvoicesState(this.outletId, this.outletName);

  var includeFields = [
    'invoiceDate',
    'supplier',
    'status',
    'invoiceNum',
    'outlet',
    'invoiceId',
    'paymentDueDate',
    'totalCharge'
  ];
  bool isFilterApplied = false;
  List<String> selectedFilters = [];

  final globalKey = new GlobalKey<ScaffoldState>();
  InvoicesResponse invoicesResponse;
  List<Invoices> invoices;
  Future<List<Invoices>> invoicesFuture;

  SharedPref sharedPref = SharedPref();

  @override
  void initState() {
    super.initState();

    invoicesFuture = retriveInvoices();
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
      'includeFields': includeFields.join(','),
      if (selectedFilters != null) 'dueStatus': selectedFilters.join(',')
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: globalKey,
      backgroundColor: faintGrey,
      appBar: buildAppBar(context),
      floatingActionButton: Stack(
        children: [
          Container(
            width: 130,
            child: new FloatingActionButton.extended(
              backgroundColor: buttonBlue,
              foregroundColor: Colors.white,
              onPressed: () async {
                print(selectedFilters);
                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            new InvoicesFilterPage(selectedFilters)));


                selectedFilters = result;
                // isFilterApplied = true;
                invoicesFuture = retriveInvoices();
                setState(() {});
              },
              icon: ImageIcon(AssetImage('assets/images/filter_white.png'),
                  size: 22),
              elevation: 0,
              label: Text(
                'Filter',
                style: TextStyle(
                    fontSize: 16, fontFamily: 'SourceSansProSemiBold'),
              ),
            ),
          ),
          filterCount(),
        ],
      ),
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[buildSearchBar(context), invoicesList()],
      ),
    );
  }

  Widget filterCount() {
    if (selectedFilters.length > 0) {
      return Padding(
        padding: const EdgeInsets.only(left: 105.0, top: 15),
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
              color: warningRed,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Center(
            child: Text(
              selectedFilters.length.toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'SourceSansProSemiBold'),
            ),
          ),
        ),
      );
    } else {
      return Container(
        width: 0,
        height: 0,
      );
    }
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Column(children: [
        Text(
          'Invoices',
          style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'SourceSansProBold'),
        ),
        Text(outletName,
            style: TextStyle(
                color: greyText,
                fontSize: 12,
                fontFamily: 'SourceSansProRegular')),
      ]),
      bottomOpacity: 0.0,
      elevation: 0.0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
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
                            new InvoicesSearchPage(outletId, outletName)));

                print(result);
                //  setState(() {

                // });
              },
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: new Icon(Icons.search, color: Colors.grey),
                  hintText: 'Search invoice number',
                  hintStyle: new TextStyle(color: greyText)),
              // onChanged: searchOperation,
            ),
          ),
        ));
  }

  Widget invoicesList() {
    final height = AppBar().preferredSize.height;

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
                  height: MediaQuery.of(context).size.height - (height + 120),
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
                               moveToInvoiceDetailsPage(element);
                            },
                            // contentPadding: EdgeInsets.only(
                            //     top: 10.0,
                            //     bottom: 10.0,
                            //     left: 15.0,
                            //     right: 10.0),
                            leading: leadingImage(element.outlet.outletName),
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

                            subtitle: Column(
                              children: [
                                Row(children: <Widget>[
                                  checkPaymentStatus(element),

                                  Text(
                                    " " + '#${element.invoiceNum}',
                                    style: TextStyle(
                                        color: greyText,
                                        fontSize: 12.0,
                                        fontFamily: "SourceSansProRegular"),
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

                                checkInvoiceStatus(element),
                                //Container(height: 20, color: Colors.yellow,)
                              ],
                            ),

                          ),

                          Divider(
                            height: 1.5,
                            color: faintGrey,
                          )
                        ],
                      );
                    },
                  ));
            } else {
              return Container(

                height: MediaQuery.of(context).size.height - (height+150),
                color: faintGrey,

                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Container(
                          child: Image(
                            image: new AssetImage('assets/images/no_orders_icon.png'),
                            width: 70,
                            height: 70,
                            color: null,
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.center,
                          ),
                        ),
                       // ImageIcon(AssetImage('assets/images/orders_icon.png')),
                        SizedBox(height: 15),
                        Text('No invoices', style: TextStyle(fontSize: 16, fontFamily: 'SourceSansProSemiBold'),),
                      ],
                    ),
              );
            }
          }
        });
  }

  Widget moveToInvoiceDetailsPage(Invoices inv) {

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
            new InvoiceDetailsPage(inv)));
  }

  Widget checkPaymentStatus(Invoices inv) {
    if (inv.status == 'Paid') {
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

  Widget leadingImage(String name) {
    return Container(
      height: 38,
      width: 38,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: Colors.blue.withOpacity(0.5),
      ),
      child: Center(
        child: Text(
          outletPlaceholder(name),
          style: TextStyle(fontSize: 14, fontFamily: "SourceSansProSemiBold"),
        ),
      ),
    );
  }

  String outletPlaceholder(String name) {
    Constants value = Constants();
    var placeholder = value.getInitialWords(name);
    return placeholder;
  }
}
