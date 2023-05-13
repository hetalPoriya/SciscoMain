import 'package:scisco/models/SettlementDatum.dart';
class SettlementListModel {
  String error;
  List<SettlementDatum> all_payment;
  String error_msg;

  SettlementListModel(this.error, this.all_payment, this.error_msg);

  factory SettlementListModel.fromJson(Map<String, dynamic> json) {
    return SettlementListModel(
      json['error'],
      json['all_payment'] != null
          ? json['all_payment']
              .map<SettlementDatum>((json) => SettlementDatum.fromJson(json))
              .toList()
          : null,
      json['error_msg'],
    );
  }



  Map<String, dynamic> toJson() => {
        "error": error,
        "all_payment": List<dynamic>.from(all_payment.map((x) => x.toJson())),
        "error_msg": error_msg,
      };
}
