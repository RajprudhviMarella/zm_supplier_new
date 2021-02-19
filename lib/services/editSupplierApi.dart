import 'package:flutter/material.dart';
import 'package:zm_supplier/models/user.dart';

import '../models/user.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:zm_supplier/utils/urlEndPoints.dart';

import '../utils/urlEndPoints.dart';

/**
 * Created by RajPrudhviMarella on 15/Feb/2021.
 */

class EditSupplierDetails {
  String MudhraToken, EmailId;

  Future<ChangePasswordResponse> changePassword(String password,
      String newPassword, String mudraID, String UseriD) async {
    var authModel;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart',
      'mudra': mudraID
    };
    final msg = jsonEncode(
        ChangePasswordRequest(UseriD, password, newPassword).tojson());
    print("header" + json.encode(headers));
    print("body" + json.encode(msg));
    print("body" + URLEndPoints.change_password);

    var response = await http.post(URLEndPoints.change_password,
        headers: headers, body: msg);

    authModel = ChangePasswordResponse.fromJson(json.decode(response.body));

    print('returned');
    return authModel;
  }

  Future<statusSuccessResponse> createPassword(
      String userId, String newPassword, String verificationCode) async {
    var authModel;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart',
    };

    final params = jsonEncode(
        CreatePasswordRequest(userId, newPassword, verificationCode).tojson());
    print("header" + json.encode(headers));
    print("body" + json.encode(params));
    print("body" + URLEndPoints.create_password);

    try {
      await http
          .post(URLEndPoints.create_password, headers: headers, body: params)
          .then((response) {
        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 202) {
          authModel =
              statusSuccessResponse.fromJson(json.decode(response.body));

          print('response' + response.toString());
        } else {
          print('failed to create password');
        }
      });
    } catch (Exception) {
      print('cache');
    }
    return authModel;
  }
}
