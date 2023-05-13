import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:scisco/models/VechicleTypeDatum.dart';

import 'AllReviewData.dart';
import 'AllVehicleData.dart';
class DriverProfileModel {
  String error;
  String driver_name;
  String driver_email;
  String driver_mobile;
  String driver_image;
  String rating;
  String total_rating;
  String polite_rating;
  String strong;
  String efficient;
  String careful;
  List<AllVehicleData> all_vehicledata;
  List<AllReviewData> all_reviewsdata;
  String error_msg;

  DriverProfileModel(
      this.error,
      this.driver_name,
      this.driver_email,
      this.driver_mobile,
      this.driver_image,
      this.rating,
      this.total_rating,
      this.polite_rating,
      this.strong,
      this.efficient,
      this.careful,

      this.all_vehicledata, this.all_reviewsdata, this.error_msg);

  factory DriverProfileModel.fromJson(Map<String, dynamic> json) {
    return DriverProfileModel(
      json['error'],
      json['driver_name'],
      json['driver_email'],
      json['driver_mobile'],
      json['driver_image'],
      json['rating'],
      json['total_rating'],
      json['polite_rating'],
      json['strong'],
      json['efficient'],
      json['careful'],
      json['all_vehicledata'] != null
          ? json['all_vehicledata']
              .map<AllVehicleData>((json) => AllVehicleData.fromJson(json))
              .toList()
          : null,
      json['all_reviewsdata'] != null
          ? json['all_reviewsdata']
              .map<AllReviewData>((json) => AllReviewData.fromJson(json))
              .toList()
          : null,
      json['error_msg'],
    );
  }


  Map<String, dynamic> toJson() => {
        "error": error,
        "driver_name": driver_name,
        "driver_email": driver_email,
        "driver_mobile": driver_mobile,
        "driver_image": driver_image,
        "rating": rating,
        "total_rating": total_rating,
        "polite_rating": polite_rating,
        "strong": strong,
        "efficient": efficient,
        "careful": careful,
        "all_vehicledata": List<dynamic>.from(all_vehicledata.map((x) => x.toJson())),
        "all_reviewsdata": List<dynamic>.from(all_reviewsdata.map((x) => x.toJson())),
        "error_msg": error_msg,
      };
}
