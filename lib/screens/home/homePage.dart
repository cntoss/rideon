import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rideon/config/constant.dart';
import 'package:rideon/models/googleModel/locationModel.dart';
import 'package:rideon/models/savedAddress/addressType.dart';
import 'package:rideon/models/savedAddress/savedAddressModel.dart';
import 'package:rideon/route/navigateToRoute.dart';
import 'package:rideon/screens/home/loactionSetScreen.dart';
import 'package:rideon/screens/home/static_map.dart';
import 'package:rideon/screens/widgets/circleIcon.dart';
import 'package:rideon/services/google/geocodingService.dart';
import 'package:rideon/services/helper/savedAddressService.dart';
import 'package:rideon/models/googleModel/GeocodingModel.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
   {
  Position currentLocation ;
   LocationDetail locationDetail = LocationDetail();
  SavedAddressModel _homeAddress ;
    
  SavedAddressModel _workAddress ;
     
  
  /* void getLocationUpdates() {
    Geolocator.getPositionStream(
            desiredAccuracy: LocationAccuracy.high, distanceFilter: 10)
        .listen((Position position) {
      setState(() {
        currentLocation = position;
      });
    });
  } */

@override
  void initState() {
    super.initState();
    _homeAddress =
      SavedAddressService().getSingleAddress(AddressType.Home);
   _workAddress =
      SavedAddressService().getSingleAddress(AddressType.Work);
    _getLocationDetail();
  }

  _getLocationDetail() async {
     currentLocation = await Geolocator.getCurrentPosition(); 
    locationDetail = await GeocodingService().getPlaceDetailFromLocation(
        LocationModel(
            lat: currentLocation.latitude, lng: currentLocation.longitude));
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[       
        StaticMap(),       
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
                            
                          ],
                        ),
                      ),
                    ],
                  ));
            })
      ],
    );
  }
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
