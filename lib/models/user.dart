import 'package:flutter/material.dart';
import 'package:zm_supplier/models/supplier.dart';
import 'package:zm_supplier/models/outletSettings.dart';

class User {
  User({
    this.status,
    this.company,
    this.outlet,
    this.supplier,
    this.roleGroup,
    this.roles,
    this.supplierRoleGroup,
    this.supplierRoles,
    this.market,
    this.language,
    this.outletFeatures,
    this.email,
    this.userId,
  });

  String status;
  List<Company> company;
  List<Outlet> outlet;
  List<Supplier> supplier;
  String roleGroup;
  List<String> roles;
  String supplierRoleGroup;
  List<String> supplierRoles;
  String market;
  String language;
  OutletFeatures outletFeatures;
  String email;
  String userId;

  factory User.fromJson(Map<String, dynamic> json) => User(
        status: json["status"],
        company:
            List<Company>.from(json["company"].map((x) => Company.fromJson(x))),
        outlet:
            List<Outlet>.from(json["outlet"].map((x) => Outlet.fromJson(x))),
        supplier: List<Supplier>.from(
            json["supplier"].map((x) => Supplier.fromJson(x))),
        roleGroup: json["roleGroup"],
        roles: List<String>.from(json["roles"].map((x) => x)),
        supplierRoleGroup: json["supplierRoleGroup"],
        supplierRoles: List<String>.from(json["supplierRoles"].map((x) => x)),
        market: json["market"],
        language: json["language"],
        outletFeatures: OutletFeatures.fromJson(json["outletFeatures"]),
        email: json["email"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "company": List<dynamic>.from(company.map((x) => x.toJson())),
        "outlet": List<dynamic>.from(outlet.map((x) => x.toJson())),
        "supplier": List<dynamic>.from(supplier.map((x) => x.toJson())),
        "roleGroup": roleGroup,
        "roles": List<dynamic>.from(roles.map((x) => x)),
        "supplierRoleGroup": supplierRoleGroup,
        "supplierRoles": List<dynamic>.from(supplierRoles.map((x) => x)),
        "market": market,
        "language": language,
        "outletFeatures": outletFeatures.toJson(),
        "email": email,
        "userId": userId,
      };
}

class LoginResponse {
  LoginResponse({
    this.mudra,
    this.supplier,
    this.language,
    this.market,
    this.restrictedAccess,
    this.status,
    this.user,
  });

  String mudra;
  List<Supplier> supplier;
  String language;
  String market;
  List<String> restrictedAccess;
  String status;
  User user;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        mudra: json["mudra"],
        supplier: List<Supplier>.from(
            json["supplier"].map((x) => Supplier.fromJson(x))),
        language: json["language"],
        market: json["market"],
        restrictedAccess:
            List<String>.from(json["restrictedAccess"].map((x) => x)),
        status: json["status"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "mudra": mudra,
        "supplier": List<dynamic>.from(supplier.map((x) => x.toJson())),
        "language": language,
        "market": market,
        "restrictedAccess": List<dynamic>.from(restrictedAccess.map((x) => x)),
        "status": status,
        "user": user.toJson(),
      };
}

class ChangePasswordResponse {
  ChangePasswordResponse({
    this.status,
  });

  String status;

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) =>
      ChangePasswordResponse(
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
      };
}

class Login {
  String ZeemartId;
  String password;

  Login({
    this.ZeemartId,
    this.password,
  });

  // Login.fromJson(Map<String, dynamic> json) {

  Map<String, dynamic> tojson() {
    Map<String, dynamic> map = {
      'ZeemartId': ZeemartId.trim(),
      'password': password.trim()
    };
  }
}

class ChangePasswordRequest {
  String ZeemartId;
  String password;
  String newPassword;

  ChangePasswordRequest(
    this.ZeemartId,
    this.password,
    this.newPassword,
  );

  // Login.fromJson(Map<String, dynamic> json) {

  Map<String, dynamic> tojson() {
    Map<String, dynamic> map = {
      'userName': ZeemartId,
      'password': password,
      'newPassword': newPassword,
      'clientType': "SUPPLIER"
    };
    return map;
  }
// ZeemartId = json['ZeemartId'],
// password = json['password'];
}

class userData {
  userData({
    this.dateUpdated,
    this.timeUpdated,
    this.updatedBy,
    this.supplierId,
    this.supplierName,
    //  this.address,
    this.alias,
    this.desc,
    this.email,
    this.logoUrl,
    this.market,
    this.phone,
    this.regNo,
    //this.settings,
    this.shortDesc,
    this.showPrice,
    this.supplierIntegrationEnabled,
    this.isActive,
    this.status,
    this.timePublished,
  });

  String dateUpdated;
  int timeUpdated;
  UpdatedBy updatedBy;
  String supplierId;
  String supplierName;

  // Address address;
  String alias;
  String desc;
  String email;
  String logoUrl;
  String market;
  String phone;
  String regNo;

  //Settings settings;
  String shortDesc;
  bool showPrice;
  bool supplierIntegrationEnabled;
  bool isActive;
  String status;
  int timePublished;

  factory userData.fromJson(Map<String, dynamic> json) => userData(
        dateUpdated: json["dateUpdated"],
        timeUpdated: json["timeUpdated"],
        updatedBy: UpdatedBy.fromJson(json["updatedBy"]),
        supplierId: json["supplierId"],
        supplierName: json["supplierName"],
        // address: Address.fromJson(json["address"]),
        alias: json["alias"],
        desc: json["desc"],
        email: json["email"],
        logoUrl: json["logoURL"],
        market: json["market"],
        phone: json["phone"],
        regNo: json["regNo"],
        //settings: Settings.fromJson(json["settings"]),
        shortDesc: json["shortDesc"],
        showPrice: json["showPrice"],
        supplierIntegrationEnabled: json["supplierIntegrationEnabled"],
        isActive: json["isActive"],
        status: json["status"],
        timePublished: json["timePublished"],
      );

  Map<String, dynamic> toJson() => {
        "dateUpdated": dateUpdated,
        "timeUpdated": timeUpdated,
        "updatedBy": updatedBy.toJson(),
        "supplierId": supplierId,
        "supplierName": supplierName,
        //"address": address.toJson(),
        "alias": alias,
        "desc": desc,
        "email": email,
        "logoURL": logoUrl,
        "market": market,
        "phone": phone,
        "regNo": regNo,
        //"settings": settings.toJson(),
        "shortDesc": shortDesc,
        "showPrice": showPrice,
        "supplierIntegrationEnabled": supplierIntegrationEnabled,
        "isActive": isActive,
        "status": status,
        "timePublished": timePublished,
      };
}
