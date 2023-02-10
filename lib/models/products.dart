class CatalogueProducts {
  CatalogueProducts({
    this.dateUpdated,
    this.dateDeleted,
    this.timeCreated,
    this.timeUpdated,
    this.timeDeleted,
    // this.updatedBy,
    // this.deletedBy,
    this.sku,
    this.supplierId,
    this.productName,
    this.urlProductName,
    this.brand,
    this.chargeBy,
    this.supplierProductCode,
    this.upcEanNumber,
    this.description,
    this.categoryTags,
    this.categoryPath,
    this.orderBy,
    this.status,
    this.tags,
    this.images,
    this.mainCategoryId,
    this.categoryId,
    this.attributes,
    this.countryOfOrigin,
    this.certifications,
    this.directorySettings,
    this.favourites,
    this.isFavourite,
    this.dateCreated,
    // this.stocks,
    this.linkedMarketList,
  });

  String dateUpdated;
  String dateDeleted;
  int timeCreated;
  int timeUpdated;
  int timeDeleted;
  // TedBy updatedBy;
  // TedBy deletedBy;
  String sku;
  String supplierId;
  String productName;
  String urlProductName;
  String brand;
  ChargeBy chargeBy;
  String supplierProductCode;
  String upcEanNumber;
  String description;
  List<String> categoryTags;
  String categoryPath;
  List<OrderBy> orderBy;
  String status;
  List<String> tags;
  List<Images> images;
  String mainCategoryId;
  String categoryId;
  List<String> attributes;
  String countryOfOrigin;
  List<Certification> certifications;
  DirectorySettings directorySettings;
  List<String> favourites;
  bool isFavourite;
  String dateCreated;
  //List<Stock> stocks;
  List<LinkedMarketList> linkedMarketList;

  factory CatalogueProducts.fromJson(Map<String, dynamic> json) => CatalogueProducts(
    dateUpdated: json["dateUpdated"] == null ? null : json["dateUpdated"],
    dateDeleted: json["dateDeleted"] == null ? null : json["dateDeleted"],
    timeCreated: json["timeCreated"] == null ? null : json["timeCreated"],
    timeUpdated: json["timeUpdated"] == null ? null : json["timeUpdated"],
    timeDeleted: json["timeDeleted"] == null ? null : json["timeDeleted"],
    // updatedBy: json["updatedBy"] == null ? null : TedBy.fromJson(json["updatedBy"]),
    // deletedBy: json["deletedBy"] == null ? null : TedBy.fromJson(json["deletedBy"]),
    sku: json["sku"],
    supplierId: json["supplierId"],
    productName: json["productName"],
    urlProductName: json["urlProductName"] == null ? null : json["urlProductName"],
    brand: json["brand"],
    chargeBy: ChargeBy.fromJson(json["chargeBy"]),
    supplierProductCode: json["supplierProductCode"] == null ? null : json["supplierProductCode"],
    upcEanNumber: json["upcEanNumber"] == null ? null : json["upcEanNumber"],
    description: json["description"] == null ? null : json["description"],
    categoryTags: List<String>.from(json["categoryTags"].map((x) => x)),
    categoryPath: json["categoryPath"],
    orderBy: List<OrderBy>.from(json["orderBy"].map((x) => OrderBy.fromJson(x))),
    status: json["status"],
    tags: json["tags"] == null ? null : List<String>.from(json["tags"].map((x) => x)),
    images: json["images"] == null ? null : List<Images>.from(json["images"].map((x) => Images.fromJson(x))),
    mainCategoryId: json["mainCategoryId"],
    categoryId: json["categoryId"],
    attributes: json["attributes"] == null ? null : List<String>.from(json["attributes"].map((x) => x)),
    countryOfOrigin: json["countryOfOrigin"] == null ? null : json["countryOfOrigin"],

    certifications: json["certifications"] == null ? null : List<Certification>.from(json["certifications"].map((x) => Certification.fromJson(x))),
    directorySettings: json["directorySettings"] == null ? null : DirectorySettings.fromJson(json["directorySettings"]),
    favourites: json["favourites"] == null ? null : List<String>.from(json["favourites"].map((x) => x)),
    isFavourite: json["isFavourite"],
    dateCreated: json["dateCreated"] == null ? null : json["dateCreated"],
   // stocks: json["stocks"] == null ? null : List<Stock>.from(json["stocks"].map((x) => Stock.fromJson(x))),
    linkedMarketList: json["linkedMarketList"] == null ? null : List<LinkedMarketList>.from(json["linkedMarketList"].map((x) => LinkedMarketList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "dateUpdated": dateUpdated == null ? null : dateUpdated,
    "dateDeleted": dateDeleted == null ? null : dateDeleted,
    "timeCreated": timeCreated == null ? null : timeCreated,
    "timeUpdated": timeUpdated == null ? null : timeUpdated,
    "timeDeleted": timeDeleted == null ? null : timeDeleted,
    // "updatedBy": updatedBy == null ? null : updatedBy.toJson(),
    // "deletedBy": deletedBy == null ? null : deletedBy.toJson(),
    "sku": sku,
    "supplierId": supplierId == null ? null : supplierId,
    "productName": productName,
    "urlProductName": urlProductName == null ? null : urlProductName,
    "brand": brand,
    "chargeBy": chargeBy.toJson(),
    "supplierProductCode": supplierProductCode == null ? null : supplierProductCode,
    "upcEanNumber": upcEanNumber == null ? null : upcEanNumber,
    "description": description == null ? null : description,
    "categoryTags": List<dynamic>.from(categoryTags.map((x) => x)),
    "categoryPath": categoryPath,
    "orderBy": List<dynamic>.from(orderBy.map((x) => x.toJson())),
    "status": status,
    "tags": tags == null ? null : List<dynamic>.from(tags.map((x) => x)),
    "images": images == null ? null : List<dynamic>.from(images.map((x) => x.toJson())),
    "mainCategoryId": mainCategoryId,
    "categoryId": categoryId,
    "attributes": attributes == null ? null : List<dynamic>.from(attributes.map((x) => x)),
    "countryOfOrigin": countryOfOrigin == null ? null : countryOfOrigin,
    "certifications": certifications == null ? null : List<dynamic>.from(certifications.map((x) => x.toJson())),
    "directorySettings": directorySettings == null ? null : directorySettings.toJson(),
    "favourites": favourites == null ? null : List<dynamic>.from(favourites.map((x) => x)),
    "isFavourite": isFavourite,
    "dateCreated": dateCreated == null ? null : dateCreated,
    //"stocks": stocks == null ? null : List<dynamic>.from(stocks.map((x) => x.toJson())),
    "linkedMarketList": linkedMarketList == null ? null : List<dynamic>.from(linkedMarketList.map((x) => x.toJson())),
  };
}

class Certification {
  Certification({
    this.id,
    this.name,
   // this.certificationUrl,
  });

  String id;
  String name;
 // Images certificationUrl;

  factory Certification.fromJson(Map<String, dynamic> json) => Certification(
    id: json["id"],
    name: json["name"],
  //  certificationUrl: json["certificationURL"] == null ? null : Images.fromJson(json["certificationURL"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
   // "certificationURL": certificationUrl == null ? null : certificationUrl.toJson(),
  };
}

class Images {
  Images({
    this.imageFileNames,
    this.imageUrl,
  });

  List<String> imageFileNames;
  String imageUrl;

  factory Images.fromJson(Map<String, dynamic> json) => Images(
    imageFileNames: List<String>.from(json["imageFileNames"].map((x) => x)),
    imageUrl: json["imageURL"],
  );

  Map<String, dynamic> toJson() => {
    "imageFileNames": List<dynamic>.from(imageFileNames.map((x) => x)),
    "imageURL": imageUrl,
  };
}

class ChargeBy {
  ChargeBy({
    this.unitSize,
    this.unitSizeAlias,
  });

  String unitSize;
  UnitSizeAlias unitSizeAlias;

  factory ChargeBy.fromJson(Map<String, dynamic> json) => ChargeBy(
    unitSize: json["unitSize"],
    unitSizeAlias: json["unitSizeAlias"] == null ? null : UnitSizeAlias.fromJson(json["unitSizeAlias"]),
  );

  Map<String, dynamic> toJson() => {
    "unitSize": unitSize,
    "unitSizeAlias": unitSizeAlias.toJson(),
  };
}

class UnitSizeAlias {
  UnitSizeAlias({
    this.unitSize,
    this.shortName,
    this.isDecimalAllowed,
  });

  String unitSize;
  String shortName;
  bool isDecimalAllowed;

  factory UnitSizeAlias.fromJson(Map<String, dynamic> json) => UnitSizeAlias(
    unitSize: json["unitSize"],
    shortName: json["shortName"],
    isDecimalAllowed: json["isDecimalAllowed"],
  );

  Map<String, dynamic> toJson() => {
    "unitSize": unitSize,
    "shortName": shortName,
    "isDecimalAllowed": isDecimalAllowed,
  };
}


class DirectorySettings {
  DirectorySettings({
    this.isIncluded,
    this.skuName,
    this.leadTime,
    this.priceRange,
    this.condition,
    this.shelfLife,
  });

  bool isIncluded;
  String skuName;
  LeadTime leadTime;
  List<PriceRange> priceRange;
  String condition;
  LeadTime shelfLife;

  factory DirectorySettings.fromJson(Map<String, dynamic> json) => DirectorySettings(
    isIncluded: json["isIncluded"] == null ? null : json["isIncluded"],
    skuName: json["skuName"] == null ? null : json["skuName"],
    leadTime: json["leadTime"] == null ? null : LeadTime.fromJson(json["leadTime"]),
    priceRange: json["priceRange"] == null ? null : List<PriceRange>.from(json["priceRange"].map((x) => PriceRange.fromJson(x))),
    condition: json["condition"] == null ? null : json["condition"],
    shelfLife: json["shelfLife"] == null ? null : LeadTime.fromJson(json["shelfLife"]),
  );

  Map<String, dynamic> toJson() => {
    "isIncluded": isIncluded == null ? null : isIncluded,
    "skuName": skuName == null ? null : skuName,
    "leadTime": leadTime == null ? null : leadTime.toJson(),
    "priceRange": priceRange == null ? null : List<dynamic>.from(priceRange.map((x) => x.toJson())),
    "condition": condition == null ? null : condition,
    "shelfLife": shelfLife == null ? null : shelfLife.toJson(),
  };
}

class LeadTime {
  LeadTime({
    this.time,
    this.duration,
  });

  String time;
  String duration;

  factory LeadTime.fromJson(Map<String, dynamic> json) => LeadTime(
    time: json["time"] == null ? null : json["time"],
    duration: json["duration"],
  );

  Map<String, dynamic> toJson() => {
    "time": time == null ? null : time,
    "duration": duration,
  };
}

class PriceRange {
  PriceRange({
    this.range,
    this.promo,
    this.moq,
    this.unitSize,
  });

  Range range;
  Range promo;
  int moq;
  String unitSize;

  factory PriceRange.fromJson(Map<String, dynamic> json) => PriceRange(
    range: Range.fromJson(json["range"]),
    promo: json["promo"] == null ? null : Range.fromJson(json["promo"]),
    moq: json["moq"],
    unitSize: json["unitSize"] == null ? null : json["unitSize"],
  );

  Map<String, dynamic> toJson() => {
    "range": range.toJson(),
    "promo": promo == null ? null : promo.toJson(),
    "moq": moq,
    "unitSize": unitSize == null ? null : unitSize,
  };
}

class Range {
  Range({
    this.max,
    this.min,
  });

  int max;
  double min;

  factory Range.fromJson(Map<String, dynamic> json) => Range(
    max: json["max"],
    min: json["min"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "max": max,
    "min": min,
  };
}

class LinkedMarketList {
  LinkedMarketList({
    this.unitSize,
    this.linkedOutlets,
  });

  String unitSize;
  List<LinkedOutlet> linkedOutlets;

  factory LinkedMarketList.fromJson(Map<String, dynamic> json) => LinkedMarketList(
    unitSize: json["unitSize"],
    linkedOutlets: List<LinkedOutlet>.from(json["linkedOutlets"].map((x) => LinkedOutlet.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "unitSize": unitSize,
    "linkedOutlets": List<dynamic>.from(linkedOutlets.map((x) => x.toJson())),
  };
}

class LinkedOutlet {
  LinkedOutlet({
    this.outletId,
    this.outletName,
  });

  String outletId;
  String outletName;

  factory LinkedOutlet.fromJson(Map<String, dynamic> json) => LinkedOutlet(
    outletId: json["outletId"],
    outletName: json["outletName"],
  );

  Map<String, dynamic> toJson() => {
    "outletId": outletId,
    "outletName": outletName,
  };
}

class OrderBy {
  OrderBy({
    this.unitSize,
    this.unitSizeAlias,
    this.unitQuantity,
    this.isDefault,
  });

  String unitSize;
  UnitSizeAlias unitSizeAlias;
  double unitQuantity;
  bool isDefault;

  factory OrderBy.fromJson(Map<String, dynamic> json) => OrderBy(
    unitSize: json["unitSize"],
    unitSizeAlias: json["unitSizeAlias"] == null ? null : UnitSizeAlias.fromJson(json["unitSizeAlias"]),
    unitQuantity: json["unitQuantity"].toDouble(),
    isDefault: json["isDefault"],
  );

  Map<String, dynamic> toJson() => {
    "unitSize": unitSize,
    "unitSizeAlias": unitSizeAlias == null ? null : unitSizeAlias.toJson(),
    "unitQuantity": unitQuantity,
    "isDefault": isDefault,
  };
}