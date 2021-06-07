// To parse required this JSON data, do
//
//     final savedAddressModel = savedAddressModelFromJson(jsonString);


import 'package:hive/hive.dart';
import 'package:rideon/config/appConfig.dart';
import 'package:rideon/maps/google_maps_place_picker.dart';
import 'package:rideon/models/savedAddress/addressType.dart';

part 'savedAddressModel.g.dart';



String getLocationType(AddressType type) {
  if (type == AddressType.Home) return 'home';
  if (type == AddressType.Work) return 'work';
  return 'other';
}

AddressType setLocationType(String type) {
  if (type == 'home') return AddressType.Home;
  if (type == 'work') return AddressType.Work;
  return AddressType.Other;
}

@HiveType(typeId: htSavedAddress)
class SavedAddressModel extends HiveObject {
  SavedAddressModel(
      { this.id,
       this.type,
       this.placeId,
       this.location,
       this.locationName,
       this.addrComponent,
       this.detail});

  @HiveField(0)
  String? id;

  @HiveField(1)
  AddressType? type;

  @HiveField(2)
  String? placeId;

  @HiveField(3)
  LnModel? location;

  @HiveField(4)
  String? locationName;

  @HiveField(5)
  String? detail;

  @HiveField(6)
  List<AddrComponent>? addrComponent;

 /*  factory SavedAddressModel.fromJson(Map<String, dynamic> json) =>
      SavedAddressModel(
        id: json['id'],
        //type: json["type"],
        //location: LocationModel.fromJson(json["location"]),
        locationName: json["locationName"],
      ); */

  factory SavedAddressModel.fromPickResult(PickResult result) {
    return SavedAddressModel(
        placeId: result.placeId,
        location: LnModel.fromGeomerty(
            result.geometry!.location.lat, result.geometry!.location.lng),
        locationName: result.name,
        //added after v2
        detail: '',
        type: AddressType.Other,
        addrComponent: List<AddrComponent>.from(result.addressComponents!.map(
            (x) => AddrComponent.fromResult(x.types, x.longName, x.shortName)))

        ///todo:formated address
        //types: result.types,
        //adrAddress: result.adrAddress,
        //name: result.name,
        );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": getLocationType(type!),
        "location": {
          "address_components":
              List<dynamic>.from(addrComponent!.map((x) => x.toJson())),
          "formatted_address": locationName,
          "location": {
            "type": "Point",
            "coordinates": [location!.lng, location!.lat]
          },
          "place_id": placeId,
        },
        "locationName": detail,
      };
}

@HiveType(typeId: htlnModel)
class LnModel extends HiveObject {
  LnModel({
    required this.lat,
    required this.lng,
  });
  @HiveField(0)
  double lat;

  @HiveField(1)
  double lng;

  factory LnModel.fromJson(Map<String, dynamic> json) => LnModel(
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };

  factory LnModel.fromGeomerty(lat, lng) {
    return LnModel(
      lat: lat,
      lng: lng,
    );
  }
}

@HiveType(typeId: htAddressComponents)
class AddrComponent extends HiveObject {
  @HiveField(0)
  final List<String> types;

  /// JSON long_name
  @HiveField(1)
  final String longName;

  /// JSON short_name
  @HiveField(2)
  final String shortName;

  AddrComponent(
    this.types,
    this.longName,
    this.shortName,
  );

//changed on v2 also remove case for null hnadling
  factory AddrComponent.fromJson(Map json) => 
       AddrComponent( json["types"] == null ? <String>[] : List<String>.from(json["types"].map((x) => x)),
          json['long_name'], json['short_name'])
      ;

  factory AddrComponent.fromResult(types, longName, shortName) {
    return AddrComponent(types, longName, shortName);
  }

  Map<String, dynamic> toJson() {
    return {
      'types': types,
      'long_name': longName,
      'short_name': shortName,
    };
  }
}
