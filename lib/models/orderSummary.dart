

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
  SummaryData data;

  factory OrderSummaryResponse.fromJson(Map<String, dynamic> json) => OrderSummaryResponse(
    path: json["path"],
    timestamp: DateTime.parse(json["timestamp"]),
    status: json["status"],
    message: json["message"],
    data: SummaryData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "path": path,
    "timestamp": timestamp.toIso8601String(),
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class SummaryData {
  SummaryData({
    this.totalSpendingCurrWeek,
    this.totalSpendingLastWeek,
    this.totalSpendingCurrMonth,
    this.totalSpendingLastMonth,
    this.totalSpendingLastTwoMonths,
    this.todayPendingDeliveries,
    this.goalPercentage,
    this.isGoalActive,
  });

  dynamic totalSpendingCurrWeek;
  dynamic totalSpendingLastWeek;
  dynamic totalSpendingCurrMonth;
  dynamic totalSpendingLastMonth;
  dynamic totalSpendingLastTwoMonths;
  dynamic todayPendingDeliveries;
  dynamic goalPercentage;
  bool isGoalActive;

  factory SummaryData.fromJson(Map<String, dynamic> json) => SummaryData(
    totalSpendingCurrWeek: json["totalSpendingCurrWeek"],
    totalSpendingLastWeek: json["totalSpendingLastWeek"],
    totalSpendingCurrMonth: json["totalSpendingCurrMonth"],
    totalSpendingLastMonth: json["totalSpendingLastMonth"],
    totalSpendingLastTwoMonths: json["totalSpendingLastTwoMonths"],
    todayPendingDeliveries: json["todayPendingDeliveries"],
    goalPercentage: json["goalPercentage"],
    isGoalActive: json["isGoalActive"],
  );

  Map<String, dynamic> toJson() => {
    "totalSpendingCurrWeek": totalSpendingCurrWeek,
    "totalSpendingLastWeek": totalSpendingLastWeek,
    "totalSpendingCurrMonth": totalSpendingCurrMonth,
    "totalSpendingLastMonth": totalSpendingLastMonth,
    "totalSpendingLastTwoMonths": totalSpendingLastTwoMonths,
    "todayPendingDeliveries": todayPendingDeliveries,
    "goalPercentage": goalPercentage,
    "isGoalActive": isGoalActive,
  };
}
