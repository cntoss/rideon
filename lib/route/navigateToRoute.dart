import 'package:flutter/material.dart';
import 'package:rideon/config/appConfig.dart';
import 'package:rideon/maps/google_maps_place_picker.dart';
import 'package:rideon/maps/web_service/places.dart';
import 'package:rideon/models/googleModel/GeocodingModel.dart';
import 'package:rideon/models/savedAddress/addressType.dart';
import 'package:rideon/models/savedAddress/savedAddressModel.dart';
import 'package:rideon/screens/maps/routeScreen.dart';
import 'package:rideon/screens/setting/addAddress.dart';

class NavigateToRoute {
  navigateToRoute(
      {@required LocationDetail source, @required LocationDetail destination}) {
    if (source.geometry != null && destination.geometry != null)
      Navigator.push(
          AppConfig.navigatorKey.currentContext,
          MaterialPageRoute(
              builder: (context) => RouteScreen(
                  sourceDetail: source, destinationDetail: destination)));
  }

  Future navigateFromHome(
      {@required LocationDetail source,
      @required SavedAddressModel address,
      @required AddressType type}) {
    if (address != null)
      return navigateToAdd(type: type);
    else {
      LocationDetail destination = LocationDetail(
          formattedAddress: address.locationName,
          placeId: address.placeId,
          geometry: Geometry(
              Location(address.location.lat, address.location.lng),
              '',
              null,
              null));
      return navigateToRoute(source: source, destination: destination);
    }
  }

  Future navigateToAdd({@required AddressType type}) {
    return Navigator.push(
        AppConfig.navigatorKey.currentContext,
        MaterialPageRoute(
            builder: (context) => PlacePicker(
                useCurrentLocation: true,
                onPlacePicked: (result) {
                  SavedAddressModel address =
                      SavedAddressModel.fromPickResult(result);
                  address.type = type;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddAddress(
                        address: address,
                        title: 'Set ${type.toString().split('.')[1]} Location',
                      ),
                    ),
                  );
                })));
  }
}
