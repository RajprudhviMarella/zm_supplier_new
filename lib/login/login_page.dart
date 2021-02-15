import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:zm_supplier/home/home_page.dart';
import 'package:zm_supplier/models/user.dart';
import 'package:zm_supplier/utils/constants.dart';
import 'package:zm_supplier/models/response.dart';

import '../utils/color.dart';
import '../utils/color.dart';
import '../utils/color.dart';
import '../utils/color.dart';
import 'package:zm_supplier/services/authenticationApi.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool _obscureText = true;
bool _btnEnabled = false;
String _email, _password;

GlobalKey<FormState> formKeyEmail = GlobalKey<FormState>();
GlobalKey<FormState> formKeyPassword = GlobalKey<FormState>();

void main() {
  runApp(LoginPage());
}

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool isEmailFilled = false;
  bool isPasswordFilled = false;

//Initialize a button color variable
  Color btnColor = lightGreen.withOpacity(0.5);

  SharedPref sharedPref = SharedPref();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void _toggle() {
      setState(() {
        _obscureText = !_obscureText;
      });
    }

    getUserDetails() async {
      try {
        LoginResponse user = LoginResponse.fromJson(
            await sharedPref.readData(Constants.login_Info));
        setState(() {
          getSpecificUser specificUser = new getSpecificUser();

          specificUser
              .retriveSpecificUser(user.supplier.first.supplierId, user.mudra)
              .then((value) async {
            sharedPref.saveData(Constants.specific_user_info, value);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          });
        });
      } catch (Excepetion) {
        print('failed to retrive data');
      }
    }

    void loginApiCalling() {
      Authentication login = new Authentication();

      login.authenticate(_email, _password).then((value) async {
        if (value.status == Constants.status_success) {
          //save login data
          sharedPref.saveData(Constants.login_Info, value);

          getUserDetails();
        } else {
          showErrorAlert(context, value);
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
      body: Container(
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: width,
                height: height * 0.5,
                // child: Container(child: Image.asset('assets/img_welcome_salmon.png', fit: BoxFit.fill,)),

                child: Stack(
                  children: <Widget>[
                    FadeInImage(
                      placeholder: AssetImage("assets/images/blackdot.png"),
                      image: AssetImage("assets/images/img_welcome_salmon.png"),
                      fit: BoxFit.fill,
                      height: double.infinity,
                      width: double.infinity,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 23, top: 35),
                      child: Image.asset('assets/images/ZM_logo_white.png'),
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
                height: 40,
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
                          validator();
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
                height: 10,
              ),
            ],
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
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  BasicDialogAlert alert = BasicDialogAlert(
    title: Text(Constants.txt_login),
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

void showErrorAlert(context, LoginResponse value) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text(Constants.txt_ok),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  BasicDialogAlert alert = BasicDialogAlert(
    title: Text(Constants.txt_login),
    content: Text(value.status),
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
