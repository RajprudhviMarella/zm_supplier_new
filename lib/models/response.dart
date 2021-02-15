
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