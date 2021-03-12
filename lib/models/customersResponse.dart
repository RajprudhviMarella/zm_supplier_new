

import 'ordersResponseList.dart';

class CustomersResponse {
  CustomersResponse({
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
  List<Customers> data;

  factory CustomersResponse.fromJson(Map<String, dynamic> json) => CustomersResponse(
    path: json["path"],
    timestamp: DateTime.parse(json["timestamp"]),
    status: json["status"],
    message: json["message"],
    data: List<Customers>.from(json["data"].map((x) => Customers.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "path": path,
    "timestamp": timestamp.toIso8601String(),
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Customers {
  Customers({
    this.timeCreated,
    this.timeUpdated,
    this.timeDeleted,
    this.outlet,
    this.supplier,
    this.status,
    this.customOutletId,
    this.customBillingId,
    this.lastOrdered,
    this.useDefault,
    this.orderDisabled,
    this.disableCancel,
    this.paymentDue,
    //this.customFields,
    this.invoiceSettings,
    //this.supplierSetting,
    this.linkedUsers,
   // this.teams,
    this.isFavourite,
    this.odpId,
   // this.payments,
  });

  int timeCreated;
  int timeUpdated;
  int timeDeleted;
  Outlet outlet;
  Supplier supplier;
  String status;
  String customOutletId;
  String customBillingId;
  int lastOrdered;
  bool useDefault;
  bool orderDisabled;
  bool disableCancel;
  double paymentDue;
 // CustomFields customFields;
  InvoiceSettings invoiceSettings;
 // SupplierSetting supplierSetting;
  List<LinkedUser> linkedUsers;
 // List<Team> teams;
  bool isFavourite;
  String odpId;
  //Payments payments;

  factory Customers.fromJson(Map<String, dynamic> json) => Customers(
    timeCreated: json["timeCreated"],
    timeUpdated: json["timeUpdated"],
    timeDeleted: json["timeDeleted"] == null ? null : json["timeDeleted"],
    outlet: Outlet.fromJson(json["outlet"]),
    supplier: Supplier.fromJson(json["supplier"]),
    status: json["status"],
    customOutletId: json["customOutletId"] == null ? null : json["customOutletId"],
    customBillingId: json["customBillingId"] == null ? null : json["customBillingId"],
    lastOrdered: json["lastOrdered"],
    useDefault: json["useDefault"],
    orderDisabled: json["orderDisabled"],
    disableCancel: json["disableCancel"],
    paymentDue: json["paymentDue"] == null ? null : json["paymentDue"].toDouble(),
   // customFields: json["customFields"] == null ? null : CustomFields.fromJson(json["customFields"]),
    invoiceSettings: json["invoiceSettings"] == null ? null : InvoiceSettings.fromJson(json["invoiceSettings"]),
    //supplierSetting: SupplierSetting.fromJson(json["supplierSetting"]),
    linkedUsers: json["linkedUsers"] == null ? null : List<LinkedUser>.from(json["linkedUsers"].map((x) => LinkedUser.fromJson(x))),
    //teams: json["teams"] == null ? null : List<Team>.from(json["teams"].map((x) => Team.fromJson(x))),
    isFavourite: json["isFavourite"],
    odpId: json["odpId"],
   // payments: json["payments"] == null ? null : Payments.fromJson(json["payments"]),
  );

  Map<String, dynamic> toJson() => {
    "timeCreated": timeCreated,
    "timeUpdated": timeUpdated,
    "timeDeleted": timeDeleted == null ? null : timeDeleted,
    "outlet": outlet.toJson(),
    "supplier": supplier.toJson(),
    "status": status,
    "customOutletId": customOutletId == null ? null : customOutletId,
    "customBillingId": customBillingId == null ? null : customBillingId,
    "lastOrdered": lastOrdered,
    "useDefault": useDefault,
    "orderDisabled": orderDisabled,
    "disableCancel": disableCancel,
    "paymentDue": paymentDue == null ? null : paymentDue,
   // "customFields": customFields == null ? null : customFields.toJson(),
    "invoiceSettings": invoiceSettings == null ? null : invoiceSettings.toJson(),
    //"supplierSetting": supplierSetting.toJson(),
    "linkedUsers": linkedUsers == null ? null : List<dynamic>.from(linkedUsers.map((x) => x.toJson())),
    //"teams": teams == null ? null : List<dynamic>.from(teams.map((x) => x.toJson())),
    "isFavourite": isFavourite,
    "odpId": odpId,
    //"payments": payments == null ? null : payments.toJson(),
  };
}

class InvoiceSettings {
  InvoiceSettings({
    this.notes,
    this.paymentTerms,
    this.recipientEmail,
    this.salesPerson,
  });

  String notes;
  String paymentTerms;
  String recipientEmail;
  SalesPerson salesPerson;

  factory InvoiceSettings.fromJson(Map<String, dynamic> json) => InvoiceSettings(
    notes: json["notes"],
    paymentTerms: json["paymentTerms"],
    recipientEmail: json["recipientEmail"],
    salesPerson: SalesPerson.fromJson(json["salesPerson"]),
  );

  Map<String, dynamic> toJson() => {
    "notes": notes,
    "paymentTerms": paymentTerms,
    "recipientEmail": recipientEmail,
    "salesPerson": salesPerson.toJson(),
  };
}
class SalesPerson {
  SalesPerson({
    this.name,
    this.phone,
  });

  String name;
  String phone;

  factory SalesPerson.fromJson(Map<String, dynamic> json) => SalesPerson(
    name: json["name"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "phone": phone,
  };
}

class LinkedUser {
  LinkedUser({
    this.id,
    this.firstName,
    this.lastName,
    this.imageUrl,
    this.phone,
    this.roles,
    this.roleGroup,
    this.supplierRoleGroup,
    this.supplierRoles,
  });

  String id;
  String firstName;
  String lastName;
  String imageUrl;
  String phone;
  List<String> roles;
  String roleGroup;
  String supplierRoleGroup;
  List<String> supplierRoles;

  factory LinkedUser.fromJson(Map<String, dynamic> json) => LinkedUser(
    id: json["id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    imageUrl: json["imageURL"] == null ? null : json["imageURL"],
    phone: json["phone"],
    roles: List<String>.from(json["roles"].map((x) => x)),
    roleGroup: json["roleGroup"],
    supplierRoleGroup: json["supplierRoleGroup"],
    supplierRoles: json["supplierRoles"] == null ? null : List<String>.from(json["supplierRoles"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "imageURL": imageUrl == null ? null : imageUrl,
    "phone": phone,
    "roles": List<dynamic>.from(roles.map((x) => x)),
    "roleGroup": roleGroup,
    "supplierRoleGroup": supplierRoleGroup,
    "supplierRoles": supplierRoles == null ? null : List<dynamic>.from(supplierRoles.map((x) => x)),
  };
}

class CustomersReportResponse {
  CustomersReportResponse({
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
  List<CustomersData> data;

  factory CustomersReportResponse.fromJson(Map<String, dynamic> json) => CustomersReportResponse(
    path: json["path"],
    timestamp: DateTime.parse(json["timestamp"]),
    status: json["status"],
    message: json["message"],
    data: List<CustomersData>.from(json["data"].map((x) => CustomersData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "path": path,
    "timestamp": timestamp.toIso8601String(),
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class CustomersData {
  CustomersData({
    this.customerType,
    this.count,
    this.outlets,
  });

  String customerType;
  int count;
  List<Customers> outlets;

  factory CustomersData.fromJson(Map<String, dynamic> json) => CustomersData(
    customerType: json["customerType"],
    count: json["count"],
    outlets: List<Customers>.from(json["outlets"].map((x) => Customers.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "customerType": customerType,
    "count": count,
    "outlets": List<dynamic>.from(outlets.map((x) => x.toJson())),
  };
}
/*
class CustomersData {
  CustomersData({
    this.allCustomers,
    this.favouriteCustomers,
    this.currentWeekOrderedCustomers,
    this.lastWeekOrderedCustomers,
    this.noRecentOrderedCustomers,
  });

  CustomersReport allCustomers;
  CustomersReport favouriteCustomers;
  CustomersReport currentWeekOrderedCustomers;
  CustomersReport lastWeekOrderedCustomers;
  CustomersReport noRecentOrderedCustomers;

  factory CustomersData.fromJson(Map<String, dynamic> json) => CustomersData(
    allCustomers: CustomersReport.fromJson(json["allCustomers"]),
    favouriteCustomers: CustomersReport.fromJson(json["favouriteCustomers"]),
    currentWeekOrderedCustomers: CustomersReport.fromJson(json["currentWeekOrderedCustomers"]),
    lastWeekOrderedCustomers: CustomersReport.fromJson(json["lastWeekOrderedCustomers"]),
    noRecentOrderedCustomers: CustomersReport.fromJson(json["noRecentOrderedCustomers"]),
  );

  Map<String, dynamic> toJson() => {
    "allCustomers": allCustomers.toJson(),
    "favouriteCustomers": favouriteCustomers.toJson(),
    "currentWeekOrderedCustomers": currentWeekOrderedCustomers.toJson(),
    "lastWeekOrderedCustomers": lastWeekOrderedCustomers.toJson(),
    "noRecentOrderedCustomers": noRecentOrderedCustomers.toJson(),
  };
}*/
//
// class CustomersReport {
//   CustomersReport({
//     this.count,
//     this.outlets,
//   });
//
//   int count;
//   List<Outlet> outlets;
//
//   factory CustomersReport.fromJson(Map<String, dynamic> json) => CustomersReport(
//     count: json["count"],
//     outlets: List<Outlet>.from(json["outlets"].map((x) => Outlet.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "count": count,
//     "outlets": List<dynamic>.from(outlets.map((x) => x.toJson())),
//   };
// }
