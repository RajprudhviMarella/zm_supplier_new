import 'package:flutter/material.dart';
import 'package:zm_supplier/models/user.dart';

class ApiResponse {
  ApiResponse({
    this.path,
    this.timestamp,
    this.status,
    this.message,
    this.data,
  });

  String path;
  DateTime timestamp;
  int status;
  String message;
  userData data;

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
        path: json["path"],
        timestamp: DateTime.parse(json["timestamp"]),
        status: json["status"],
        message: json["message"],
        data: userData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "path": path,
        "timestamp": timestamp.toIso8601String(),
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class TokenApiResponse {
  TokenApiResponse({
    this.path,
    this.timestamp,
    this.status,
    this.message,
  });

  String path;
  DateTime timestamp;
  int status;
  String message;

  factory TokenApiResponse.fromJson(Map<String, dynamic> json) =>
      TokenApiResponse(
        path: json["path"],
        timestamp: DateTime.parse(json["timestamp"]),
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "path": path,
        "timestamp": timestamp.toIso8601String(),
        "status": status,
        "message": message,
      };
}

class NotificationUri {
  NotificationUri({this.type, this.parameters});
  String type;
  UriParams parameters;

  factory NotificationUri.fromJson(Map<String, dynamic> json) =>
      NotificationUri(
          type: json["type"],
          parameters: UriParams.fromJson(json["parameters"]));

  Map<String, dynamic> toJson() => {"type": type, "parameters": parameters};
}

class UriParams {
  UriParams({this.orderId, this.orderStatus});

  String orderId;
  String orderStatus;

  factory UriParams.fromJson(Map<String, dynamic> json) =>
      UriParams(orderId: json["orderId"], orderStatus: json["orderStatus"]);

  Map<String, dynamic> toJson() =>
      {"orderId": orderId, "orderStatus": orderStatus};
}
