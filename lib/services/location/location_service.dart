import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rideon/config/appConfig.dart';
import 'package:location/location.dart';

class LocationService {
  BuildContext context = AppConfig.navigatorKey.currentState.overlay.context;
  Future<bool> showLocationDialog(
      {@required String title,
      VoidCallback onPressed,
      @required String message}) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
                //onPressed: onPressed,
                onPressed: () async {
                  Navigator.pop(context);
                  getLocation();
                },
                child: Text("OK"))
          ],
        );
      },
    );
  }

  Future<String> getLocation() async {
    Location location = new Location();
    bool _locationServiceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _locationServiceEnabled = await location.serviceEnabled();
    if (!_locationServiceEnabled) {
      _locationServiceEnabled = await location.requestService();
      if (!_locationServiceEnabled) {
        showLocationDialog(
          title: 'Location Disabled',
          message: 'Please enable location service to continue',
        );
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        showLocationDialog(
          title: "Permission Denied",
          message:
              'Please allow permission to access device location to continue.',
        );

        return null;
      }
    }

    _locationData = await location.getLocation();
    return _locationData.toString();
  }
  
}
