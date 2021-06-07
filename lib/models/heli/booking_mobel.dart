import 'package:rideon/models/googleModel/GeocodingModel.dart';

enum HeliType { Charter, Tour }

class HelicopterBookingModel {
  HeliType type;
  LocationDetail fromAddress;
  LocationDetail toAddress;
  String name;
  String phone;
  String email;
  String? details;
  String? tourPlane;
  String? noOfAdults;
  String? noOfChild;

  HelicopterBookingModel(
      {this.details,
      required this.email,
      required this.fromAddress,
      required this.name,
      this.noOfAdults,
      this.noOfChild,
      required this.phone,
      required this.toAddress,
      required this.tourPlane,
      required this.type});
}
