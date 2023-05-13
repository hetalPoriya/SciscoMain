import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:scisco/models/insuranceSavedData.dart';

import 'AllImages.dart';
class BookingDetailsModel {
  String error;
  String id;
  String order_id;
  String customer_id;
  String pickup_date;
  String pickup_time;
  String pickup_address;
  String delivery_address;
  String type_of_move;
  String job_detail;
  String any_stairs_involved;
  String access_issues;
  String parking_inst;
  String truck_type;
  String category_image;
  String total_amount;
  String booking_status;
  String show_mobile;
  List<AllImages>  all_images;
  List<InsuranceSavedData>  insurance_data;
  String driver_name;
  String driver_image;
  int driver_distance;
  String driver_rating;
  String driver_id;
  String driver_total_rating;
  String customer_name;
  String customer_mobile_number;
  String error_msg;
  String pickup_address_unit_no;
  String delivery_address_unit_no;
  String booking_type;

  BookingDetailsModel(this.error
      ,this.id
      ,this.order_id
      ,this.customer_id
      ,this.pickup_date
      ,this.pickup_time
      ,this.pickup_address
      ,this.delivery_address
      ,this.type_of_move
      ,this.job_detail
      ,this.any_stairs_involved
      ,this.access_issues
      ,this.parking_inst
      ,this.truck_type
      ,this.category_image
      ,this.total_amount
      ,this.booking_status
      ,this.show_mobile
      ,this.all_images
      ,this.insurance_data
      ,this.driver_name
      ,this.driver_image
      ,this.driver_distance
      ,this.driver_rating
      ,this.driver_id
      ,this.driver_total_rating
      ,this.customer_name
      ,this.customer_mobile_number
      , this.error_msg
      , this.pickup_address_unit_no
      , this.delivery_address_unit_no
      , this.booking_type

      );

  factory BookingDetailsModel.fromJson(Map<String, dynamic> json) {
    return BookingDetailsModel(
      json['error'],
      json['id'],
      json['order_id'],
      json['customer_id'],
      json['pickup_date'],
      json['pickup_time'],
      json['pickup_address'],
      json['delivery_address'],
      json['type_of_move'],
      json['job_detail'],
      json['any_stairs_involved'],
      json['access_issues'],
      json['parking_inst'],
      json['truck_type'],
      json['category_image'],
      json['total_amount'],
      json['booking_status'],
      json['show_mobile'],

      json['all_images'] != null
          ? json['all_images']
          .map<AllImages>((json) => AllImages.fromJson(json))
          .toList()
          : null,
 json['insurance_data'] != null
          ? json['insurance_data']
          .map<InsuranceSavedData>((json) => InsuranceSavedData.fromJson(json))
          .toList()
          : null,

      json['driver_name'],
      json['driver_image'],
      json['driver_distance'],
      json['driver_rating'],
      json['driver_id'],
      json['driver_total_rating'],
      json['customer_name'],
      json['customer_mobile_number'],
      json['error_msg'],
      json['pickup_address_unit_no'],
      json['delivery_address_unit_no'],
      json['booking_type'],
    );
  }

  Map<String, dynamic> toJson() => {
        "error": error,
        "id": id,
        "order_id": order_id,
        "customer_id": customer_id,
        "pickup_date": pickup_date,
        "pickup_time": pickup_time,
        "pickup_address": pickup_address,
        "delivery_address": delivery_address,
        "type_of_move": type_of_move,
        "job_detail": job_detail,
        "any_stairs_involved": any_stairs_involved,
        "access_issues": access_issues,
        "parking_inst": parking_inst,
        "truck_type": truck_type,
        "category_image": category_image,
        "total_amount": total_amount,
        "booking_status": booking_status,
        "show_mobile": show_mobile,
        "all_images": List<dynamic>.from(all_images.map((x) => x.toJson())),
        "insurance_data": List<dynamic>.from(insurance_data.map((x) => x.toJson())),

    "driver_name": driver_name,
        "driver_image": driver_image,
        "driver_distance": driver_distance,
        "driver_rating": driver_rating,
        "driver_id": driver_id,
        "driver_total_rating": driver_total_rating,
        "customer_name": customer_name,
        "customer_mobile_number": customer_mobile_number,
        "error_msg": error_msg,
        "pickup_address_unit_no": pickup_address_unit_no,
        "delivery_address_unit_no": delivery_address_unit_no,
        "booking_type": booking_type,
      };
}
