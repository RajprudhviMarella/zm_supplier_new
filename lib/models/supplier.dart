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

class UpdatedBy {
  UpdatedBy({
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

  factory UpdatedBy.fromJson(Map<String, dynamic> json) => UpdatedBy(
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
