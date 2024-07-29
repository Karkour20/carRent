// To parse this JSON data, do
//
//     final homeBanner = homeBannerFromJson(jsonString);

// ignore_for_file: file_names
import 'package:carlink/model/carbrand.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:convert';

import 'bookrange_modal.dart';

HomeBanner homeBannerFromJson(String str) => HomeBanner.fromJson(json.decode(str));

String homeBannerToJson(HomeBanner data) => json.encode(data.toJson());

class HomeBanner {
  String responseCode;
  String result;
  String responseMsg;
  List<myBanner> banner;
  String isBlock;
  String tax;
  String currency;
  List<Carlist> cartypelist;
  List<Carbrand> carbrandlist;
  List<FeatureCar> featureCar;
  List<RecommendCar> recommendCar;
  String showAddCar;

  HomeBanner({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
    required this.banner,
    required this.isBlock,
    required this.tax,
    required this.currency,
    required this.cartypelist,
    required this.carbrandlist,
    required this.featureCar,
    required this.recommendCar,
    required this.showAddCar, 
    required List<RecommendCar> recommendCars,
  });

  factory HomeBanner.fromJson(Map<String, dynamic> json) => HomeBanner(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
    banner: List<myBanner>.from(json["banner"].map((x) => myBanner.fromJson(x))),
    isBlock: json["is_block"],
    tax: json["tax"],
    currency: json["currency"],
    cartypelist: List<Carlist>.from(json["cartypelist"].map((x) => Carlist.fromJson(x))),
    carbrandlist: List<Carbrand>.from(json["carbrandlist"].map((x) => Carlist.fromJson(x))),
    featureCar: List<FeatureCar>.from(json["FeatureCar"].map((x) => FeatureCar.fromJson(x))),
    recommendCar: List<RecommendCar>.from(json["Recommend_car"].map((x) => RecommendCar.fromJson(x))),
    showAddCar: json["show_add_car"], recommendCars: [],
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
    "banner": List<dynamic>.from(banner.map((x) => x.toJson())),
    "is_block": isBlock,
    "tax": tax,
    "currency": currency,
    "cartypelist": List<dynamic>.from(cartypelist.map((x) => x.toJson())),
    "carbrandlist": List<dynamic>.from(carbrandlist.map((x) => x.toJson())),
    "FeatureCar": List<dynamic>.from(featureCar.map((x) => x.toJson())),
    "Recommend_car": List<dynamic>.from(recommendCar.map((x) => x.toJson())),
    "show_add_car": showAddCar,
  };
}


class myBanner {
  String id;
  String img;

  myBanner({
    required this.id,
    required this.img,
  });

  factory myBanner.fromJson(Map<String, dynamic> json) => myBanner(
    id: json["id"],
    img: json["img"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "img": img,
  };

}

class Carlist {
  String id;
  String title;
  String img;

  Carlist({
    required this.id,
    required this.title,
    required this.img,
  });

  factory Carlist.fromJson(Map<String, dynamic> json) => Carlist(
    id: json["id"],
    title: json["title"],
    img: json["img"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "img": img,
  };
}
class Carbrand{
  String id;
  String title;
  String img;
  Carbrand({
    required this.id,
    required this.title,
    required this.img,
  });

  factory Carbrand.fromJson(Map<String, dynamic> json) => Carbrand(
    id: json["id"],
    title: json["title"],
    img: json["img"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "img": img,
  };
  
}

class FeatureCar {
  String id;
  String typeId;
  String cityId;
  String brandId;
  String minHrs;
  String carTitle;
  List<String> carImg;
  String carRating;
  String carNumber;
  String totalSeat;
  String carGear;
  String totalKm;
  String pickLat;
  String pickLng;
  String pickAddress;
  String carDesc;
  String fuelType;
  String priceType;
  String engineHp;
  String carFacility;
  String facilityImg;
  String carTypeTitle;
  String carTypeImg;
  String carBrandTitle;
  String carBrandImg;
  String carRentPrice;
  String carRentPriceDriver;
  String carAc;
  int isFavorite;
  List<Bookeddate>? bookeddate;

  FeatureCar({
    required this.id,
    required this.typeId,
    required this.cityId,
    required this.brandId,
    required this.minHrs,
    required this.carTitle,
    required this.carImg,
    required this.carRating,
    required this.carNumber,
    required this.totalSeat,
    required this.carGear,
    required this.totalKm,
    required this.pickLat,
    required this.pickLng,
    required this.pickAddress,
    required this.carDesc,
    required this.fuelType,
    required this.priceType,
    required this.engineHp,
    required this.carFacility,
    required this.facilityImg,
    required this.carTypeTitle,
    required this.carTypeImg,
    required this.carBrandTitle,
    required this.carBrandImg,
    required this.carRentPrice,
    required this.carRentPriceDriver,
    required this.carAc,
    required this.isFavorite,
     this.bookeddate
  });

  factory FeatureCar.fromJson(Map<String, dynamic> json) =>
      FeatureCar(
        id: json["id"],
        typeId: json["type_id"],
        cityId: json["city_id"],
        brandId: json["brand_id"],
        minHrs: json["min_hrs"],
        carTitle: json["car_title"],
        carImg: List<String>.from(json["car_img"].map((x) => x)),
        carRating: json["car_rating"],
        carNumber: json["car_number"],
        totalSeat: json["total_seat"],
        carGear: json["car_gear"],
        totalKm: json["total_km"],
        pickLat: json["pick_lat"],
        pickLng: json["pick_lng"],
        pickAddress: json["pick_address"],
        carDesc: json["car_desc"],
        fuelType: json["fuel_type"],
        priceType: json["price_type"],
        engineHp: json["engine_hp"],
        carFacility: json["car_facility"],
        facilityImg: json["facility_img"],
        carTypeTitle: json["car_type_title"],
        carTypeImg: json["car_type_img"],
        carBrandTitle: json["car_brand_title"],
        carBrandImg: json["car_brand_img"],
        carRentPrice: json["car_rent_price"],
        carRentPriceDriver: json["car_rent_price_driver"],
        carAc: json["car_ac"],
        isFavorite: json["IS_FAVOURITE"], bookeddate: [],
      );

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "type_id": typeId,
        "city_id": cityId,
        "brand_id": brandId,
        "min_hrs": minHrs,
        "car_title": carTitle,
        "car_img": List<dynamic>.from(carImg.map((x) => x)),
        "car_rating": carRating,
        "car_number": carNumber,
        "total_seat": totalSeat,
        "car_gear": carGear,
        "total_km": totalKm,
        "pick_lat": pickLat,
        "pick_lng": pickLng,
        "pick_address": pickAddress,
        "car_desc": carDesc,
        "fuel_type": fuelType,
        "price_type": priceType,
        "engine_hp": engineHp,
        "car_facility": carFacility,
        "facility_img": facilityImg,
        "car_type_title": carTypeTitle,
        "car_type_img": carTypeImg,
        "car_brand_title": carBrandTitle,
        "car_brand_img": carBrandImg,
        "car_rent_price": carRentPrice,
        "car_rent_price_driver": carRentPriceDriver,
        "car_ac": carAc,
        'IS_FAVOURITE': isFavorite,
      };
}
class RecommendCar {
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
  String carTypeTitle;
  String carDistance;

  RecommendCar({
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
    required this.carTypeTitle,
    required this.carDistance,
     required String title,
  });

  factory RecommendCar.fromJson(Map<String, dynamic> json) => RecommendCar(
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
    carTypeTitle: json["car_type_title"],
    carDistance: json["car_distance"], title: '',
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
    "car_type_title": carTypeTitle,
    "car_distance": carDistance,
  };
}
