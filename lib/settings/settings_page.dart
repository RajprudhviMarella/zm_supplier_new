import 'dart:ui';
import 'dart:io';
import 'dart:convert';
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
import 'package:zm_supplier/models/imageUploadResponse.dart';
import '../login/login_page.dart';
import '../models/response.dart';
import 'package:zm_supplier/utils/webview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http_parser/http_parser.dart';
import 'package:zm_supplier/utils/urlEndPoints.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

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
  File _image;
  String _email;
  String _userID;
  String _image_Url;
  String supplierID;
  String mudra;
  NetworkImage _networkImage;
  bool _isShowLoader = false;

  @override
  void initState() {
    super.initState();
    loadSharedPrefs();
  }

  void _showLoader() {
    setState(() {
      _isShowLoader = true;
    });
  }

  void _hideLoader() {
    setState(() {
      _isShowLoader = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: faintGrey,
        body: ModalProgressHUD(
          inAsyncCall: _isShowLoader,
          child: ListView(
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
        ));
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
                        fit: BoxFit.fill, image: _networkImage))),
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
      _launchMailClient();
    } else if (name == Constants.txt_terms_of_use) {
      _handleURLButtonPress(
          context, Constants.termsUrl, Constants.txt_terms_of_use);
    } else if (name == Constants.txt_privacy_policy) {
      _handleURLButtonPress(
          context, Constants.privacyUrl, Constants.txt_privacy_policy);
    } else if (name == Constants.txt_log_out) {
      showAlert(context);
    }
  }

  void _handleURLButtonPress(BuildContext context, String url, String title) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url, title)));
  }

  void _launchMailClient() async {
    const mailUrl = 'mailto:help@zeemart.asia';
    try {
      await launch(mailUrl);
    } catch (e) {}
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
    final File file = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = file;
      uploadImage();
    });
  }

  _imgFromGallery() async {
    final File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = file;
      uploadImage();
    });
  }

  SharedPref sharedPref = SharedPref();

  loadSharedPrefs() async {
    try {
      ApiResponse user = ApiResponse.fromJson(
          await sharedPref.readData(Constants.specific_user_info));
      LoginResponse loginResponse = LoginResponse.fromJson(
          await sharedPref.readData(Constants.login_Info));
      setState(() {
        if (user.data.email != null) {
          _email = user.data.email;
        }
        if (user.data.supplierName != null) {
          _userID = user.data.supplierName;
        }
        if (user.data.logoUrl != null) {
          _image_Url = user.data.logoUrl;
          _networkImage = NetworkImage(user.data.logoUrl);
          print("logo url: " + user.data.logoUrl);
        }
        if (loginResponse.mudra != null) {
          mudra = loginResponse.mudra;
        }
        if (user.data.supplierId != null) {
          supplierID = user.data.supplierId;
        }
      });
    } catch (Excepetion) {
      // do something

    }
  }

  void uploadImage() async {
    _showLoader();
    var uri = Uri.parse(URLEndPoints.img_upload_url);
    var imageModel = new ImageUploadResponse();
    http.MultipartRequest request = http.MultipartRequest('POST', uri);
    Map<String, String> headers = {
      "authType": "Zeemart",
      "Content-type": "multipart/form-data",
      "supplierId": supplierID,
      "mudra": mudra
    };
    request.headers.addAll(headers);
    request.fields.addAll({"componentType": "PROFILE"});

    request.files.add(await http.MultipartFile(
      'multipartFiles',
      _image.readAsBytes().asStream(),
      _image.lengthSync(),
      filename: basename(_image.path),
      contentType: MediaType('image', 'jpeg'),
    ));
    print("request: " + request.toString());
    // var imgUploadResponse = await request.send();
    http.Response imgUploadResponse =
        await http.Response.fromStream(await request.send());
    print("response" + imgUploadResponse.statusCode.toString());
    imageModel =
        ImageUploadResponse.fromJson(json.decode(imgUploadResponse.body));
    String fileUrl = imageModel.data.lstFiles.elementAt(0).fileUrl;
    if (fileUrl.isNotEmpty) {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'authType': 'Zeemart',
        'mudra': mudra,
        'supplierId': supplierID
      };
      Map<String, String> queryParams = {'supplierId': supplierID};
      String queryString = Uri(queryParameters: queryParams).query;
      var requestUrl = URLEndPoints.get_specific_user_url + '?' + queryString;
      final msg = jsonEncode({'logoURL': fileUrl, 'supplierId': supplierID});
      var response = await http.put(requestUrl, headers: headers, body: msg);
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        UpdateImageView(fileUrl);
      } else {
        _hideLoader();
      }
    }
  }

  void UpdateImageView(String fileUrl) {
    setState(() {
      _networkImage = new NetworkImage(fileUrl);
      _hideLoader();
    });
  }
}
