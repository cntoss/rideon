import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:rideon/config/appConfig.dart';
import 'package:rideon/config/constant.dart';
import 'package:rideon/models/driverModel.dart';
import 'dart:async';
import 'package:rideon/models/googleModel/GeocodingModel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rideon/models/route/pininformation.dart';
import 'package:rideon/services/helper/zoomCalculate.dart';

class PackageDeliveryRouteScreen extends StatefulWidget {
  PackageDeliveryRouteScreen(
      {this.sourceDetail, this.driverDetail, this.destinationDetail});
  final LocationDetail sourceDetail;
  final DriverModel driverDetail;
  final LocationDetail destinationDetail;
  @override
  State<StatefulWidget> createState() => PackageDeliveryRouteScreenState(
      this.sourceDetail, this.destinationDetail);
}

class PackageDeliveryRouteScreenState
    extends State<PackageDeliveryRouteScreen> {
  PackageDeliveryRouteScreenState(this.sourceDetail, this.destinationDetail);
  LocationDetail sourceDetail;
  LocationDetail destinationDetail;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;
  Position currentLocation;
  Position destinationLocation;
  PinInformation sourcePinInfo;
  PinInformation destinationPinInfo;

  @override
  void initState() {
    super.initState();
    currentLocation = Position.fromMap({
      "latitude": sourceDetail.geometry.location.lat,
      "longitude": sourceDetail.geometry.location.lng
    });

    setSourceAndDestinationIcons();
    setInitialLocation();
  }

  void setSourceAndDestinationIcons() async {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.0), 'assets/driving_pin.png')
        .then((onValue) {
      sourceIcon = onValue;
    });

    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.0),
            'assets/destination_map_marker.png')
        .then((onValue) {
      destinationIcon = onValue;
    });
  }

  void setInitialLocation() async {
    destinationLocation = Position.fromMap({
      "latitude": widget.destinationDetail.geometry.location.lat,
      "longitude": widget.destinationDetail.geometry.location.lng
    });
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
        target: LatLng(
            (sourceDetail.geometry.location.lat +
                    destinationDetail.geometry.location.lat) /
                2,
            (sourceDetail.geometry.location.lng +
                    destinationDetail.geometry.location.lng) /
                2),
        zoom: ZoomCalculate().getZoom(
            sourceDetail.geometry.location.lat,
            sourceDetail.geometry.location.lng,
            destinationDetail.geometry.location.lat,
            destinationDetail.geometry.location.lng),
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
              myLocationEnabled: false,
              compassEnabled: true,
              tiltGesturesEnabled: false,
              zoomControlsEnabled: true,
              indoorViewEnabled: false,
              scrollGesturesEnabled: true,
              buildingsEnabled: false,
              markers: _markers,
              myLocationButtonEnabled: false,
              mapType: MapType.terrain,
              trafficEnabled: false,
              initialCameraPosition: initialCameraPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                showPinsOnMap();
              }),
          MapPinPillComponent(driverModel: widget.driverDetail)
        ],
      ),
    );
  }

  void showPinsOnMap() {
    var pinPosition = LatLng(
        sourceDetail.geometry.location.lat, sourceDetail.geometry.location.lng);
    var destPosition = LatLng(destinationDetail.geometry.location.lat,
        destinationDetail.geometry.location.lng);

    // add the initial source location pin
    _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: pinPosition,
        icon: sourceIcon));
    // destination pin
    _markers.add(Marker(
        markerId: MarkerId('destPin'),
        position: destPosition,
        icon: destinationIcon));
    setState(() {});
  }
}

class MapPinPillComponent extends StatelessWidget {
  final DriverModel driverModel;
  MapPinPillComponent({this.driverModel});
  @override
  Widget build(BuildContext context) {
    var boxWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.all(8),
        //height: boxHeight / 3,
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(12)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  blurRadius: 20,
                  offset: Offset.zero,
                  color: Colors.grey.withOpacity(0.5))
            ]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Colors.teal,
              height: 3,
              width: boxWidth / 4,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'On the way',
                style: Constant.title,
              ),
            ),
            Container(
              color: Colors.teal,
              height: 1,
              width: boxWidth / 1.2,
            ),
            Container(
              height: 80,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: driverModel.profilePicture == null
                        ? AssetImage('assets/avatar.png')
                        : NetworkImage(driverModel.profilePicture),
                    radius: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          driverModel.displayName ?? '',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          driverModel.vehicle.name ?? '',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, size: 12, color: Colors.yellow),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text('4.5',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black54)),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.local_shipping_rounded),
                        Flexible(child: Text(driverModel.vehicle.vehicleid))
                      ],
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Spacer(flex: 2),
                ElevatedButton(
                  onPressed: () => {},
                  child: Text('Call a driver'),
                ),
                Spacer(flex: 2),
                IconButton(
                  icon: Icon(
                    Icons.outbox,
                    size: 40,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
                Spacer(flex: 2)
              ],
            )
          ],
        ),
      ),
    );
  }
}
