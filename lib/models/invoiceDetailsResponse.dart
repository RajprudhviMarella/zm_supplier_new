//
import 'ordersResponseList.dart';

class InvoiceDetailsResponse {
  InvoiceDetailsResponse({
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
  InvoiceDetails data;

  factory InvoiceDetailsResponse.fromJson(Map<String, dynamic> json) => InvoiceDetailsResponse(
    path: json["path"],
    timestamp: DateTime.parse(json["timestamp"]),
    status: json["status"],
    message: json["message"],
    data: InvoiceDetails.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "path": path,
    "timestamp": timestamp.toIso8601String(),
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class InvoiceDetails {
  InvoiceDetails({
    this.timeCreated,
    this.createdBy,
    this.invoiceId,
    this.status,
    this.ocrStatus,
    this.paymentStatus,
    this.outlet,
    this.supplier,
    this.lastUpdatedBy,
    this.invoiceNum,
    this.invoiceDate,
    this.paymentTerms,
    this.paymentTermsDisplay,
    this.paymentDueDate,
    this.orderIds,
    this.products,
    this.subTotal,
    this.promoCodeDiscount,
    this.discount,
    this.others,
    this.gst,
    this.gstPercentage,
    this.deliveryFee,
    this.totalCharge,
    this.timeLastUpdated,
    this.processedBy,
    this.invoiceType,
    this.notes,
    this.salesPerson,
    this.emailToBuyer,
    this.pdfUrl,
    this.isExported,
    this.isSupplierExported,
  });

  int timeCreated;
  CreatedBy createdBy;
  String invoiceId;
  String status;
  String ocrStatus;
  String paymentStatus;
  Outlet outlet;
  Supplier supplier;
  CreatedBy lastUpdatedBy;
  String invoiceNum;
  int invoiceDate;
  String paymentTerms;
  String paymentTermsDisplay;
  int paymentDueDate;
  List<String> orderIds;
  List<Products> products;
  DeliveryFee subTotal;
  DeliveryFee promoCodeDiscount;
  DeliveryFee discount;
  Others others;
  DeliveryFee gst;
  int gstPercentage;
  DeliveryFee deliveryFee;
  DeliveryFee totalCharge;
  int timeLastUpdated;
  CreatedBy processedBy;
  String invoiceType;
  String notes;
  SalesPerson salesPerson;
  String emailToBuyer;
  String pdfUrl;
  bool isExported;
  bool isSupplierExported;

  factory InvoiceDetails.fromJson(Map<String, dynamic> json) => InvoiceDetails(

    // totalCharge: json["totalCharge"] == null ? null : TotalCharge.fromJson(json["totalCharge"]),
    // timeLastUpdated: json["timeLastUpdated"] == null ? null : json["timeLastUpdated"],


    timeCreated: json["timeCreated"],
    createdBy: CreatedBy.fromJson(json["createdBy"]),
    invoiceId: json["invoiceId"],
    status: json["status"],
    ocrStatus: json["ocrStatus"],
    paymentStatus: json["paymentStatus"],
    outlet: Outlet.fromJson(json["outlet"]),
    supplier: Supplier.fromJson(json["supplier"]),
    lastUpdatedBy: CreatedBy.fromJson(json["lastUpdatedBy"]),
    invoiceNum: json["invoiceNum"],
    invoiceDate: json["invoiceDate"],

    paymentTerms: json['paymentTerms'] == null ? null : json['paymentTerms'],
    paymentTermsDisplay: json['paymentTermsDisplay'] == null ? null : json['paymentTermsDisplay'],
    paymentDueDate: json['paymentDueDate'] == null ? null : json['paymentDueDate'],

    orderIds: List<String>.from(json["orderIds"].map((x) => x)),
    products: List<Products>.from(json["products"].map((x) => Products.fromJson(x))),
    subTotal: DeliveryFee.fromJson(json["subTotal"]),
    promoCodeDiscount: DeliveryFee.fromJson(json["promoCodeDiscount"]),
    discount: DeliveryFee.fromJson(json["discount"]),
    others: Others.fromJson(json["others"]),
    gst: DeliveryFee.fromJson(json["gst"]),
    gstPercentage: json["gstPercentage"],
    deliveryFee: DeliveryFee.fromJson(json["deliveryFee"]),
    totalCharge: DeliveryFee.fromJson(json["totalCharge"]),
    timeLastUpdated: json["timeLastUpdated"],
    processedBy: CreatedBy.fromJson(json["processedBy"]),
    invoiceType: json["invoiceType"],
    notes: json["notes"],
    salesPerson: SalesPerson.fromJson(json["salesPerson"]),
    emailToBuyer: json["emailToBuyer"],
    pdfUrl: json["pdfURL"],
    isExported: json["isExported"],
    isSupplierExported: json["isSupplierExported"],
  );

  Map<String, dynamic> toJson() => {
    "timeCreated": timeCreated,
    "createdBy": createdBy.toJson(),
    "invoiceId": invoiceId,
    "status": status,
    "ocrStatus": ocrStatus,
    "paymentStatus": paymentStatus,
    "outlet": outlet.toJson(),
    "supplier": supplier.toJson(),
    "lastUpdatedBy": lastUpdatedBy.toJson(),
    "invoiceNum": invoiceNum,
    "invoiceDate": invoiceDate,


    // "paymentTerms": paymentTerms,
    // "paymentTermsDisplay": paymentTermsDisplay,
    // "paymentDueDate": paymentDueDate,

    //fullName: json["fullName"] == null ? null : json["fullName"],
  //  "fullName": fullName == null ? null : fullName,

    'paymentTerms': paymentTerms == null ? null : paymentTerms,
    'paymentTermsDisplay': paymentTermsDisplay == null ? null : paymentTermsDisplay,
    'paymentDueDate': paymentDueDate == null ? null : paymentDueDate,

    "orderIds": List<dynamic>.from(orderIds.map((x) => x)),
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
    "subTotal": subTotal.toJson(),
    "promoCodeDiscount": promoCodeDiscount.toJson(),
    "discount": discount.toJson(),
    "others": others.toJson(),
    "gst": gst.toJson(),
    "gstPercentage": gstPercentage,
    "deliveryFee": deliveryFee.toJson(),
    "totalCharge": totalCharge.toJson(),
    "timeLastUpdated": timeLastUpdated,
    "processedBy": processedBy.toJson(),
    "invoiceType": invoiceType,
    "notes": notes,
    "salesPerson": salesPerson.toJson(),
    "emailToBuyer": emailToBuyer,
    "pdfURL": pdfUrl,
    "isExported": isExported,
    "isSupplierExported": isSupplierExported,
  };

}

class Others {
  Others({
    this.name,
    this.charge,
  });

  String name;
  DeliveryFee charge;

  factory Others.fromJson(Map<String, dynamic> json) => Others(
    name: json["name"],
    charge: DeliveryFee.fromJson(json["charge"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "charge": charge.toJson(),
  };
}

class SalesPerson {
  String name;
  String phone;

  SalesPerson({this.name, this.phone});

  SalesPerson.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phone'] = this.phone;
    return data;
  }
}
/*
import 'package:zm_supplier/models/ordersResponseList.dart';

class InvoiceDetailsResponse {
  String path;
  String timestamp;
  int status;
  String message;
  InvoiceDetails data;

  InvoiceDetailsResponse(
      {this.path, this.timestamp, this.status, this.message, this.data});

  InvoiceDetailsResponse.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    timestamp = json['timestamp'];
    status = json['status'];
    message = json['message'];
    data =
    json['data'] != null ? new InvoiceDetails.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['path'] = this.path;
    data['timestamp'] = this.timestamp;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class InvoiceDetails {
  int timeCreated;
  CreatedBy createdBy;
  String invoiceId;
  String status;
  String ocrStatus;
  String paymentStatus;
  Outlet outlet;
  Supplier supplier;
  CreatedBy lastUpdatedBy;
  String invoiceNum;
  int invoiceDate;
  String paymentTerms;
  String paymentTermsDisplay;

  int paymentDueDate;
  List<String> orderIds;
  List<Products> products;
  // List<LinkedCreditNotes> linkedCreditNotes;
  DeliveryFee subTotal;
  DeliveryFee promoCodeDiscount;
  DeliveryFee discount;
  Others others;
  Gst gst;
  int gstPercentage;
  DeliveryFee deliveryFee;
  Gst totalCharge;
  int timeLastUpdated;
  CreatedBy processedBy;
  String invoiceType;
  String notes;
  SalesPerson salesPerson;
  String emailToBuyer;
  String pdfURL;
  bool isExported;
  bool isSupplierExported;

  InvoiceDetails({this.timeCreated,
    this.createdBy,
    this.invoiceId,
    this.status,
    this.ocrStatus,
    this.paymentStatus,
    this.outlet,
    this.supplier,
    this.lastUpdatedBy,
    this.invoiceNum,
    this.invoiceDate,
    this.paymentTerms,
    this.paymentTermsDisplay,
    this.paymentDueDate,
    this.orderIds,
    this.products,
    // this.linkedCreditNotes,
    this.subTotal,
    this.promoCodeDiscount,
    this.discount,
    this.others,
    this.gst,
    this.gstPercentage,
    this.deliveryFee,
    this.totalCharge,
    this.timeLastUpdated,
    this.processedBy,
    this.invoiceType,
    this.notes,
    this.salesPerson,
    this.emailToBuyer,
    this.pdfURL,
    this.isExported,
    this.isSupplierExported});

  InvoiceDetails.fromJson(Map<String, dynamic> json) {
    timeCreated = json['timeCreated'];
    createdBy = json['createdBy'] != null
        ? new CreatedBy.fromJson(json['createdBy'])
        : null;
    invoiceId = json['invoiceId'];
    status = json['status'];
    ocrStatus = json['ocrStatus'];
    paymentStatus = json['paymentStatus'];
    outlet =
    json['outlet'] != null ? new Outlet.fromJson(json['outlet']) : null;
    supplier = json['supplier'] != null
        ? new Supplier.fromJson(json['supplier'])
        : null;
    lastUpdatedBy = json['lastUpdatedBy'] != null
        ? new CreatedBy.fromJson(json['lastUpdatedBy'])
        : null;
    invoiceNum = json['invoiceNum'];
    invoiceDate = json['invoiceDate'];

    paymentTerms = json['paymentTerms'] != null
        ? json['paymentTerms'] : null;
    paymentTermsDisplay = json['paymentTermsDisplay'] != null
        ? json['paymentTermsDisplay'] : null;
    paymentDueDate = json['paymentDueDate'] != null
       ? json['paymentDueDate'] : null;


    // paymentTerms = json['paymentTerms'];
    // paymentTermsDisplay = json['paymentTermsDisplay'];
    // paymentDueDate = json['paymentDueDate'];
    // orderIds = json['orderIds'].cast<String>();

    // orderIds = json['orderIds'] != null
    //     ? json['orderIds'] : null;

    if (json['orderIds'] != null) {
      orderIds = List<String>();
      json['orderIds'].forEach((v) {
        orderIds.add(v);
      });
    }

    if (json['products'] != null) {
      products = new List<Products>();
      json['products'].forEach((v) {
        products.add(new Products.fromJson(v));
      });
    }
    // if (json['linkedCreditNotes'] != null) {
    //   linkedCreditNotes = new List<LinkedCreditNotes>();
    //   json['linkedCreditNotes'].forEach((v) {
    //     linkedCreditNotes.add(new LinkedCreditNotes.fromJson(v));
    //   });
    // }
    subTotal = json['subTotal'] != null
        ? new DeliveryFee.fromJson(json['subTotal'])
        : null;
    promoCodeDiscount = json['promoCodeDiscount'] != null
        ? new DeliveryFee.fromJson(json['promoCodeDiscount'])
        : null;
    discount = json['discount'] != null
        ? new DeliveryFee.fromJson(json['discount'])
        : null;
    others =
    json['others'] != null ? new Others.fromJson(json['others']) : null;
    gst = json['gst'] != null ? new Gst.fromJson(json['gst']) : null;
    gstPercentage = json['gstPercentage'];
    deliveryFee = json['deliveryFee'] != null
        ? new DeliveryFee.fromJson(json['deliveryFee'])
        : null;
    totalCharge = json['totalCharge'] != null
        ? new Gst.fromJson(json['totalCharge'])
        : null;
    timeLastUpdated = json['timeLastUpdated'];
    processedBy = json['processedBy'] != null
        ? new CreatedBy.fromJson(json['processedBy'])
        : null;
    invoiceType = json['invoiceType'];
    //notes = json['notes'];
    notes = json['notes'] != null ? json['notes'] : null;
    salesPerson = json['salesPerson'] != null
        ? new SalesPerson.fromJson(json['salesPerson'])
        : null;
    emailToBuyer = json['emailToBuyer'];
    pdfURL = json['pdfURL'];
    isExported = json['isExported'];
    isSupplierExported = json['isSupplierExported'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['timeCreated'] = this.timeCreated;
    if (this.createdBy != null) {
      data['createdBy'] = this.createdBy.toJson();
    }
    data['invoiceId'] = this.invoiceId;
    data['status'] = this.status;
    data['ocrStatus'] = this.ocrStatus;
    data['paymentStatus'] = this.paymentStatus;
    if (this.outlet != null) {
      data['outlet'] = this.outlet.toJson();
    }
    if (this.supplier != null) {
      data['supplier'] = this.supplier.toJson();
    }
    if (this.lastUpdatedBy != null) {
      data['lastUpdatedBy'] = this.lastUpdatedBy.toJson();
    }
    data['invoiceNum'] = this.invoiceNum;
    data['invoiceDate'] = this.invoiceDate;
    data['paymentTerms'] = this.paymentTerms;
    data['paymentTermsDisplay'] = this.paymentTermsDisplay;
    data['paymentDueDate'] = this.paymentDueDate;

    if (this.orderIds != null) {
      data['orderIds'] = this.orderIds.map((v) => v.toString()).toList();
    }
    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }
    // if (this.linkedCreditNotes != null) {
    //   data['linkedCreditNotes'] =
    //       this.linkedCreditNotes.map((v) => v.toJson()).toList();
    // }
    if (this.subTotal != null) {
      data['subTotal'] = this.subTotal.toJson();
    }
    if (this.promoCodeDiscount != null) {
      data['promoCodeDiscount'] = this.promoCodeDiscount.toJson();
    }
    if (this.discount != null) {
      data['discount'] = this.discount.toJson();
    }
    if (this.others != null) {
      data['others'] = this.others.toJson();
    }
    if (this.gst != null) {
      data['gst'] = this.gst.toJson();
    }
    data['gstPercentage'] = this.gstPercentage;
    if (this.deliveryFee != null) {
      data['deliveryFee'] = this.deliveryFee.toJson();
    }
    if (this.totalCharge != null) {
      data['totalCharge'] = this.totalCharge.toJson();
    }
    data['timeLastUpdated'] = this.timeLastUpdated;
    if (this.processedBy != null) {
      data['processedBy'] = this.processedBy.toJson();
    }
    data['invoiceType'] = this.invoiceType;
    if (this.notes != null) {
      data['notes'] = this.notes;
    }
    if (this.salesPerson != null) {
      data['salesPerson'] = this.salesPerson.toJson();
    }
    data['emailToBuyer'] = this.emailToBuyer;
    data['pdfURL'] = this.pdfURL;
    data['isExported'] = this.isExported;
    data['isSupplierExported'] = this.isSupplierExported;
    return data;
  }
}


class Products {
  String sku;
  String productName;
  int quantity;
  String supplierProductCode;
  String categoryPath;
  String unitSize;
  DeliveryFee unitPrice;
  DeliveryFee discount;
  DeliveryFee totalPrice;

  Products({this.sku,
    this.productName,
    this.quantity,
    this.supplierProductCode,
    this.categoryPath,
    this.unitSize,
    this.unitPrice,
    this.discount,
    this.totalPrice});

  Products.fromJson(Map<String, dynamic> json) {
    sku = json['sku'];
    productName = json['productName'];
    quantity = json['quantity'];
    supplierProductCode = json['supplierProductCode'];
    categoryPath = json['categoryPath'];
    unitSize = json['unitSize'];
    unitPrice = json['unitPrice'] != null
        ? new DeliveryFee.fromJson(json['unitPrice'])
        : null;
    discount = json['discount'] != null
        ? new DeliveryFee.fromJson(json['discount'])
        : null;
    totalPrice = json['totalPrice'] != null
        ? new DeliveryFee.fromJson(json['totalPrice'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sku'] = this.sku;
    data['productName'] = this.productName;
    data['quantity'] = this.quantity;
    data['supplierProductCode'] = this.supplierProductCode;
    data['categoryPath'] = this.categoryPath;
    data['unitSize'] = this.unitSize;
    if (this.unitPrice != null) {
      data['unitPrice'] = this.unitPrice.toJson();
    }
    if (this.discount != null) {
      data['discount'] = this.discount.toJson();
    }
    if (this.totalPrice != null) {
      data['totalPrice'] = this.totalPrice.toJson();
    }
    return data;
  }
}

//
// class LinkedCreditNotes {
//   String invoiceId;
//   String invoiceNum;
//   String invoiceType;
//
//   LinkedCreditNotes({this.invoiceId, this.invoiceNum, this.invoiceType});
//
//   LinkedCreditNotes.fromJson(Map<String, dynamic> json) {
//     invoiceId = json['invoiceId'];
//     invoiceNum = json['invoiceNum'];
//     invoiceType = json['invoiceType'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['invoiceId'] = this.invoiceId;
//     data['invoiceNum'] = this.invoiceNum;
//     data['invoiceType'] = this.invoiceType;
//     return data;
//   }
// }

class Others {
  String name;
  DeliveryFee charge;

  Others({this.name, this.charge});

  Others.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    charge =
    json['charge'] != null ? new DeliveryFee.fromJson(json['charge']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.charge != null) {
      data['charge'] = this.charge.toJson();
    }
    return data;
  }
}

class Gst {
  String currencyCode;
  double amountV1;
  int amount;

  Gst({this.currencyCode, this.amountV1, this.amount});

  Gst.fromJson(Map<String, dynamic> json) {
    currencyCode = json['currencyCode'];
    amountV1 = json['amountV1'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currencyCode'] = this.currencyCode;
    data['amountV1'] = this.amountV1;
    data['amount'] = this.amount;
    return data;
  }
}

class SalesPerson {
  String name;
  String phone;

  SalesPerson({this.name, this.phone});

  SalesPerson.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phone'] = this.phone;
    return data;
  }
}*/