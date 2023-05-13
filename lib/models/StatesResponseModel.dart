class StateResponseModel {
  String error;
  String error_msg;
  List<StateListModel> states;


  StateResponseModel(
      this.error,
      this.error_msg,
      this.states,
      );

  factory StateResponseModel.fromJson(Map<String, dynamic> json) {
    return StateResponseModel(
      json['error'].toString(),
      json['error_msg'],
      json['state'] != null
        ? json['state']
        .map<StateListModel>((json) => StateListModel.fromJson(json))
        .toList()
        : null,

    );
  }

  Map<String, dynamic> toJson() => {
    "error": error,
    "error_msg": error_msg,
    "state": List<dynamic>.from(states.map((x) => x.toJson())),

  };
}
class StateListModel {
  String name;
  String id;


  StateListModel(
      this.name,
      this.id,
      );

  factory StateListModel.fromJson(Map<String, dynamic> json) {
    return StateListModel(
      json['name'],
      json['id'].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,

  };
}
