import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rideon/config/appConfig.dart';
import 'package:rideon/config/constant.dart';
import 'package:rideon/models/googleModel/locationModel.dart';
import 'package:rideon/models/savedAddress/addressType.dart';
import 'package:rideon/models/savedAddress/savedAddressModel.dart';
import 'package:rideon/route/navigateToRoute.dart';
import 'package:rideon/screens/home/loactionSetScreen.dart';
import 'package:rideon/screens/widgets/circleIcon.dart';
import 'package:rideon/services/google/geocodingService.dart';
import 'package:rideon/services/helper/savedAddressService.dart';
import '../pooling/carPoolingStart.dart';
import 'package:rideon/models/googleModel/GeocodingModel.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  Position currentLocation;
  LocationDetail locationDetail = LocationDetail();
  SavedAddressModel _homeAddress =
      SavedAddressService().getSingleAddress(AddressType.Home);
  SavedAddressModel _workAddress =
      SavedAddressService().getSingleAddress(AddressType.Work);

  @override
  void initState() {
    super.initState();
    setInitialLocation();
    getLocationUpdates();
  }

  void setInitialLocation() async {
    currentLocation = await Geolocator.getCurrentPosition();
    locationDetail = await GeocodingService().getPlaceDetailFromLocation(
        LocationModel(
            lat: currentLocation.latitude, lng: currentLocation.longitude));
    print(locationDetail.toJson());
  }

/* StreamSubscription<Position> positionStream = Geolocator
                                .getPositionStream(desiredAccuracy: LocationAccuracy.high, 
                      distanceFilter: 10)
                                .listen((Position position) {
    print(position == null ? 'Unknown' : position.latitude.toString() + ', ' + 
       position.longitude.toString());
       
}) */

  void getLocationUpdates() {
    Geolocator.getPositionStream(
            desiredAccuracy: LocationAccuracy.high, distanceFilter: 10)
        .listen((Position position) {
      setState(() {
        currentLocation = position;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    CameraPosition _initialCameraPosition = CameraPosition(
        target: currentLocation == null ?SOURCE_LOCATION: LatLng(currentLocation.latitude ?? SOURCE_LOCATION.latitude,
            currentLocation.longitude ?? SOURCE_LOCATION.longitude),
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING);

    super.build(context);
    return Stack(
      children: <Widget>[
        /* StreamBuilder(
           stream: positionStream,
          builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (!snapshot.hasData) {
                    return Loader();
                  }

                  if (snapshot.connectionState == ConnectionState.done) {}

                  return */
        GoogleMap(
          mapType: MapType.normal,
          myLocationEnabled: true,
          compassEnabled: true,
          tiltGesturesEnabled: false,
          initialCameraPosition: _initialCameraPosition,
          gestureRecognizers: Set()
            ..add(Factory<EagerGestureRecognizer>(
                () => EagerGestureRecognizer())),
        ),
        //StaticMap(),
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
            maxChildSize: 0.24,
            expand: true,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                  controller: scrollController,
                  child: Stack(
                    children: [
                      RoundedBar(),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        LocationSetScreen(locationDetail),
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
                            TextButton.icon(
                                icon: CircularIcon(icon: Icon(Icons.home)),
                                onPressed: () => NavigateToRoute()
                                    .navigateFromHome(
                                        source: locationDetail,
                                        type: AddressType.Home,
                                        address: _homeAddress),
                                style: Constant.buttonStyle,
                                label: _homeAddress != null
                                    ? Flexible(
                                        child: Text(
                                          _homeAddress.locationName ??
                                              'Set Home',
                                        ),
                                      )
                                    : Text('Set Home')),
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
                            TextButton.icon(
                                icon: CircularIcon(
                                  icon: Icon(Icons.work_outline_sharp),
                                ),
                                onPressed: () => NavigateToRoute()
                                    .navigateFromHome(
                                        source: locationDetail,
                                        type: AddressType.Work,
                                        address: _workAddress)
                                    .then((value) => setState(() {})),
                                style: Constant.buttonStyle,
                                label: _workAddress != null
                                    ? Flexible(
                                        child: Text(
                                          _workAddress.locationName ??
                                              'Set Office',
                                        ),
                                      )
                                    : Text('Set Office')),
                            /*   Row(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Home'),
                                    Text('Pulchowk Lalitpur')
                                  ],
                                )
                              ],
                            ), */
                          ],
                        ),
                      ),
                    ],
                  ));
            })
      ],
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
