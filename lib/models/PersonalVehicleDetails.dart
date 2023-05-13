import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:scisco/models/SelectedVehicleEquipment.dart';
class PersonalVehicleDetails {
  String error;
  String error_msg;
  String vehicle_type;
  int how_many_men;
  List<SelectedVehicleEquipment> vehicle_equipment;
  String vehicle_height;
  String cargo_area_height;
  String cargo_area_width;
  String cargo_area_lenght;

  PersonalVehicleDetails(
  this.error
  ,this.error_msg
  ,this.vehicle_type
  ,this.how_many_men
  ,this.vehicle_equipment
  ,this.vehicle_height
  ,this.cargo_area_height
  ,this.cargo_area_width
  ,this.cargo_area_lenght);

  factory PersonalVehicleDetails.fromJson(Map<String, dynamic> json) {
    return PersonalVehicleDetails(
      json['error'],
      json['error_msg'],
      json['vehicle_type'],
      json['how_many_men'],
      json['vehicle_equipment'] != null
          ? json['vehicle_equipment']
          .map<SelectedVehicleEquipment>((json) => SelectedVehicleEquipment.fromJson(json))
          .toList()
          : null,
      json['vehicle_height'],
      json['cargo_area_height'],
      json['cargo_area_width'],
      json['cargo_area_lenght'],
    );
  }



  Map<String, dynamic> toJson() => {
    "error": error,
    "error_msg": error_msg,
    "vehicle_type": vehicle_type,
    "how_many_men": how_many_men,
    "vehicle_equipment": List<dynamic>.from(vehicle_equipment.map((x) => x.toJson())),

    "vehicle_height": vehicle_height,
    "cargo_area_height": cargo_area_height,
    "cargo_area_width": cargo_area_width,
    "cargo_area_lenght": cargo_area_lenght,
  };
}
