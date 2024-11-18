// To parse this JSON data, do
//
//     final bookingHisModel = bookingHisModelFromJson(jsonString);

import 'dart:convert';

BookingHisModel bookingHisModelFromJson(String str) =>
    BookingHisModel.fromJson(json.decode(str));

String bookingHisModelToJson(BookingHisModel data) =>
    json.encode(data.toJson());

class BookingHisModel {
  bool? status;
  Data? data;
  String? message;

  BookingHisModel({
    this.status,
    this.data,
    this.message,
  });

  factory BookingHisModel.fromJson(Map<String, dynamic> json) =>
      BookingHisModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class Data {
  List<OngoingAndCompletedBooking>? ongoingAndCompletedBookings;
  List<CancelledBooking>? cancelledBookings;

  Data({
    this.ongoingAndCompletedBookings,
    this.cancelledBookings,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        ongoingAndCompletedBookings: json["ongoingAndCompletedBookings"] == null
            ? []
            : List<OngoingAndCompletedBooking>.from(
                json["ongoingAndCompletedBookings"]!
                    .map((x) => OngoingAndCompletedBooking.fromJson(x))),
        cancelledBookings: json["cancelledBookings"] == null
            ? []
            : List<CancelledBooking>.from(json["cancelledBookings"]!
                .map((x) => CancelledBooking.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ongoingAndCompletedBookings": ongoingAndCompletedBookings == null
            ? []
            : List<dynamic>.from(
                ongoingAndCompletedBookings!.map((x) => x.toJson())),
        "cancelledBookings": cancelledBookings == null
            ? []
            : List<dynamic>.from(cancelledBookings!.map((x) => x.toJson())),
      };
}

class CancelledBooking {
  String? id;
  String? status;
  String? carName;
  String? carImage;
  String? startLocation;
  String? endLocation;
  String? kmCovered;
  String? amountPaid;
  String? date;

  CancelledBooking({
    this.id,
    this.status,
    this.carName,
    this.carImage,
    this.startLocation,
    this.endLocation,
    this.kmCovered,
    this.amountPaid,
    this.date,
  });

  factory CancelledBooking.fromJson(Map<String, dynamic> json) =>
      CancelledBooking(
        id: json["id"],
        status: json["status"],
        carName: json["car_name"],
        carImage: json["car_image"],
        startLocation: json["startLocation"],
        endLocation: json["endLocation"],
        kmCovered: json["kmCovered"],
        amountPaid: json["amountPaid"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "car_name": carName,
        "car_image": carImage,
        "startLocation": startLocation,
        "endLocation": endLocation,
        "kmCovered": kmCovered,
        "amountPaid": amountPaid,
        "date": date,
      };
}

class OngoingAndCompletedBooking {
  String? id;
  String? status;
  String? carName;
  String? carImage;
  String? startLocation;
  String? endLocation;
  String? kmCovered;
  String? amountPaid;
  String? date;

  OngoingAndCompletedBooking({
    this.id,
    this.status,
    this.carName,
    this.carImage,
    this.startLocation,
    this.endLocation,
    this.kmCovered,
    this.amountPaid,
    this.date,
  });

  factory OngoingAndCompletedBooking.fromJson(Map<String, dynamic> json) =>
      OngoingAndCompletedBooking(
        id: json["id"],
        status: json["status"],
        carName: json["car_name"],
        carImage: json["car_image"],
        startLocation: json["startLocation"],
        endLocation: json["endLocation"],
        kmCovered: json["kmCovered"].toString(),
        amountPaid: json["amountPaid"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "car_name": carName,
        "car_image": carImage,
        "startLocation": startLocation,
        "endLocation": endLocation,
        "kmCovered": kmCovered,
        "amountPaid": amountPaid,
        "date": date,
      };
}
