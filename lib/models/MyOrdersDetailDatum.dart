class MyOrdersDetailDatum{
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
  String price;
  String order_date;
  String quantity;
  String orderstatus;
  String actualPrice;
  String gst;
  String discount;
  String clientType;
  String grandTotal;
  String deliverQuantity;

  MyOrdersDetailDatum(
      this.id,
      this.image,
      this.product_name,
      this.category,
      this.status,
      this.categoryid,
      this.supercategoryid,
      this.supercategory_name,
      this.Distributer,
      this.brandid,
      this.brand_name,
      this.price,
      this.order_date,
      this.quantity,
      this.orderstatus,
      this.actualPrice,
      this.gst,
      this.discount,
      this.clientType,
      this.grandTotal,
      this.deliverQuantity,
      );
  factory MyOrdersDetailDatum.fromJson(Map<String, dynamic> json) => MyOrdersDetailDatum(
    json["id"]
    ,json["image"]
    ,json["product_name"]
    ,json["category"]
    ,json["status"]
    ,json["categoryid"]
    ,json["supercategoryid"]
    ,json["supercategory_name"]
    ,json["Distributer"]
    ,json["brandid"]
    ,json["brand_name"]
    ,json["price"]
    ,json["order_date"]
    ,json["quantity"]
    ,json["order_status"],
    json["Actual_Price"],
    json["gst"],
    json["discount"],
    json["client_type"],
    json["grand_total"],
    json["deliver_quantity"],
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
    "price": price,
    "quantity": quantity,
    "order_status": orderstatus,
    "Actual_Price": actualPrice,
    "discount": discount,
    "gst": gst,
    "client_type": clientType,
    "grand_total": grandTotal,
    "deliver_quantity": deliverQuantity,
  };
}