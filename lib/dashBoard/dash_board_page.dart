import 'package:flutter/material.dart';

/**
 * Created by RajPrudhviMarella on 11/Feb/2021.
 */

class DashBoardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    TextField(
      controller: TextEditingController()..text = 'Your initial value',
      onChanged: (text) => {},
    );
  }
}
