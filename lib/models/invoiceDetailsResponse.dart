import 'ordersResponseList.dart';

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
  InvoiceDetails({
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
    this.notes,
    this.pdfUrl,
  });
  List<Products> products;
  DeliveryFee subTotal;
  DeliveryFee promoCodeDiscount;
  DeliveryFee discount;
  Others others;
  DeliveryFee gst;
  int gstPercentage;
  DeliveryFee deliveryFee;
  DeliveryFee totalCharge;
  String notes;
  String pdfUrl;
  CreditNoteAmount unUsedCredit;
  LinkedInvoice linkedInvoice;
  List<String> orderIds;

  InvoiceDetails.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = new List<Products>();
      json['products'].forEach((v) {
        products.add(new Products.fromJson(v));
      });
    }
    subTotal = json['subTotal'] != null
        ? new DeliveryFee.fromJson(json['subTotal'])
        : null;
    discount = json['discount'] != null
        ? new DeliveryFee.fromJson(json['discount'])
        : null;
    others =
        json['others'] != null ? new Others.fromJson(json['others']) : null;
    gst = json['gst'] != null ? new DeliveryFee.fromJson(json['gst']) : null;
    gstPercentage = json['gstPercentage'];
    deliveryFee = json['deliveryFee'] != null
        ? new DeliveryFee.fromJson(json['deliveryFee'])
        : null;
    totalCharge = json['totalCharge'] != null
        ? new DeliveryFee.fromJson(json['totalCharge'])
        : null;
    notes = json['notes'];
    // emailToBuyer = json['emailToBuyer'];
    pdfUrl = json['pdfURL'];
    linkedInvoice = json['linkedInvoice'] != null
        ? new LinkedInvoice.fromJson(json['linkedInvoice'])
        : null;
    orderIds = json['orderIds'] != null
        ? new List<String>.from(json["orderIds"].map((x) => x))
        : null;

    print(json['pdfURL']);
    print(json['linkedInvoice']);
  }

  Map<String, dynamic> toJson() => {
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
        "notes": notes,
        "pdfURL": pdfUrl,
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

class LinkedInvoice {
  String invoiceId;
  String invoiceNum;
  String invoiceType;

  LinkedInvoice({this.invoiceId, this.invoiceNum, this.invoiceType});

  LinkedInvoice.fromJson(Map<String, dynamic> json) {
    invoiceId = json['invoiceId'];
    invoiceNum = json['invoiceNum'];
    invoiceType = json['invoiceType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['invoiceId'] = this.invoiceId;
    data['invoiceNum'] = this.invoiceNum;
    data['invoiceType'] = this.invoiceType;
    return data;
  }
}

class CreditNoteAmount {
  String currencyCode;
  int amount;
  var amountV1;

  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');

  dynamic getAmount() {
    if (amountV1 == null) {
      return 0.0;
    } else {
      return amountV1
          .toStringAsFixed(2)
          .replaceAllMapped(reg, (Match m) => '${m[1]},');
    }
  }

  String getDisplayValue() {
    dynamic amt = getAmount();
    return "\$$amt";
  }

  CreditNoteAmount({this.currencyCode, this.amount, this.amountV1});

  CreditNoteAmount.fromJson(Map<String, dynamic> json) {
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
