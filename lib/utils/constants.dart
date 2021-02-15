import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/**
 * Created by RajPrudhviMarella on 11/Feb/2021.
 */

class Constants {
  // Strings
  static const String app_name = "Zeemart Supplier";
  static const String txt_change_password = "Change Password";
  static const String txt_help = "Help";
  static const String txt_ask_zeemart = "Ask Zeemart";
  static const String txt_send_feed_back = "Send FeedBack";
  static const String txt_terms_of_use = "Terms Of Use";
  static const String txt_privacy_policy = "Privacy policy";
  static const String txt_log_out = "Sign Out";
  static const String txt_support = "Support";
  static const String txt_account = "Account";
  static const String txt_ok = "OK";
  static const String txt_cancel = "Cancel";
  static const String txt_confirm_logout = "Are you sure you want to logout?";
  static const String txt_select_from = "Change profile photo";
  static const String txt_take_photo = "Take photo";
  static const String txt_select_library = "Select from Library";

  static const String txt_login = "Login";
  static const String txt_alert_message = "please enter valid email/password";
  static const String loginInfo = "loginInfo";

  static const String status_success = "Success";
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