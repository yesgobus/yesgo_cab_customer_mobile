// To parse this JSON data, do
//
//     final tripDetailModel = tripDetailModelFromJson(jsonString);

import 'dart:convert';

TransTripDetailModel transTripDetailModelFromJson(String str) =>
    TransTripDetailModel.fromJson(json.decode(str));

String transTripDetailModelToJson(TransTripDetailModel data) =>
    json.encode(data.toJson());

class TransTripDetailModel {
  String? status;
  String? statusMessage;
  String? rideId;
  String? driverImage;
  String? driverName;
  String? pickupTime;
  String? userName;
  String? tripDistance;
  String? tripDuration;
  String? tripAmount;
  String? pickupAddress;
  String? pickupLat;
  String? pickupLng;
  String? dropAddress;
  String? dropLat;
  String? dropLng;
  String? pickupDistance;
  String? pickupDuration;
  String? otp;

  TransTripDetailModel(
      {this.status,
      this.statusMessage,
      this.rideId,
      this.driverName,
      this.driverImage,
      this.pickupTime,
      this.userName,
      this.tripDistance,
      this.tripDuration,
      this.tripAmount,
      this.pickupAddress,
      this.pickupLat,
      this.pickupLng,
      this.dropAddress,
      this.dropLat,
      this.dropLng,
      this.pickupDistance,
      this.pickupDuration,
      this.otp});

  factory TransTripDetailModel.fromJson(Map<String, dynamic> json) =>
      TransTripDetailModel(
        rideId: json["ride_id"],
        status: json["status"],
        statusMessage: json["status_message"],
        driverName: json["driverName"],
        driverImage: json["driver_image"],
        pickupTime: json["pickup_time"],
        userName: json["user_name"],
        tripDistance: json["trip_distance"],
        tripDuration: json["trip_duration"],
        tripAmount: json["trip_amount"],
        pickupAddress: json["pickup_address"],
        pickupLat: json["pickup_lat"],
        pickupLng: json["pickup_lng"],
        dropAddress: json["drop_address"],
        dropLat: json["drop_lat"],
        dropLng: json["drop_lng"],
        pickupDistance: json["pickup_distance"],
        pickupDuration: json["pickup_duration"],
        otp: json["otp"],
      );

  Map<String, dynamic> toJson() => {
        "driverName": driverName,
        "pickup_time": pickupTime,
        "user_name": userName,
        "trip_distance": tripDistance,
        "trip_duration": tripDuration,
        "trip_amount": tripAmount,
        "pickup_address": pickupAddress,
        "pickup_lat": pickupLat,
        "pickup_lng": pickupLng,
        "drop_address": dropAddress,
        "drop_lat": dropLat,
        "drop_lng": dropLng,
        "pickup_distance": pickupDistance,
        "pickup_duration": pickupDuration,
      };
}
