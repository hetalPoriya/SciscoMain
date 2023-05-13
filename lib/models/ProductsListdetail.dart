class ProductsListDetail{
// String id;
String image;
String product_name;
String category;
String status;
String categoryid;
String supercategoryid;
String supercategoryname;
String brandid;
String brand_name;
String brochure;
String description;
String specification;
String features;
ProductsListDetail(
    // this.id
    this.image
, this.product_name
, this.category
, this.status
, this.categoryid
, this.supercategoryid
, this.supercategoryname
, this.brandid
, this.brand_name
,this.brochure
, this.description
, this.specification
,this.features

    );
factory ProductsListDetail.fromJson(Map<String, dynamic> json) => ProductsListDetail(
    // json["id"],
    json["image"],
    json["product_name"]
,json["category"]
,json["status"]
,json["categoryid"]
,json["supercategoryid"]
,json["supercategoryname"]
,json["brandid"]
,json["brand_name"]
,json["brochure"]
,json["description"]
,json["specification"]
,json["features"]
);

Map<String, dynamic> toJson() => {
  // "id": id,
  "image": image,
  "product_name": product_name,
  "category": category,
  "status": status,
  "categoryid": categoryid,
  "supercategoryid": supercategoryid,
  "supercategoryname": supercategoryname,
  "brandid": brandid,
  "brand_name": brand_name,
  "brochure": brochure,
  "description": description,
  "specification": specification,
  "features": features
};
}