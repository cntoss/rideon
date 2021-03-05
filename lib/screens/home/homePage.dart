import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:rideon/config/appConfig.dart';
import 'package:rideon/config/constant.dart';
import 'package:rideon/models/googleModel/locationModel.dart';
import 'package:rideon/screens/home/loactionSetScreen.dart';
import 'package:rideon/services/google/geocodingService.dart';
import '../pooling/carPoolingStart.dart';
import 'package:rideon/models/googleModel/GeocodingModel.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  Completer<GoogleMapController> _controller = Completer();
  LocationData currentLocation;
  Location location;
//current location all info
  LocationDetail locationDetail = LocationDetail();
  @override
  void initState() {
    super.initState();
    location = new Location();
    setInitialLocation();
  }

  void setInitialLocation() async {
    currentLocation = await location.getLocation(); 
    locationDetail = await GeocodingService().getPlaceDetailFromLocation(
        LocationModel(
            lat: currentLocation.latitude, lng: currentLocation.longitude));
    /*  final coordinates = new Coordinates(currentLocation.latitude, currentLocation.longitude);
   var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
   var first = addresses.first;
  print("${first.featureName} : ${first.addressLine}"); */
    print(locationDetail.toJson());
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    CameraPosition _initialCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
        target: SOURCE_LOCATION);
    if (currentLocation != null) {
      _initialCameraPosition = CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: CAMERA_ZOOM,
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING);
    }

    super.build(context);
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            compassEnabled: true,
            tiltGesturesEnabled: false,
            initialCameraPosition: _initialCameraPosition,
            gestureRecognizers: Set()
        ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
        ..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
        ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
        ..add(Factory<HorizontalDragGestureRecognizer>(
            () => HorizontalDragGestureRecognizer()))
        ..add(Factory<VerticalDragGestureRecognizer>(
            () => VerticalDragGestureRecognizer())),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Positioned(
            top: 33,
            right: 8,
            child: TextButton.icon(
              icon: Icon(Icons.car_rental, color: Colors.blue),
              label: Text(
                "Carpooling",
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CarPoolingFirst()));
              },
            ),
          ),
          DraggableScrollableSheet(
              initialChildSize: 0.1,
              minChildSize: 0.05,
              maxChildSize: 0.32,
              expand: true,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                    controller: scrollController,
                    child: Stack(
                      children: [
                        RoundedBar(),
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                     Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LocationSetScreen(locationDetail),
                                    ),
                                  );
                                },
                                child: Card(
                                  color: Color(0xfff0e1ee),
                                  child: Container(
                                    width: width,
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Where to go? ',
                                      style: Constant.title,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  MaterialButton(
                                    onPressed: () {},
                                    color: Colors.grey,
                                    textColor: Colors.white,
                                    child: Icon(
                                      Icons.home,
                                      size: 20,
                                    ),
                                    padding: EdgeInsets.all(0),
                                    shape: CircleBorder(),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Home'),
                                      Text('Pulchowk Lalitpur')
                                    ],
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 50.0),
                                child: SizedBox(
                                  height: 1,
                                  width: width,
                                  child: Container(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  MaterialButton(
                                    onPressed: () {},
                                    color: Colors.grey,
                                    textColor: Colors.white,
                                    child: Icon(
                                      Icons.star,
                                      size: 20,
                                    ),
                                    padding: EdgeInsets.all(0),
                                    shape: CircleBorder(),
                                  ),
                                  Column(
                                    children: [
                                      Text('Choose a saved place'),
                                      //Text('Pulchowk Lalitpur')
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ));
              })
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class RoundedBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return new SizedBox.fromSize(
      size: preferredSize,
      child: new LayoutBuilder(builder: (context, constraint) {
        final width = constraint.maxWidth * 8;
        return new ClipRect(
          child: new OverflowBox(
            maxHeight: double.infinity,
            maxWidth: double.infinity,
            child: new SizedBox(
              width: width,
              height: width,
              child: new Padding(
                padding: new EdgeInsets.only(
                    top: width / 2 - preferredSize.height / 2),
                child: new Container(
                  decoration: new BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(180.0);
}
