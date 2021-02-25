
// To parse this JSON data, do
//
//     final activityResponse = activityResponseFromJson(jsonString);

import 'dart:convert';

ActivityResponse activityResponseFromJson(String str) => ActivityResponse.fromJson(json.decode(str));

String activityResponseToJson(ActivityResponse data) => json.encode(data.toJson());

class ActivityResponse {
  ActivityResponse({
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
  List<ActivityData> data;

  factory ActivityResponse.fromJson(Map<String, dynamic> json) => ActivityResponse(
    path: json["path"],
    timestamp: DateTime.parse(json["timestamp"]),
    status: json["status"],
    message: json["message"],
    data: List<ActivityData>.from(json["data"].map((x) => ActivityData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "path": path,
    "timestamp": timestamp.toIso8601String(),
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class ActivityData {
  ActivityData({
    this.orderId,
    this.activity,
    this.timeActivity,
    this.timeActivityMilli,
    this.activityMessage,
    this.activityRemark,
    this.id,
    this.activityUser,
  });

  String orderId;
  String activity;
  int timeActivity;
  int timeActivityMilli;
  String activityMessage;
  String activityRemark;
  String id;
  ActivityUser activityUser;

  factory ActivityData.fromJson(Map<String, dynamic> json) => ActivityData(
    orderId: json["orderId"],
    activity: json["activity"],
    timeActivity: json["timeActivity"],
    timeActivityMilli: json["timeActivityMilli"],
    activityMessage: json["activityMessage"],
    activityRemark: json["activityRemark"],
    id: json["id"],
    activityUser: json["activityUser"] == null ? null : ActivityUser.fromJson(json["activityUser"]),
  );

  Map<String, dynamic> toJson() => {
    "orderId": orderId,
    "activity": activity,
    "timeActivity": timeActivity,
    "timeActivityMilli": timeActivityMilli,
    "activityMessage": activityMessage,
    "activityRemark": activityRemark,
    "id": id,
    "activityUser": activityUser == null ? null : activityUser.toJson(),
  };
}

class ActivityUser {
  ActivityUser({
    this.id,
    this.firstName,
    this.lastName,
    this.imageUrl,
    this.phone,
  });

  String id;
  String firstName;
  String lastName;
  String imageUrl;
  String phone;

  factory ActivityUser.fromJson(Map<String, dynamic> json) => ActivityUser(
    id: json["id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    imageUrl: json["imageURL"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "imageURL": imageUrl,
    "phone": phone,
  };
}

