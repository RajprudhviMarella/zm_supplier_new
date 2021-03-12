/**
 * Created by RajPrudhviMarella on 08/Mar/2021.
 */

class CreateOrderModel {
  int timeDelivered;
  List<Product> products=[];
  String notes;
  String orderId;

  CreateOrderModel(
      {this.timeDelivered,
        this.products,
        this.orderId,
        this.notes});

  CreateOrderModel.fromJson(Map<String, dynamic> json) {
    timeDelivered = json['timeDelivered'];
    if (json['products'] != null) {
      products = new List<Product>();
      json['products'].forEach((v) {
        products.add(new Product.fromJson(v));
      });
    }
    notes = json['notes'];
    orderId = json['orderId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['timeDelivered'] = this.timeDelivered;
    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }
    data['notes'] = this.notes;
    data['orderId'] = this.orderId;
    return data;
  }
}

class Product {
  String sku;
  int quantity;
  String unitSize;
  String notes;

  Product({this.sku, this.quantity, this.unitSize, this.notes});

  Product.fromJson(Map<String, dynamic> json) {
    sku = json['sku'];
    quantity = json['quantity'];
    unitSize = json['unitSize'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sku'] = this.sku;
    data['quantity'] = this.quantity;
    data['unitSize'] = this.unitSize;
    data['notes'] = this.notes;
    return data;
  }
}