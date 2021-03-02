import 'package:flutter/material.dart';
import 'package:zm_supplier/models/outletResponse.dart';

/**
 * Created by RajPrudhviMarella on 02/Mar/2021.
 */

class MarketListPage extends StatefulWidget {
  static const String tag = 'MarketListPage';
  Outlet outletList;

  MarketListPage(this.outletList);

  @override
  State<StatefulWidget> createState() {
    return MarketListDesign();
  }
}

class MarketListDesign extends State<MarketListPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Text(widget.outletList.outletName),
    );
  }
}
