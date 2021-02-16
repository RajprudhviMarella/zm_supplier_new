import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../utils/color.dart';
import 'package:zm_supplier/utils/constants.dart';
import 'package:zm_supplier/utils/color.dart';

import '../utils/constants.dart';
import 'package:zm_supplier/services/editSupplierApi.dart';

import 'login_page.dart';

/**
 * Created by RajPrudhviMarella on 14/Feb/2021.
 */

class ChangePassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChangePasswordDesign();
  }
}

class ChangePasswordDesign extends State<ChangePassword>
    with TickerProviderStateMixin {
  String oldPassword, newPassword, newPasswordAgain, passwordEncrypted;
  LoginResponse userResponse;
  GlobalKey<FormState> formKeyCurrentPassword = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyNewPassword = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyNewPasswordAgain = GlobalKey<FormState>();
  bool _currentPasswordToggle = true;
  bool _newPasswordToggle = true;
  bool _newPasswordAgainToggle = true;
  RegExp regex = new RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!#$%&()*+,-./:;<=>?@\^_`{|}~"\[\]]).{8,}$');

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
          menuItem(context, Constants.txt_change_password,
              Icon(Icons.arrow_back_ios_outlined, color: Colors.black), 15),
          Headers(context, Constants.txt_current_password, 16, Colors.black),
          CurrentPassword(
            context,
            Constants.txt_enter_current_password,
          ),
          Headers(context, Constants.txt_new_password_min, 16, Colors.black),
          subText(context, Constants.txt_password_requirements, 14, greyText),
          NewPassword(
            context,
            Constants.txt_enter_new_password,
          ),
          NewPasswordAgain(
            context,
            Constants.txt_enter_new_password_again,
          ),
          Button(context),
        ],
      ),
    );
  }

  Widget menuItem(context, String name, Icon icon, double margin) {
    return InkWell(
      // onTap: () => onItemSelect(name, context),
      child: Container(
        color: Colors.white,
        // margin: EdgeInsets.only(bottom: margin),
        padding: EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              child: Container(
                height: 18,
                width: 18,
                child: icon,
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Text(name,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "SourceSansProBold",
                      fontSize: 18,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget Headers(context, String name, double size, Color greyText) {
    return Container(
      color: faintGrey,
      margin: EdgeInsets.only(top: 2.0),
      padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      child: Text(name,
          style: TextStyle(
            color: greyText,
            fontFamily: "SourceSansProSemiBold",
            fontSize: size,
          )),
    );
  }

  Widget subText(context, String name, double size, Color greyText) {
    return Container(
      color: faintGrey,
      margin: EdgeInsets.only(top: 5.0),
      padding: EdgeInsets.only(left: 20.0),
      child: Text(name,
          style: TextStyle(
            color: greyText,
            fontFamily: "SourceSansProRegular",
            fontSize: size,
          )),
    );
  }

  Widget Button(context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 40.0, right: 20.0),
      child: Container(
        height: 48.0,
        child: GestureDetector(
          onTap: () {
            validator(context);
          },
          child: Container(
            decoration: BoxDecoration(
              color: lightGreen,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(
                    "Save",
                    style: TextStyle(
                      color: Colors.white,
                      // fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget CurrentPassword(context, String hint) {
    void _toggle() {
      setState(() {
        _currentPasswordToggle = !_currentPasswordToggle;
      });
    }

    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 10.0),
      padding:
          const EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
      child: Form(
        key: formKeyCurrentPassword,
        child: TextFormField(
          validator: (value) {
            if (value.isEmpty) {
              return Constants.txt_invalid_password;
            } else {
              if (!regex.hasMatch(value)) {
                return Constants.txt_invalid_password;
              } else {
                if (value != passwordEncrypted) {
                  print(passwordEncrypted);
                  print(oldPassword);
                  return Constants.txt_incorrect_current_password;
                } else {
                  return null;
                }
              }
            }
          },

          // controller: passwordController,
          onChanged: (input) => oldPassword = input,

          // validator: (input) => input.isValidEmail() ? null : "Check your email",

          obscureText: _currentPasswordToggle,
          // obscureText: true,

          style: TextStyle(fontSize: 20, height: 1),

          //  cursorColor: Color(0xff999999),
          decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: InkWell(
              onTap: _toggle,
              child: Icon(
                _currentPasswordToggle
                    ? Icons.visibility_off
                    : Icons.visibility_rounded,
                size: 22.0,
                color: Colors.grey,
              ),
            ),
            hintText: hint,
            //  suffixIcon: Icon(Icons.visibility_off),
            hintStyle: TextStyle(
              fontSize: 16,
              color: greyText,
            ),
          ),
        ),
      ),
    );
  }

  Widget NewPassword(context, String hint) {
    void _toggle() {
      setState(() {
        _newPasswordToggle = !_newPasswordToggle;
      });
    }

    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 10.0),
      padding:
          const EdgeInsets.only(left: 20, right: 20, top: 5.0, bottom: 5.0),
      child: Form(
        key: formKeyNewPassword,
        child: TextFormField(
          validator: (value) {
            if (value.isEmpty) {
              return Constants.txt_invalid_password;
            } else {
              if (!regex.hasMatch(value))
                return Constants.txt_invalid_password;
              else {
                if (value != newPasswordAgain) {
                  return Constants.txt_new_password_didnt_match;
                } else {
                  return null;
                }
              }
            }
          },

          // controller: passwordController,
          onChanged: (input) => newPassword = input,

          // validator: (input) => input.isValidEmail() ? null : "Check your email",

          obscureText: _newPasswordToggle,
          // obscureText: true,

          style: TextStyle(fontSize: 20, height: 1),

          //  cursorColor: Color(0xff999999),
          decoration: InputDecoration(
              suffixIcon: InkWell(
                onTap: _toggle,
                child: Icon(
                  _newPasswordToggle
                      ? Icons.visibility_off
                      : Icons.visibility_rounded,
                  size: 22.0,
                  color: Colors.grey,
                ),
              ),
              hintText: hint,
              //  suffixIcon: Icon(Icons.visibility_off),
              hintStyle: TextStyle(
                fontSize: 16,
                color: greyText,
              ),
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
    );
  }

  Widget NewPasswordAgain(context, String hint) {
    void _toggle() {
      setState(() {
        _newPasswordAgainToggle = !_newPasswordAgainToggle;
      });
    }

    return Container(
      color: Colors.white,
      padding:
          const EdgeInsets.only(left: 20, right: 20, top: 5.0, bottom: 5.0),
      child: Form(
        key: formKeyNewPasswordAgain,
        child: TextFormField(
          validator: (value) {
            if (value.isEmpty) {
              return Constants.txt_invalid_password;
            } else {
              if (!regex.hasMatch(value))
                return Constants.txt_invalid_password;
              else {
                if (value != newPassword) {
                  return Constants.txt_new_password_didnt_match;
                } else {
                  return null;
                }
              }
            }
          },

          // controller: passwordController,
          onChanged: (input) => newPasswordAgain = input,

          // validator: (input) => input.isValidEmail() ? null : "Check your email",

          obscureText: _newPasswordAgainToggle,
          // obscureText: true,

          style: TextStyle(fontSize: 20, height: 1),

          //  cursorColor: Color(0xff999999),
          decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: InkWell(
              onTap: _toggle,
              child: Icon(
                _newPasswordAgainToggle
                    ? Icons.visibility_off
                    : Icons.visibility_rounded,
                size: 22.0,
                color: Colors.grey,
              ),
            ),
            hintText: hint,
            //  suffixIcon: Icon(Icons.visibility_off),
            hintStyle: TextStyle(
              fontSize: 16,
              color: greyText,
            ),
          ),
        ),
      ),
    );
  }

  SharedPref sharedPref = SharedPref();

  loadSharedPrefs() async {
    try {
      userResponse = LoginResponse.fromJson(
          await sharedPref.readData(Constants.login_Info));
      passwordEncrypted =
          await sharedPref.readData(Constants.PASSWORD_ENCRYPTED);
    } catch (Excepetion) {
      // do something
    }
  }

  void validator(context) {
    if (formKeyCurrentPassword.currentState.validate() &&
        formKeyNewPassword.currentState.validate() &&
        formKeyNewPasswordAgain.currentState.validate()) {
      changePasswordApiCalling(context);
    }
  }

  void changePasswordApiCalling(context) {
    EditSupplierDetails login = new EditSupplierDetails();
    print(userResponse.mudra);
    print(json.encode(userResponse));
    login
        .changePassword(oldPassword, newPassword, userResponse.mudra,
            userResponse.user.email)
        .then((value) async {
      if (value.status == "success") {
        showAlert(context);
      } else {
        showErrorAlert(context, value.status);
      }
    });
  }

  void showAlert(context) {
    BuildContext dialogContext;
    // set up the button
    Widget okButton = FlatButton(
      child: Text(Constants.txt_ok),
      onPressed: () async {
        Navigator.pop(context);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs?.clear();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (dialogContext) {
            return LoginPage();
          }),
        );
        Navigator.of(dialogContext).pop();
      },
    );

    // set up the AlertDialog
    BasicDialogAlert alert = BasicDialogAlert(
      title: Text(Constants.txt_password_updated),
      content: Text(Constants.txt_for_security_login_again),
      actions: [okButton],
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

  void showErrorAlert(context, String status) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(Constants.txt_ok),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    BasicDialogAlert alert = BasicDialogAlert(
      title: Text(status),
      content: Text("Please try again"),
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
}
