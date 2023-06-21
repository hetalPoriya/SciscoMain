// To parse this JSON data, do
//
//     final sliderModel = sliderModelFromMap(jsonString);

import 'dart:convert';

SliderModel sliderModelFromMap(String str) => SliderModel.fromMap(json.decode(str));

String sliderModelToMap(SliderModel data) => json.encode(data.toMap());

class SliderModel {
  final String error;
  final List<ListElement> list;
  final String errorMsg;

  SliderModel({
    this.error,
    this.list,
    this.errorMsg,
  });

  factory SliderModel.fromMap(Map<String, dynamic> json) => SliderModel(
    error: json["error"],
    list: json["list"] == null ? [] : List<ListElement>.from(json["list"].map((x) => ListElement.fromMap(x))),
    errorMsg: json["error_msg"],
  );

  Map<String, dynamic> toMap() => {
    "error": error,
    "list": list == null ? [] : List<dynamic>.from(list.map((x) => x.toMap())),
    "error_msg": errorMsg,
  };
}

class ListElement {
  final String image;

  ListElement({
    this.image,
  });

  factory ListElement.fromMap(Map<String, dynamic> json) => ListElement(
    image: json["image"],
  );

  Map<String, dynamic> toMap() => {
    "image": image,
  };
}