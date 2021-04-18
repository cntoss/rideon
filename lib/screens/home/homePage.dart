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

    return Stack(
      children: <Widget>[
        Positioned(
          top: 170,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  //todo: bike select
                },
                child: VehichleOption(
                  width: width,
                  image: 'assets/bike.png',
                  title: 'Bike',
                ),
              ),
              InkWell(
                onTap: () {
                  //todo: car select
                },
                child: VehichleOption(
                  width: width,
                  image: 'assets/car.png',
                  title: 'Car',
                ),
              ),
              InkWell(
                onTap: () {
                  //todo: car select
                },
                child: VehichleOption(
                  width: width,
                  image: 'assets/plane.png',
                  title: 'Plane',
                ),
              )
            ],
          ),
        ),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio:
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? 1.2
                  : 2.5,
          children: [
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CarPoolingFirst()));
                },
                child: _homeCard(
                    title: 'Carpooling',
                    subtitle: 'Easy way to share rides',
                    image: 'assets/carpooling.png')),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ParcelScreen()));
              },
              child: _homeCard(
                  title: 'Package Transfer',
                  subtitle: 'Real time stuffs delivery',
                  image: 'assets/gift.png'),
            ),
          ],
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

  Widget _homeCard({@required title, @required subtitle, @required image}) {
    return Card(
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
              title,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Image.asset(
            image,
            height: MediaQuery.of(context).size.height / 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(subtitle),
          )
        ],
      ),
    );
  }
}

class VehichleOption extends StatelessWidget {
  const VehichleOption({
    Key key,
    @required this.width,
    @required this.image,
    @required this.title,
  }) : super(key: key);

  final double width;
  final String image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).scaffoldBackgroundColor,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Image.asset(
              image,
              height: 70,
              width: width / 4,
            ),
            Text(title),
          ],
        ),
      ),
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
