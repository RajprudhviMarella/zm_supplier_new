
import 'dart:convert';

import 'outletSettings.dart';
import 'package:zm_supplier/models/price.dart';

PaginatedOrders paginatedOrdersFromJson(String str) => PaginatedOrders.fromJson(json.decode(str));

String paginatedOrdersToJson(PaginatedOrders data) => json.encode(data.toJson());

class PaginatedOrders {
  PaginatedOrders({
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

  factory PaginatedOrders.fromJson(Map<String, dynamic> json) => PaginatedOrders(
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
  List<OrdersData> data;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    numberOfPages: json["numberOfPages"],
    numberOfRecords: json["numberOfRecords"],
    currentPageNumber: json["currentPageNumber"],
    data: List<OrdersData>.from(json["data"].map((x) => OrdersData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "numberOfPages": numberOfPages,
    "numberOfRecords": numberOfRecords,
    "currentPageNumber": currentPageNumber,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class OrdersData {
  OrdersData({
    this.dateCreated,
    this.dateUpdated,
    this.timeCreated,
    this.timeUpdated,
    this.createdBy,
    this.updatedBy,
    this.orderId,
    this.orderType,
    this.outlet,
    // this.supplier,
    this.amount,
    this.orderStatus,
    // this.products,
    this.pendingForApprovalLevel,
    //this.approvalHistory,
    this.timeDelivered,
    this.timeCutOff,
    this.timeLastAction,
    this.dateDelivered,
    this.promoCode,
    this.isAddOn,
    this.linkedOrder,
    this.isAcknowledged,
    this.timePlaced,
    this.datePlaced,
    this.addOns,
    this.pdfUrl,
    this.timeRejected,
    this.rejectedBy,
    this.lastUpdatedBy,
    this.rejectedRemark,
    this.timeDrafted,
    this.draftedBy,
    this.notes,
    this.deliveryInstruction,
    //this.deliveryStatus,
    this.dateRejected,
   // this.paymentStatus,
   // this.paymentType,
    this.timeApproved,
    this.paidBy,
    //this.essentialsId,
    this.timeInvoiced,
   // this.linkedInvoices,
    this.isInvoiced,
    this.timeCancelled,
    this.dateCancelled,
    this.cancelledBy,
    // this.cancelledRemark,
    // this.transactionImage,
    this.timeReceived,
    this.receivedBy,
    this.isReceived,
    this.dateApproved,
    this.approvedBy,
    this.timeDeleted,
    this.deletedBy,
   // this.dealNumber,
  });

  String dateCreated;
  String dateUpdated;
  int timeCreated;
  int timeUpdated;
  CreatedBy createdBy;
  CreatedBy updatedBy;
  String orderId;
  String orderType;
  Outlet outlet;
  // Supplier supplier;
  Amount amount;
  String orderStatus;
  // List<Product> products;
   int pendingForApprovalLevel;
  // List<ApprovalHistory> approvalHistory;
  int timeDelivered;
  int timeCutOff;
  int timeLastAction;
  String dateDelivered;
  String promoCode;
  bool isAddOn;
  String linkedOrder;
  bool isAcknowledged;
  int timePlaced;
  String datePlaced;
  List<String> addOns;
  String pdfUrl;
  int timeRejected;
  CreatedBy rejectedBy;
  CreatedBy lastUpdatedBy;
  String rejectedRemark;
  int timeDrafted;
  CreatedBy draftedBy;
  String notes;
  String deliveryInstruction;
  //DeliveryStatus deliveryStatus;
  String dateRejected;
 // PaymentStatus paymentStatus;
 // PaymentType paymentType;
  int timeApproved;
  CreatedBy paidBy;
//  EssentialsId essentialsId;
  int timeInvoiced;
 // List<LinkedInvoice> linkedInvoices;
  bool isInvoiced;
  int timeCancelled;
  String dateCancelled;
  CreatedBy cancelledBy;
  // CancelledRemark cancelledRemark;
  // TransactionImage transactionImage;
  int timeReceived;
  CreatedBy receivedBy;
  bool isReceived;
  String dateApproved;
  CreatedBy approvedBy;
  int timeDeleted;
  CreatedBy deletedBy;
  //DealNumber dealNumber;

  factory OrdersData.fromJson(Map<String, dynamic> json) => OrdersData(
    dateCreated: json["dateCreated"],
    dateUpdated: json["dateUpdated"],
    timeCreated: json["timeCreated"],
    timeUpdated: json["timeUpdated"],
    createdBy: CreatedBy.fromJson(json["createdBy"]),
    updatedBy: CreatedBy.fromJson(json["updatedBy"]),
    orderId: json["orderId"],
    orderType: json["orderType"],
    outlet: Outlet.fromJson(json["outlet"]),
    // supplier: Supplier.fromJson(json["supplier"]),
    amount: Amount.fromJson(json["amount"]),
    orderStatus: json["orderStatus"],
    // products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
     pendingForApprovalLevel: json["pendingForApprovalLevel"] == null ? null : json["pendingForApprovalLevel"],
    // approvalHistory: json["approvalHistory"] == null ? null : List<ApprovalHistory>.from(json["approvalHistory"].map((x) => ApprovalHistory.fromJson(x))),
    timeDelivered: json["timeDelivered"],
    timeCutOff: json["timeCutOff"],
    timeLastAction: json["timeLastAction"] == null ? null : json["timeLastAction"],
    dateDelivered: json["dateDelivered"] == null ? null : json["dateDelivered"],
    promoCode: json["promoCode"] == null ? null : json["promoCode"],
    isAddOn: json["isAddOn"],
    linkedOrder: json["linkedOrder"] == null ? null : json["linkedOrder"],
    isAcknowledged: json["isAcknowledged"] == null ? null : json["isAcknowledged"],
    timePlaced: json["timePlaced"] == null ? null : json["timePlaced"],
    datePlaced: json["datePlaced"] == null ? null : json["datePlaced"],
    addOns: json["addOns"] == null ? null : List<String>.from(json["addOns"].map((x) => x)),
    pdfUrl: json["pdfURL"] == null ? null : json["pdfURL"],
    timeRejected: json["timeRejected"] == null ? null : json["timeRejected"],
    rejectedBy: json["rejectedBy"] == null ? null : CreatedBy.fromJson(json["rejectedBy"]),
    lastUpdatedBy: json["lastUpdatedBy"] == null ? null : CreatedBy.fromJson(json["lastUpdatedBy"]),
    rejectedRemark: json["rejectedRemark"] == null ? null : json["rejectedRemark"],
    timeDrafted: json["timeDrafted"] == null ? null : json["timeDrafted"],
    draftedBy: json["draftedBy"] == null ? null : CreatedBy.fromJson(json["draftedBy"]),
    notes: json["notes"] == null ? null : json["notes"],
    deliveryInstruction: json["deliveryInstruction"] == null ? null : json["deliveryInstruction"],
    // deliveryStatus: json["deliveryStatus"] == null ? null : deliveryStatusValues.map[json["deliveryStatus"]],
     dateRejected: json["dateRejected"] == null ? null : json["dateRejected"],
    // paymentStatus: json["paymentStatus"] == null ? null : paymentStatusValues.map[json["paymentStatus"]],
    // paymentType: json["paymentType"] == null ? null : paymentTypeValues.map[json["paymentType"]],
    timeApproved: json["timeApproved"] == null ? null : json["timeApproved"],
    paidBy: json["paidBy"] == null ? null : CreatedBy.fromJson(json["paidBy"]),
    //essentialsId: json["essentialsId"] == null ? null : essentialsIdValues.map[json["essentialsId"]],
    timeInvoiced: json["timeInvoiced"] == null ? null : json["timeInvoiced"],
    //linkedInvoices: json["linkedInvoices"] == null ? null : List<LinkedInvoice>.from(json["linkedInvoices"].map((x) => LinkedInvoice.fromJson(x))),
    isInvoiced: json["isInvoiced"] == null ? null : json["isInvoiced"],
    timeCancelled: json["timeCancelled"] == null ? null : json["timeCancelled"],
    dateCancelled: json["dateCancelled"] == null ? null : json["dateCancelled"],
    cancelledBy: json["cancelledBy"] == null ? null : CreatedBy.fromJson(json["cancelledBy"]),
    // cancelledRemark: json["cancelledRemark"] == null ? null : cancelledRemarkValues.map[json["cancelledRemark"]],
    // transactionImage: json["transactionImage"] == null ? null : TransactionImage.fromJson(json["transactionImage"]),
    timeReceived: json["timeReceived"] == null ? null : json["timeReceived"],
    receivedBy: json["receivedBy"] == null ? null : CreatedBy.fromJson(json["receivedBy"]),
    isReceived: json["isReceived"] == null ? null : json["isReceived"],
    dateApproved: json["dateApproved"] == null ? null : json["dateApproved"],
    approvedBy: json["approvedBy"] == null ? null : CreatedBy.fromJson(json["approvedBy"]),
    timeDeleted: json["timeDeleted"] == null ? null : json["timeDeleted"],
    deletedBy: json["deletedBy"] == null ? null : CreatedBy.fromJson(json["deletedBy"]),
    // dealNumber: json["dealNumber"] == null ? null : dealNumberValues.map[json["dealNumber"]],
  );

  Map<String, dynamic> toJson() => {
    "dateCreated": dateCreated,
    "dateUpdated": dateUpdated,
    "timeCreated": timeCreated,
    "timeUpdated": timeUpdated,
    "createdBy": createdBy.toJson(),
    "updatedBy": updatedBy.toJson(),
    "orderId": orderId,
    "orderType": orderType,
    "outlet": outlet.toJson(),
    // "supplier": supplier.toJson(),
    "amount": amount.toJson(),
    "orderStatus": orderStatus,
    //"products": List<dynamic>.from(products.map((x) => x.toJson())),
    "pendingForApprovalLevel": pendingForApprovalLevel == null ? null : pendingForApprovalLevel,
    //"approvalHistory": approvalHistory == null ? null : List<dynamic>.from(approvalHistory.map((x) => x.toJson())),
    "timeDelivered": timeDelivered,
    "timeCutOff": timeCutOff,
    "timeLastAction": timeLastAction == null ? null : timeLastAction,
    "dateDelivered": dateDelivered == null ? null : dateDelivered,
    // "promoCode": promoCode == null ? null : promoCodeValues.reverse[promoCode],
    "isAddOn": isAddOn,
    "linkedOrder": linkedOrder == null ? null : linkedOrder,
    "isAcknowledged": isAcknowledged == null ? null : isAcknowledged,
    "timePlaced": timePlaced == null ? null : timePlaced,
    "datePlaced": datePlaced == null ? null : datePlaced,
    "addOns": addOns == null ? null : List<dynamic>.from(addOns.map((x) => x)),
    "pdfURL": pdfUrl == null ? null : pdfUrl,
    "timeRejected": timeRejected == null ? null : timeRejected,
    "rejectedBy": rejectedBy == null ? null : rejectedBy.toJson(),
    "lastUpdatedBy": lastUpdatedBy == null ? null : lastUpdatedBy.toJson(),
    "rejectedRemark": rejectedRemark == null ? null : rejectedRemark,
    "timeDrafted": timeDrafted == null ? null : timeDrafted,
    "draftedBy": draftedBy == null ? null : draftedBy.toJson(),
    "notes": notes == null ? null : notes,
    "deliveryInstruction": deliveryInstruction == null ? null : deliveryInstruction,
    //"deliveryStatus": deliveryStatus == null ? null : deliveryStatusValues.reverse[deliveryStatus],
    "dateRejected": dateRejected == null ? null : dateRejected,
    // "paymentStatus": paymentStatus == null ? null : paymentStatusValues.reverse[paymentStatus],
    // "paymentType": paymentType == null ? null : paymentTypeValues.reverse[paymentType],
    "timeApproved": timeApproved == null ? null : timeApproved,
    "paidBy": paidBy == null ? null : paidBy.toJson(),
    // "essentialsId": essentialsId == null ? null : essentialsIdValues.reverse[essentialsId],
    "timeInvoiced": timeInvoiced == null ? null : timeInvoiced,
    // "linkedInvoices": linkedInvoices == null ? null : List<dynamic>.from(linkedInvoices.map((x) => x.toJson())),
    "isInvoiced": isInvoiced == null ? null : isInvoiced,
    "timeCancelled": timeCancelled == null ? null : timeCancelled,
    "dateCancelled": dateCancelled == null ? null : dateCancelled,
    "cancelledBy": cancelledBy == null ? null : cancelledBy.toJson(),
    // "cancelledRemark": cancelledRemark == null ? null : cancelledRemarkValues.reverse[cancelledRemark],
    // "transactionImage": transactionImage == null ? null : transactionImage.toJson(),
    "timeReceived": timeReceived == null ? null : timeReceived,
    "receivedBy": receivedBy == null ? null : receivedBy.toJson(),
    "isReceived": isReceived == null ? null : isReceived,
    "dateApproved": dateApproved == null ? null : dateApproved,
    "approvedBy": approvedBy == null ? null : approvedBy.toJson(),
    "timeDeleted": timeDeleted == null ? null : timeDeleted,
    "deletedBy": deletedBy == null ? null : deletedBy.toJson(),
   // "dealNumber": dealNumber == null ? null : dealNumberValues.reverse[dealNumber],
  };
}

class CreatedBy {
  CreatedBy({
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

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
    id: json["id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    imageUrl: json["imageURL"] == null ? null : json["imageURL"],
    phone: json["phone"] == null ? null : json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "firstName": firstName == null ? null : firstName,
    "lastName": lastName == null ? null : lastName,
    "imageURL": imageUrl == null ? null : imageUrl,
    "phone": phone == null ? null : phone,
  };
}