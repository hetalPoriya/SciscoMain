
import 'AllPaymentDatum.dart';

class TotalEarningModel {
  String error;
  String error_msg;
  String total_payment;


  List<AllPaymentDatum> all_payment;
  TotalEarningModel(
      this.error,
      this.total_payment,
      this.all_payment,


      this.error_msg);

  factory TotalEarningModel.fromJson(Map<String, dynamic> json) {
    return TotalEarningModel(
      json['error'],
      json['total_payment'],
      json['all_payment'] != null
          ? json['all_payment']
          .map<AllPaymentDatum>((json) => AllPaymentDatum.fromJson(json))
          .toList()
          : null,

      json['error_msg'],
    );
  }

  Map<String, dynamic> toJson() => {
        "error": error,
        "total_payment": total_payment,
         "all_payment": List<dynamic>.from(all_payment.map((x) => x.toJson())),

         "error_msg": error_msg,
      };
}
