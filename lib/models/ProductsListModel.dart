import 'ProductsList.dart';
class ProductsListModel {
  String error;
  String error_msg;
  List<ProductsList> list;


  ProductsListModel.dart(this.error,
      this.list,
      this.error_msg
      );

  factory ProductsListModel.fromJson(Map<String, dynamic> json) {
    return ProductsListModel.dart(
      json['error'],
      json['list'] != null
          ? json['list']
          .map<ProductsList>((json) => ProductsList.fromJson(json))
          .toList()
          : null,
      json['error_msg'],

    );
  }



  Map<String, dynamic> toJson() => {
    "error": error,
    "list": List<dynamic>.from(list.map((x) => x.toJson())),
    "error_msg": error_msg,

  };
}
