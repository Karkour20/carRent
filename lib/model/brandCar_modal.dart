// To parse this JSON data, do
//
//     final brandModal = brandModalFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

import 'homeData_modal.dart';

BrandModal brandModalFromJson(String str) => BrandModal.fromJson(json.decode(str));

String brandModalToJson(BrandModal data) => json.encode(data.toJson());

class BrandModal {
  String responseCode;
  String result;
  String responseMsg;
  List<FeatureCar> featureCar;

  BrandModal({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
    required this.featureCar,
  });

  factory BrandModal.fromJson(Map<String, dynamic> json) => BrandModal(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
    featureCar: List<FeatureCar>.from(json["FeatureCar"].map((x) => FeatureCar.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
    "FeatureCar": List<dynamic>.from(featureCar.map((x) => x.toJson())),
  };
}

class BrandFeatureCar {
  String id;
  String carTitle;
  List<String> carImg;
  String carRating;
  String carNumber;
  String totalSeat;
  String carGear;
  String carRentPrice;
  String priceType;
  String engineHp;
  String fuelType;
  String carDistance;

  BrandFeatureCar({
    required this.id,
    required this.carTitle,
    required this.carImg,
    required this.carRating,
    required this.carNumber,
    required this.totalSeat,
    required this.carGear,
    required this.carRentPrice,
    required this.priceType,
    required this.engineHp,
    required this.fuelType,
    required this.carDistance,
  });

  factory BrandFeatureCar.fromJson(Map<String, dynamic> json) => BrandFeatureCar(
    id: json["id"],
    carTitle: json["car_title"],
    carImg: List<String>.from(json["car_img"].map((x) => x)),
    carRating: json["car_rating"],
    carNumber: json["car_number"],
    totalSeat: json["total_seat"],
    carGear: json["car_gear"],
    carRentPrice: json["car_rent_price"],
    priceType: json["price_type"],
    engineHp: json["engine_hp"],
    fuelType: json["fuel_type"],
    carDistance: json["car_distance"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "car_title": carTitle,
    "car_img": List<dynamic>.from(carImg.map((x) => x)),
    "car_rating": carRating,
    "car_number": carNumber,
    "total_seat": totalSeat,
    "car_gear": carGear,
    "car_rent_price": carRentPrice,
    "price_type": priceType,
    "engine_hp": engineHp,
    "fuel_type": fuelType,
    "car_distance": carDistance,
  };
}
