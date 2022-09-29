import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zm_supplier/home/home_page.dart';
import 'package:zm_supplier/models/user.dart';
import 'package:zm_supplier/utils/constants.dart';
import 'package:zm_supplier/models/response.dart';
import 'package:zm_supplier/login/forgot_password.dart';
import 'package:zm_supplier/utils/eventsList.dart';

import '../utils/color.dart';
import '../utils/color.dart';
import '../utils/color.dart';
import '../utils/color.dart';
import 'package:zm_supplier/services/authenticationApi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  bool isLogged = false;
  FirebaseMessaging messaging;

  bool isApiCallingProcess = false;
  String _email, _password;

  GlobalKey<FormState> formKeyEmail = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyPassword = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool isEmailFilled = false;
  bool isPasswordFilled = false;

  bool _isShowLoader = false;

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

  String firebaseToken = '';

//Initialize a button color variable
  Color btnColor = lightGreen.withOpacity(0.5);

  SharedPref sharedPref = SharedPref();

  Constants events = Constants();

  @override
  void initState() {
    super.initState();
    messaging = FirebaseMessaging.instance;
    messaging.requestPermission();
    messaging.getToken().then((value) {
      firebaseToken = value;
      print("token===>" + value);
    });
    Future<void> _messageHandler(RemoteMessage message) async {
      print('background message ${message.notification.body}');
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification.body);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
    events.mixPanelEvents();
  }

  setUserProfilesToMixPanel(String userId, String name, String email) {
    events.mixpanel.track("create_alias", properties: {
      "distinct_id": userId,
      "alias": "12345",
      "token": Constants.MIXPANEL_EVENTS_TOKEN
    });
    events.mixpanel.identify(userId);
    events.mixpanel.getPeople().set('name', name);
    events.mixpanel.getPeople().set("email", email);
  }

  static Future<List<String>> getDeviceDetails() async {
    String deviceName;
    String deviceVersion;
    String identifier;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion = build.version.toString();
        identifier = build.androidId; //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor; //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }

//if (!mounted) return;
    return [deviceName, deviceVersion, identifier];
  }

  @override
  Widget build(BuildContext context) {
    void _toggle() {
      setState(() {
        _obscureText = !_obscureText;
      });
    }

    getUserDetails() async {
      LoginResponse user = LoginResponse.fromJson(
          await sharedPref.readData(Constants.login_Info));
      setState(() {
        TokenAuthentication tokenAuthentication = new TokenAuthentication();

        tokenAuthentication
            .authenticateToken(user.supplier.first.supplierId, user.mudra,
                user.user.userId, firebaseToken, user.market)
            .then((value) async {
          print('token response' + value.toString());
        });

        getSpecificUser specificUser = new getSpecificUser();

        specificUser
            .retriveSpecificUser(
                user.supplier.first.supplierId, user.mudra, user.user.userId)
            .then((value) async {
          sharedPref.saveData(Constants.specific_user_info, value);
          sharedPref.saveData(Constants.USER_NAME, value.data.fullName);
          sharedPref.saveData(Constants.USER_EMAIL, value.data.email);
          sharedPref.saveData(Constants.USER_IMAGE_URL, value.data.imageURL);
          sharedPref.saveData(Constants.USER_GOAL, value.data.goal);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          isLogged = true;
          prefs.setBool(Constants.is_logged, isLogged);

          // set distinct id as userName
          //  events.mixpanel.track("create_alias",
          //      properties: {
          //       // "distinct_id": value.data.fullName,
          //        "alias": "12345",
          //        "name": value.data.fullName,
          //       "token": "727ea70267ae81d186a7365cc2befcf4"
          //      }
          //  );
          // events.mixpanel.
          // events.mixpanel.identify("4D011EE5-BE1B-4BE9-995A-88C5F6AEE044");
          // events.mixpanel.getPeople().set('name', value.data.fullName,);

          // events.mixpanel.registerSuperPropertiesOnce({'name': value.data.fullName, "email": value.data.email});
          //  events.mixpanel.registerSuperProperties({'Name': value.data.fullName, 'Email': value.data.email});

          setUserProfilesToMixPanel(
              user.user.userId, value.data.fullName, value.data.email);

          events.mixpanel
              .track(Events.TAP_LOGIN, properties: {'email': _email});
          SharedPref.registerIntercomUser();
          SharedPref.updateIntercomUser();
          _hideLoader();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => new HomePage()),
              (Route<dynamic> route) => false);
        });
      });
    }

    void loginApiCalling() {
      _showLoader();
      Authentication login = new Authentication();

      login.authenticate(_email, _password).then((value) async {
        print('login api calling done');

        if (value == null) {
          print('null');
          showAlert(context);
        }

        if (value.status == Constants.status_success) {
          //save login data
          sharedPref.saveData(Constants.login_Info, value);
          sharedPref.saveData(Constants.PASSWORD_ENCRYPTED, _password);
          sharedPref.saveData(Constants.USER_MARKET, value.market);
          getUserDetails();
        } else {
          _hideLoader();
          showAlert(context);
        }
      });
    }

    void validator() {
      if (_email.isValidEmail() && _password.length > 3) {
        print('validated');
        loginApiCalling();
      } else {
        showAlert(context);
        print('not validated');
      }
    }

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(children: [
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/login_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              //   mainAxisSize: MainAxisSize.min,
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: width,
                  height: height > 667 ? height * 0.55 : height * 0.5,
                  // child: Container(child: Image.asset('assets/img_welcome_salmon.png', fit: BoxFit.fill,)),

                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(40, 80, 40, 10),
                          child: Image.asset(
                            'assets/images/visual.png',
                            fit: BoxFit.fill,
                            // height: height,//double.infinity,
                            // width: width,//double.infinity,
                          ),
                        ),
                      ),

                      // FadeInImage(
                      //   placeholder: AssetImage("assets/images/blackdot.png"),
                      //   image:
                      //       AssetImage("assets/images/img_welcome_salmon.png"),
                      //   fit: BoxFit.fill,
                      //   height: double.infinity,
                      //   width: double.infinity,
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 40),
                        child: Image.asset(
                          'assets/images/zm_logo.png',
                          width: 28,
                          height: 28,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 57, top: 45),
                        child: Text(
                          "Supplier",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontFamily: 'SourceSansProBold'),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontFamily: "SourceSansProBold"),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Form(
                    key: formKeyEmail,
                    child: TextFormField(
                      // validator: (input) => input.isValidEmail() ? null : "please enter a valid email",

                      //  onChanged: (input) => _email = input,
                      onChanged: (text) {
                        setState(() {
                          _email = text;
                          if (text.length > 0) {
                            isEmailFilled = true;
                            // btnColor = lightGreen;
                          } else {
                            isEmailFilled = false;
                            //btnColor = lightGreen.withOpacity(0.5);
                          }
                        });
                      },
                      //  controller: emailController,
                      style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          fontFamily: "SourceSansProRegular",
                          color: Colors.white),
                      //cursorColor: Color(0xff999999),

                      decoration: InputDecoration(
                          errorStyle:
                              TextStyle(height: 0, color: Colors.transparent),
                          hintText: 'Email',
                          hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.5),
                              fontFamily: "SourceSansProRegular"),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.5),
                              width: 0.5,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white))),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Form(
                    child: TextFormField(
                      key: formKeyPassword,

                      // controller: passwordController,
                      // onChanged: (input) => _password = input,

                      onChanged: (text) {
                        setState(() {
                          _password = text;
                          if (text.length > 0) {
                            isPasswordFilled = true;
                          } else {
                            isPasswordFilled = false;
                          }
                        });
                      },
                      // validator: (input) => input.isValidEmail() ? null : "Check your email",

                      obscureText: _obscureText,
                      // obscureText: true,

                      style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          fontFamily: "SourceSansProRegular",
                          color: Colors.white),

                      //  cursorColor: Color(0xff999999),
                      decoration: InputDecoration(
                          suffixIcon: InkWell(
                            onTap: _toggle,
                            child: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility_rounded,
                              size: 22.0,
                              color: Colors.white,
                            ),
                          ),
                          hintText: 'Password',
                          //  suffixIcon: Icon(Icons.visibility_off),
                          hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.5),
                              fontFamily: "SourceSansProRegular"),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.5),
                              width: 0.5,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white))),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: GestureDetector(
                    onTap: () {
                      print('forgot tapped');

                      events.mixpanel.track(Events.TAP_FORGOT_PASSWORD,
                          properties: {'email': _email});
                      events.mixpanel.flush();

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordPage()));
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Forgot password?',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontFamily: "SourceSansProRegular"),
                          ),
                        ]),
                  ),
                ),
                SizedBox(
                  height: height > 667
                      ? height - (height * 0.55 + 270)
                      : height - (height * 0.5 + 270),
                ),
                Container(
                  width: width,
                  height: 48,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: FlatButton(
                    disabledColor: Colors.white.withOpacity(0.5),
                    color: (isEmailFilled && isPasswordFilled)
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                    onPressed: isEmailFilled && isPasswordFilled
                        ? () {
                            FocusScope.of(context).unfocus();

                            setState(() {
                              isApiCallingProcess = true;
                              validator();
                            });
                          }
                        : null,
                    child: Text(
                      'Log in',
                      style: TextStyle(
                          color: buttonBlue.withOpacity(0.5),
                          fontSize: 16,
                          fontFamily: "SourceSansProSemiBold"),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
              ],
            ),
          ),
        ),
        _isShowLoader
            ? Container(
                child: Stack(children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.black.withOpacity(0.3),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          // color: Colors.black.withOpacity(0.4) ,
                          child: SpinKitThreeBounce(
                        color: Colors.white,
                        size: 24,
                        duration: Duration(seconds: 2),
                      )),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Logging you in...',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'SourceSansProRegular',
                            color: Colors.white),
                      ),
                    ],
                  ),
                ]),
              )
            : Container()
      ]),
    );
  }
}

void showAlert(context) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text(Constants.txt_ok),
    onPressed: () {
      //  Navigator.pop(context);
      Navigator.of(context, rootNavigator: true).pop();
    },
  );

  // set up the AlertDialog
  BasicDialogAlert alert = BasicDialogAlert(
    title: Text(Constants.invalid_details),
    content: Text(Constants.txt_alert_message),
    actions: [okButton],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
