class MyOrdersDatum{
String id;
String image;
String product_name;
String category;
String status;
String categoryid;
String supercategoryid;
String supercategory_name;
String Distributer;
String brandid;
String brand_name;
String order_id;
String orderstaus;
String order_date;


MyOrdersDatum(
    this.id
    ,this.image
, this.product_name
, this.category
, this.status
, this.categoryid
, this.supercategoryid
, this.supercategory_name
, this.Distributer
, this.brandid
, this.brand_name
, this.order_id
, this.orderstaus
, this.order_date


    );
factory MyOrdersDatum.fromJson(Map<String, dynamic> json) => MyOrdersDatum(
    json["id"]
    ,json["image"],
    json["product_name"]
,json["category"]
,json["status"]
,json["categoryid"]
,json["supercategoryid"]
,json["supercategory_name"]
,json["Distributer"]
,json["brandid"]
,json["brand_name"]
,json["order_id"].toString()
,json["orderstaus"].toString()
,json["order_date"]

);

Map<String, dynamic> toJson() => {
  "id": id,
  "image": image,
  "product_name": product_name,
  "category": category,
  "status": status,
  "categoryid": categoryid,
  "supercategoryid": supercategoryid,
  "supercategory_name": supercategory_name,
  "Distributer": Distributer,
  "brandid": brandid,
  "brand_name": brand_name,
  "order_id": order_id,
  "orderstaus": orderstaus,
  "order_date": order_date,

};



}