// To parse this JSON data, do
//
//     final cabDetailModel = cabDetailModelFromJson(jsonString);

import 'dart:convert';

CabDetailModel cabDetailModelFromJson(String str) =>
    CabDetailModel.fromJson(json.decode(str));

String cabDetailModelToJson(CabDetailModel data) => json.encode(data.toJson());

class CabDetailModel {
  bool? success;
  CabDetailsData? data;
  String? message;

  CabDetailModel({
    this.success,
    this.data,
    this.message,
  });

  factory CabDetailModel.fromJson(Map<String, dynamic> json) => CabDetailModel(
        success: json["success"],
        data:
            json["data"] == null ? null : CabDetailsData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
        "message": message,
      };
}

class CabDetailsData {
  String? route;
  String? date;
  String? pickupTime;
  Car? car;
  DriverDetails? driverDetails;
  Inclusions? inclusions;
  ExtraCharges? extraCharges;
  List<String>? additionalInfo;

  CabDetailsData({
    this.route,
    this.date,
    this.pickupTime,
    this.car,
    this.driverDetails,
    this.inclusions,
    this.extraCharges,
    this.additionalInfo,
  });

  factory CabDetailsData.fromJson(Map<String, dynamic> json) => CabDetailsData(
        route: json["route"],
        date: json["date"],
        pickupTime: json["pickup_time"],
        car: json["car"] == null ? null : Car.fromJson(json["car"]),
        driverDetails: json["driver_details"] == null
            ? null
            : DriverDetails.fromJson(json["driver_details"]),
        inclusions: json["inclusions"] == null
            ? null
            : Inclusions.fromJson(json["inclusions"]),
        extraCharges: json["extra_charges"] == null
            ? null
            : ExtraCharges.fromJson(json["extra_charges"]),
        additionalInfo: json["additional_info"] == null
            ? []
            : List<String>.from(json["additional_info"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "route": route,
        "date": date,
        "pickup_time": pickupTime,
        "car": car?.toJson(),
        "driver_details": driverDetails?.toJson(),
        "inclusions": inclusions?.toJson(),
        "extra_charges": extraCharges?.toJson(),
        "additional_info": additionalInfo == null
            ? []
            : List<dynamic>.from(additionalInfo!.map((x) => x)),
      };
}

class Car {
  String? carName;
  String? carType;
  String? imageUrl;
  String? category;
  bool? ac;
  String? passengerCapacity;
  String? luggageCapacity;
  String? carSize;
  String? rating;
  String? totalRatings;
  String? extraKmFare;
  String? fuelType;
  String? cancellationPolicy;
  String? freeWaitingTime;

  Car({
    this.carName,
    this.carType,
    this.imageUrl,
    this.category,
    this.ac,
    this.passengerCapacity,
    this.luggageCapacity,
    this.carSize,
    this.rating,
    this.totalRatings,
    this.extraKmFare,
    this.fuelType,
    this.cancellationPolicy,
    this.freeWaitingTime,
  });

  factory Car.fromJson(Map<String, dynamic> json) => Car(
        carName: json["car_name"],
        carType: json["car_type"],
        imageUrl: json["image_url"],
        category: json["category"],
        ac: json["ac"],
        passengerCapacity: json["passenger_capacity"],
        luggageCapacity: json["luggage_capacity"],
        carSize: json["car_size"],
        rating: json["rating"],
        totalRatings: json["total_ratings"],
        extraKmFare: json["extra_km_fare"],
        fuelType: json["fuel_type"],
        cancellationPolicy: json["cancellation_policy"],
        freeWaitingTime: json["free_waiting_time"],
      );

  Map<String, dynamic> toJson() => {
        "car_name": carName,
        "car_type": carType,
        "image_url": imageUrl,
        "category": category,
        "ac": ac,
        "passenger_capacity": passengerCapacity,
        "luggage_capacity": luggageCapacity,
        "car_size": carSize,
        "rating": rating,
        "total_ratings": totalRatings,
        "extra_km_fare": extraKmFare,
        "fuel_type": fuelType,
        "cancellation_policy": cancellationPolicy,
        "free_waiting_time": freeWaitingTime,
      };
}

class DriverDetails {
  String? verification;
  String? driverRating;
  String? cabRating;

  DriverDetails({
    this.verification,
    this.driverRating,
    this.cabRating,
  });

  factory DriverDetails.fromJson(Map<String, dynamic> json) => DriverDetails(
        verification: json["verification"],
        driverRating: json["driver_rating"],
        cabRating: json["cab_rating"],
      );

  Map<String, dynamic> toJson() => {
        "verification": verification,
        "driver_rating": driverRating,
        "cab_rating": cabRating,
      };
}

class ExtraCharges {
  String? fareBeyondIncludedDistance;
  String? waitingChargesBeyondFreeTime;
  String? nightTimeAllowance;

  ExtraCharges({
    this.fareBeyondIncludedDistance,
    this.waitingChargesBeyondFreeTime,
    this.nightTimeAllowance,
  });

  factory ExtraCharges.fromJson(Map<String, dynamic> json) => ExtraCharges(
        fareBeyondIncludedDistance: json["fare_beyond_included_distance"],
        waitingChargesBeyondFreeTime: json["waiting_charges_beyond_free_time"],
        nightTimeAllowance: json["night_time_allowance"],
      );

  Map<String, dynamic> toJson() => {
        "fare_beyond_included_distance": fareBeyondIncludedDistance,
        "waiting_charges_beyond_free_time": waitingChargesBeyondFreeTime,
        "night_time_allowance": nightTimeAllowance,
      };
}

class Inclusions {
  String? includedKms;
  String? pickupDrop;
  bool? stateTaxes;
  bool? tollCharges;

  Inclusions({
    this.includedKms,
    this.pickupDrop,
    this.stateTaxes,
    this.tollCharges,
  });

  factory Inclusions.fromJson(Map<String, dynamic> json) => Inclusions(
        includedKms: json["included_kms"],
        pickupDrop: json["pickup_drop"],
        stateTaxes: json["state_taxes"],
        tollCharges: json["toll_charges"],
      );

  Map<String, dynamic> toJson() => {
        "included_kms": includedKms,
        "pickup_drop": pickupDrop,
        "state_taxes": stateTaxes,
        "toll_charges": tollCharges,
      };
}
