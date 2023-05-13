
class BrandListDatum{
  String id;
  String image;
  String supercategory;
  BrandListDatum(
      this.id
      ,this.image
      , this.supercategory

      );
  factory BrandListDatum.fromJson(Map<String, dynamic> json) => BrandListDatum(
      json["id"],
      json["image"],
      json["supercategory"]

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "supercategory": supercategory,

  };



}