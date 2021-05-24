import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zm_supplier/models/products.dart';
import 'package:zm_supplier/utils/color.dart';

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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }
  contentBox(context){
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 20,top: 25, right: 20,bottom: 20
          ),
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black,offset: Offset(0,10),
                    blurRadius: 10
                ),
              ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              displayProductImage(widget.catalogueProducts),
              Text(widget.catalogueProducts.productName,style: TextStyle(
                  fontSize: 18,
                  fontFamily: "SourceSansProBold"),textAlign: TextAlign.left,),
              Text(widget.catalogueProducts.supplierProductCode,style: TextStyle(
                  fontSize: 14,
                  fontFamily: "SourceSansProRegular"),textAlign: TextAlign.left,),
              SizedBox(
                height: 43,
                child: ListView.builder(
                    key: const PageStorageKey<String>(
                        'scrollPosition'),
                    itemCount: widget.catalogueProducts.certifications.length,
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
                                      displayCertImage(widget.catalogueProducts.certifications[subIndex]
                                          .name),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
              Text(widget.catalogueProducts.description,style: TextStyle(fontSize: 16,
                  fontFamily: "SourceSansProRegular"),textAlign: TextAlign.left,),
              SizedBox(height: 22,),

            ],
          ),
        ),
      ],
    );
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
          margin: EdgeInsets.fromLTRB(5, 15, 5, 15),
          child:  Image.network(url)
      );
    } else {
      return Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: faintGrey
        ),
        child: Center(
          child: Image.asset('assets/images/icon_sku_placeholder.png'),
        ),
      );
    }
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