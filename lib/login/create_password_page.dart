
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zm_supplier/login/login_page.dart';
import 'package:zm_supplier/models/user.dart';
import 'package:zm_supplier/services/editSupplierApi.dart';
import 'package:zm_supplier/utils/color.dart';
import 'package:zm_supplier/utils/constants.dart';
import 'package:zm_supplier/utils/eventsList.dart';

class CreatePassword extends StatefulWidget {
  @override
  CreatePasswordState createState() => new CreatePasswordState();
}

class CreatePasswordState extends State<CreatePassword> {
  GlobalKey<FormState> formKeyNewPassword = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyNewPasswordAgain = GlobalKey<FormState>();

  String newPassword, newPasswordAgain, passwordEncrypted, verificationCode, email;
  bool _newPasswordToggle = true;
  bool _newPasswordAgainToggle = true;

  bool _isPassWordFilled = false;
  bool _isNewPasswordFilled = false;

  bool _isShowLoader = false;

  // var verificationCode;

  RegExp regex = new RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!#$%&()*+,-./:;<=>?@\^_`{|}~"\[\]]).{8,}$');

  Constants events = Constants();
  @override
  void initState() {
    super.initState();
    events.mixPanelEvents();
    retriveVerificationCode();
  }

  @override
  void dipose() {
    super.dispose();
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

  retriveVerificationCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    verificationCode = prefs.getString(Constants.verification_code);
    email = prefs.getString(Constants.user_email);
    print('verificationCode' + verificationCode);
    print("email" + email);
  }

  // sharedPref.saveData(Constants.PASSWORD_ENCRYPTED, _password);


  void createPasswordApiCalling() {

    _showLoader();
    EditSupplierDetails login = new EditSupplierDetails();
    login.createPassword(email, newPassword, verificationCode)
        .then((value) async {
      _hideLoader();
      if (value == null) {
        showErrorAlert(Constants.txt_change_password, Constants.txt_something_wrong);
      }
      if (value.status == "success") {

        events.mixpanel.track(Events.TAP_CHANGE_PASSWORD_CONTINUE);
        events.mixpanel.flush();
        SharedPref sharedPref = SharedPref();
        sharedPref.saveData(Constants.PASSWORD_ENCRYPTED, newPassword);

        showAlert(Constants.txt_password_updated, Constants.txt_for_security_login_again);
      } else {
        showErrorAlert(Constants.txt_change_password, Constants.txt_something_wrong);
      }
    });

  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return ModalProgressHUD(
      inAsyncCall: _isShowLoader,
      child: Scaffold(
        backgroundColor: faintGrey,
        body: ListView(
          children: [
            backButton(context, Icon(Icons.arrow_back_ios_outlined)),
            Headers(context, Constants.txt_create_password, 30, Colors.black),
            subText(context),
            NewPassword(
              context,
              Constants.txt_password,
            ),
            NewPasswordAgain(
              context,
              Constants.txt_re_enter_password,
            ),
            Button(context)
          ],
        ),
      ),
    );
  }

  void validator(context) {
    if (formKeyNewPassword.currentState.validate() &&
        formKeyNewPasswordAgain.currentState.validate()) {
      //changePasswordApiCalling(context);
    }
  }

  Widget backButton(context, Icon icon) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 12,
                height: 18,
                child: icon,
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
      padding: EdgeInsets.only(top: 5.0, left: 26.0, right: 26.0),
      child: Text(name,
          style: TextStyle(
            color: greyText,
            fontFamily: "SourceSansProBold",
            fontSize: size,
          )),
    );
  }

  Widget subText(context) {
    return Container(
      color: faintGrey,
      margin: EdgeInsets.only(top: 2.0),
      padding: EdgeInsets.only(top: 10.0, left: 26.0, right: 26.0),
      child: RichText(
        text: TextSpan(children: <TextSpan>[
          TextSpan(
              text: Constants.txt_password_requiremntSemiBold,
              style: TextStyle(
                  fontFamily: "SourceSansProSemiBold",
                  fontSize: 14,
                  color: greyText)),
          TextSpan(
              text: Constants.txt_password_requirementRegular,
              style: TextStyle(
                fontFamily: "SourceSansProRegular",
                fontSize: 14,
                color: greyText,
              )),
        ]),
      ),
    );
  }

  validatePassword() {
    print('validating');
    if (newPassword.length < 8 && newPasswordAgain.length < 8) {
      showErrorAlert(Constants.txt_short_password, Constants.txt_password_length);
    } else if (!regex.hasMatch(newPassword)) {
      showErrorAlert(Constants.txt_incorrect_format,
          Constants.txt_password_requirements);
    } else if (newPassword != newPasswordAgain) {
      showErrorAlert(Constants.txt_password_not_match,
          Constants.txt_re_enter_new_password);
    } else {
      print('password matched');
      createPasswordApiCalling();
    }
  }

  Widget NewPassword(context, String hint) {
    void _toggle() {
      setState(() {
        _newPasswordToggle = !_newPasswordToggle;
      });
    }

    return Container(
      margin: const EdgeInsets.only(left: 26, top: 20.0, right: 26),
      // padding:
      // const EdgeInsets.only(left: 20, right: 20, top: 5.0, bottom: 5.0),
      child: Form(
        key: formKeyNewPassword,
        child: TextFormField(
          onChanged: (value) {
            newPassword = value;
            setState(() {
              if (value.length > 0) {
                _isPassWordFilled = true; // to clear error warnigns.
              } else {
                _isPassWordFilled = false;
              }
            });
          },
          // validator: (input) => input.isValidEmail() ? null : "Check your email",

          obscureText: _newPasswordToggle,

          style: TextStyle(fontSize: 20, height: 1),

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
      padding:
      const EdgeInsets.only(left: 26, right: 26, top: 15.0, bottom: 5.0),
      child: Form(
        key: formKeyNewPasswordAgain,
        child: TextFormField(
          onChanged: (value) {
            newPasswordAgain = value;
            setState(() {
              if (value.length > 0) {
                _isNewPasswordFilled = true; // to clear error warnigns.
              } else {
                _isNewPasswordFilled = false;
              }
            });
          },

          // validator: (input) => input.isValidEmail() ? null : "Check your email",

          obscureText: _newPasswordAgainToggle,
          style: TextStyle(fontSize: 20, height: 1),

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

            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: greyText,
                width: 0.5,
              ),
            ),
            focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: buttonBlue)),

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

  Widget Button(context) {
    return Padding(
      padding: const EdgeInsets.only(left: 26.0, top: 100.0, right: 26.0),
      child: Container(
        height: 48.0,
        child: GestureDetector(
          onTap: (_isPassWordFilled && _isNewPasswordFilled)
              ? () {
            //validator(context);
            validatePassword();
          }
              : null,
          child: Container(
            decoration: BoxDecoration(
              color: _isPassWordFilled && _isNewPasswordFilled
                  ? lightGreen
                  : lightGreen.withOpacity(0.5),
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
                      fontFamily: 'SourceSansProRegular',
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

  void showAlert(String status, String message) {
    // set up the button
    Widget okButton = FlatButton(
        child: Text(Constants.txt_ok),
        onPressed: () {
          // Navigator.pop(context);
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginPage(), fullscreenDialog: true));
          //  Navigator.of(context).pop();
        }
    );

    // set up the AlertDialog
    BasicDialogAlert alert = BasicDialogAlert(
      title: Text(status),
      content: Text(message),
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

  void showErrorAlert(String status, String message) {
    // set up the button
    Widget okButton = FlatButton(
        child: Text(Constants.txt_ok),
        onPressed: () {
          // Navigator.pop(context);

          //  Navigator.of(context).pop();
          Navigator.of(context, rootNavigator: true).pop();
        }
    );

    // set up the AlertDialog
    BasicDialogAlert alert = BasicDialogAlert(
      title: Text(status),
      content: Text(message),
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


