import 'package:scisco/models/CategoriesListDatum.dart';

import 'ProductsList.dart';
class CategoriesListModel {
  String error;
  String error_msg;
  List<CategoriesListDatum> data;


  CategoriesListModel.dart(this.error,
      this.data,
      this.error_msg
      );

  factory CategoriesListModel.fromJson(Map<String, dynamic> json) {
    return CategoriesListModel.dart(
      json['error'],
      json['data'] != null
          ? json['data']
          .map<CategoriesListDatum>((json) => CategoriesListDatum.fromJson(json))
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
