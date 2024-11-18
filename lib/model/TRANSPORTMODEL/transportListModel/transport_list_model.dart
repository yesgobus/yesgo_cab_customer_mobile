// To parse this JSON data, do
//
//     final vehicleListModel = vehicleListModelFromJson(jsonString);

import 'dart:convert';

VehicleListModel vehicleListModelFromJson(String str) =>
    VehicleListModel.fromJson(json.decode(str));

String vehicleListModelToJson(VehicleListModel data) =>
    json.encode(data.toJson());

class VehicleListModel {
  bool? status;
  String? message;
  Data? data;

  VehicleListModel({
    this.status,
    this.message,
    this.data,
  });

  factory VehicleListModel.fromJson(Map<String, dynamic> json) =>
      VehicleListModel(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data!.toJson(),
      };
}

class Data {
  String? distance;
  List<TransportVehicle>? transportVehicles;

  Data({
    this.distance,
    this.transportVehicles,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        distance: json["distance"],
        transportVehicles: List<TransportVehicle>.from(
            json["transport_vehicles"]
                .map((x) => TransportVehicle.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "distance": distance,
        "transport_vehicles":
            List<dynamic>.from(transportVehicles!.map((x) => x.toJson())),
      };
}

class TransportVehicle {
  String? id;
  String? transportModel;
  String? capacityInfo;
  String? ratePerKm;
  String? fare;
  String? imageUrl;

  TransportVehicle({
    this.id,
    this.transportModel,
    this.capacityInfo,
    this.ratePerKm,
    this.fare,
    this.imageUrl,
  });

  factory TransportVehicle.fromJson(Map<String, dynamic> json) =>
      TransportVehicle(
        id: json["id"],
        transportModel: json["transport_model"],
        capacityInfo: json["capacity_info"],
        ratePerKm: json["rate_per_km"],
        fare: json["fare"],
        imageUrl: json["image_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "transport_model": transportModel,
        "capacity_info": capacityInfo,
        "rate_per_km": ratePerKm,
        "fare": fare,
        "image_url": imageUrl,
      };
}
