class InsuranceSavedData {
  String parentId;
  String parentName;
  List<Data> data;

  InsuranceSavedData({this.parentId, this.parentName, this.data});

  InsuranceSavedData.fromJson(Map<String, dynamic> json) {
    parentId = json['parent_id'];
    parentName = json['parent_name'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['parent_id'] = this.parentId;
    data['parent_name'] = this.parentName;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String id;
  String categoryName;
  String qty;
  String totalValue;

  Data({this.id, this.categoryName, this.qty, this.totalValue});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    qty = json['qty'];
    totalValue = json['total_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['qty'] = this.qty;
    data['total_value'] = this.totalValue;
    return data;
  }
}