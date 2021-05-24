class CategoryResponse {
  CategoryResponse({
    this.data,
  });

  List<Categories> data;

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      CategoryResponse(
        data: List<Categories>.from(
            json["data"].map((x) => Categories.fromJson(x))),
      );

  Map<String, dynamic> toJson() =>
      {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Categories {
  String categoryId;
  String name;
  String imageURL;

  Categories(this.categoryId, this.name, this.imageURL);

  Categories.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    name = json['name'];
    imageURL = json['imageURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['categoryId'] = this.categoryId;
    data['name'] = this.name;
    data['imageURL'] = this.imageURL;
  }
}
class SubCategoryBaseResponse {
  String path;
  String timestamp;
  int status;
  String message;
  List<SubCategoryData> data;

  SubCategoryBaseResponse(
      {this.path, this.timestamp, this.status, this.message, this.data});

  SubCategoryBaseResponse.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    timestamp = json['timestamp'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<SubCategoryData>();
      json['data'].forEach((v) {
        data.add(new SubCategoryData.fromJson(v));
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

class SubCategoryData {
  String categoryId;
  String name;
  List<Children> children;

  SubCategoryData({this.categoryId, this.name, this.children});

  SubCategoryData.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    name = json['name'];
    if (json['children'] != null) {
      children = new List<Children>();
      json['children'].forEach((v) {
        children.add(new Children.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryId'] = this.categoryId;
    data['name'] = this.name;
    if (this.children != null) {
      data['children'] = this.children.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Children {
  String categoryId;
  String name;

  Children({this.categoryId, this.name});

  Children.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryId'] = this.categoryId;
    data['name'] = this.name;
    return data;
  }
}
