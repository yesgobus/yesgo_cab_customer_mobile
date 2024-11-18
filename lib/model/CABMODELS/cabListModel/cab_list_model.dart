// To parse this JSON data, do
//
//     final cabListModel = cabListModelFromJson(jsonString);

import 'dart:convert';

CabListModel cabListModelFromJson(String str) =>
    CabListModel.fromJson(json.decode(str));

String cabListModelToJson(CabListModel data) => json.encode(data.toJson());

class CabListModel {
  bool? status;
  Data? data;
  String? message;

  CabListModel({
    this.status,
    this.data,
    this.message,
  });

  factory CabListModel.fromJson(Map<String, dynamic> json) => CabListModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data!.toJson(),
        "message": message,
      };
}

class Data {
  String? distance;
  List<Cab>? cabs;

  Data({
    this.distance,
    this.cabs,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        distance: json["distance"],
        cabs: List<Cab>.from(json["cabs"].map((x) => Cab.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "distance": distance,
        "cabs": List<dynamic>.from(cabs!.map((x) => x.toJson())),
      };
}

class Cab {
  String? id;
  String? carType;
  String? ratePerKm;
  String? tagline;
  String? imageUrl;
  String? fare;
  String? fareAmountDisplay;

  Cab({
    this.id,
    this.carType,
    this.ratePerKm,
    this.tagline,
    this.imageUrl,
    this.fare,
    this.fareAmountDisplay,
  });

  factory Cab.fromJson(Map<String, dynamic> json) => Cab(
        id: json["id"],
        carType: json["car_type"],
        ratePerKm: json["rate_per_km"],
        tagline: json["tagline"],
        imageUrl: json["image_url"],
        fare: json["fare"],
        fareAmountDisplay: json["fare_amount_display"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "car_type": carType,
        "rate_per_km": ratePerKm,
        "tagline": tagline,
        "fare": fare,
        "fare_amount_display": fareAmountDisplay,
      };
}
