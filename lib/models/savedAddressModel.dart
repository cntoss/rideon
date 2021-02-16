// To parse this JSON data, do
//
//     final savedAddressModel = savedAddressModelFromJson(jsonString);

import 'dart:convert';

List<SavedAddressModel> savedAddressModelFromJson(String str) => List<SavedAddressModel>.from(json.decode(str).map((x) => SavedAddressModel.fromJson(x)));

String savedAddressModelToJson(List<SavedAddressModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SavedAddressModel {
    SavedAddressModel({
        this.type,
        this.location,
        this.locationName,
    });

    String type;
    dynamic location;
    String locationName;

    factory SavedAddressModel.fromJson(Map<String, dynamic> json) => SavedAddressModel(
        type: json["type"],
        location: json["location"],
        locationName: json["locationName"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "location": location,
        "locationName": locationName,
    };
}
