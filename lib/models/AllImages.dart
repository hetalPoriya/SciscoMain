class AllImages{

  String image_url;


  AllImages(this.image_url

      );

  factory AllImages.fromJson(Map<String, dynamic> json) {
    return AllImages(
      json['image_url']
    );
  }

  Map<String, dynamic> toJson() => {
    "image_url": image_url,
  };

}