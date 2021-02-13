import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:image_picker/image_picker.dart';
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
  PickedFile _image;
  final ImagePicker _picker = ImagePicker();

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
          GestureDetector(
            child: Container(
                width: 50.0,
                height: 50.0,
                margin: EdgeInsets.only(left: 100.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(
                            'assets/images/icon_place_holder.png')))),
            onTap: () {
              showImagePickerAlert(context);
            },
          )
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
      showAlert(context);
    }
  }

  void showAlert(context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(Constants.txt_ok),
      onPressed: () {},
    );
    // set up the button
    Widget btnCancel = FlatButton(
      child: Text(Constants.txt_cancel),
      onPressed: () {},
    );

    // set up the AlertDialog
    BasicDialogAlert alert = BasicDialogAlert(
      title: Text(Constants.txt_log_out),
      content: Text(Constants.txt_confirm_logout),
      actions: [okButton, btnCancel],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showImagePickerAlert(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text(Constants.txt_select_library),
                      onTap: () {
                        _imgFromGallery();

                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text(Constants.txt_take_photo),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgFromCamera() async {
    final PickedFile file = await _picker.getImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    setState(() {
      _image = file;
    });
  }

  _imgFromGallery() async {
    final PickedFile file = await _picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    // File image = await ImagePicker.pickImage(
    //     source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = file;
    });
  }
}
