import 'dart:convert';

import 'package:dio/dio.dart';
class CommonRespoModel {
  String error;
  String error_msg;

  CommonRespoModel(this.error, this.error_msg);

  factory CommonRespoModel.fromJson(Map<String, dynamic> json) {
    return CommonRespoModel(
      json['error'],
      json['error_msg'],
    );
  }



  Map<String, dynamic> toJson() => {
        "error": error,

        "error_msg": error_msg,
      };
}
