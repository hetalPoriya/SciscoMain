
class CategoriesListDatum{
String id;
String image;
String supercategory;
String page_name;
CategoriesListDatum(
    this.id
    ,this.image
, this.supercategory
, this.page_name

    );
factory CategoriesListDatum.fromJson(Map<String, dynamic> json) => CategoriesListDatum(
    json["id"],
    json["image"],
    json["supercategory"],
    json["page_name"]

);

Map<String, dynamic> toJson() => {
  "id": id,
  "image": image,
  "supercategory": supercategory,
  "page_name": page_name,

};



}