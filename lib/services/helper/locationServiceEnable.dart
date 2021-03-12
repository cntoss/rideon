/* import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rideon/config/appConfig.dart';

class LocationService {
  BuildContext context = AppConfig.navigatorKey.currentState.overlay.context;
  void showLocationDialog(
      {@required BuildContext context,
      @required String title,
      @required String message}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
                onPressed: () => Navigator.pop(context), child: Text("OK"))
          ],
        );
      },
    );
  }

  Future<Position> getLocation() async {
    bool _serviceEnabled;
    LocationPermission _permission;
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission;

    if (!_serviceEnabled) {
      print('location disabled');
      showLocationDialog(
          context: context,
          title: 'Failed!',
          message: 'Please enable location service to continue');
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();

    _permission = await Geolocator.requestPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Permission Denied"),
                content: Text(
                    'Please allow permission to access device location to continue.'),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        getLocation();
                      },
                      child: Text("OK"))
                ],
              );
            });
        return null;
      }
    }
    await Geolocator.getCurrentPosition();
  }
}
 */