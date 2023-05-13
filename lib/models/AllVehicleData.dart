class AllVehicleData{
String id;
String name;
String image_name;

AllVehicleData(this.id
, this.name
, this.image_name
);
factory AllVehicleData.fromJson(Map<String, dynamic> json) => AllVehicleData(json["id"]
,json["name"]
,json["image_name"]);

Map<String, dynamic> toJson() => {
  "id": id,
  "name": name,
  "image_name": image_name,
};



}