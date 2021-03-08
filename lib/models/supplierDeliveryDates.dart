class SupplierDeliveryDates {
  String path;
  String timestamp;
  int status;
  String message;
  List<DeliveryDateList> data;

  SupplierDeliveryDates(
      {this.path, this.timestamp, this.status, this.message, this.data});

  SupplierDeliveryDates.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    timestamp = json['timestamp'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<DeliveryDateList>();
      json['data'].forEach((v) {
        data.add(new DeliveryDateList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['path'] = this.path;
    data['timestamp'] = this.timestamp;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DeliveryDateList {
  Supplier supplier;
  int lastOrdered;
  bool useDefault;
  bool orderDisabled;
  DeliveryFeePolicy deliveryFeePolicy;
  List<DeliveryDates> deliveryDates;

  DeliveryDateList(
      {this.supplier,
      this.lastOrdered,
      this.useDefault,
      this.orderDisabled,
      this.deliveryFeePolicy,
      this.deliveryDates});

  DeliveryDateList.fromJson(Map<String, dynamic> json) {
    supplier = json['supplier'] != null
        ? new Supplier.fromJson(json['supplier'])
        : null;
    lastOrdered = json['lastOrdered'];
    useDefault = json['useDefault'];
    orderDisabled = json['orderDisabled'];
    deliveryFeePolicy = json['deliveryFeePolicy'] != null
        ? new DeliveryFeePolicy.fromJson(json['deliveryFeePolicy'])
        : null;
    if (json['deliveryDates'] != null) {
      deliveryDates = new List<DeliveryDates>();
      json['deliveryDates'].forEach((v) {
        deliveryDates.add(new DeliveryDates.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.supplier != null) {
      data['supplier'] = this.supplier.toJson();
    }
    data['lastOrdered'] = this.lastOrdered;
    data['useDefault'] = this.useDefault;
    data['orderDisabled'] = this.orderDisabled;
    if (this.deliveryFeePolicy != null) {
      data['deliveryFeePolicy'] = this.deliveryFeePolicy.toJson();
    }
    if (this.deliveryDates != null) {
      data['deliveryDates'] =
          this.deliveryDates.map((v) => v.toJson()).toList();
    }
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

class Settings {
  Gst gst;
  Gst gST;

  Settings({this.gst, this.gST});

  Settings.fromJson(Map<String, dynamic> json) {
    gst = json['gst'] != null ? new Gst.fromJson(json['gst']) : null;
    gST = json['GST'] != null ? new Gst.fromJson(json['GST']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.gst != null) {
      data['gst'] = this.gst.toJson();
    }
    if (this.gST != null) {
      data['GST'] = this.gST.toJson();
    }
    return data;
  }
}

class ListingURL {
  String url;
  String listingName;

  ListingURL({this.url, this.listingName});

  ListingURL.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    listingName = json['listingName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['listingName'] = this.listingName;
    return data;
  }
}

class MinOrder {
  String currencyCode;
  var amountV1;
  var amount;

  MinOrder({this.currencyCode, this.amountV1, this.amount});

  MinOrder.fromJson(Map<String, dynamic> json) {
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

class Gst {
  var percent;

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

class DeliveryFeePolicy {
  String condition;
  String type;
  MinOrder fee;
  MinOrder minOrder;
  bool blockBelowMinOrder;

  DeliveryFeePolicy(
      {this.condition,
      this.type,
      this.fee,
      this.minOrder,
      this.blockBelowMinOrder});

  DeliveryFeePolicy.fromJson(Map<String, dynamic> json) {
    condition = json['condition'];
    type = json['type'];
    fee = json['fee'] != null ? new MinOrder.fromJson(json['fee']) : null;
    minOrder = json['minOrder'] != null
        ? new MinOrder.fromJson(json['minOrder'])
        : null;
    blockBelowMinOrder = json['blockBelowMinOrder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['condition'] = this.condition;
    data['type'] = this.type;
    if (this.fee != null) {
      data['fee'] = this.fee.toJson();
    }
    if (this.minOrder != null) {
      data['minOrder'] = this.minOrder.toJson();
    }
    data['blockBelowMinOrder'] = this.blockBelowMinOrder;
    return data;
  }
}

class DeliveryDates {
  int deliveryDate;
  int cutOffDate;
  bool isPH;
  bool isEvePH;

  DeliveryDates({this.deliveryDate, this.cutOffDate, this.isPH, this.isEvePH});

  DeliveryDates.fromJson(Map<String, dynamic> json) {
    deliveryDate = json['deliveryDate'];
    cutOffDate = json['cutOffDate'];
    isPH = json['isPH'];
    isEvePH = json['isEvePH'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deliveryDate'] = this.deliveryDate;
    data['cutOffDate'] = this.cutOffDate;
    data['isPH'] = this.isPH;
    data['isEvePH'] = this.isEvePH;
    return data;
  }
}
