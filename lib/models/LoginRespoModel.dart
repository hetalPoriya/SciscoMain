class LoginRespoModel {
  String error;
  String error_msg;
  String name;
  String mobile;
  String email;
  String user_id;
  String whatsapp;
  String organisation;
  String category;
  String kyc;
  String order_id;
  String registration_upload;
  String aadhar_card_upload;
  String hospital_reg_no;
  String drug_license_no;
  String pan;
  String gstin;


  LoginRespoModel(
      this.error,
      this.error_msg,
      this.name,
      this.mobile,
      this.email,
      this.user_id,
      this.whatsapp,
      this.organisation,
      this.category,
      this.kyc,
      this.order_id,
      this.registration_upload,
      this.aadhar_card_upload,
      this.hospital_reg_no,
      this.drug_license_no,
      this.pan,
      this.gstin,
      );

  factory LoginRespoModel.fromJson(Map<String, dynamic> json) {
    return LoginRespoModel(
      json['error'].toString(),
      json['error_msg'],
      json['name'],
      json['mobile'],
      json['email'],
      json['user_id'].toString(),
      json['whatsapp'].toString(),
      json['organisation'].toString(),
      json['categories'].toString(),
      json['kyc'].toString(),
      json['order_id'].toString(),
      json['registration_upload'].toString(),
      json['aadhar_card_upload'].toString(),
      json['hospital_reg_no'].toString(),
      json['drug_license_no'].toString(),
      json['pan'].toString(),
      json['gstin'].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "error": error,
        "error_msg": error_msg,
        "name": name,
        "mobile": mobile,
        "email": email,
        "user_id": user_id,
        "whatsapp": whatsapp,
        "organisation": organisation,
        "categories": category,
        "kyc": kyc,
        "order_id": order_id,
        "registration_upload": registration_upload,
        "aadhar_card_upload": aadhar_card_upload,
        "hospital_reg_no": hospital_reg_no,
        "drug_license_no": drug_license_no,
        "pan": pan,
        "gstin": gstin,
      };
}
