

import 'package:zm_supplier/models/response.dart';

class OrderSummaryResponse {
  OrderSummaryResponse({
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
  summaryData data;

  factory OrderSummaryResponse.fromJson(Map<String, dynamic> json) => OrderSummaryResponse(
    path: json["path"],
    timestamp: DateTime.parse(json["timestamp"]),
    status: json["status"],
    message: json["message"],
    data: summaryData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "path": path,
    "timestamp": timestamp.toIso8601String(),
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class summaryData {
  summaryData({
    this.totalSpendingCurrWeek,
    this.totalSpendingLastWeek,
    this.totalSpendingCurrMonth,
    this.totalSpendingLastMonth,
    this.todayPendingDeliveries,
  });

  double totalSpendingCurrWeek;
  double totalSpendingLastWeek;
  double totalSpendingCurrMonth;
  double totalSpendingLastMonth;
  int todayPendingDeliveries;

  factory summaryData.fromJson(Map<String, dynamic> json) => summaryData(
    totalSpendingCurrWeek: json["totalSpendingCurrWeek"],
    totalSpendingLastWeek: json["totalSpendingLastWeek"],
    totalSpendingCurrMonth: json["totalSpendingCurrMonth"],
    totalSpendingLastMonth: json["totalSpendingLastMonth"],
    todayPendingDeliveries: json["todayPendingDeliveries"],
  );

  Map<String, dynamic> toJson() => {
    "totalSpendingCurrWeek": totalSpendingCurrWeek,
    "totalSpendingLastWeek": totalSpendingLastWeek,
    "totalSpendingCurrMonth": totalSpendingCurrMonth,
    "totalSpendingLastMonth": totalSpendingLastMonth,
    "todayPendingDeliveries": todayPendingDeliveries,
  };
}
