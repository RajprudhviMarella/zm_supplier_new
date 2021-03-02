import 'dart:math';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:zm_supplier/models/customersResponse.dart';
import 'dart:convert';
import 'dart:async';
import 'package:zm_supplier/utils/urlEndPoints.dart';

class FavouritesApi {
  Future<CustomersResponse> updateFavourite(
      String mudra, String supplierId, String outletId, bool isFav) async {
    var resetPasswordModel = null;

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
    var url = URLEndPoints.favourite_url + '?' + queryString;

    final body = jsonEncode([
      {
        'outletId': outletId,
        'isFavourite': isFav,
      }
    ]);

    var response = await http.put(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      resetPasswordModel =
          CustomersResponse.fromJson(json.decode(response.body));
    } else {
      print('failed to update favourite');
    }
    return resetPasswordModel;
  }
}
