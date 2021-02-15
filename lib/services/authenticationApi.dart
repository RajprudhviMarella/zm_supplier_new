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
    var authModel;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart'
    };

    final msg = jsonEncode({'ZeemartId': email, 'password': pass});

    var response =
        await http.post(URLEndPoints.login_url, headers: headers, body: msg);
    if (response.statusCode == 200) {
      print(response.body);
      print('Success response');
      authModel = LoginResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to login');
    }

    print('returned');
    return authModel;
  }
}

class getSpecificUser {
  Future<ApiResponse> retriveSpecificUser(
      String supplierId, String mudra) async {
    Map<String, String> queryParams = {'supplierId': supplierId};
    var userModel;
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
    var response = await http.get(requestUrl, headers: headers);

    if (response.statusCode == 200) {
      print(response.body);
      var jsonMap = json.decode(response.body);
      userModel = ApiResponse.fromJson(jsonMap);
    }

    return userModel;
  }
}
