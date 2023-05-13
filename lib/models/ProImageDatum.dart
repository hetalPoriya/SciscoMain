class ProImageDatum{
String id;
String product_id;
String product_image;

ProImageDatum(
    this.id
    ,this.product_id
, this.product_image);
factory ProImageDatum.fromJson(Map<String, dynamic> json) => ProImageDatum(
    json["id"]
    ,json["product_id"],
    json["product_image"]

);

Map<String, dynamic> toJson() => {
  "id": id,
  "product_id": product_id,
  "product_image": product_image,


};



}