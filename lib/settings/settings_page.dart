import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:zm_supplier/utils/color.dart';
import 'package:zm_supplier/utils/constants.dart';

/**
 * Created by RajPrudhviMarella on 11/Feb/2021.
 */

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingsDesign();
  }
}

class SettingsDesign extends State<SettingsPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: faintGrey,
      body: ListView(
        children: <Widget>[
          Headers(context, Constants.txt_account, 30.0),
          profileView(context),
          menuItem(
              context,
              Constants.txt_change_password,
              Icon(Icons.lock_outline_rounded, color: Colors.grey),
              1.0,
              Colors.black),
          Headers(context, Constants.txt_support, 18.0),
          menuItem(
              context,
              Constants.txt_help,
              Icon(Icons.help_outline_rounded, color: Colors.grey),
              1.0,
              Colors.black),
          menuItem(
              context,
              Constants.txt_ask_zeemart,
              Icon(Icons.message_outlined, color: Colors.grey),
              1.0,
              Colors.black),
          menuItem(
              context,
              Constants.txt_send_feed_back,
              Icon(Icons.thumb_up_alt_outlined, color: Colors.grey),
              1.0,
              Colors.black),
          menuItem(
              context,
              Constants.txt_terms_of_use,
              Icon(Icons.contact_page_outlined, color: Colors.grey),
              20.0,
              Colors.black),
          menuItem(
              context,
              Constants.txt_privacy_policy,
              Icon(Icons.privacy_tip_outlined, color: Colors.grey),
              1.0,
              Colors.black),
          menuItem(
              context,
              Constants.txt_log_out,
              Icon(Icons.lock_outline_rounded, color: Colors.pinkAccent),
              20.0,
              Colors.pinkAccent),
        ],
      ),
    );
  }

  Widget profileView(context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: 100.0,
      padding: EdgeInsets.all(20.0),
      child: Row(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(left: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("RajPrudhvi Marella",
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                          fontFamily: 'SourceSansProSemiBold')),
                  Text("marella@zeemart.asia",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: greyText,
                        // fontFamily: 'AvenirMedium'
                      ))
                ],
              )),
          // Container(
          //     width: 50.0,
          //     height: 50.0,
          //     decoration: BoxDecoration(
          //         shape: BoxShape.circle,
          //         image: DecorationImage(
          //             fit: BoxFit.fill,
          //             image:
          //                 AssetImage('assets/images/icon_place_holder.png')))),
        ],
      ),
    );
  }

  Widget Headers(context, String name, double size) {
    return Container(
      color: faintGrey,
      margin: EdgeInsets.only(top: 2.0),
      padding: EdgeInsets.all(20.0),
      child: Text(name,
          style: TextStyle(
            fontFamily: "SourceSansProBold",
            fontSize: size,
          )),
    );
  }

  Widget menuItem(context, String name, Icon icon, double margin, Color color) {
    return InkWell(
      onTap: () => onItemSelect(name, context),
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: margin),
        padding: EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 22,
              width: 22,
              child: icon,
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(name,
                    style: TextStyle(
                      color: color,
                      fontFamily: "SourceSansProRegular",
                      fontSize: 16,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  onItemSelect(String name, context) {
    if (name == Constants.txt_change_password) {

    } else if (name == Constants.txt_help) {

    } else if (name == Constants.txt_ask_zeemart) {

    } else if (name == Constants.txt_send_feed_back) {

    } else if (name == Constants.txt_terms_of_use) {

    } else if (name == Constants.txt_privacy_policy) {

    } else if (name == Constants.txt_log_out) {

    }
  }
}
