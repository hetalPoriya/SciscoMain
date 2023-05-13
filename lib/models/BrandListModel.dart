import 'package:scisco/models/CategoriesListDatum.dart';

import 'BrandListDatum.dart';

class BrandListModel {
  String error;
  String error_msg;
  List<BrandListDatum> data;


  BrandListModel.dart(this.error,
      this.data,
      this.error_msg
      );

  factory BrandListModel.fromJson(Map<String, dynamic> json) {
    return BrandListModel.dart(
      json['error'],
      json['data'] != null
          ? json['data']
          .map<BrandListDatum>((json) => BrandListDatum.fromJson(json))
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
