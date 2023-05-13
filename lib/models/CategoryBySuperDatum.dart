
class CategoryBySuperDatum{
  String id;
  String image;
  String superCategory;
  String superCategoryId;

  CategoryBySuperDatum(
      this.id
      ,this.image
      , this.superCategory
      , this.superCategoryId

      );
  factory CategoryBySuperDatum.fromJson(Map<String, dynamic> json) => CategoryBySuperDatum(
      json["id"],
      json["image"],
      json["supercategory"],
      json["supercategory_id"]

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "supercategory": superCategory,
    "supercategory_id": superCategoryId,

  };



}