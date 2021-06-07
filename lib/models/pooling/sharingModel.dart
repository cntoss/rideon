// To parse this JSON data, do
//
//     final sharingModel = sharingModelFromJson(jsonString);

import 'dart:convert';

import 'package:rideon/models/googleModel/GeocodingModel.dart';

List<SharingModel> sharingModelFromJson(String str) => List<SharingModel>.from(json.decode(str).map((x) => SharingModel.fromJson(x)));

String sharingModelToJson(List<SharingModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SharingModel {
    SharingModel({
       required this.id,
       required this.fromLocation,
       required this.toLocation,
       required this.passenger,
       required this.cost,
       required this.date,
       required this.time,
       required this.phoneNumber,
       required this.email,
    });

    int id;
    LocationDetail fromLocation;
    LocationDetail toLocation;
    int passenger;
    int cost;
    DateTime date;
    String time;
    int phoneNumber;
    String email;

    factory SharingModel.fromJson(Map<String, dynamic> json) => SharingModel(
        id: json["id"],
        fromLocation: json["fromLocation"],
        toLocation: json["toLocation"],
        passenger: json["passenger"],
        cost: json["cost"],
        date: json["date"],
        time: json["time"],
        phoneNumber: json["phoneNumber"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "fromLocation": fromLocation,
        "toLocation": toLocation,
        "passenger": passenger,
        "cost": cost,
        "date": date,
        "time": time,
        "phoneNumber": phoneNumber,
        "email": email,
    };
}
