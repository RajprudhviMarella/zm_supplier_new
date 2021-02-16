import 'dart:math';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:zm_supplier/models/user.dart';
import 'package:zm_supplier/models/response.dart';
import 'package:zm_supplier/utils/urlEndPoints.dart';

class UserApi {
  Future<forgotPasswordResponse> forgotPassword(String email) async {
    var resetPasswordModel = null;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart',
    };
    print(headers);

    print(URLEndPoints.forgot_password_url);
    final msg = jsonEncode(
        {'ZeemartId': email, 'userType': "SUPPLIER", 'market': "sg", });

    print(msg);
    try {
      await http
          .post(URLEndPoints.forgot_password_url, headers: headers, body: msg)
          .then((response) {
        if (response.statusCode == 200) {
          print(response.body);
          print('Success response');
          var jsonString = response.body;
          var jsonMap = json.decode(response.body);
          resetPasswordModel =
              forgotPasswordResponse.fromJson(json.decode(response.body));
          //  return resetPasswordModel;
        } else {
          throw Exception('Failed to login');
        }
      });
    } catch (Exception) {
      //return resetPasswordModel;
    }
    return resetPasswordModel;
  }
}
