import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/**
 * Created by RajPrudhviMarella on 09/Mar/2021.
 */

class CustomDialogBox extends StatefulWidget {
  final String title, imageAssets;

  const CustomDialogBox({Key key, this.title, this.imageAssets})
      : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
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

  contentBox(context) {
    Future.delayed(Duration(milliseconds: 3000), () {
      Navigator.of(context).pop(true);
    });
    return Stack(children: <Widget>[
      Center(
          child: Container(
              height: 100,
              width: 160,
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Image(
                        image: AssetImage(widget.imageAssets),
                        height: 40,
                        width: 40),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.title,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontFamily: "SourceSansProSemiBold"),
                    ),
                  ],
                ),
              ))),
    ]);
  }
}
