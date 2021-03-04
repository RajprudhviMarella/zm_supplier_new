import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zm_supplier/utils/color.dart';

class OutletMarketBaseResponse {
  String path;
  String timestamp;
  int status;
  String message;
  OutletMarketResponse data;

  OutletMarketBaseResponse(
      {this.path, this.timestamp, this.status, this.message, this.data});

  OutletMarketBaseResponse.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    timestamp = json['timestamp'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? new OutletMarketResponse.fromJson(json['data'])
        : null;
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

class OutletMarketResponse {
  int numberOfPages;
  int numberOfRecords;
  int currentPageNumber;
  List<OutletMarketList> data;

  OutletMarketResponse(
      {this.numberOfPages,
      this.numberOfRecords,
      this.currentPageNumber,
      this.data});

  OutletMarketResponse.fromJson(Map<String, dynamic> json) {
    numberOfPages = json['numberOfPages'];
    numberOfRecords = json['numberOfRecords'];
    currentPageNumber = json['currentPageNumber'];
    if (json['data'] != null) {
      data = new List<OutletMarketList>();
      json['data'].forEach((v) {
        data.add(new OutletMarketList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['numberOfPages'] = this.numberOfPages;
    data['numberOfRecords'] = this.numberOfRecords;
    data['currentPageNumber'] = this.currentPageNumber;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OutletMarketList {
  String dateCreated;
  String dateUpdated;
  int timeUpdated;
  CreatedBy createdBy;
  CreatedBy updatedBy;
  String status;
  String sku;
  String outletId;
  String supplierId;
  String productName;
  String supplierProductCode;
  String categoryPath;
  List<String> categoryTags;
  String description;
  List<Images> images;
  List<PriceList> priceList;
  bool isFavourite;
  int timeCreated;
  List<String> tags;
  List<Certifications> certifications;
  int timePriceUpdated;
  Color bgColor = faintGrey;
  Color txtColor = Colors.blue;
  var txtSize = 30.0;
  String selectedQuantity = "+";
  String skuNotes = "";
  int quantity = 0;
  bool isSelected = false;

  OutletMarketList(
      {this.dateCreated,
      this.dateUpdated,
      this.timeUpdated,
      this.createdBy,
      this.updatedBy,
      this.status,
      this.sku,
      this.outletId,
      this.supplierId,
      this.productName,
      this.supplierProductCode,
      this.categoryPath,
      this.categoryTags,
      this.description,
      this.images,
      this.priceList,
      this.isFavourite,
      this.timeCreated,
      this.tags,
      this.certifications,
      this.timePriceUpdated,
      this.bgColor,
      this.txtColor,
      this.quantity,
      this.skuNotes,
      this.txtSize,
      this.isSelected,
      this.selectedQuantity});

  OutletMarketList.fromJson(Map<String, dynamic> json) {
    dateCreated = json['dateCreated'];
    dateUpdated = json['dateUpdated'];
    timeUpdated = json['timeUpdated'];
    createdBy = json['createdBy'] != null
        ? new CreatedBy.fromJson(json['createdBy'])
        : null;
    updatedBy = json['updatedBy'] != null
        ? new CreatedBy.fromJson(json['updatedBy'])
        : null;
    status = json['status'];
    sku = json['sku'];
    outletId = json['outletId'];
    supplierId = json['supplierId'];
    productName = json['productName'];
    supplierProductCode = json['supplierProductCode'];
    categoryPath = json['categoryPath'];
    categoryTags = json['categoryTags'].cast<String>();
    description = json['description'];
    if (json['images'] != null) {
      images = new List<Images>();
      json['images'].forEach((v) {
        images.add(new Images.fromJson(v));
      });
    }
    if (json['priceList'] != null) {
      priceList = new List<PriceList>();
      json['priceList'].forEach((v) {
        priceList.add(new PriceList.fromJson(v));
      });
    }
    isFavourite = json['isFavourite'];
    timeCreated = json['timeCreated'];
    if (json['tags'] != null) {
      tags = json['tags'].cast<String>();
    }
    if (json['certifications'] != null) {
      certifications = new List<Certifications>();
      json['certifications'].forEach((v) {
        certifications.add(new Certifications.fromJson(v));
      });
    }
    timePriceUpdated = json['timePriceUpdated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dateCreated'] = this.dateCreated;
    data['dateUpdated'] = this.dateUpdated;
    data['timeUpdated'] = this.timeUpdated;
    if (this.createdBy != null) {
      data['createdBy'] = this.createdBy.toJson();
    }
    if (this.updatedBy != null) {
      data['updatedBy'] = this.updatedBy.toJson();
    }
    data['status'] = this.status;
    data['sku'] = this.sku;
    data['outletId'] = this.outletId;
    data['supplierId'] = this.supplierId;
    data['productName'] = this.productName;
    data['supplierProductCode'] = this.supplierProductCode;
    data['categoryPath'] = this.categoryPath;
    data['categoryTags'] = this.categoryTags;
    data['description'] = this.description;
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    if (this.priceList != null) {
      data['priceList'] = this.priceList.map((v) => v.toJson()).toList();
    }
    data['isFavourite'] = this.isFavourite;
    data['timeCreated'] = this.timeCreated;
    data['tags'] = this.tags;
    if (this.certifications != null) {
      data['certifications'] =
          this.certifications.map((v) => v.toJson()).toList();
    }
    data['timePriceUpdated'] = this.timePriceUpdated;
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

class Images {
  List<String> imageFileNames;
  String imageURL;

  Images({this.imageFileNames, this.imageURL});

  Images.fromJson(Map<String, dynamic> json) {
    imageFileNames = json['imageFileNames'].cast<String>();
    imageURL = json['imageURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageFileNames'] = this.imageFileNames;
    data['imageURL'] = this.imageURL;
    return data;
  }
}

class PriceList {
  int moq;
  Price price;
  String status;
  String unitSize;

  PriceList({this.moq, this.price, this.status, this.unitSize});

  PriceList.fromJson(Map<String, dynamic> json) {
    moq = json['moq'];
    price = json['price'] != null ? new Price.fromJson(json['price']) : null;
    status = json['status'];
    unitSize = json['unitSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['moq'] = this.moq;
    if (this.price != null) {
      data['price'] = this.price.toJson();
    }
    data['status'] = this.status;
    data['unitSize'] = this.unitSize;
    return data;
  }
}

class Price {
  String currencyCode;
  int amountV1;
  int amount;

  double getAmount() {
    if (amountV1 == null) {
      return 0.0;
    } else {
      return amountV1.toDouble();
    }
  }

  String getDisplayValue() {
    var amt = getAmount().toStringAsFixed(2);
    return "\$$amt";
  }

  Price({this.currencyCode, this.amountV1, this.amount});

  Price.fromJson(Map<String, dynamic> json) {
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

class Certifications {
  String id;
  String name;
  Images certificationURL;

  Certifications({this.id, this.name, this.certificationURL});

  Certifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    certificationURL = json['certificationURL'] != null
        ? new Images.fromJson(json['certificationURL'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.certificationURL != null) {
      data['certificationURL'] = this.certificationURL.toJson();
    }
    return data;
  }
}
