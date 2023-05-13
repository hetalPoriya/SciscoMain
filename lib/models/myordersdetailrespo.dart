import 'MyOrdersDetailDatum.dart';
class MyOrdersDetailRespo {
  String error;
  String error_msg;
  dynamic grand_total;
  dynamic discount_amount;
  dynamic discount_grand_total;
  String orderstatus;
  String promocodedata;
  String transactionId;
  String actualPrice;
  String transportationCharges;
  List<MyOrdersDetailDatum> list;


  MyOrdersDetailRespo.dart(this.error,
      this.list,
      this.error_msg,
      this.grand_total,
      this.discount_amount,
      this.discount_grand_total,
      this.orderstatus,
      this.promocodedata,
      this.transactionId,
      this.actualPrice,
      this.transportationCharges,
      );

  factory MyOrdersDetailRespo.fromJson(Map<String, dynamic> json) {
    return MyOrdersDetailRespo.dart(
      json['error'],
      json['list'] != null
          ? json['list']
          .map<MyOrdersDetailDatum>((json) => MyOrdersDetailDatum.fromJson(json))
          .toList()
          : null,
      json['error_msg'],
      json['grand_total'],
      json['discount_amount'],
      json['discount_grand_total'],
      json['order_status'],
      json['promocodedata'],
      json['trasaction_id'],
      json['Actual_Price'],
      json['TransportationCharges'],

    );
  }



  Map<String, dynamic> toJson() => {
    "error": error,
    "list": List<dynamic>.from(list.map((x) => x.toJson())),
    "error_msg": error_msg,
    "grand_total": grand_total,
    "discount_amount": discount_amount,
    "discount_grand_total": discount_grand_total,
    "order_status": orderstatus,
    "promocodedata": promocodedata,
    "trasaction_id": transactionId,
    "Actual_Price": actualPrice,
    "TransportationCharges": transportationCharges,
  };
}
