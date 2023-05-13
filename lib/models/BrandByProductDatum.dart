class BrandByProductDatum {
  String id;
  String image;
  String superCategory;
  String superCategoryId;

  BrandByProductDatum(this.id
      , this.image
      , this.superCategory
      , this.superCategoryId);

  factory BrandByProductDatum.fromJson(Map<String, dynamic> json) =>
      BrandByProductDatum(
          json["id"],
          json["image"],
          json["supercategory"],
          json["supercategory_id"]

      );

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "image": image,
        "supercategory": superCategory,
        "supercategory_id": superCategoryId,

      };
}