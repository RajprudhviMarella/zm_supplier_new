import 'dart:ui';
import 'dart:io';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zm_supplier/catalogue/catalogue.dart';
import 'package:zm_supplier/models/user.dart';
import 'package:zm_supplier/services/authenticationApi.dart';
import 'package:zm_supplier/utils/color.dart';
import 'package:zm_supplier/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:zm_supplier/login/change_password.dart';
import 'package:zm_supplier/models/imageUploadResponse.dart';
import 'package:zm_supplier/utils/eventsList.dart';
import '../login/login_page.dart';
import '../models/response.dart';
import 'package:zm_supplier/utils/webview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http_parser/http_parser.dart';
import 'package:zm_supplier/utils/urlEndPoints.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../utils/color.dart';

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
  String _email = "";
  String _userID = "";
  String _versioncode = "";
  String _image_Url = "";
  String supplierID = "";
  String market = "";
  String supplierName = "";
  String mudra;
  NetworkImage _networkImage;
  bool _isShowLoader = false;
  String token = '';
  Constants events = Constants();

  @override
  void initState() {
    super.initState();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      token = value;
    });

    loadSharedPrefs();
    events.mixPanelEvents();
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
        appBar: new AppBar(
          toolbarHeight: 60,
          centerTitle: false,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(top: 1.0),
            child: Row(
              children: [
                Text(
                  Constants.txt_account,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "SourceSansProBold",
                      fontSize: 30),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          backgroundColor: faintGrey,
          elevation: 0,
        ),
        backgroundColor: faintGrey,
        body: ModalProgressHUD(
          inAsyncCall: _isShowLoader,
          child: ListView(
            children: <Widget>[
              profileView(context),
              menuItem(
                  context,
                  Constants.txt_change_password,
                  ImageIcon(AssetImage('assets/images/icon_lock.png'),
                      color: grey_text),
                  1.0,
                  Colors.black),
              Headers(context, supplierName, 18.0),
              menuItem(
                  context,
                  Constants.txt_catalogue,
                  ImageIcon(AssetImage('assets/images/icon_view_cataloge.png'),
                      color: grey_text),
                  1.0,
                  Colors.black),
              Headers(context, Constants.txt_support, 18.0),
              menuItem(
                  context,
                  Constants.txt_help,
                  ImageIcon(AssetImage('assets/images/icon_help.png'),
                      color: grey_text),
                  1.0,
                  Colors.black),
              menuItem(
                  context,
                  Constants.txt_ask_zeemart,
                  ImageIcon(AssetImage('assets/images/icon_chat.png'),
                      color: grey_text),
                  1.0,
                  Colors.black),
              menuItem(
                  context,
                  Constants.txt_send_feed_back,
                  ImageIcon(AssetImage('assets/images/icon_feedback.png'),
                      color: grey_text),
                  1.0,
                  Colors.black),
              menuItem(
                  context,
                  Constants.txt_terms_of_use,
                  ImageIcon(AssetImage('assets/images/icon_terms.png'),
                      color: grey_text),
                  20.0,
                  Colors.black),
              menuItem(
                  context,
                  Constants.txt_privacy_policy,
                  ImageIcon(AssetImage('assets/images/icon_privacy.png'),
                      color: grey_text),
                  1.0,
                  Colors.black),
              menuItem(
                  context,
                  Constants.txt_log_out,
                  ImageIcon(AssetImage('assets/images/icon_signout.png'),
                      color: Colors.pinkAccent),
                  20.0,
                  Colors.pinkAccent),
              Container(
                color: faintGrey,
                margin: EdgeInsets.only(top: 2.0),
                padding: EdgeInsets.fromLTRB(18, 15, 20, 15),
                child: Text("Version " + _versioncode,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: grey_text,
                      fontFamily: "SourceSansProRegular",
                      fontSize: 14.0,
                    )),
              ),
            ],
          ),
        ));
  }

  Widget profileView(context) {
    return Container(
        color: Colors.white,
        child: Center(
            child: ListTile(
                focusColor: Colors.white,
                contentPadding: EdgeInsets.only(
                    left: 18.0, right: 15.0, top: 5.0, bottom: 5.0),
                title: Text(_userID,
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                        fontFamily: 'SourceSansProBold')),
                subtitle: Text(_email,
                    style: TextStyle(
                        fontSize: 14.0,
                        color: greyText,
                        fontFamily: 'SourceSansProRegular')),
                trailing: GestureDetector(
                  child: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: (_networkImage != null)
                                  ? _networkImage
                                  : new NetworkImage(_image_Url)))),
                  onTap: () {
                    sendEvent(Events.TAP_SETTINGS_TAB_PROFILE_PIC);
                    showImagePickerAlert(context);
                  },
                ))));
  }

  Widget Headers(context, String name, double size) {
    return Container(
      color: faintGrey,
      margin: EdgeInsets.only(top: 2.0),
      padding: EdgeInsets.fromLTRB(18, 10, 20, 10),
      child: Text(name,
          style: TextStyle(
            fontFamily: "SourceSansProBold",
            fontSize: size,
          )),
    );
  }

  Widget menuItem(
      context, String name, ImageIcon icon, double margin, Color color) {
    return InkWell(
      onTap: () => onItemSelect(name, context),
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: margin),
        padding: EdgeInsets.all(18.0),
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
                padding: EdgeInsets.only(left: 5.0),
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
      sendEvent(Events.TAP_SETTINGS_TAB_CHANGE_PASSWORD);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ChangePassword()));
    } else if (name == Constants.txt_catalogue) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Catalogue()));
    } else if (name == Constants.txt_help) {
      Intercom.displayHelpCenter();
      sendEvent(Events.TAP_SETTINGS_TAB_HELP);
    } else if (name == Constants.txt_ask_zeemart) {
      Intercom.displayMessenger();
      sendEvent(Events.TAP_SETTINGS_TAB_ASK_ZEEMART);
    } else if (name == Constants.txt_send_feed_back) {
      sendEvent(Events.TAP_SETTINGS_TAB_SEND_FEEDBACK);
      _launchMailClient();
    } else if (name == Constants.txt_terms_of_use) {
      sendEvent(Events.TAP_SETTINGS_TAB_TERMS_OF_USE);
      _handleURLButtonPress(
          context, Constants.termsUrl, Constants.txt_terms_of_use);
    } else if (name == Constants.txt_privacy_policy) {
      sendEvent(Events.TAP_SETTINGS_TAB_PRIVACY_POLICY);
      _handleURLButtonPress(
          context, Constants.privacyUrl, Constants.txt_privacy_policy);
    } else if (name == Constants.txt_log_out) {
      sendEvent(Events.TAP_SETTINGS_TAB_SIGN_OUT);
      showAlert(context);
    }
  }

  sendEvent(String eventName) {
    events.mixpanel.track(eventName);
    events.mixpanel.flush();
  }

  void _handleURLButtonPress(BuildContext context, String url, String title) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebViewContainer(url, title, false)));
  }

  void _launchMailClient() async {
    const mailUrl = 'mailto:help@zeemart.asia';
    try {
      await launch(mailUrl);
    } catch (e) {}
  }

  void unregisterToken() {
    TokenAuthentication tokenAuthentication = new TokenAuthentication();
    tokenAuthentication
        .unregisterToken(supplierID, mudra, token, market)
        .then((value) async {});
  }

  void showAlert(context) {
    BuildContext dialogContext;
    // set up the button
    Widget okButton = FlatButton(
      child: Text(Constants.txt_ok),
      onPressed: () async {
        sendEvent(Events.TAP_SETTINGS_TAB_SIGN_OUT_CONFIRM);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs?.clear();
        unregisterToken();
        Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(builder: (context) => new LoginPage()),
            (route) => false);
      },
    );
    // set up the button
    Widget btnCancel = FlatButton(
      child: Text(Constants.txt_cancel),
      onPressed: () {
        sendEvent(Events.TAP_SETTINGS_TAB_SIGN_OUT_CANCEL);
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
      String _userEmail = await sharedPref.readData(Constants.USER_EMAIL);
      String _userName = await sharedPref.readData(Constants.USER_NAME);
      String _userImageUrl =
          await sharedPref.readData(Constants.USER_IMAGE_URL);
      setState(() {
        PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
          _versioncode = packageInfo.version;
        });
        if (_userImageUrl != null && _userImageUrl.isNotEmpty) {
          _image_Url = _userImageUrl;
          _networkImage = NetworkImage(_userImageUrl);
          print("logo url: " + _userImageUrl);
        }
        if (_userName != null && _userName.isNotEmpty) {
          _userID = _userName;
        }
        if (_userEmail != null && _userEmail.isNotEmpty) {
          _email = _userEmail;
        }
        if (loginResponse.mudra != null) {
          mudra = loginResponse.mudra;
        }
        if (user.data.supplier[0].supplierId != null) {
          supplierID = user.data.supplier[0].supplierId;
        }
        if (loginResponse.market != null) {
          market = loginResponse.market;
        }
        if (user.data.supplier[0].supplierName != null) {
          supplierName = user.data.supplier[0].supplierName;
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
    } else {
      _hideLoader();
    }
  }

  void UpdateImageView(String fileUrl) {
    setState(() {
      _networkImage = new NetworkImage(fileUrl);
      sharedPref.saveData(Constants.USER_IMAGE_URL, fileUrl);
      _hideLoader();
    });
  }
}
