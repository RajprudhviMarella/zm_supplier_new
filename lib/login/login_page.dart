import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:zm_supplier/home/home_page.dart';
import 'package:zm_supplier/models/user.dart';
import 'package:zm_supplier/utils/constants.dart';
import 'package:zm_supplier/models/response.dart';
import 'package:zm_supplier/login/forgot_password.dart';

import '../utils/color.dart';
import '../utils/color.dart';
import '../utils/color.dart';
import '../utils/color.dart';
import 'package:zm_supplier/services/authenticationApi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  bool isLogged = false;

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

//Initialize a button color variable
  Color btnColor = lightGreen.withOpacity(0.5);

  SharedPref sharedPref = SharedPref();

  @override
  void initState() {
    super.initState();
    mixPanelEvents();
  }

  Mixpanel mixpanel;

  void mixPanelEvents() async {
    mixpanel = await Constants.initMixPanel();
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
        getSpecificUser specificUser = new getSpecificUser();

        specificUser
            .retriveSpecificUser(user.supplier.first.supplierId, user.mudra)
            .then((value) async {
          sharedPref.saveData(Constants.specific_user_info, value);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          isLogged = true;
          prefs.setBool(Constants.is_logged, isLogged);

          _hideLoader();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(), fullscreenDialog: true));
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
      body: ModalProgressHUD(
        inAsyncCall: _isShowLoader,
        child: Container(
          height: height,
          width: width,
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              //   mainAxisSize: MainAxisSize.min,
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: width,
                  height: height * 0.5,
                  // child: Container(child: Image.asset('assets/img_welcome_salmon.png', fit: BoxFit.fill,)),

                  child: Stack(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/img_welcome_salmon.png',
                        fit: BoxFit.fill,
                        height: double.infinity,
                        width: double.infinity,
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
                        padding: const EdgeInsets.only(left: 23, top: 35),
                        child: Image.asset(
                          'assets/images/zm_logo.png',
                          width: 28,
                          height: 28,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 60, top: 40),
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
                            fontSize: 25,
                            color: Colors.black,
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
                          fontSize: 18,
                          height: 1.5,
                          fontFamily: "SourceSansProRegular"),
                      //cursorColor: Color(0xff999999),

                      decoration: InputDecoration(
                          errorStyle:
                              TextStyle(height: 0, color: Colors.transparent),
                          hintText: 'Email',
                          hintStyle: TextStyle(
                              fontSize: 16,
                              color: greyText,
                              fontFamily: "SourceSansProRegular"),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: greyText,
                              width: 0.5,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: buttonBlue))),
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
                          fontSize: 18,
                          height: 1.5,
                          fontFamily: "SourceSansProRegular"),

                      //  cursorColor: Color(0xff999999),
                      decoration: InputDecoration(
                          suffixIcon: InkWell(
                            onTap: _toggle,
                            child: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility_rounded,
                              size: 22.0,
                              color: Colors.grey,
                            ),
                          ),
                          hintText: 'Password',
                          //  suffixIcon: Icon(Icons.visibility_off),
                          hintStyle: TextStyle(
                              fontSize: 16,
                              color: greyText,
                              fontFamily: "SourceSansProRegular"),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: greyText,
                              width: 0.5,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: buttonBlue))),
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

                      // mixpanel.timeEvent('Aquaman');
                      // mixpanel.track('Aquaman');
                      // mixpanel.flush();

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
                                color: buttonBlue,
                                fontFamily: "SourceSansProRegular"),
                          ),
                        ]),
                  ),
                ),
                SizedBox(
                  height: height - (height * 0.5 + 270),
                ),
                Container(
                  width: width,
                  height: 48,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: FlatButton(
                    disabledColor: lightGreen.withOpacity(0.5),
                    color: (isEmailFilled && isPasswordFilled)
                        ? lightGreen
                        : lightGreen.withOpacity(0.5),
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
                          color: Colors.white,
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
      ),
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
