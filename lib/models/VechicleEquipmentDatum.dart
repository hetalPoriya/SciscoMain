class VechicleEquipmentDatum{
  String id;
  String name;



  VechicleEquipmentDatum(this.id
      , this.name
   );
  factory VechicleEquipmentDatum.fromJson(Map<String, dynamic> json) => VechicleEquipmentDatum(json["id"]
      ,json["name"]
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,

  };



}