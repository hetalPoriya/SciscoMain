import 'package:scisco/models/VechicleTypeDatum.dart';
class VehicleTypeModel {
  String error;
  List<VechicleTypeDatum> all_mancat_type;
  String error_msg;

  VehicleTypeModel(this.error, this.all_mancat_type, this.error_msg);

  factory VehicleTypeModel.fromJson(Map<String, dynamic> json) {
    return VehicleTypeModel(
      json['error'],
      json['all_mancat_type'] != null
          ? json['all_mancat_type']
              .map<VechicleTypeDatum>((json) => VechicleTypeDatum.fromJson(json))
              .toList()
          : null,
      json['error_msg'],
    );
  }



  Map<String, dynamic> toJson() => {
        "error": error,
        "all_mancat_type": List<dynamic>.from(all_mancat_type.map((x) => x.toJson())),
        "error_msg": error_msg,
      };
}
