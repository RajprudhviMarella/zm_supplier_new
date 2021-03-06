import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:zm_supplier/models/ordersResponseList.dart';

import 'color.dart';

/**
 * Created by RajPrudhviMarella on 11/Feb/2021.
 */

class Constants {
  // Strings
  static const String app_name = "Zeemart Supplier";
  static const String txt_change_password = "Change password";
  static const String txt_help = "Help";
  static const String txt_ask_zeemart = "Ask Zeemart";
  static const String txt_send_feed_back = "Send feedback";
  static const String txt_terms_of_use = "Terms of use";
  static const String txt_privacy_policy = "Privacy policy";
  static const String txt_log_out = "Sign out";
  static const String txt_support = "Support";
  static const String txt_account = "Account";
  static const String txt_ok = "OK";
  static const String txt_cancel = "Cancel";
  static const String txt_confirm_logout = "Are you sure you want to sign out?";
  static const String txt_place_this_order = "Place this order now?";
  static const String txt_select_from = "Change profile photo";
  static const String txt_take_photo = "Take photo";
  static const String txt_select_library = "Select from library";

  static const String txt_login = "Login";
  static const String txt_reset_password = "Reset Password";
  static const String txt_alert_message = "please enter valid email/password";
  static const String txt_alert_email_message = "please enter valid email";
  static const String login_Info = "loginInfo";
  static const String PASSWORD_ENCRYPTED = "PASSWORD_ENCRYPTED";
  static const String specific_user_info = "specificUserInfo";

  static const String txt_incorrect_format = "Incorrect format";
  static const String txt_short_password = "New password is too short";
  static const String txt_password_not_match =
      "New passwords entered do not match";
  static const String txt_re_enter_new_password =
      "Please reenter new password.";
  static const String txt_password_length =
      "Please enter at least 8 characters.";
  static const String txt_password = "Password";
  static const String txt_re_enter_password = "Re-enter password";

  static const String txt_current_password = "Current password";
  static const String txt_enter_current_password = "Enter current password";
  static const String txt_new_password_min = "New password (min. 8 characters)";
  static const String txt_enter_new_password = "Enter new password";
  static const String txt_enter_new_password_again = "Enter new password again";
  static const String txt_invalid_password = "Invalid password";
  static const String txt_password_updated = "Password updated";
  static const String txt_for_security_login_again =
      "For security reasons, please login again";
  static const String txt_incorrect_current_password =
      "Incorrect current password";
  static const String txt_password_requirements =
      "Include at least 1 lowercase and uppercase letters, 1 number, and 1 symbol/special character.";

  static const String txt_password_requiremntSemiBold = "Min. 8 characters, ";
  static const String txt_password_requirementRegular =
      "at least 1 lowercase and uppercase letters, 1 number, and 1 symbol/special character.";
  static const String txt_create_password = "Create new password";

  static const String user_email = 'user_Email';
  static const String is_logged = "isLogged";
  static const String verification_code = "VerificationCode";
  static const String status_success = "Success";
  static const String txt_new_password_didnt_match =
      "New password does not match Confirm password.";
  static const String txt_resend_otp = "Resend OTP";
  static const String txt_something_wrong =
      "Something went wrong. please try again";

  static const String termsUrl = "https://www.zeemart.asia/terms";
  static const String privacyUrl = "https://www.zeemart.asia/privacy-policy";
  static const String txt_orders = "Orders";
  static const String txt_select_outlet = "Select outlet";
  static const String txt_deliveries = "Deliveries";
  static const String txt_starred = "Starred";
  static const String txt_Search_order_number = "Search order number";
  static const String txt_Search_outlet = "Search outlet";
  static const String txt_Search_sku = "Search SKU";
  static const String txt_all_outlets = "All outlets";
  static const String txt_add_notes = "Add notes..";
  static const String txt_search_outlet = "Search outlet or people";

  static Widget OrderStatusColor(Orders orders) {
    String status = orders.orderStatus;
    if (status == "Approving") {
      return Container(
        margin: EdgeInsets.only(top: 3),
        decoration: BoxDecoration(
          color: keyLineGrey,
          border: Border.all(
            color: keyLineGrey,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 2.0, bottom: 2.0, left: 5.0, right: 5.0),
          child: Text(status.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.black,
                  fontFamily: "SourceSansProSemiBold")),
        ),
      );
    } else if (status == "Cancelling") {
      return Container(
        margin: EdgeInsets.only(top: 3),
        decoration: BoxDecoration(
          color: keyLineGrey,
          border: Border.all(
            color: keyLineGrey,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 2.0, bottom: 2.0, left: 5.0, right: 5.0),
          child: Text(status.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.black,
                  fontFamily: "SourceSansProSemiBold")),
        ),
      );
    } else if (status == "Creating") {
      return Container(
        margin: EdgeInsets.only(top: 3),
        decoration: BoxDecoration(
          color: keyLineGrey,
          border: Border.all(
            color: keyLineGrey,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 2.0, bottom: 2.0, left: 5.0, right: 5.0),
          child: Text(status.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.black,
                  fontFamily: "SourceSansProSemiBold")),
        ),
      );
    } else if (status == "Rejecting") {
      return Container(
        margin: EdgeInsets.only(top: 3),
        decoration: BoxDecoration(
          color: keyLineGrey,
          border: Border.all(
            color: keyLineGrey,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 2.0, bottom: 2.0, left: 5.0, right: 5.0),
          child: Text(status.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.black,
                  fontFamily: "SourceSansProSemiBold")),
        ),
      );
    } else if (status == "Draft") {
      return Container(
        margin: EdgeInsets.only(top: 3),
        decoration: BoxDecoration(
          color: chartBlue,
          border: Border.all(
            color: chartBlue,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 2.0, bottom: 2.0, left: 5.0, right: 5.0),
          child: Text(status.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.white,
                  fontFamily: "SourceSansProSemiBold")),
        ),
      );
    } else if (status == "Created" || status == "PendingPayment") {
      return Container(
        margin: EdgeInsets.only(top: 3),
        decoration: BoxDecoration(
          color: yellow,
          border: Border.all(
            color: yellow,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 2.0, bottom: 2.0, left: 5.0, right: 5.0),
          child: Text(status.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.black,
                  fontFamily: "SourceSansProSemiBold")),
        ),
      );
    } else if (status == "Placed" ||
        (orders.isInvoiced != null && orders.isInvoiced)) {
      return Container(
        margin: EdgeInsets.only(top: 3),
        decoration: BoxDecoration(
          color: green,
          border: Border.all(
            color: green,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 2.0, bottom: 2.0, left: 5.0, right: 5.0),
          child: Text(status.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.white,
                  fontFamily: "SourceSansProSemiBold")),
        ),
      );
    } else if (status == "Cancelled" ||
        status == "Deleted" ||
        status == "Rejected" ||
        status == "Void") {
      return Container(
        margin: EdgeInsets.only(top: 3),
        decoration: BoxDecoration(
          color: pinkyRed,
          border: Border.all(
            color: pinkyRed,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 2.0, bottom: 2.0, left: 5.0, right: 5.0),
          child: Text(status.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.white,
                  fontFamily: "SourceSansProSemiBold")),
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(top: 3),
        decoration: BoxDecoration(
          color: pinkyRed,
          border: Border.all(
            color: pinkyRed,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 2.0, bottom: 2.0, left: 5.0, right: 5.0),
          child: Text("UN AVAILABLE",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.white,
                  fontFamily: "SourceSansProSemiBold")),
        ),
      );
    }
  }

  String getInitialWords(String name) {
    var firstWord = name[0];
    var lastWord = name.substring(name.lastIndexOf(' ') + 1);
    var finalStr = '';
    if (name.split(' ').length > 1) {
      finalStr = firstWord + ' ' + lastWord;
    } else {
      finalStr = firstWord;
    }
    return getInitialsChars(finalStr).toUpperCase();
  }

  String getInitialsChars(String bank_account_name) =>
      bank_account_name.isNotEmpty
          ? bank_account_name.trim().split(' ').map((l) => l[0]).take(2).join()
          : '';
}

class SharedPref {
  saveData(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  readData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key));
  }
}
