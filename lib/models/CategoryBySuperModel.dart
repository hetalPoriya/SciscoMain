import 'package:scisco/models/CategoriesListDatum.dart';

import 'CategoryBySuperDatum.dart';

class CategoriesBySuperModel {
  String error;
  String error_msg;
  List<CategoryBySuperDatum> data;


  CategoriesBySuperModel.dart(this.error,
      this.data,
      this.error_msg
      );

  factory CategoriesBySuperModel.fromJson(Map<String, dynamic> json) {
    return CategoriesBySuperModel.dart(
      json['error'],
      json['data'] != null
          ? json['data']
          .map<CategoryBySuperDatum>((json) => CategoryBySuperDatum.fromJson(json))
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
