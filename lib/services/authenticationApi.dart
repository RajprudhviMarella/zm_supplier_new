import 'dart:math';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:zm_supplier/models/user.dart';

class Authentication {
  Future<LoginResponse> authenticate(String email, String pass) async {
    String myurl =
        "https://zm-staging-authserv.zeemart.asia/services/supplier/login";

    var authModel = null;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart'
    };

    //var as = Login();
    final msg = jsonEncode({'ZeemartId': email, 'password': pass});

    try {
      await http.post(myurl, headers: headers, body: msg).then((response) {
        if (response.statusCode == 200) {
          print(response.body);
          print('Success response');
          var jsonString = response.body;
          var jsonMap = json.decode(response.body);
          authModel = LoginResponse.fromJson(json.decode(response.body));
          return authModel;
        } else {
          throw Exception('Failed to login');
        }
      });
    } catch (Exception) {
      return authModel;
    }

    print('returned');
    return authModel;
  }
}
