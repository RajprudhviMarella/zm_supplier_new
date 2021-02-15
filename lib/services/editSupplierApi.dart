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
}
