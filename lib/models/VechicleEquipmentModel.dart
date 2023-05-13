import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:scisco/models/VechicleEquipmentDatum.dart';

class VechicleEquipmentModel {
  String error;
  List<VechicleEquipmentDatum> all_vehicle_equipment;
  String error_msg;

  VechicleEquipmentModel.dart(this.error, this.all_vehicle_equipment, this.error_msg);

  factory VechicleEquipmentModel.fromJson(Map<String, dynamic> json) {
    return VechicleEquipmentModel.dart(
      json['error'],
      json['all_vehicle_equipment'] != null
          ? json['all_vehicle_equipment']
              .map<VechicleEquipmentDatum>((json) => VechicleEquipmentDatum.fromJson(json))
              .toList()
          : null,
      json['error_msg'],
    );
  }



  Map<String, dynamic> toJson() => {
        "error": error,
        "all_vehicle_equipment": List<dynamic>.from(all_vehicle_equipment.map((x) => x.toJson())),
        "error_msg": error_msg,
      };
}
