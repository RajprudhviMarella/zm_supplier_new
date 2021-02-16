import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zm_supplier/models/user.dart';
import 'package:zm_supplier/utils/color.dart';
import 'package:zm_supplier/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:zm_supplier/login/change_password.dart';
import 'package:zm_supplier/models/response.dart';

import '../login/login_page.dart';
import '../models/response.dart';

/**
 * Created by RajPrudhviMarella on 11/Feb/2021.
 */

class SettingsPage extends StatefulWidget {
  static const String tag = 'settings_page';

  @override
  State<StatefulWidget> createState() {
    return SettingsDesign();
  }
}

class SettingsDesign extends State<SettingsPage> with TickerProviderStateMixin {
  PickedFile _image;
  String _email;
  String _userID;
  String _image_Url;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadSharedPrefs();
  }

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
                  Text(_userID,
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                          fontFamily: 'SourceSansProSemiBold')),
                  Text(_email,
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
                        fit: BoxFit.fill, image: NetworkImage(_image_Url)))),
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
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ChangePassword()));
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
    BuildContext dialogContext;
    // set up the button
    Widget okButton = FlatButton(
      child: Text(Constants.txt_ok),
      onPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs?.clear();

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LoginPage(), fullscreenDialog: true));
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (dialogContext) {
        //     return LoginPage();
        //   }),
        // );
        Navigator.of(dialogContext).pop();
      },
    );
    // set up the button
    Widget btnCancel = FlatButton(
      child: Text(Constants.txt_cancel),
      onPressed: () {
        Navigator.pop(dialogContext);
      },
    );

    // set up the AlertDialog
    BasicDialogAlert alert = BasicDialogAlert(
      title: Text(Constants.txt_log_out),
      content: Text(Constants.txt_confirm_logout),
      actions: [btnCancel, okButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        dialogContext = context;
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
      // uploadImage();
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
      // uploadImage();
    });
  }

  SharedPref sharedPref = SharedPref();

  loadSharedPrefs() async {
    try {
      ApiResponse user = ApiResponse.fromJson(
          await sharedPref.readData(Constants.specific_user_info));
      setState(() {
        if (user.data.email != null) {
          _email = user.data.email;
        }
        if (user.data.supplierName != null) {
          _userID = user.data.supplierName;
        }
        if (user.data.logoUrl != null) {
          _image_Url = user.data.logoUrl;
        }
      });
    } catch (Excepetion) {
      // do something

    }
  }
// void uploadImage() async {
//   // open a byteStream
//   var stream = new http.ByteStream(DelegatingStream.typed(_image.openRead()));
//   // get file length
//   var length = await _image.length();
//
//   // string to uri
//   var uri = Uri.parse("enter here upload URL");
//
//   // create multipart request
//   var request = new http.MultipartRequest("POST", uri);
//
//   // if you need more parameters to parse, add those like this. i added "user_id". here this "user_id" is a key of the API request
//   request.fields["user_id"] = "text";
//
//   // multipart that takes file.. here this "image_file" is a key of the API request
//   var multipartFile = new http.MultipartFile(
//       'image_file', stream, length, filename: basename(_image.path));
//
//   // add file to multipart
//   request.files.add(multipartFile);
//
//   // send request to upload image
//   await request.send().then((response) async {
//     // listen for response
//     response.stream.transform(utf8.decoder).listen((value) {
//       print(value);
//     });
//   }).catchError((e) {
//     print(e);
//   });
// }
}
