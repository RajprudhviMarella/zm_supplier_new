
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:zm_supplier/models/customersResponse.dart';
import 'package:zm_supplier/models/ordersResponseList.dart';
import 'package:zm_supplier/utils/constants.dart';
import 'dart:convert';
import 'dart:async';
import 'package:zm_supplier/utils/urlEndPoints.dart';

class OrderApi {
  Future<String> acknowledgeOrder(
      String mudra, String supplierId, String orderId) async {
    String status;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authType': 'Zeemart',
      'mudra': mudra,
      'supplierId': supplierId
    };

    Map<String, String> queryParams = {
      'supplierId': supplierId,
    };
    String queryString = Uri(queryParameters: queryParams).query;
    var url = URLEndPoints.acknowledge_order + '?' + queryString;

    final body = jsonEncode([
        orderId,
    ]);

    print(url);
    print(body);
    var response = await http.put(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      status = Constants.status_success;
    } else {
      print('failed to acknowledge');
      status = '';
    }
    return status;
  }
}
