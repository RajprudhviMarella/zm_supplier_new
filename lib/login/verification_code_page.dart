import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zm_supplier/utils/color.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:zm_supplier/services/userApi.dart';
import 'package:zm_supplier/utils/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'create_password_page.dart';

// void main() {
//   runApp(VerificationCode());
// }

class VerificationCode extends StatefulWidget {
  //static String tag = 'login-page';

  final email;

  VerificationCode(this.email);

  @override
  _VerificationCodeState createState() =>
      new _VerificationCodeState(this.email);
}

class _VerificationCodeState extends State<VerificationCode> {
  // Constants

  final email;

  _VerificationCodeState(this.email);

  var codeValue;
  bool isFilledOTP = false;
  bool isCodeValid = true;
  bool isTimerEnabled = true;

  Timer _timer;
  int _countDown = 59;
  bool _isShowLoader = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  // @override
  // void dipose() {
  //   super.dispose();
  // }

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

  void startTimer() {
    print('timer calling');
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_countDown == 1) {
          setState(() {
            timer.cancel();
            isTimerEnabled = false;
          });
        } else {
          if (this.mounted) {
            setState(() {
              _countDown--;
              print(_countDown);
              isTimerEnabled = true;
            });
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    resendCode() {
      _showLoader();

      UserApi login = new UserApi();

      login.forgotPassword(email).then((value) async {
        _hideLoader();
        if (value == null) {
          showAlert(context);
        }
        if (value.status == Constants.status_success.toLowerCase()) {
          _countDown = 59;
          startTimer();
          print('OTP sent to email');
        } else {
          showAlert(context);
        }
      });
    }

    validateVerificationCode() {
      _showLoader();

      UserApi login = new UserApi();

      login.validateVerificationCode(email, codeValue).then((value) async {
        _hideLoader();
        if (value == null) {
          setState(() {
            isCodeValid = false;
          });
        }
        if (value.status == Constants.status_success.toLowerCase()) {
          setState(() {
            isCodeValid = true;
            isFilledOTP = true;
          });


          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(Constants.verification_code, codeValue);
          
          print('otp validated');
        } else {
          setState(() {
            isCodeValid = false;
            isFilledOTP = false;
          });
        }
      });
    }

    return ModalProgressHUD(
      inAsyncCall: _isShowLoader,
      child: Scaffold(
        appBar: AppBar(
          title: Text(''),
          leading: new IconButton(
              icon: new Icon(
                Icons.arrow_back_ios,
                size: 22,
                color: Colors.black,
              ),
              onPressed: () => Navigator.of(context).pop()),
          backgroundColor: faintGrey,
          elevation: 0,
        ),
        body: Container(
          height: height,
          width: width,
          color: faintGrey,
          alignment: Alignment.topLeft,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 26, top: 0, right: 26),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Verification code',
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                              fontFamily: "SourceSansProBold"),
                        ),
                      ]),
                ),
                SizedBox(height: 5),
                Padding(
                    padding: const EdgeInsets.only(left: 26, top: 0, right: 26),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Enter the code we’ve sent to your email: $email',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: greyText,
                                  fontFamily: "SourceSansProRegular"),
                            ),
                          ),
                        ])),

                SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.only(left: 26, right: 26),

                  child: Container(
                    height: 56,
                    child: PinCodeTextField(
                      appContext: context,

                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontFamily: "SourceSansProBold",
                      ),

                      length: 6,
                      blinkWhenObscuring: true,
                      animationType: AnimationType.fade,

                      onChanged: (value) {
                        setState(() {
                          if (value.length < 1) {
                            isCodeValid = true; // to clear error warnigns.
                          }

                          if (value.length < 6) {
                            isFilledOTP = false;
                          }
                        });
                      },
                      // validator: (v) {
                      //   if (v.length < 3) {
                      //     return "I'm from validator";
                      //   } else {
                      //     return null;
                      //   }
                      // },

                      onCompleted: (_value) {
                        codeValue = _value;
                        print("values entered $codeValue");
                        validateVerificationCode();
                      },

                      pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 54,
                          fieldWidth: 46,
                          //(width - 70)/6;

                          activeFillColor: Colors.white,
                          selectedFillColor: Colors.white,
                          inactiveFillColor: Colors.white,
                          borderWidth: isCodeValid ? 0 : 1.0,
                          selectedColor:
                              isCodeValid ? Colors.white : warningRed,
                          activeColor: isCodeValid ? Colors.white : warningRed,
                          inactiveColor:
                              isCodeValid ? Colors.white : warningRed),

                      cursorColor: buttonBlue,
                      cursorWidth: 1,

                      animationDuration: Duration(milliseconds: 300),
                      backgroundColor: faintGrey,

                      enableActiveFill: true,
                      keyboardType: TextInputType.number,
                    ),
                  ),
//
                ),

                Padding(
                    padding: const EdgeInsets.only(left: 26, top: 5, right: 26),
                    child: Container(
                      height: isCodeValid ? 0 : 20,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                isCodeValid ? '' : 'Incorrect code',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: warningRed,
                                    fontFamily: "SourceSansProRegular"),
                              ),
                            ),
                          ]),
                    )),

                SizedBox(height: 5),

                Padding(
                    padding: const EdgeInsets.only(left: 26, right: 26),
                    child: GestureDetector(
                      onTap: !isTimerEnabled
                          ? () {
                              resendCode();
                              print('send again tapped');
                            }
                          : null,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                isTimerEnabled
                                    ? 'Send again ($_countDown)'
                                    : "Send again",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: isTimerEnabled
                                        ? buttonBlue.withOpacity(0.5)
                                        : buttonBlue,
                                    fontFamily: "SourceSansProRegular"),
                              ),
                            ),
                          ]),
                    )),

                SizedBox(height: 50),
                //
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: RaisedButton(
                //     onPressed: () {},
                //     child: const Text('Bottom Button!', style: TextStyle(fontSize: 20)),
                //     color: Colors.blue,
                //     textColor: Colors.white,
                //     elevation: 5,
                //   ),
                // ),

                Container(
                  width: width,
                  height: 48,
                  padding: EdgeInsets.only(left: 26, right: 26),
                  child: MaterialButton(
                    disabledColor: buttonBlue.withOpacity(0.5),
                    color: (isCodeValid && isFilledOTP)
                        ? buttonBlue
                        : buttonBlue.withOpacity(0.5),
                    onPressed: isCodeValid && isFilledOTP
                        ? () {
                            //Navigation to create password.

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreatePassword()));

                          }
                        : null,
                    child: Text(
                      'Continue',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: "SourceSansProSemiBold"),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                  ),
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
  Widget okButton = MaterialButton(
    child: Text(Constants.txt_ok),
    onPressed: () {
      //  Navigator.pop(context);
      Navigator.of(context, rootNavigator: true).pop();
    },
  );

  // set up the AlertDialog
  BasicDialogAlert alert = BasicDialogAlert(
    title: Text(Constants.txt_resend_otp),
    content: Text(Constants.txt_something_wrong),
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
