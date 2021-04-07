import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rideon/config/constant.dart';
import 'package:rideon/models/googleModel/locationModel.dart';
import 'package:rideon/models/savedAddress/addressType.dart';
import 'package:rideon/screens/home/rideCreateScreen.dart';
import 'package:rideon/screens/localAddress/savedAddressView.dart';
import 'package:rideon/screens/packageDelivery/parcelScreen.dart';
import 'package:rideon/screens/pooling/carPoolingStart.dart';
import 'package:rideon/services/google/geocodingService.dart';
import 'package:rideon/models/googleModel/GeocodingModel.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position currentLocation;
  LocationDetail locationDetail = LocationDetail();
  bool _initialized = false;
  @override
  void initState() {
    super.initState();
    _getLocationDetail();
  }

  _getLocationDetail() async {
    currentLocation = await Geolocator.getCurrentPosition();
    await GeocodingService()
        .getPlaceDetailFromLocation(LocationModel(
            lat: currentLocation.latitude, lng: currentLocation.longitude))
        .then((value) => setState(() {
              locationDetail = value;
            }));
    setState(() {
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 0.6,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CarPoolingFirst()));
                },
                child: Container(
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Carpooling',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        Image.asset('assets/carpooling.png'),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Easy way to share rides'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ParcelScreen()));
                },
                child: Container(
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Package Transfer',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        Image.asset(
                          'assets/gift.png',
                          height: height / 4.5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Real time stuffs delivery'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        DraggableScrollableSheet(
            initialChildSize: 0.318,
            minChildSize: 0.318, //make 0.05 if scrollable
            maxChildSize: 0.318,
            expand: true,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                  controller: scrollController,
                  child: Stack(
                    children: [
                      RoundedBar(),
                      Padding(
                        padding: const EdgeInsets.only(top: 22.0),
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
                            !_initialized
                                ? SavedAddressView(AddressType.Home)
                                : SavedAddressView(AddressType.Home,
                                    source: locationDetail),
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
                            !_initialized
                                ? SavedAddressView(AddressType.Work)
                                : SavedAddressView(AddressType.Work,
                                    source: locationDetail),
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
  Size get preferredSize => const Size.fromHeight(192.0);
}
