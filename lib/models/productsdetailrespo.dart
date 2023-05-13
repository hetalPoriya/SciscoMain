import 'package:scisco/models/ProductsListdetail.dart';

import 'ProImageDatum.dart';
class ProductsDetailRespo {
  String error;
  String error_msg;
  List<ProImageDatum> multi_image;
  List<ProductsListDetail> list;


  ProductsDetailRespo.dart(this.error,

      this.multi_image,
      this.list,
      this.error_msg,
      );

  factory ProductsDetailRespo.fromJson(Map<String, dynamic> json) {
    return ProductsDetailRespo.dart(
      json['error'],
      json['multi_image'] != null
          ? json['multi_image']
          .map<ProImageDatum>((json) => ProImageDatum.fromJson(json))
          .toList()
          : null,
        json['list'] != null
          ? json['list']
          .map<ProductsListDetail>((json) => ProductsListDetail.fromJson(json))
          .toList()
          : null,
      json['error_msg'],

    );
  }

  Map<String, dynamic> toJson() => {
    "error": error,
    "multi_image": List<dynamic>.from(multi_image.map((x) => x.toJson())),
    "list": List<dynamic>.from(list.map((x) => x.toJson())),
    "error_msg": error_msg,

  };
}
