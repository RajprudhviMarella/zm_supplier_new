import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zm_supplier/models/products.dart';
import 'package:zm_supplier/orders/orderDetailsPage.dart';
import 'package:zm_supplier/utils/color.dart';

import '../models/products.dart';
import '../utils/color.dart';
import '../utils/color.dart';
import '../utils/color.dart';
import '../utils/color.dart';
import '../utils/color.dart';

class Productdetails extends StatefulWidget {
  final CatalogueProducts catalogueProducts;

  const Productdetails({Key key, this.catalogueProducts}) : super(key: key);

  @override
  ProductdetailsState createState() => ProductdetailsState();
}

class ProductdetailsState extends State<Productdetails> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      alignment: Alignment.topCenter,
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 20, top: 0, right: 0, bottom: 5),
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10), topLeft: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 3), blurRadius: 10),
              ]),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                displayProductImage(widget.catalogueProducts),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 3),
                      child: Text(
                        widget.catalogueProducts.productName,
                        style: TextStyle(
                            fontSize: 18, fontFamily: "SourceSansProBold"),
                        textAlign: TextAlign.left,
                      ),
                    )),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      widget.catalogueProducts.supplierProductCode,
                      style: TextStyle(
                          fontSize: 14,
                          color: grey_text,
                          fontFamily: "SourceSansProRegular"),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),

                if (widget.catalogueProducts.certifications != null &&
                    widget.catalogueProducts.certifications.isNotEmpty)
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          child: ListView.builder(
                              key: const PageStorageKey<String>(
                                  'scrollPosition'),
                              itemCount: widget
                                  .catalogueProducts.certifications.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder:
                                  (BuildContext context, int subIndex) {
                                return Padding(
                                  padding: EdgeInsets.only(top: 5, bottom: 5),
                                  child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        // color: Colors.red,
                                        child: Row(
                                          //  mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              //  width: 30,
                                              color: Colors.white,
                                              child: displayCertImage(widget
                                                  .catalogueProducts
                                                  .certifications[subIndex]
                                                  .name),
                                            ),
                                          ],
                                        ),
                                      )),
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                // SizedBox(height: 10,),

                showSoldPer(widget.catalogueProducts),
                shelfLife(widget.catalogueProducts),
                region(widget.catalogueProducts),
                condition(widget.catalogueProducts),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.catalogueProducts.description,
                        style: TextStyle(
                            fontSize: 16, fontFamily: "SourceSansProRegular"),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 22,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget region(CatalogueProducts pro) {
    if (pro.countryOfOrigin != null && pro.countryOfOrigin.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Country of origin",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'SourceSansProRegular',
                        color: grey_text),
                  ),
                  if (pro.countryOfOrigin != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Container(
                          child: Text(
                        pro.countryOfOrigin,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'SourceSansProRegular',
                            color: Colors.black),
                      )),
                    )
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                height: 1.5,
                color: faintGrey,
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget showSoldPer(CatalogueProducts products) {
    print('sold by');
    print(products.orderBy);
    List<String> uoms = [];
    if (products.orderBy != null)
      for (OrderBy orderBy in products.orderBy) {
        print(orderBy.unitSize);
        uoms.add(orderBy.unitSize);
      }

    if (uoms != null && uoms.length != 0) {
      print(uoms);
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Sold per",
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'SourceSansProRegular',
                      color: grey_text),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 80.0),
                  child: Container(
                    // margin: EdgeInsets.symmetric(vertical: 1.0),
                    width: 170,
                    //  height: 200,
                    //     child: Flexible(
                    child: Text(
                      uoms.join(", "),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'SourceSansProRegular',
                          color: Colors.black),
                    ),
                    // )
                  ),
                )
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              height: 1.5,
              color: faintGrey,
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget shelfLife(CatalogueProducts pro) {
    if (pro.directorySettings != null &&
        pro.directorySettings.shelfLife != null &&
        pro.directorySettings.shelfLife.duration != null &&
        pro.directorySettings.shelfLife.time != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Shelf life",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'SourceSansProRegular',
                        color: grey_text),
                  ),
                  if (pro.directorySettings != null &&
                      pro.directorySettings.shelfLife.duration != null &&
                      pro.directorySettings.shelfLife.time != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 78.0),
                      child: Container(
                          child: Text(
                        pro.directorySettings.shelfLife.time +
                            " " +
                            pro.directorySettings.shelfLife.duration,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'SourceSansProRegular',
                            color: Colors.black),
                      )),
                    )
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                height: 1.5,
                color: faintGrey,
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget condition(CatalogueProducts pro) {
    if (pro.directorySettings != null &&
        pro.directorySettings.condition != null &&
        pro.directorySettings.condition.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Condition",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'SourceSansProRegular',
                        color: grey_text),
                  ),
                  if (pro.directorySettings != null &&
                      pro.directorySettings.condition != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 70.0),
                      child: Container(
                          child: Text(
                        pro.directorySettings.condition,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'SourceSansProRegular',
                            color: Colors.black),
                      )),
                    )
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                height: 1.5,
                color: faintGrey,
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget displayProductImage(CatalogueProducts products) {
    if (products != null &&
        products.images != null &&
        products.images.isNotEmpty &&
        products.images[0].imageUrl != null &&
        products.images[0].imageFileNames != null &&
        products.images[0].imageFileNames.isNotEmpty) {
      var url =
          products.images[0].imageUrl + products.images[0].imageFileNames[0];
      return Container(
          height: 375,
          width: 375,
          margin: EdgeInsets.fromLTRB(5, 15, 15, 5),
          child: Image.network(
            url,
            fit: BoxFit.fill,
          ));
    } else {
      return Container(
          // height: 375,
          // width: 375,
          // margin: EdgeInsets.fromLTRB(5, 15, 5, 15),
          // decoration: BoxDecoration(
          //     borderRadius: BorderRadius.all(Radius.circular(5.0)),
          //     color: faintGrey),
          // child: Center(
          //   child: Image.asset('assets/images/icon_sku_placeholder.png'),
          // ),
          );
    }
  }

  Widget displayCertImage(String certName) {
    var assetName = 'assets/images/cert_vegan.png';
    Color color = Colors.blue;
    Color textColor = Colors.black;

    if (certName == 'Halal') {
      assetName = 'assets/images/cert_halal.png';
      color = litGreen;
      textColor = thickGreen;
    }
    if (certName == 'Vegetarian') {
      assetName = 'assets/images/cert_vegetarian.png';
      color = litGreen;
      textColor = thickGreen;
    }
    if (certName == 'Organic') {
      assetName = 'assets/images/cert_organic.png';
      color = litGreen;
      textColor = thickGreen;
    }
    if (certName == 'Vegan') {
      assetName = 'assets/images/cert_vegan.png';
      color = litGreen;
      textColor = thickGreen;
    }
    if (certName == 'Gluten-free') {
      assetName = 'assets/images/cert_gluten.png';
      color = sandal;
      textColor = orange_thick;
    }
    if (certName == 'Kosher') {
      assetName = 'assets/images/cert_halal.png';
      color = sandal;
      textColor = orange_thick;
    }
    if (certName == 'FDA') {
      assetName = 'assets/images/cert_fda.png';
      color = Colors.blue;
      textColor = Colors.white;
    }
    if (certName == 'Fairtrade') {
      assetName = 'assets/images/cert_fairtrade.png';
      color = sandal;
      textColor = orange_thick;
    }
    if (certName == 'GMP') {
      assetName = 'assets/images/cert_gmp.png';
      color = Colors.blue;
      textColor = Colors.white;
    }
    if (certName == 'HAACP') {
      assetName = 'assets/images/cert_haacp.png';
      color = Colors.blue;
      textColor = Colors.white;
    }

    return Padding(
      padding: const EdgeInsets.only(right: 5.0, top: 5, bottom: 5),
      child: Container(
        height: 32,
        // width: 23,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: color.withOpacity(1),
        ),
        child: Row(children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Image.asset(
              assetName,
              width: 20,
              height: 20,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              certName,
              style: TextStyle(
                  fontFamily: 'SourceSansProSemiBold',
                  fontSize: 14,
                  color: textColor),
            ),
          ),
        ]),
      ),
    );
  }
}
