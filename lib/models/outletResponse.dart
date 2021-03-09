class StarredOutletList {
  String path;
  String timestamp;
  int status;
  String message;
  List<FavouriteOutletsList> data;

  StarredOutletList(
      {this.path, this.timestamp, this.status, this.message, this.data});

  StarredOutletList.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    timestamp = json['timestamp'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<FavouriteOutletsList>();
      json['data'].forEach((v) {
        data.add(new FavouriteOutletsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['path'] = this.path;
    data['timestamp'] = this.timestamp;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FavouriteOutletsList {
  Outlet outlet;
  bool isFavourite;

  FavouriteOutletsList({this.outlet, this.isFavourite});

  FavouriteOutletsList.fromJson(Map<String, dynamic> json) {
    outlet =
        json['outlet'] != null ? new Outlet.fromJson(json['outlet']) : null;
    isFavourite = json['isFavourite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.outlet != null) {
      data['outlet'] = this.outlet.toJson();
    }
    data['isFavourite'] = this.isFavourite;
    return data;
  }
}

class Outlet {
  String outletId;
  String outletName;
  Company company;
  Settings settings;
  String logoUrl;

  Outlet(
      {this.outletId,
      this.outletName,
      this.company,
      this.settings,
      this.logoUrl});

  Outlet.fromJson(Map<String, dynamic> json) {
    outletId = json['outletId'];
    outletName = json['outletName'];
    logoUrl = json["logoURL"];
    company =
        json['company'] != null ? new Company.fromJson(json['company']) : null;
    settings = json['settings'] != null
        ? new Settings.fromJson(json['settings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['outletId'] = this.outletId;
    data['logoURL'] = this.logoUrl;
    data['outletName'] = this.outletName;
    if (this.company != null) {
      data['company'] = this.company.toJson();
    }
    if (this.settings != null) {
      data['settings'] = this.settings.toJson();
    }
    return data;
  }
}

class Company {
  String companyId;
  String companyName;

  Company({this.companyId, this.companyName});

  Company.fromJson(Map<String, dynamic> json) {
    companyId = json['companyId'];
    companyName = json['companyName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyId'] = this.companyId;
    data['companyName'] = this.companyName;
    return data;
  }
}

class Settings {
  String timeZone;
  String language;
  bool enableSpecialRequest;
  bool enableDeliveryInstruction;
  bool viewDeals;
  bool viewEssentials;

  Settings(
      {this.timeZone,
      this.language,
      this.enableSpecialRequest,
      this.enableDeliveryInstruction,
      this.viewDeals,
      this.viewEssentials});

  Settings.fromJson(Map<String, dynamic> json) {
    timeZone = json['timeZone'];
    language = json['language'];
    enableSpecialRequest = json['enableSpecialRequest'];
    enableDeliveryInstruction = json['enableDeliveryInstruction'];
    viewDeals = json['viewDeals'];
    viewEssentials = json['viewEssentials'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['timeZone'] = this.timeZone;
    data['language'] = this.language;
    data['enableSpecialRequest'] = this.enableSpecialRequest;
    data['enableDeliveryInstruction'] = this.enableDeliveryInstruction;
    data['viewDeals'] = this.viewDeals;
    data['viewEssentials'] = this.viewEssentials;
    return data;
  }
}
class SpecificOutletResponse {
  SpecificOutletResponse({
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
  List<Outlet> data;

  factory SpecificOutletResponse.fromJson(Map<String, dynamic> json) => SpecificOutletResponse(
    path: json["path"],
    timestamp: DateTime.parse(json["timestamp"]),
    status: json["status"],
    message: json["message"],
    data: List<Outlet>.from(json["data"].map((x) => Outlet.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "path": path,
    "timestamp": timestamp.toIso8601String(),
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}
