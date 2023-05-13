import 'package:scisco/models/CategoriesListDatum.dart';

import 'BrandByProductDatum.dart';

class BrandByProductModel {
  String error;
  String error_msg;
  List<BrandByProductDatum> data;


  BrandByProductModel.dart(this.error,
      this.data,
      this.error_msg
      );

  factory BrandByProductModel.fromJson(Map<String, dynamic> json) {
    return BrandByProductModel.dart(
      json['error'],
      json['data'] != null
          ? json['data']
          .map<BrandByProductDatum>((json) => BrandByProductDatum.fromJson(json))
          .toList()
          : null,
      json['error_msg'],

    );
  }



  Map<String, dynamic> toJson() => {
    "error": error,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "error_msg": error_msg,

  };
}
