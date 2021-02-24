

class Amount {
  Amount({
    this.deliveryFee,
    this.gst,
    this.subTotal,
    this.total,
    this.discount,
  });

  DeliveryFee deliveryFee;
  DeliveryFee gst;
  DeliveryFee subTotal;
  DeliveryFee total;
  DeliveryFee discount;

  factory Amount.fromJson(Map<String, dynamic> json) => Amount(
    deliveryFee: DeliveryFee.fromJson(json["deliveryFee"]),
    gst: DeliveryFee.fromJson(json["gst"]),
    subTotal: DeliveryFee.fromJson(json["subTotal"]),
    total: DeliveryFee.fromJson(json["total"]),
    discount: json["discount"] == null ? null : DeliveryFee.fromJson(json["discount"]),
  );

  Map<String, dynamic> toJson() => {
    "deliveryFee": deliveryFee.toJson(),
    "gst": gst.toJson(),
    "subTotal": subTotal.toJson(),
    "total": total.toJson(),
    "discount": discount == null ? null : discount.toJson(),
  };
}

class DeliveryFee {
  DeliveryFee({
    this.currencyCode,
    this.amountV1,
    this.amount,
  });

  String currencyCode;
  double amountV1;
  double amount;

  factory DeliveryFee.fromJson(Map<String, dynamic> json) => DeliveryFee(
    currencyCode: json["currencyCode"],
    amountV1: json["amountV1"].toDouble(),
    amount: json["amount"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "currencyCode": currencyCode,
    "amountV1": amountV1,
    "amount": amount,
  };
}