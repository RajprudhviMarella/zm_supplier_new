import 'package:flutter/material.dart';
import 'package:zm_supplier/models/outletMarketList.dart';

/**
 * Created by RajPrudhviMarella on 04/Mar/2021.
 */

class ReviewOrderPage extends StatefulWidget {
  static const String tag = 'MarketListPage';
  List<OutletMarketList> marketList;

  ReviewOrderPage(this.marketList);

  @override
  State<StatefulWidget> createState() {
    return ReviewOrderDesign();
  }
}

class ReviewOrderDesign extends State<ReviewOrderPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        bottomOpacity: 0.0,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Review order",
          style: new TextStyle(
              color: Colors.black, fontFamily: "SourceSansProSemiBold"),
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.delete_forever_outlined, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
