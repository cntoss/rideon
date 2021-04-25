import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:rideon/config/appConfig.dart';
import 'package:rideon/models/googleModel/GeocodingModel.dart';
import 'request/request.dart';

class RideRequest {
  send() async {
    try {
      var response = await Dio().post(firebaseUrl,
          options: RequestHeader().optionsForFirebase(),
          data: RequestBody().firebaseBody());
      return (response.data)['results'];
    } on DioError catch (error) {
      if (error.response != null) {
        print((error.response.data));
        return null;
      } else {
        return null;
      }
    }
  }

  request(
      {@required LocationDetail fromLocation,
      @required LocationDetail toLocation,
      @required String distance,
      @required String time}) async {
    try {
      print(RequestBody().driveRequestBody(
              fromLocation: fromLocation,
              toLocation: toLocation,
              distance: distance,
              time: time));
      var response = await Dio().post(firebaseUrl,
          options: RequestHeader().optionsForFirebase(),
          data: RequestBody().driveRequestBody(
              fromLocation: fromLocation,
              toLocation: toLocation,
              distance: distance,
              time: time));
      return (response.data)['results'];
    } on DioError catch (error) {
      if (error.response != null) {
        print((error.response.data));
        return null;
      } else {
        return null;
      }
    }
  }
}
