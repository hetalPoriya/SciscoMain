class CityResponseModel {
  String error;
  String error_msg;
  List<CityListModel> cities;


  CityResponseModel(
      this.error,
      this.error_msg,
      this.cities,
      );

  factory CityResponseModel.fromJson(Map<String, dynamic> json) {
    return CityResponseModel(
      json['error'].toString(),
      json['error_msg'],
      json['city'] != null
          ? json['city']
          .map<CityListModel>((json) => CityListModel.fromJson(json))
          .toList()
          : null,

    );
  }

  Map<String, dynamic> toJson() => {
    "error": error,
    "error_msg": error_msg,
    "city": List<dynamic>.from(cities.map((x) => x.toJson())),

  };
}
class CityListModel {
  String name;
  String id;


  CityListModel(
      this.name,
      this.id,
      );

  factory CityListModel.fromJson(Map<String, dynamic> json) {
    return CityListModel(
      json['name'],
      json['id'].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,

  };
}
