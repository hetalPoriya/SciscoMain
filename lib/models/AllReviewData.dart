class AllReviewData{
String id;
String message;
String rating;
String strong_rating;
String efficient_rating;
String careful_rating;
String polite_rating;
String reviews_date;
String customer_name;
String image_name;

AllReviewData(this.id
, this.message
, this.rating
, this.strong_rating
, this.efficient_rating
, this.careful_rating
, this.polite_rating
, this.reviews_date
, this.customer_name
, this.image_name
);
factory AllReviewData.fromJson(Map<String, dynamic> json) => AllReviewData(json["id"]
,json["message"]
,json["rating"]
,json["strong_rating"]
,json["efficient_rating"]
,json["careful_rating"]
,json["polite_rating"]
,json["reviews_date"]
,json["customer_name"]
,json["image_name"]

);

Map<String, dynamic> toJson() => {
  "id": id,
  "message": message,
  "rating": rating,
  "strong_rating": strong_rating,
  "efficient_rating": efficient_rating,
  "careful_rating": careful_rating,
  "polite_rating": polite_rating,
  "reviews_date": reviews_date,
  "customer_name": customer_name,
  "image_name": image_name,
};



}