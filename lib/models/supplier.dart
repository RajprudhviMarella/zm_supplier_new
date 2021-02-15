class Supplier {
  Supplier({
    this.supplierId,
    this.supplierName,
    this.timeZone,
    this.logoUrl,
    this.market,
  });

  String supplierId;
  String supplierName;
  String timeZone;
  String logoUrl;
  String market;

  factory Supplier.fromJson(Map<String, dynamic> json) => Supplier(
    supplierId: json["supplierId"],
    supplierName: json["supplierName"],
    timeZone: json["timeZone"],
    logoUrl: json["logoURL"],
    market: json["market"],
  );

  Map<String, dynamic> toJson() => {
    "supplierId": supplierId,
    "supplierName": supplierName,
    "timeZone": timeZone,
    "logoURL": logoUrl,
    "market": market,
  };
}
