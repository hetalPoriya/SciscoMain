
import 'AllPaymentDatum.dart';

class EarningDetailModel {
  String error;
  String error_msg;
  String booking_amount;
  String service_fee;
  String tax_charge;
  String earn_amount;
  String earn_date;

  EarningDetailModel(
      this.error,
      this.booking_amount,
      this.service_fee,
      this.tax_charge,
      this.earn_amount,
      this.earn_date,


      this.error_msg);

  factory EarningDetailModel.fromJson(Map<String, dynamic> json) {
    return EarningDetailModel(
      json['error'],
      json['booking_amount'],
      json['service_fee'],
      json['tax_charge'],
      json['earn_amount'],
      json['earn_date'],


      json['error_msg'],
    );
  }

  Map<String, dynamic> toJson() => {
        "error": error,
        "booking_amount": booking_amount,
        "service_fee": service_fee,
        "tax_charge": tax_charge,
        "earn_amount": earn_amount,
        "earn_date": earn_date,


         "error_msg": error_msg,
      };
}
