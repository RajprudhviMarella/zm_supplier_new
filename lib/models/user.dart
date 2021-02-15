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

// LoginResponse(
//       {this.mudra, this.supplier, this.language, this.market, this.restrictedAccess});
//
//   LoginResponse.fromJson(Map<String, dynamic> json) {
//     mudra = json['mudra'];
//     supplier = json['supplier'];
//     language = json['language'];
//     market = json['market'];
//     restrictedAccess = json['restrictedAccess'];
//   }
// }

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
// ZeemartId = json['ZeemartId'],
// password = json['password'];
}

//}
