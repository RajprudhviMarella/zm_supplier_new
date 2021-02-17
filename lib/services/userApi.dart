import 'dart:math';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:zm_supplier/models/user.dart';
import 'package:zm_supplier/models/response.dart';
import 'package:zm_supplier/utils/urlEndPoints.dart';

class UserApi {
  Future<statusSuccessResponse> forgotPassword(String email) async {
    var resetPasswordModel = null;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart',
    };
    print(headers);

    print(URLEndPoints.forgot_password_url);
    final msg = jsonEncode({
      'ZeemartId': email,
      'userType': "SUPPLIER",
      'market': "sg",
    });

    print(msg);
    try {
      await http
          .post(URLEndPoints.forgot_password_url, headers: headers, body: msg)
          .then((response) {
        if (response.statusCode == 200) {
          print(response.body);
          print('Success response');
          // var jsonString = response.body;
          // var jsonMap = json.decode(response.body);
          resetPasswordModel =
              statusSuccessResponse.fromJson(json.decode(response.body));
        } else {
          //throw Exception('Failed to login');
          print('failed to send otp');
        }
      });
    } catch (Exception) {
      print('returned to cache');
    }
    return resetPasswordModel;
  }


  Future<statusSuccessResponse> validateVerificationCode(String email, String otp) async {
    var resetPasswordModel = null;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart',
    };
    print(headers);

    print(URLEndPoints.validate_verification_code);
    final msg = jsonEncode({
      'ZeemartId': email,
      'verificationCode': otp,
    });

    print(msg);
    try {
      await http
          .post(URLEndPoints.validate_verification_code, headers: headers, body: msg)
          .then((response) {
        if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {
          print(response.body);
          print('Success response');
          resetPasswordModel =
              statusSuccessResponse.fromJson(json.decode(response.body));
        } else {
          //throw Exception('Failed to login');
          print('failed to send otp');
        }
      });
    } catch (Exception) {
      print('returned to cache');
    }
    return resetPasswordModel;
  }

}
