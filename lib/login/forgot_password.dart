import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:zm_supplier/home/home_page.dart';
import 'package:zm_supplier/login/verification_code_page.dart';
import 'package:zm_supplier/models/user.dart';
import 'package:zm_supplier/utils/constants.dart';
import 'package:zm_supplier/models/response.dart';
import 'package:zm_supplier/utils/eventsList.dart';

import '../utils/color.dart';
import '../utils/color.dart';
import '../utils/color.dart';
import '../utils/color.dart';
import 'package:zm_supplier/services/authenticationApi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zm_supplier/services/userApi.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

String _email;

void main() {
  runApp(ForgotPasswordPage());
}

class ForgotPasswordPage extends StatefulWidget {
  static String tag = 'forgot-password-page';

  @override
  _ForgotPasswordState createState() => new _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordPage> {
  TextEditingController emailController = new TextEditingController();

  bool isEmailFilled = false;
  bool _isShowLoader = false;

  SharedPref sharedPref = SharedPref();

  Constants events = Constants();

  @override
  void initState() {
    super.initState();
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

  Mixpanel mixpanel;

  void mixPanelEvents() async {
    mixpanel = await Constants.initMixPanel();
  }

  @override
  Widget build(BuildContext context) {
/*
    getUserDetails() async {
      try {
        print('forgot');
        LoginResponse user = LoginResponse.fromJson(
            await sharedPref.readData(Constants.login_Info));
        // setState(() {
        UserApi login = new UserApi();

        login.forgotPassword(_email).then((value) async {

          print(value.toJson());
          // });
        });
      } catch (Excepetion) {
        print('failed to retrive data');
      }
    }*/

    requestForVerificationCode() {
      _showLoader();
      UserApi login = new UserApi();

      login.forgotPassword(_email).then((value) async {
        print('value.toJson()');
        _hideLoader();
        if (value == null) {
          showAlert(context);
        }
        if (value.status == Constants.status_success.toLowerCase()) {
          print('OTP sent to email');

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(Constants.user_email, _email);

          events.mixpanel.track(Events.TAP_REQUEST_RESET_PASSWORD);
          mixpanel.flush();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VerificationCode(_email)));
        } else {
          showAlert(context);
        }
        print(value.toJson());
      });
    }

    void validator() {
      if (_email.isValidEmail1()) {
        print('validated');
        requestForVerificationCode();
      } else {
        showAlert(context);
        print('not validated');
      }
    }

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      //  resizeToAvoidBottomPadding: false;
      body: ModalProgressHUD(
        inAsyncCall: _isShowLoader,
        child: Container(
          height: height,
          width: width,
          child: SingleChildScrollView(
            // physics: ClampingScrollPhysics(),

            reverse: true,

            //   physics: NeverScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                //  mainAxisAlignment: MainAxisAlignment.center,
                //   mainAxisSize: MainAxisSize.min,
                //   crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: width,
                    height: height > 667 ? height * 0.55 : height * 0.5,
                    // child: Container(child: Image.asset('assets/img_welcome_salmon.png', fit: BoxFit.fill,)),

                    child: Stack(
                      children: <Widget>[
                        FadeInImage(
                          placeholder: AssetImage("assets/images/blackdot.png"),
                          image: AssetImage(
                              "assets/images/img_welcome_salmon.png"),
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                        ),
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
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Reset password',
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
                    child: TextFormField(
                      // validator: (input) => input.isValidEmail() ? null : "please enter a valid email",

                      //  onChanged: (input) => _email = input,
                      onChanged: (text) {
                        setState(() {
                          _email = text;
                          if (text.length > 0) {
                            isEmailFilled = true;
                          } else {
                            isEmailFilled = false;
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
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: GestureDetector(
                      onTap: () {
                        events.mixpanel.track(Events.TAP_CANCEL_RESET_PASSWORD);
                        //  mixpanel.flush();
                        print('Back to login');
                        Navigator.pop(context);
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Back to login',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: buttonBlue,
                                  fontFamily: "SourceSansProRegular"),
                            ),
                          ]),
                    ),
                  ),
                  // SizedBox(
                  //   height: 100,
                  // ),

                  SizedBox(
                    height: height > 667
                        ? height - (height * 0.55 + 220)
                        : height - (height * 0.5 + 220),
                  ),
                  Container(
                    width: width,
                    height: 48,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: FlatButton(
                      disabledColor: buttonBlue.withOpacity(0.5),
                      color: (isEmailFilled)
                          ? buttonBlue
                          : buttonBlue.withOpacity(0.5),
                      onPressed: isEmailFilled
                          ? () {
                              validator();
                            }
                          : null,
                      child: Text(
                        'Request password reset',
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
                    height: 10,
                  ),

                  //  Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom))
                ],
              ),
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
      Navigator.of(context, rootNavigator: true).pop();
    },
  );

  // set up the AlertDialog
  BasicDialogAlert alert = BasicDialogAlert(
    title: Text(Constants.txt_reset_password),
    content: Text(Constants.txt_please_try_again),
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
  bool isValidEmail1() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
