import 'package:flutter/material.dart';

class OrderDetailsPage extends StatefulWidget {
  String orderId;

  OrderDetailsPage(this.orderId);

  @override
  State<StatefulWidget> createState() {
    return OrderDetailsDesign();
  }
}

class OrderDetailsDesign extends State<OrderDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return new Text(widget.orderId);
  }
}
