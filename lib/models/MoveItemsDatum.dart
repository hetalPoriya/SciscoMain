
class MoveItemsDatum{
String id;
String name;
String image_url;

MoveItemsDatum(this.id, this.name, this.image_url);
factory MoveItemsDatum.fromJson(Map<String, dynamic> json) => MoveItemsDatum(json["id"],json["name"],json["image_url"]);

Map<String, dynamic> toJson() => {
  "id": id,
  "name": name,
  "image_url": image_url,
};



}