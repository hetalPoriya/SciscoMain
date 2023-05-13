import 'dart:convert';

import 'package:dio/dio.dart';
class LiveStatusModel {
  String error;
  String error_msg;
  String live_status;

  LiveStatusModel(this.error,this.live_status, this.error_msg);

  factory LiveStatusModel.fromJson(Map<String, dynamic> json) {
    return LiveStatusModel(
      json['error'],
      json['live_status'],
      json['error_msg'],
    );
  }



  Map<String, dynamic> toJson() => {
        "error": error,
        "live_status": live_status,

        "error_msg": error_msg,
      };
}
