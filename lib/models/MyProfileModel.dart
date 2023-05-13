class MyProfileModel {
  String error;
  String name;
  String email;
  String mobile;
  String id;
  String address;
  String error_msg;

  MyProfileModel(
    this.error,
    this.name,
    this.email,
    this.mobile,
    this.id,
    this.address,
    this.error_msg,
  );

  factory MyProfileModel.fromJson(Map<String, dynamic> json) {
    return MyProfileModel(
      json['error'],
      json['name'],
      json['email'],
      json['mobile'],
      json['id'],
      json['address'],
      json['error_msg'],
    );
  }

  Map<String, dynamic> toJson() => {
        "error": error,
        "name": name,
        "email": email,
        "mobile": mobile,
        "id": id,
        "address": address,
        "error_msg": error_msg,
      };
}
