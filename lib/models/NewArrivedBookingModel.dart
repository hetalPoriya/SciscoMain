import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:scisco/models/ScheduledBookingData.dart';

import 'VechicleEquipmentDatum.dart';

class NewArrivedBookingModel {
  String error;
  String error_msg;
  String booking_id;
  int total_sec;
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
  String all_b_images;
  String customer_name;
  String customer_mobile_number;
  String customer_image;
  String booking_status;
  String delivery_address_unit_no;
  String pickup_address_unit_no;
  List<ScheduledBookingData> driver_current_upcomingbookings;

  NewArrivedBookingModel.dart(this.error
      , this.booking_id
      , this.total_sec
      , this.customer_id
      , this.pickup_date
      , this.pickup_time
      , this.pickup_address
      , this.delivery_address
      , this.type_of_move
      , this.job_detail
      , this.any_stairs_involved
      , this.access_issues
      , this.parking_inst
      , this.truck_type
      , this.category_image
      , this.total_amount
      , this.all_b_images
      , this.customer_name
      , this.customer_mobile_number
      , this.customer_image
      , this.error_msg
      , this.booking_status
      , this.delivery_address_unit_no
      , this.pickup_address_unit_no
      ,this.driver_current_upcomingbookings
      );

  factory NewArrivedBookingModel.fromJson(Map<String, dynamic> json) {
    return NewArrivedBookingModel.dart(
      json['error'],
      json['booking_id'],
      json['total_sec'],
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
      json['all_b_images'],
      json['customer_name'],
      json['customer_mobile_number'],
      json['customer_image'],
      json['error_msg'],
      json['booking_status'],
      json['delivery_address_unit_no'],
      json['pickup_address_unit_no'],
      json['driver_current_upcomingbookings'] != null
          ? json['driver_current_upcomingbookings']
          .map<ScheduledBookingData>((json) => ScheduledBookingData.fromJson(json))
          .toList()
          : null,
    );
  }



  Map<String, dynamic> toJson() => {
    "error": error,
    "booking_id": booking_id,
    "total_sec": total_sec,
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
    "all_b_images": all_b_images,
    "customer_name": customer_name,
    "customer_mobile_number": customer_mobile_number,
    "customer_image": customer_image,
    "error_msg": error_msg,
    "booking_status": booking_status,
    "delivery_address_unit_no": delivery_address_unit_no,
    "pickup_address_unit_no": pickup_address_unit_no,
    "driver_current_upcomingbookings": List<dynamic>.from(driver_current_upcomingbookings.map((x) => x.toJson())),
  };
}
