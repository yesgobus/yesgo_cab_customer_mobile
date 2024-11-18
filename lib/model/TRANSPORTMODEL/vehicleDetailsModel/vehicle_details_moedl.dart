// To parse this JSON data, do
//
//     final vehicleDetailsModel = vehicleDetailsModelFromJson(jsonString);

import 'dart:convert';

VehicleDetailsModel vehicleDetailsModelFromJson(String str) =>
    VehicleDetailsModel.fromJson(json.decode(str));

String vehicleDetailsModelToJson(VehicleDetailsModel data) =>
    json.encode(data.toJson());

class VehicleDetailsModel {
  bool? status;
  String? message;
  VehicleDetailData? data;

  VehicleDetailsModel({
    this.status,
    this.message,
    this.data,
  });

  factory VehicleDetailsModel.fromJson(Map<String, dynamic> json) =>
      VehicleDetailsModel(
        status: json["status"],
        message: json["message"],
        data: VehicleDetailData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data!.toJson(),
      };
}

class VehicleDetailData {
  String? currentDate;
  String? pickupDuration;
  String? pickupTime;
  String? image;
  String? route;
  String? vehicleName;
  List<String>? highlights;
  String? includedLoadingTime;
  String? distance;
  String? fare;
  String? roundedFare;

  VehicleDetailData({
    this.currentDate,
    this.pickupDuration,
    this.pickupTime,this.image,
    this.route,
    this.vehicleName,
    this.highlights,
    this.includedLoadingTime,
    this.distance,
    this.fare,
    this.roundedFare,
  });

  factory VehicleDetailData.fromJson(Map<String, dynamic> json) => VehicleDetailData(
        currentDate: json["current_date"],
        pickupDuration: json["pickup_duration"],
        pickupTime: json["pickup_time"],
        route: json["route"],
        image: json["image"],
        vehicleName: json["vehicle_name"],
        highlights: List<String>.from(json["highlights"].map((x) => x)),
        includedLoadingTime: json["included_loading_time"],
        distance: json["distance"],
        fare: json["fare"],
        roundedFare: json["rounded_fare"],
      );

  Map<String, dynamic> toJson() => {
        "current_date": currentDate,
        "pickup_duration": pickupDuration,
        "pickup_time": pickupTime,
        "route": route,
        "vehicle_name": vehicleName,
        "highlights": List<dynamic>.from(highlights!.map((x) => x)),
        "included_loading_time": includedLoadingTime,
        "distance": distance,
        "fare": fare,
        "rounded_fare": roundedFare,
      };
}
