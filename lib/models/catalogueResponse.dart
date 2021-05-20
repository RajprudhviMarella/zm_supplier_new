
import 'package:intl/intl.dart';
import 'package:zm_supplier/models/products.dart';

class CatalogueBaseResponse {
  CatalogueBaseResponse({
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
  CatalogueResponse data;

  factory CatalogueBaseResponse.fromJson(Map<String, dynamic> json) =>
      CatalogueBaseResponse(
        path: json["path"],
        timestamp: DateTime.parse(json["timestamp"]),
        status: json["status"],
        message: json["message"],
        data: CatalogueResponse.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "path": path,
    "timestamp": timestamp.toIso8601String(),
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class CatalogueResponse {
  CatalogueResponse({
    this.numberOfPages,
    this.numberOfRecords,
    this.currentPageNumber,
    this.data,
  });

  int numberOfPages;
  int numberOfRecords;
  int currentPageNumber;
  List<CatalogueProducts> data;

  factory CatalogueResponse.fromJson(Map<String, dynamic> json) => CatalogueResponse(
      numberOfPages: json["numberOfPages"],
      currentPageNumber: json["currentPageNumber"],
      numberOfRecords: json["numberOfRecords"],
      data: List<CatalogueProducts>.from(json["data"].map((x) => CatalogueProducts.fromJson(x))));

  Map<String, dynamic> toJson() => {
    "numberOfPages": numberOfPages,
    "currentPageNumber": currentPageNumber,
    "numberOfRecords": numberOfRecords,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}
