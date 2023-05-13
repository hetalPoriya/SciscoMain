class VechicleTypeDatum{
String id;
String title;
String sub_title;
String bottom_title;
String price;
String image_url;


VechicleTypeDatum(this.id
, this.title
, this.sub_title
, this.bottom_title
, this.price

, this.image_url);

factory VechicleTypeDatum.fromJson(Map<String, dynamic> json) => VechicleTypeDatum(json["id"]
,json["title"]
,json["sub_title"]
,json["bottom_title"]
,json["price"]
,json["image_url"]);

Map<String, dynamic> toJson() => {
  "id": id,
  "title": title,
  "sub_title": sub_title,
  "price": price,
  "image_url": image_url,
};



}