import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:scisco/models/MoveItemsDatum.dart';
class MoveItemsModel {
  String error;
  List<MoveItemsDatum> all_move_type;
  String error_msg;
  MoveItemsModel(this.error, this.all_move_type, this.error_msg);

  factory MoveItemsModel.fromJson(Map<String, dynamic> json) {
    return MoveItemsModel(
      json['error'],
      json['all_move_type'] != null
          ? json['all_move_type']
              .map<MoveItemsDatum>((json) => MoveItemsDatum.fromJson(json))
              .toList()
          : null,
      json['error_msg'],
    );
  }



  Map<String, dynamic> toJson() => {
        "error": error,
        "all_move_type": List<dynamic>.from(all_move_type.map((x) => x.toJson())),
        "error_msg": error_msg,
      };
}
