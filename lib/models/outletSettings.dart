class Outlet {
  Outlet({
    this.outletId,
    this.outletName,
    this.timeZone,
    this.logoUrl,
  });

  String outletId;
  String outletName;
  String timeZone;
  String logoUrl;

  factory Outlet.fromJson(Map<String, dynamic> json) => Outlet(
        outletId: json["outletId"],
        outletName: json["outletName"],
        timeZone: json["timeZone"],
        logoUrl: json["logoURL"],
      );

  Map<String, dynamic> toJson() => {
        "outletId": outletId,
        "outletName": outletName,
        "timeZone": timeZone,
        "logoURL": logoUrl,
      };
}

class Company {
  Company({
    this.companyId,
    this.companyName,
    this.logoUrl,
    this.market,
    this.timeZone,
  });

  String companyId;
  String companyName;
  String logoUrl;
  String market;
  String timeZone;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        companyId: json["companyId"],
        companyName: json["companyName"],
        logoUrl: json["logoURL"],
        market: json["market"],
        timeZone: json["timeZone"] == null ? null : json["timeZone"],
      );

  Map<String, dynamic> toJson() => {
        "companyId": companyId,
        "companyName": companyName,
        "logoURL": logoUrl,
        "market": market,
        "timeZone": timeZone == null ? null : timeZone,
      };
}

class OutletFeatures {
  OutletFeatures({
    this.businessType,
    this.cuisineType,
    this.cuisineFeatures,
    this.tags,
  });

  List<OutletFeatureType> businessType;
  List<OutletFeatureType> cuisineType;
  List<OutletFeatureType> cuisineFeatures;
  List<String> tags;

  factory OutletFeatures.fromJson(Map<String, dynamic> json) => OutletFeatures(
        businessType: List<OutletFeatureType>.from(
            json["businessType"].map((x) => OutletFeatureType.fromJson(x))),
        cuisineType: List<OutletFeatureType>.from(
            json["cuisineType"].map((x) => OutletFeatureType.fromJson(x))),
        cuisineFeatures: List<OutletFeatureType>.from(
            json["cuisineFeatures"].map((x) => OutletFeatureType.fromJson(x))),
        tags: List<String>.from(json["tags"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "businessType": List<dynamic>.from(businessType.map((x) => x.toJson())),
        "cuisineType": List<dynamic>.from(cuisineType.map((x) => x.toJson())),
        "cuisineFeatures":
            List<dynamic>.from(cuisineFeatures.map((x) => x.toJson())),
        "tags": List<dynamic>.from(tags.map((x) => x)),
      };
}

class OutletFeatureType {
  OutletFeatureType({
    this.id,
    this.name,
  });

  String id;
  String name;

  factory OutletFeatureType.fromJson(Map<String, dynamic> json) =>
      OutletFeatureType(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
