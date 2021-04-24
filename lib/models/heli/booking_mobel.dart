import 'package:flutter/cupertino.dart';
import 'package:rideon/models/googleModel/GeocodingModel.dart';

enum HeliType { Charter, Tour }

class HelicopterBookingModel {
  @required HeliType type;
  @required LocationDetail fromAddress;
  @required LocationDetail toAddress;
  @required String name;
  @required String phone;
  @required String email;
  String details;
  String tourPlane;
  String noOfAdults;
  String noOfChild;

  HelicopterBookingModel({
      this.details,
      this.email,
      this.fromAddress,
      this.name,
      this.noOfAdults,
      this.noOfChild,
      this.phone,
      this.toAddress,
      this.tourPlane,
      this.type});
}