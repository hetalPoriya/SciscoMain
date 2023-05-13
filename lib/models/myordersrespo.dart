import 'MyOrdersDatum.dart';
class MyOrdersRespo {
  String error;
  String error_msg;
  List<MyOrdersDatum> list;


  MyOrdersRespo.dart(this.error,
      this.list,
      this.error_msg
      );

  factory MyOrdersRespo.fromJson(Map<String, dynamic> json) {
    return MyOrdersRespo.dart(
      json['error'],
      json['list'] != null
          ? json['list']
          .map<MyOrdersDatum>((json) => MyOrdersDatum.fromJson(json))
          .toList()
          : null,
      json['error_msg'],

    );
  }



  Map<String, dynamic> toJson() => {
    "error": error,
    "list": List<dynamic>.from(list.map((x) => x.toJson())),
    "error_msg": error_msg,

  };
}
