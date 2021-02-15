import 'dart:math';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:zm_supplier/models/user.dart';
import 'package:zm_supplier/models/response.dart';
import 'package:zm_supplier/utils/urlEndPoints.dart';

class Authentication {
  Future<LoginResponse> authenticate(String email, String pass) async {
    var authModel = null;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart'
    };

    final msg = jsonEncode({'ZeemartId': email, 'password': pass});

    try {
      await http
          .post(URLEndPoints.login_url, headers: headers, body: msg)
          .then((response) {
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

class getSpecificUser {
  Future<ApiResponse> retriveSpecificUser(
      String supplierId, String mudra) async {

    Map<String, String> queryParams = {'supplierId': supplierId};
    var userModel = null;
    String queryString = Uri(queryParameters: queryParams).query;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart',
      'mudra': mudra,
      'supplierId': supplierId
    };

    print(headers);
    var requestUrl = URLEndPoints.get_specific_user_url + '?' + queryString;
    print(requestUrl);
    try {
      await http.get(requestUrl, headers: headers).then((response) {
        if (response.statusCode == 200) {
          print(response.body);
          var jsonString = response.body;
          var jsonMap = json.decode(response.body);
          userModel = ApiResponse.fromJson(jsonMap);
          return userModel;
        } else {
          throw Exception('Failed to login');
        }
      });
    } catch (Exception) {
      return userModel;
    }
    return userModel;
  }
}
