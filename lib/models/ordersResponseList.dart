import 'package:flutter/material.dart';

class OrdersBaseResponse {
  OrdersBaseResponse({
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
  OrdersResponse data;

  factory OrdersBaseResponse.fromJson(Map<String, dynamic> json) =>
      OrdersBaseResponse(
        path: json["path"],
        timestamp: DateTime.parse(json["timestamp"]),
        status: json["status"],
        message: json["message"],
        data: OrdersResponse.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "path": path,
        "timestamp": timestamp.toIso8601String(),
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class OrdersResponse {
  OrdersResponse({
    this.numberOfPages,
    this.numberOfRecords,
    this.currentPageNumber,
    this.data,
  });

  int numberOfPages;
  int numberOfRecords;
  int currentPageNumber;
  List<Orders> data;

  factory OrdersResponse.fromJson(Map<String, dynamic> json) => OrdersResponse(
      numberOfPages: json["numberOfPages"],
      currentPageNumber: json["currentPageNumber"],
      numberOfRecords: json["numberOfRecords"],
      data: List<Orders>.from(json["data"].map((x) => Orders.fromJson(x))));

  Map<String, dynamic> toJson() => {
        "numberOfPages": numberOfPages,
        "currentPageNumber": currentPageNumber,
        "numberOfRecords": numberOfRecords,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Orders {
  String dateCreated;
  String dateUpdated;
  int timeCreated;
  int timeUpdated;
  CreatedBy createdBy;
  CreatedBy updatedBy;
  String orderId;
  Outlet outlet;
  Supplier supplier;
  Amount amount;
  String orderStatus;
  List<Products> products;
  int timeCutOff;
  int timeDrafted;
  int timePlaced;
  int timeDelivered;
  int timeReceived;
  int timeRejected;
  int timeCancelled;
  String datePlaced;
  String dateDelivered;
  CreatedBy draftedBy;
  CreatedBy receivedBy;
  CreatedBy lastUpdatedBy;
  String notes;
  String promoCode;
  String pdfURL;
  DateTime timeCompare;

  DateTime getTimeCompare() {
    if (this.timePlaced != null &&
        (identical(this.orderStatus, "Placed") ||
            identical(this.orderStatus, "Invoiced"))) {
      return new DateTime.fromMillisecondsSinceEpoch(this.timePlaced * 1000);
    } else if (this.timeRejected != null &&
        identical(this.orderStatus, "Rejected")) {
      return new DateTime.fromMillisecondsSinceEpoch(this.timeRejected * 1000);
    } else if (this.timeCancelled != null &&
        identical(this.orderStatus, "Cancelled")) {
      return new DateTime.fromMillisecondsSinceEpoch(this.timeCancelled * 1000);
    } else if (this.timeUpdated != null) {
      return new DateTime.fromMillisecondsSinceEpoch(this.timeUpdated * 1000);
    } else {
      return new DateTime.fromMillisecondsSinceEpoch(this.timeCreated * 1000);
    }
  }

  Orders(
      {this.dateCreated,
      this.dateUpdated,
      this.timeCreated,
      this.timeUpdated,
      this.createdBy,
      this.updatedBy,
      this.orderId,
      this.outlet,
      this.supplier,
      this.amount,
      this.orderStatus,
      this.products,
      this.timeCutOff,
      this.timeDrafted,
      this.timePlaced,
      this.timeDelivered,
      this.timeReceived,
      this.datePlaced,
      this.dateDelivered,
      this.draftedBy,
      this.receivedBy,
      this.lastUpdatedBy,
      this.timeRejected,
      this.timeCancelled,
      this.notes,
      this.promoCode,
      this.timeCompare,
      this.pdfURL});

  Orders.fromJson(Map<String, dynamic> json) {
    dateCreated = json['dateCreated'];
    dateUpdated = json['dateUpdated'];
    timeCreated = json['timeCreated'];
    timeUpdated = json['timeUpdated'];
    timeRejected = json['timeRejected'];
    timeCancelled = json['timeCancelled'];
    createdBy = json['createdBy'] != null
        ? new CreatedBy.fromJson(json['createdBy'])
        : null;
    updatedBy = json['updatedBy'] != null
        ? new CreatedBy.fromJson(json['updatedBy'])
        : null;
    orderId = json['orderId'];
    outlet =
        json['outlet'] != null ? new Outlet.fromJson(json['outlet']) : null;
    supplier = json['supplier'] != null
        ? new Supplier.fromJson(json['supplier'])
        : null;
    amount =
        json['amount'] != null ? new Amount.fromJson(json['amount']) : null;
    orderStatus = json['orderStatus'];
    if (json['products'] != null) {
      products = new List<Products>();
      json['products'].forEach((v) {
        products.add(new Products.fromJson(v));
      });
      timeCompare = this.getTimeCompare();
    }
    // if (json['approvers'] != null) {
    //   approvers = new List<Null>();
    //   json['approvers'].forEach((v) {
    //     approvers.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['approvalHistory'] != null) {
    //   approvalHistory = new List<Null>();
    //   json['approvalHistory'].forEach((v) {
    //     approvalHistory.add(new Null.fromJson(v));
    //   }
    //   );
    // }
    timeCutOff = json['timeCutOff'];
    timeDrafted = json['timeDrafted'];
    timePlaced = json['timePlaced'];
    timeDelivered = json['timeDelivered'];
    timeReceived = json['timeReceived'];
    datePlaced = json['datePlaced'];
    dateDelivered = json['dateDelivered'];
    timeCancelled = json['timeCancelled'];
    draftedBy = json['draftedBy'] != null
        ? new CreatedBy.fromJson(json['draftedBy'])
        : null;
    receivedBy = json['receivedBy'] != null
        ? new CreatedBy.fromJson(json['receivedBy'])
        : null;
    lastUpdatedBy = json['lastUpdatedBy'] != null
        ? new CreatedBy.fromJson(json['lastUpdatedBy'])
        : null;
    notes = json['notes'];
    promoCode = json['promoCode'];
    pdfURL = json['pdfURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dateCreated'] = this.dateCreated;
    data['dateUpdated'] = this.dateUpdated;
    data['timeCreated'] = this.timeCreated;
    data['timeUpdated'] = this.timeUpdated;
    data['timeRejected'] = this.timeRejected;
    if (this.createdBy != null) {
      data['createdBy'] = this.createdBy.toJson();
    }
    if (this.updatedBy != null) {
      data['updatedBy'] = this.updatedBy.toJson();
    }
    data['orderId'] = this.orderId;
    if (this.outlet != null) {
      data['outlet'] = this.outlet.toJson();
    }
    if (this.supplier != null) {
      data['supplier'] = this.supplier.toJson();
    }
    if (this.amount != null) {
      data['amount'] = this.amount.toJson();
    }
    data['orderStatus'] = this.orderStatus;
    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }
    // if (this.approvers != null) {
    //   data['approvers'] = this.approvers.map((v) => v.toJson()).toList();
    // }
    // if (this.approvalHistory != null) {
    //   data['approvalHistory'] =
    //       this.approvalHistory.map((v) => v.toJson()).toList();
    // }
    data['timeCutOff'] = this.timeCutOff;
    data['timeDrafted'] = this.timeDrafted;
    data['timePlaced'] = this.timePlaced;
    data['timeDelivered'] = this.timeDelivered;
    data['timeReceived'] = this.timeReceived;
    data['datePlaced'] = this.datePlaced;
    data['dateDelivered'] = this.dateDelivered;
    if (this.draftedBy != null) {
      data['draftedBy'] = this.draftedBy.toJson();
    }
    if (this.receivedBy != null) {
      data['receivedBy'] = this.receivedBy.toJson();
    }
    if (this.lastUpdatedBy != null) {
      data['lastUpdatedBy'] = this.lastUpdatedBy.toJson();
    }
    data['notes'] = this.notes;
    data['promoCode'] = this.promoCode;
    data['pdfURL'] = this.pdfURL;
    return data;
  }
}

class CreatedBy {
  String id;
  String firstName;
  String lastName;
  String imageURL;
  String phone;

  CreatedBy(
      {this.id, this.firstName, this.lastName, this.imageURL, this.phone});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    imageURL = json['imageURL'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['imageURL'] = this.imageURL;
    data['phone'] = this.phone;
    return data;
  }
}

class Outlet {
  String outletId;
  String outletName;
  Company company;
  Settings settings;
  String logoURL;
  String market;
  Address address;

  Outlet(
      {this.outletId,
      this.outletName,
      this.company,
      this.settings,
      this.logoURL,
      this.market,
      this.address});

  Outlet.fromJson(Map<String, dynamic> json) {
    outletId = json['outletId'];
    outletName = json['outletName'];
    company =
        json['company'] != null ? new Company.fromJson(json['company']) : null;
    settings = json['settings'] != null
        ? new Settings.fromJson(json['settings'])
        : null;
    logoURL = json['logoURL'];
    market = json['market'];
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['outletId'] = this.outletId;
    data['outletName'] = this.outletName;
    if (this.company != null) {
      data['company'] = this.company.toJson();
    }
    if (this.settings != null) {
      data['settings'] = this.settings.toJson();
    }
    data['logoURL'] = this.logoURL;
    data['market'] = this.market;
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    return data;
  }
}

class Company {
  String companyId;
  String companyName;
  Address address;
  String logoURL;
  String email;
  String phone;
  String regNo;
  String market;

  Company(
      {this.companyId,
      this.companyName,
      this.address,
      this.logoURL,
      this.email,
      this.phone,
      this.regNo,
      this.market});

  Company.fromJson(Map<String, dynamic> json) {
    companyId = json['companyId'];
    companyName = json['companyName'];
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    logoURL = json['logoURL'];
    email = json['email'];
    phone = json['phone'];
    regNo = json['regNo'];
    market = json['market'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyId'] = this.companyId;
    data['companyName'] = this.companyName;
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    data['logoURL'] = this.logoURL;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['regNo'] = this.regNo;
    data['market'] = this.market;
    return data;
  }
}

class Address {
  String line1;
  String line2;
  String country;
  String postal;

  Address({this.line1, this.line2, this.country, this.postal});

  Address.fromJson(Map<String, dynamic> json) {
    line1 = json['line1'];
    line2 = json['line2'];
    country = json['country'];
    postal = json['postal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['line1'] = this.line1;
    data['line2'] = this.line2;
    data['country'] = this.country;
    data['postal'] = this.postal;
    return data;
  }
}

class Settings {
  String timeZone;
  String language;
  bool enableSpecialRequest;
  bool enableDeliveryInstruction;
  WeeklyOrder weeklyOrder;

  Settings(
      {this.timeZone,
      this.language,
      this.enableSpecialRequest,
      this.enableDeliveryInstruction,
      this.weeklyOrder});

  Settings.fromJson(Map<String, dynamic> json) {
    timeZone = json['timeZone'];
    language = json['language'];
    enableSpecialRequest = json['enableSpecialRequest'];
    enableDeliveryInstruction = json['enableDeliveryInstruction'];
    weeklyOrder = json['weeklyOrder'] != null
        ? new WeeklyOrder.fromJson(json['weeklyOrder'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['timeZone'] = this.timeZone;
    data['language'] = this.language;
    data['enableSpecialRequest'] = this.enableSpecialRequest;
    data['enableDeliveryInstruction'] = this.enableDeliveryInstruction;
    if (this.weeklyOrder != null) {
      data['weeklyOrder'] = this.weeklyOrder.toJson();
    }
    return data;
  }
}

class WeeklyOn {
  String day;
  String time;

  WeeklyOn({this.day, this.time});

  WeeklyOn.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['time'] = this.time;
    return data;
  }
}

class WeeklyOrder {
  CutOff cutOff;
  String startDay;
  String status;

  WeeklyOrder({this.cutOff, this.startDay, this.status});

  WeeklyOrder.fromJson(Map<String, dynamic> json) {
    cutOff =
        json['cutOff'] != null ? new CutOff.fromJson(json['cutOff']) : null;
    startDay = json['startDay'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cutOff != null) {
      data['cutOff'] = this.cutOff.toJson();
    }
    data['startDay'] = this.startDay;
    data['status'] = this.status;
    return data;
  }
}

class CutOff {
  int days;
  String time;

  CutOff({this.days, this.time});

  CutOff.fromJson(Map<String, dynamic> json) {
    days = json['days'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['days'] = this.days;
    data['time'] = this.time;
    return data;
  }
}

class Supplier {
  String supplierId;
  String supplierName;
  String shortDesc;
  String logoURL;
  Settings settings;

  Supplier(
      {this.supplierId,
      this.supplierName,
      this.shortDesc,
      this.logoURL,
      this.settings});

  Supplier.fromJson(Map<String, dynamic> json) {
    supplierId = json['supplierId'];
    supplierName = json['supplierName'];
    shortDesc = json['shortDesc'];
    logoURL = json['logoURL'];
    settings = json['settings'] != null
        ? new Settings.fromJson(json['settings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['supplierId'] = this.supplierId;
    data['supplierName'] = this.supplierName;
    data['shortDesc'] = this.shortDesc;
    data['logoURL'] = this.logoURL;
    if (this.settings != null) {
      data['settings'] = this.settings.toJson();
    }
    return data;
  }
}

class OrderSettings {
  Null currencyCode;
  Null timeZone;
  Inventory inventory;
  Null notification;
  Null payment;
  Null invoice;
  Null language;
  Null taxComponents;
  DeliveryFee gst;
  Gst gST;

  OrderSettings(
      {this.currencyCode,
      this.timeZone,
      this.inventory,
      this.notification,
      this.payment,
      this.invoice,
      this.language,
      this.taxComponents,
      this.gst,
      this.gST});

  OrderSettings.fromJson(Map<String, dynamic> json) {
    currencyCode = json['currencyCode'];
    timeZone = json['timeZone'];
    inventory = json['inventory'] != null
        ? new Inventory.fromJson(json['inventory'])
        : null;
    notification = json['notification'];
    payment = json['payment'];
    invoice = json['invoice'];
    language = json['language'];
    taxComponents = json['taxComponents'];
    gst = json['gst'] != null ? new DeliveryFee.fromJson(json['gst']) : null;
    gST = json['GST'] != null ? new Gst.fromJson(json['GST']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currencyCode'] = this.currencyCode;
    data['timeZone'] = this.timeZone;
    if (this.inventory != null) {
      data['inventory'] = this.inventory.toJson();
    }
    data['notification'] = this.notification;
    data['payment'] = this.payment;
    data['invoice'] = this.invoice;
    data['language'] = this.language;
    data['taxComponents'] = this.taxComponents;
    if (this.gst != null) {
      data['gst'] = this.gst.toJson();
    }
    if (this.gST != null) {
      data['GST'] = this.gST.toJson();
    }
    return data;
  }
}

class Inventory {
  bool allowNegative;
  String status;

  Inventory({this.allowNegative, this.status});

  Inventory.fromJson(Map<String, dynamic> json) {
    allowNegative = json['allowNegative'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['allowNegative'] = this.allowNegative;
    data['status'] = this.status;
    return data;
  }
}

class Gst {
  int percent;

  Gst({this.percent});

  Gst.fromJson(Map<String, dynamic> json) {
    percent = json['percent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['percent'] = this.percent;
    return data;
  }
}

class Amount {
  DeliveryFee deliveryFee;
  DeliveryFee gst;
  DeliveryFee subTotal;
  DeliveryFee total;

  Amount({this.deliveryFee, this.gst, this.subTotal, this.total});

  Amount.fromJson(Map<String, dynamic> json) {
    deliveryFee = json['deliveryFee'] != null
        ? new DeliveryFee.fromJson(json['deliveryFee'])
        : null;
    gst = json['gst'] != null ? new DeliveryFee.fromJson(json['gst']) : null;
    subTotal = json['subTotal'] != null
        ? new DeliveryFee.fromJson(json['subTotal'])
        : null;
    total =
        json['total'] != null ? new DeliveryFee.fromJson(json['total']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.deliveryFee != null) {
      data['deliveryFee'] = this.deliveryFee.toJson();
    }
    if (this.gst != null) {
      data['gst'] = this.gst.toJson();
    }
    if (this.subTotal != null) {
      data['subTotal'] = this.subTotal.toJson();
    }
    if (this.total != null) {
      data['total'] = this.total.toJson();
    }
    return data;
  }
}

class DeliveryFee {
  String currencyCode;
  int amount;

  DeliveryFee({this.currencyCode, this.amount});

  DeliveryFee.fromJson(Map<String, dynamic> json) {
    currencyCode = json['currencyCode'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currencyCode'] = this.currencyCode;
    data['amount'] = this.amount;
    return data;
  }
}

class Products {
  String sku;
  String productName;
  var quantity;
  String supplierProductCode;
  String unitSize;
  DeliveryFee unitPrice;
  DeliveryFee totalPrice;

  Products(
      {this.sku,
      this.productName,
      this.quantity,
      this.supplierProductCode,
      this.unitSize,
      this.unitPrice,
      this.totalPrice});

  Products.fromJson(Map<String, dynamic> json) {
    sku = json['sku'];
    productName = json['productName'];
    quantity = json['quantity'];
    supplierProductCode = json['supplierProductCode'];
    unitSize = json['unitSize'];
    unitPrice = json['unitPrice'] != null
        ? new DeliveryFee.fromJson(json['unitPrice'])
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
    data['unitSize'] = this.unitSize;
    if (this.unitPrice != null) {
      data['unitPrice'] = this.unitPrice.toJson();
    }
    if (this.totalPrice != null) {
      data['totalPrice'] = this.totalPrice.toJson();
    }
    return data;
  }
}
