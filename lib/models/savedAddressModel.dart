// To parse this JSON data, do
//
//     final savedAddressModel = savedAddressModelFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';

part 'savedAddressModel.g.dart';

List<SavedAddressModel> savedAddressModelFromJson(String str) =>
    List<SavedAddressModel>.from(
        json.decode(str).map((x) => SavedAddressModel.fromJson(x)));

String savedAddressModelToJson(List<SavedAddressModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@HiveType(typeId: 1)
class SavedAddressModel extends HiveObject {
  SavedAddressModel({
    this.id,
    this.type,
    this.location,
    this.locationName,
  });

  @HiveField(0)
  int id;

  @HiveField(1)
  String type;

  @HiveField(2)
  dynamic location;

  @HiveField(3)
  String locationName;

  factory SavedAddressModel.fromJson(Map<String, dynamic> json) =>
      SavedAddressModel(
        id: json['id'],
        type: json["type"],
        location: json["location"],
        locationName: json["locationName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "location": location,
        "locationName": locationName,
      };
}
