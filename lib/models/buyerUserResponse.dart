

import 'ordersResponseList.dart';

class BuyerUserResponse {
  BuyerUserResponse({
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
  Data data;

  factory BuyerUserResponse.fromJson(Map<String, dynamic> json) => BuyerUserResponse(
    path: json["path"],
    timestamp: DateTime.parse(json["timestamp"]),
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "path": path,
    "timestamp": timestamp.toIso8601String(),
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.numberOfPages,
    this.numberOfRecords,
    this.currentPageNumber,
    this.data,
  });

  int numberOfPages;
  int numberOfRecords;
  int currentPageNumber;
  List<BuyerDetails> data;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    numberOfPages: json["numberOfPages"],
    numberOfRecords: json["numberOfRecords"],
    currentPageNumber: json["currentPageNumber"],
    data: List<BuyerDetails>.from(json["data"].map((x) => BuyerDetails.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "numberOfPages": numberOfPages,
    "numberOfRecords": numberOfRecords,
    "currentPageNumber": currentPageNumber,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class BuyerDetails {
  BuyerDetails({
    this.userId,
    this.status,
    this.firstName,
    this.lastName,
    this.fullName,
    this.title,
    this.phone,
    this.email,
    this.age,
    this.imageUrl,
    this.sendToOutletEmail,
    this.trackNotificationsStatus,
    this.company,
    this.outlet,
    this.supplier,
    this.roleGroup,
    this.roles,
    this.supplierRoles,
    this.market,
    this.language,
    this.whatsapp,
    this.source,
    this.lastLoggedIn,
    this.isOnBoard,
    this.lastOrdered,

  });

  String userId;
  String status;
  String firstName;
  String lastName;
  String fullName;
  String title;
  String phone;
  String email;
  int age;
  String imageUrl;
  bool sendToOutletEmail;
  bool trackNotificationsStatus;
  List<Company> company;
  List<Outlet> outlet;
  List<Supplier> supplier;
  String roleGroup;
  List<String> roles;
  List<String> supplierRoles;
  String market;
  String language;
  String whatsapp;
  String source;
  int lastLoggedIn;
  bool isOnBoard;
  int lastOrdered;


  factory BuyerDetails.fromJson(Map<String, dynamic> json) => BuyerDetails(
    userId: json["userId"],
    status: json["status"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    fullName: json["fullName"] == null ? null : json["fullName"],
    title: json["title"],
    phone: json["phone"],
    email: json["email"],
    age: json["age"],
    imageUrl: json["imageURL"],
    sendToOutletEmail: json["sendToOutletEmail"],
    trackNotificationsStatus: json["trackNotificationsStatus"],
    company: List<Company>.from(json["company"].map((x) => Company.fromJson(x))),
    outlet: List<Outlet>.from(json["outlet"].map((x) => Outlet.fromJson(x))),
    supplier: json["supplier"] == null ? null : List<Supplier>.from(json["supplier"].map((x) => Supplier.fromJson(x))),
    roleGroup: json["roleGroup"],
    roles: List<String>.from(json["roles"].map((x) => x)),
    supplierRoles: List<String>.from(json["supplierRoles"].map((x) => x)),
    market: json["market"],
    language: json["language"],
    whatsapp: json["whatsapp"] == null ? null : json["whatsapp"],
    source: json["source"] == null ? null : json["source"],
    lastLoggedIn: json["lastLoggedIn"] == null ? null : json["lastLoggedIn"],
    isOnBoard: json["isOnBoard"],
    lastOrdered: json["lastOrdered"],

  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "status": status,
    "firstName": firstName,
    "lastName": lastName,
    "fullName": fullName == null ? null : fullName,
    "title": title,
    "phone": phone,
    "email": email,
    "age": age,
    "imageURL": imageUrl,
    "sendToOutletEmail": sendToOutletEmail,
    "trackNotificationsStatus": trackNotificationsStatus,
    "company": List<dynamic>.from(company.map((x) => x.toJson())),
    "outlet": List<dynamic>.from(outlet.map((x) => x.toJson())),
    "supplier": supplier == null ? null : List<dynamic>.from(supplier.map((x) => x.toJson())),
    "roleGroup": roleGroup,
    "roles": List<dynamic>.from(roles.map((x) => x)),
    "supplierRoles": List<dynamic>.from(supplierRoles.map((x) => x)),
    "market": market,
    "language": language,
    "whatsapp": whatsapp == null ? null : whatsapp,
    "source": source == null ? null : source,
    "lastLoggedIn": lastLoggedIn == null ? null : lastLoggedIn,
    "isOnBoard": isOnBoard,
    "lastOrdered": lastOrdered,
  };
}
