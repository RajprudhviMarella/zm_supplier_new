
import 'package:intl/intl.dart';

import 'ordersResponseList.dart';

class InvoicesResponse {
  InvoicesResponse({
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
  PageData data;

  factory InvoicesResponse.fromJson(Map<String, dynamic> json) => InvoicesResponse(
    path: json["path"],
    timestamp: DateTime.parse(json["timestamp"]),
    status: json["status"],
    message: json["message"],
    data: PageData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "path": path,
    "timestamp": timestamp.toIso8601String(),
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class PageData {
  PageData({
    this.numberOfPages,
    this.numberOfRecords,
    this.currentPageNumber,
    this.data,
  });

  int numberOfPages;
  int numberOfRecords;
  int currentPageNumber;
  List<Invoices> data;

  factory PageData.fromJson(Map<String, dynamic> json) => PageData(
    numberOfPages: json["numberOfPages"],
    numberOfRecords: json["numberOfRecords"],
    currentPageNumber: json["currentPageNumber"],
    data: List<Invoices>.from(json["data"].map((x) => Invoices.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "numberOfPages": numberOfPages,
    "numberOfRecords": numberOfRecords,
    "currentPageNumber": currentPageNumber,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}



class Invoices {
  Invoices({
    this.invoiceId,
    this.status,
    this.ocrStatus,
    this.outlet,
    this.supplier,
    this.invoiceNum,
    this.invoiceDate,
    this.paymentDueDate,
    this.paymentTerms,
    this.gstPercentage,
    this.totalCharge,
    this.timeLastUpdated,
    this.invoiceType,
    this.supplierExportedBy,
    this.timeSupplierExported,
    this.isSupplierExported,
  });

  String invoiceId;
  String status;
  String ocrStatus;
  Outlet outlet;
  Supplier supplier;
  String invoiceNum;
  int invoiceDate;
  int paymentDueDate;
  String paymentTerms;
  int gstPercentage;
  TotalCharge totalCharge;
  int timeLastUpdated;
  String invoiceType;
  SupplierExportedBy supplierExportedBy;
  int timeSupplierExported;
  bool isSupplierExported;

  factory Invoices.fromJson(Map<String, dynamic> json) => Invoices(
    invoiceId: json["invoiceId"],
    status: json["status"],
    ocrStatus: json["ocrStatus"],
    outlet: Outlet.fromJson(json["outlet"]),
    supplier: Supplier.fromJson(json["supplier"]),
    invoiceNum: json["invoiceNum"],
    invoiceDate: json["invoiceDate"],
    paymentDueDate: json["paymentDueDate"],
    paymentTerms: json["paymentTerms"],
    gstPercentage: json["gstPercentage"],
    totalCharge: json["totalCharge"] == null ? null : TotalCharge.fromJson(json["totalCharge"]),
    timeLastUpdated: json["timeLastUpdated"] == null ? null : json["timeLastUpdated"],
    invoiceType: json["invoiceType"],
    supplierExportedBy: json["supplierExportedBy"] == null ? null : SupplierExportedBy.fromJson(json["supplierExportedBy"]),
    timeSupplierExported: json["timeSupplierExported"] == null ? null : json["timeSupplierExported"],
    isSupplierExported: json["isSupplierExported"] == null ? null : json["isSupplierExported"],
  );

  Map<String, dynamic> toJson() => {
    "invoiceId": invoiceId,
    "status": status,
    "ocrStatus": ocrStatus,
    "outlet": outlet.toJson(),
    "supplier": supplier.toJson(),
    "invoiceNum": invoiceNum,
    "invoiceDate": invoiceDate,
    "paymentDueDate": paymentDueDate,
    "paymentTerms": paymentTerms,
    "gstPercentage": gstPercentage,
    "totalCharge": totalCharge == null ? null : totalCharge.toJson(),
    "timeLastUpdated": timeLastUpdated == null ? null : timeLastUpdated,
    "invoiceType": invoiceType,
    "supplierExportedBy": supplierExportedBy == null ? null : supplierExportedBy.toJson(),
    "timeSupplierExported": timeSupplierExported == null ? null : timeSupplierExported,
    "isSupplierExported": isSupplierExported == null ? null : isSupplierExported,
  };

  DateTime getInvoiceDate() {
    return new DateTime.fromMillisecondsSinceEpoch(this.invoiceDate * 1000);
  }

  DateTime getPaymentDueDate() {
    return new DateTime.fromMillisecondsSinceEpoch(this.paymentDueDate * 1000);
  }

  String getInvoiceDueDate() {
    DateTime dateTime =
    new DateTime.fromMillisecondsSinceEpoch(this.invoiceDate * 1000);
    return DateFormat('EEE, d MMM').format(dateTime);
  }
}


class SupplierExportedBy {
  SupplierExportedBy({
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

  factory SupplierExportedBy.fromJson(Map<String, dynamic> json) => SupplierExportedBy(
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

class TotalCharge {
  String currencyCode;
  int amount;
  dynamic amountV1;

  dynamic getAmount() {
    if (amountV1 == null) {
      return 0.0;
    } else {
      return amountV1;
    }
  }

  String getDisplayValue() {
    dynamic amt = getAmount();
    return "\$$amt";
  }

  TotalCharge({this.currencyCode, this.amount, this.amountV1});

  TotalCharge.fromJson(Map<String, dynamic> json) {
    currencyCode = json['currencyCode'];
    amount = json['amount'];
    amountV1 = json['amountV1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currencyCode'] = this.currencyCode;
    data['amount'] = this.amount;
    data['amountV1'] = this.amountV1;
    return data;
  }
}