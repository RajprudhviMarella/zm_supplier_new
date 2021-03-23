class UnitSizeAlias {
  String shortName;
  bool isDecimalAllowed = false;

  UnitSizeAlias.fromJson(Map<String, dynamic> json) {
    shortName = json['shortName'];
    isDecimalAllowed = json['isDecimalAllowed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shortName'] = this.shortName;
    data['isDecimalAllowed'] = this.isDecimalAllowed;
    return data;
  }
}
