import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:rideon/config/appConfig.dart';
import 'package:rideon/maps/web_service/distance.dart' as distance;
import 'package:rideon/models/enum_mode/transport_type.dart';
import 'dart:async';
import 'package:rideon/models/googleModel/GeocodingModel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rideon/models/route/pininformation.dart';
import 'package:rideon/repository/ride_request.dart';
import 'package:rideon/services/helper/zoomCalculate.dart';

class NavigationPage extends StatefulWidget {
  NavigationPage({required this.sourceDetail, required this.destinationDetail, this.tranportType = TranportType.None});
  final LocationDetail sourceDetail;
  final LocationDetail destinationDetail;
  final TranportType tranportType;
  @override
  State<StatefulWidget> createState() =>
      RouteScreenState(this.sourceDetail, this.destinationDetail);
}

class RouteScreenState extends State<NavigationPage> {
  RouteScreenState(this.sourceDetail, this.destinationDetail);
  LocationDetail sourceDetail;
  LocationDetail destinationDetail;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();
// for my drawn routes on the map
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;
// for my custom marker pins
  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor destinationIcon;
// the user's initial location and current location
// as it moves
 late Position currentLocation;
// a reference to the destination location
 late Position destinationLocation;
// wrapper around the location API
  double pinPillPosition = -100;
  PinInformation currentlySelectedPin = PinInformation(
      pinPath: '',
      avatarPath: '',
      location: LatLng(0, 0),
      locationName: '',
      labelColor: Colors.grey);
  late PinInformation sourcePinInfo;
  late PinInformation destinationPinInfo;

  @override
  void initState() {
    super.initState();
    // create an instance of Location
    polylinePoints = PolylinePoints();
    currentLocation = Position.fromMap({
      "latitude": sourceDetail.geometry!.location.lat,
      "longitude": sourceDetail.geometry!.location.lng
    });
    // subscribe to changes in the user's location
    // by "listening" to the location's onLocationChanged event
    /*  location.onLocationChanged.listen((LocationData cLoc) {
      // cLoc contains the lat and long of the
      // current user's position in real time,
      // so we're holding on to it
      currentLocation = cLoc;
      updatePinOnMap();
    }); */
    // set custom marker pins
    setSourceAndDestinationIcons();
    // set the initial location
    setInitialLocation();
    _getPolyline();
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
      "latitude": widget.destinationDetail.geometry!.location.lat,
      "longitude": widget.destinationDetail.geometry!.location.lng
    });
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
        target: LatLng(
            (sourceDetail.geometry!.location.lat +
                    destinationDetail.geometry!.location.lat) /
                2,
            (sourceDetail.geometry!.location.lng +
                    destinationDetail.geometry!.location.lng) /
                2),
        zoom: ZoomCalculate().getZoom(
            sourceDetail.geometry!.location.lat,
            sourceDetail.geometry!.location.lng,
            destinationDetail.geometry!.location.lat,
            destinationDetail.geometry!.location.lng),
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
              myLocationEnabled: true,
              compassEnabled: false,
              tiltGesturesEnabled: false,
              markers: _markers,
              polylines: Set<Polyline>.of(polylines.values),
              mapType: MapType.normal,
              initialCameraPosition: initialCameraPosition,
              onTap: (LatLng loc) {
                setState(() {
                  pinPillPosition = -100;
                });
              },
              onMapCreated: (GoogleMapController controller) {
                //controller.setMapStyle(Utils.mapStyles);
                _controller.complete(controller);
                // my map has completed being created;
                // i'm ready to show the pins on the map
                showPinsOnMap();
              }),
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 20,
            child: IconButton(
              color: Colors.grey,
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          FutureBuilder(
            future: getDistance(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null)
                return MapPinPillComponent(
                  fromLocation: widget.sourceDetail,
                  toLocation: widget.destinationDetail,
                  distance: snapshot.data as String,
                  transportType: widget.tranportType,
                );
              else
                return Center(
                    child: Text(
                  'Unable to find route',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ));
            },
          )
        ],
      ),
    );
  }

  void showPinsOnMap() {
    // get a LatLng for the source location
    // from the LocationData currentLocation object
    var pinPosition =
        LatLng(currentLocation.latitude, currentLocation.longitude);
    // get a LatLng out of the LocationData object
    var destPosition =
        LatLng(destinationLocation.latitude, destinationLocation.longitude);

    sourcePinInfo = PinInformation(
        locationName: "Start Location",
        location: pinPosition,
        pinPath: "assets/driving_pin.png",
        avatarPath: "assets/avatar.png",
        labelColor: Colors.blueAccent);

    destinationPinInfo = PinInformation(
        locationName: "End Location",
        location: destPosition,
        pinPath: "assets/destination_map_marker.png",
        avatarPath: "assets/avatar.png",
        labelColor: Colors.purple);

    // add the initial source location pin
    _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        infoWindow: InfoWindow(
            title: sourceDetail.formattedAddress, snippet: 'Rideon map'),
        position: pinPosition,
        onTap: () {
          setState(() {
            currentlySelectedPin = sourcePinInfo;
            pinPillPosition = 0;
          });
        },
        icon: sourceIcon));
    // destination pin
    _markers.add(Marker(
        markerId: MarkerId('destPin'),
        position: destPosition,
        onTap: () {
          setState(() {
            currentlySelectedPin = destinationPinInfo;
            pinPillPosition = 0;
          });
        },
        icon: destinationIcon));
    // set the route lines on the map from source to destination
    // for more info follow this tutorial
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.blue, points: polylineCoordinates);
    polylines[id] = polyline;
    if (!mounted) return;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPIKey,
      PointLatLng(currentLocation.latitude, currentLocation.longitude),
      PointLatLng(destinationLocation.latitude, destinationLocation.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  void updatePinOnMap() async {
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: 0,
      bearing: CAMERA_BEARING,
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    setState(() {
      // updated position
      var pinPosition =
          LatLng(currentLocation.latitude, currentLocation.longitude);

      sourcePinInfo.location = pinPosition;

      _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          onTap: () {
            setState(() {
              currentlySelectedPin = sourcePinInfo;
              pinPillPosition = 0;
            });
          },
          position: pinPosition, // updated position
          icon: sourceIcon));
    });
  }

  Future<String> getDistance() async {
    var distanceResponse =
        await distance.GoogleDistanceMatrix(apiKey: googleAPIKey)
            .distanceWithLocation([sourceDetail.geometry!.location],
                [destinationDetail.geometry!.location]);
    //if (distanceResponse != null) chnaged results from rows
      return distanceResponse.rows.first.elements.first.distance.text;
   /*  else
      return ''; */
  }
}

class MapPinPillComponent extends StatefulWidget {
  final String distance;
  final LocationDetail fromLocation;
  final LocationDetail toLocation;
  final TranportType transportType;
  MapPinPillComponent({ required this.fromLocation, required this.toLocation, required this.distance, required this.transportType});

  @override
  _MapPinPillComponentState createState() => _MapPinPillComponentState();
}

class _MapPinPillComponentState extends State<MapPinPillComponent> {
  late TranportType transportType;
  @override
  void initState() {
    super.initState();
    transportType = widget.transportType;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.all(8),
        width: width,
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
          children: <Widget>[
            if(widget.transportType == TranportType.None)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      transportType = TranportType.Bike;
                    });
                  },
                  child: Card(
                    color: transportType == TranportType.Bike
                        ? Colors.green
                        : Theme.of(context).scaffoldBackgroundColor,
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/bike.png',
                            height: 100,
                            width: width / 2.5,
                          ),
                          Text('Bike'),
                          Text(widget.distance)
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      transportType = TranportType.Car;
                    });
                  },
                  child: Card(
                    color: transportType == TranportType.Car
                        ? Colors.green
                        : Theme.of(context).scaffoldBackgroundColor,
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/car.png',
                            height: 100,
                            width: width / 2.5,
                          ),
                          Text('Car'),
                          Text(widget.distance )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                var result = await RideRequest().request(
                    fromLocation: widget.fromLocation,
                    toLocation: widget.toLocation,
                    time: '100',
                    distance: '10');
                print(result);
              },
              child: Text('Send Pick Request'),
            )
          ],
        ),
      ),
    );
  }
}
