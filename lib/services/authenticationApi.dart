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
    var authModel = LoginResponse();

    var client = http.Client();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart'
    };

    final msg = jsonEncode({'ZeemartId': email, 'password': pass});

    print(headers);
    print(msg);
    print(URLEndPoints.login_url);
    //try {
    //    await client
    //        .post(URLEndPoints.login_url, headers: headers, body: msg)
    //        .then((response) {
    var response =
        await client.post(URLEndPoints.login_url, headers: headers, body: msg);
    print(response.toString());
    if (response.statusCode == 200) {
      print(response.body);
      print('Success response');
      var jsonString = response.body;
      var jsonMap = json.decode(response.body);
      print(jsonMap.toString());
      authModel = LoginResponse.fromJson(json.decode(response.body));
      return authModel;
    } else {
      return authModel;
      throw Exception('Failed to login');
    }
  }
}

class getSpecificUser {
  Future<ApiResponse> retriveSpecificUser(
      String supplierId, String mudra, String userID) async {
    Map<String, String> queryParams = {'userId': userID};
    var userModel = null;
    String queryString = Uri(queryParameters: queryParams).query;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart',
      'mudra': mudra,
      'supplierId': supplierId
    };

    print(headers);
    var requestUrl =
        URLEndPoints.get_specific_user_login_url + '?' + queryString;
    print(requestUrl);
    try {
      var response = await http.get(requestUrl, headers: headers);
      // await http.get(requestUrl, headers: headers).then((response) {
      if (response.statusCode == 200) {
        print(response.body);
        var jsonString = response.body;
        var jsonMap = json.decode(response.body);
        userModel = ApiResponse.fromJson(jsonMap);
        // return userModel;
      } else {
        throw Exception('Failed to login');
      }
      //  });
    } catch (Exception) {
      // return userModel;
    }
    return userModel;
  }
}

class TokenAuthentication {
  Future<TokenApiResponse> authenticateToken(String supplierId, String mudra,
      String userID, String token, String market) async {
    var authModel = TokenApiResponse();

    var client = http.Client();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart',
      'mudra': mudra,
      'supplierId': supplierId
    };

    final msg = jsonEncode({
      'deviceToken': token,
      'userId': userID,
      'platform': 'GCM',
      'market': market,
      'appName': 'supplier'
    });

    print(headers);
    print(msg);
    print(URLEndPoints.register_device_url);
    //try {
    //    await client
    //        .post(URLEndPoints.login_url, headers: headers, body: msg)
    //        .then((response) {
    var response = await client.post(URLEndPoints.register_device_url,
        headers: headers, body: msg);
    print(response.toString());
    if (response.statusCode == 200) {
      print(response.body);
      print('Success response');
      var jsonString = response.body;
      var jsonMap = json.decode(response.body);
      print(jsonMap.toString());
      authModel = TokenApiResponse.fromJson(json.decode(response.body));
      return authModel;
    } else {
      return authModel;
      throw Exception('Failed to registred token');
    }
  }

  Future<TokenApiResponse> unregisterToken(
      String supplierId, String mudra, String token, String market) async {
    var authModel = TokenApiResponse();

    var client = http.Client();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart',
      'mudra': mudra,
      'supplierId': supplierId
    };

    final msg = jsonEncode({
      'deviceToken': token,
      'platform': 'GCM',
      'market': market,
      'appName': 'supplier'
    });

    print(headers);
    print(msg);
    print(URLEndPoints.register_device_url);
    //try {
    //    await client
    //        .post(URLEndPoints.login_url, headers: headers, body: msg)
    //        .then((response) {
    var response = await client.post(URLEndPoints.register_device_url,
        headers: headers, body: msg);
    print(response.toString());
    if (response.statusCode == 200) {
      print(response.body);
      print('Success response');
      var jsonString = response.body;
      var jsonMap = json.decode(response.body);
      print(jsonMap.toString());
      authModel = TokenApiResponse.fromJson(json.decode(response.body));
      return authModel;
    } else {
      return authModel;
      throw Exception('Failed to registred token');
    }
  }
}
