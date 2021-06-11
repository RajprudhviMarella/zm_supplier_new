

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
    this.totalSpendingCurrDay,
    this.totalSpendingLastWeek,
    this.totalSpendingCurrMonth,
    this.totalSpendingLastMonth,
    this.totalSpendingLastTwoMonths,
    this.totalSpendingQuarterly,
    this.todayPendingDeliveries,
    this.goalPercentage,
    this.isGoalActive,
    this.teamsSummary,
  });

  dynamic totalSpendingCurrWeek;
  dynamic totalSpendingCurrDay;
  dynamic totalSpendingLastWeek;
  dynamic totalSpendingCurrMonth;
  dynamic totalSpendingLastMonth;
  dynamic totalSpendingLastTwoMonths;
  dynamic totalSpendingQuarterly;
  dynamic todayPendingDeliveries;
  dynamic goalPercentage;
  bool isGoalActive;
  List<TeamsSummary> teamsSummary;


  factory SummaryData.fromJson(Map<String, dynamic> json) => SummaryData(
    totalSpendingCurrWeek: json["totalSpendingCurrWeek"],
    totalSpendingCurrDay: json["totalSpendingCurrDay"],
    totalSpendingLastWeek: json["totalSpendingLastWeek"],
    totalSpendingCurrMonth: json["totalSpendingCurrMonth"],
    totalSpendingLastMonth: json["totalSpendingLastMonth"],
    totalSpendingLastTwoMonths: json["totalSpendingLastTwoMonths"],
    totalSpendingQuarterly: json["totalSpendingQuarterly"],
    todayPendingDeliveries: json["todayPendingDeliveries"],
    goalPercentage: json["goalPercentage"],
    isGoalActive: json["isGoalActive"],
    teamsSummary: List<TeamsSummary>.from(json["teamsSummary"].map((x) => TeamsSummary.fromJson(x))),

  );

  Map<String, dynamic> toJson() => {
    "totalSpendingCurrWeek": totalSpendingCurrWeek,
    "totalSpendingCurrDay": totalSpendingCurrDay,
    "totalSpendingLastWeek": totalSpendingLastWeek,
    "totalSpendingCurrMonth": totalSpendingCurrMonth,
    "totalSpendingLastMonth": totalSpendingLastMonth,
    "totalSpendingLastTwoMonths": totalSpendingLastTwoMonths,
    "totalSpendingQuarterly": totalSpendingQuarterly,
    "todayPendingDeliveries": todayPendingDeliveries,
    "goalPercentage": goalPercentage,
    "isGoalActive": isGoalActive,
    "teamsSummary": List<dynamic>.from(teamsSummary.map((x) => x.toJson())),

  };
}

class TeamsSummary {
  TeamsSummary({
    this.teamId,
    this.name,
    this.totalSpendingCurrWeek,
    this.totalSpendingCurrMonth,
    this.totalSpendingQuarterly,
    this.todayPendingDeliveries,
    this.goalPercentage,
    this.isGoalActive,
  });

  String teamId;
  String name;
  dynamic totalSpendingCurrWeek;
  dynamic totalSpendingCurrMonth;
  dynamic totalSpendingQuarterly;
  dynamic todayPendingDeliveries;
  dynamic goalPercentage;
  bool isGoalActive;

  factory TeamsSummary.fromJson(Map<String, dynamic> json) => TeamsSummary(
    teamId: json["teamId"],
    name: json["name"],
    totalSpendingCurrWeek: json["totalSpendingCurrWeek"],
    totalSpendingCurrMonth: json["totalSpendingCurrMonth"],
    totalSpendingQuarterly: json["totalSpendingQuarterly"].toDouble(),
    todayPendingDeliveries: json["todayPendingDeliveries"],
    goalPercentage: json["goalPercentage"],
    isGoalActive: json["isGoalActive"],
  );

  Map<String, dynamic> toJson() => {
    "teamId": teamId,
    "name": name,
    "totalSpendingCurrWeek": totalSpendingCurrWeek,
    "totalSpendingCurrMonth": totalSpendingCurrMonth,
    "totalSpendingQuarterly": totalSpendingQuarterly,
    "todayPendingDeliveries": todayPendingDeliveries,
    "goalPercentage": goalPercentage,
    "isGoalActive": isGoalActive,
  };
}

