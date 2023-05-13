class ProductsList{
  String image;
  String product_name;
  String category;
  String status;
  int quantity;
  String categoryid;
  String superCategoryId;
  String supercategoryname;
  String brandId;
  String id;
  String brand_name;
  String description;
  String specification;
  String features;
  String discount;
  String flat;
ProductsList(
    this.image,
    this.product_name,
    this.category,
    this.status,
    this.categoryid,
    this.quantity,
    this.superCategoryId,
    this.supercategoryname,
    this.brandId,
    this.id,
    this.brand_name,
    this.description,
    this.specification,
    this.features,
    this.discount,
    this.flat
    );

factory ProductsList.fromJson(Map<String, dynamic> json) => ProductsList(
    json["image"],
    json["product_name"],
    json["category"],
    json["status"],
    json["categoryid"],
    json["quantity"],
    json["supercategoryid"],
    json["supercategory_name"],
    json["brandid"],
    json["id"],
    json["brand_name"],
    json["description"],
    json["specification"],
    json["features"],
    json["discount"],
    json["flat"]
);

Map<String, dynamic> toJson() => {
  "image": image,
  "product_name": product_name,
  "category": category,
  "status": status,
  "categoryid": categoryid,
  "quantity": quantity,
  "supercategory_name": supercategoryname,
  "supercategory_id": superCategoryId,
  "brandid": brandId,
  "id": id,
  "brand_name": brand_name,
  "description": description,
  "specification": specification,
  "features": features,
  "discount": discount,
  "flat": flat,
};



}