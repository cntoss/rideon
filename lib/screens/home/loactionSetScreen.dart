import 'package:flutter/material.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:rideon/config/appConfig.dart';
import 'package:rideon/models/googleModel/GeocodingModel.dart';
import 'package:rideon/screens/maps/routeScreen.dart';
import 'package:rideon/screens/widgets/animatedPin.dart';
import 'package:rideon/services/google/placeService.dart';
import 'package:rideon/models/googleModel/locationModel.dart';
import 'package:rideon/config/constant.dart';

enum CurrentLocation { fromLocation, toLocation }

class LocationSetScreen extends StatefulWidget {
  LocationSetScreen(this.locationDetail);
  final LocationDetail locationDetail;

  @override
  _LocationSetScreenState createState() =>
      _LocationSetScreenState(this.locationDetail);
}

class _LocationSetScreenState extends State<LocationSetScreen> {
  _LocationSetScreenState(this.fromLocationModel);
  TextEditingController _fromController;
  TextEditingController _toController = TextEditingController();
  LocationDetail fromLocationModel = LocationDetail();
  LocationDetail toLocationModel = LocationDetail();
  PlaceApiProvider apiClient;
  String query = '';
  CurrentLocation currentLocation;
  bool _fromCLear = false;
  bool _toClear = false;
  @override
  void initState() {
    super.initState();
    _fromController =
        TextEditingController(text: fromLocationModel.formattedAddress ?? '');
    apiClient = PlaceApiProvider(UniqueKey());
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: 55,
              width: MediaQuery.of(context).size.width,
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () => Navigator.pop(context)),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 55),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(Icons.location_on, color: Colors.grey),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                            color: Constant.cardColor,
                            border: Border.all(color: Constant.cardColor),
                            borderRadius: BorderRadius.circular(10)),
                        child: TextField(
                          controller: _fromController,
                          onChanged: (x) async {
                            if (!_fromCLear && x.trim().length > 1)
                              setState(() {
                                _fromCLear = true;
                                query = x;
                              });
                            else if (_fromCLear && x.trim().length < 1)
                              setState(() {
                                _fromCLear = false;
                                query = '';
                              });
                            currentLocation = CurrentLocation.fromLocation;
                          },
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          decoration: InputDecoration(
                              hintText: "From Address",
                              border: InputBorder.none,
                              suffixIcon: _fromCLear ? Icon(Icons.clear) : Container(),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 8)
                              /*  focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.green)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.green)), */
                              ),
                        ),
                      ),
                    ]),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        height: 30,
                        width: 2,
                        decoration: BoxDecoration(color: Colors.black54),
                        child: SizedBox(width: 2),
                        //child: //your widget code
                      ),
                    ),
                    Row(children: [
                      Icon(Icons.location_on, color: Colors.black38),
                      Container(
                        decoration: BoxDecoration(
                          color: Constant.cardColor,
                          border: Border.all(color: Constant.cardColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: TextField(
                          controller: _toController,
                          onChanged: (x) async {
                           if (!_toClear && x.trim().length > 1)
                              setState(() {
                                _toClear = true;
                                query = x;
                              });
                            else if (_toClear && x.trim().length < 1)
                              setState(() {
                                _toClear = false;
                                query = '';
                              });
                            currentLocation = CurrentLocation.toLocation;
                          },
                          maxLines: 2,
                          decoration: InputDecoration(
                            hintText: "Your destination?",
                            suffixIcon: _toClear ? Icon(Icons.clear) : Container(),
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 8.0),
                          ),
                        ),
                      ),
                    ]),
                    FutureBuilder(
                      future: query == ""
                          ? null
                          : apiClient.fetchSuggestions(query,
                              Localizations.localeOf(context).languageCode),
                      builder: (context, snapshot) => query == ''
                          ? Container()
                          : snapshot.hasData
                              ? ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return Divider();
                                  },
                                  physics: ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) => ListTile(
                                    contentPadding: EdgeInsets.all(0),
                                    leading: MaterialButton(
                                      onPressed: () {},
                                      color: Colors.grey,
                                      textColor: Colors.white,
                                      child: Icon(
                                        Icons.location_on,
                                        size: 20,
                                      ),
                                      padding: EdgeInsets.all(0),
                                      shape: CircleBorder(),
                                    ),
                                    title: Transform.translate(
                                      offset: Offset(-25, 0),
                                      child: Text(
                                          (snapshot.data[index] as Suggestion)
                                              .description),
                                    ),
                                    onTap: () async {
                                      if (snapshot.data[index] != null) {
                                        var result =
                                            snapshot.data[index] as Suggestion;
                                        final placeDetails =
                                            await PlaceApiProvider(UniqueKey())
                                                .getPlaceDetailFromId(
                                                    result.placeId);
                                        if (currentLocation ==
                                            CurrentLocation.toLocation) {
                                          setState(() {
                                            _toController.text =
                                                result.description;
                                            toLocationModel = placeDetails;
                                            query = '';
                                          });
                                        } else {
                                          setState(() {
                                            _fromController.text =
                                                result.description;
                                            fromLocationModel = placeDetails;
                                            query = '';
                                          });
                                        }
                                      }
                                      _navigateToProceed();
                                    },
                                  ),
                                  itemCount: snapshot.data.length,
                                )
                              : Container(child: Text('Loading...')),
                    ),
                    Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      leading: Material(
                        color: Colors.grey,
                        shape:
                            CircleBorder(side: BorderSide(color: Colors.grey)),
                        child: Icon(
                          Icons.push_pin,
                          size: 20,
                        ),
                      ),
                      title: Transform.translate(
                          offset: Offset(-25, 0), child: Text('Set on map')),
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlacePicker(
                                apiKey: googleAPIKey,
                                usePlaceDetailSearch: false,
                                autocompleteTypes: [],
                                // autocompleteRadius: 10,
                                /* onPlacePicked: (result) {
                                  print(result);
                                  print(result.addressComponents);
                                  Navigator.of(context).pop();
                                }, */
                                initialPosition: SOURCE_LOCATION,
                                useCurrentLocation: true,
                                pinBuilder: (context, state) {
                                  if (state == PinState.Idle) {
                                    return Stack(
                                      children: <Widget>[
                                        Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(Icons.push_pin,
                                                  size: 36,
                                                  color: Colors.green),
                                              SizedBox(height: 42),
                                            ],
                                          ),
                                        ),
                                        Center(
                                          child: Container(
                                            width: 5,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Stack(
                                      children: <Widget>[
                                        Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              AnimatedPin(
                                                  child: Icon(Icons.push_pin,
                                                      size: 36,
                                                      color: Colors.green)),
                                              SizedBox(height: 42),
                                            ],
                                          ),
                                        ),
                                        Center(
                                          child: Container(
                                            width: 5,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                },
                                selectedPlaceWidgetBuilder: (_, selectedPlace,
                                    state, isSearchBarFocused) {
                                  return isSearchBarFocused
                                      ? Container()
                                      // Use FloatingCard or just create your own Widget.
                                      : FloatingCard(
                                          bottomPosition:
                                              0.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                                          leftPosition: 0.0,
                                          rightPosition: 0.0,
                                          width: 500,
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          child: state ==
                                                  SearchingState.Searching
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator())
                                              : ElevatedButton(
                                                  child: Text(selectedPlace
                                                      .formattedAddress),
                                                  onPressed: () {
                                                    if (currentLocation ==
                                                                null &&
                                                            fromLocationModel
                                                                    .formattedAddress ==
                                                                null ||
                                                        currentLocation ==
                                                            CurrentLocation
                                                                .fromLocation)
                                                      setState(() {
                                                        _fromController.text =
                                                            selectedPlace
                                                                .formattedAddress;
                                                        fromLocationModel =
                                                            LocationDetail(
                                                                formattedAddress:
                                                                    selectedPlace
                                                                        .formattedAddress,
                                                                placeId:
                                                                    selectedPlace
                                                                        .placeId,
                                                                geometry:
                                                                    Geometry());

                                                        fromLocationModel
                                                                .geometry
                                                                .location =
                                                            LocationModel(
                                                                lat: selectedPlace
                                                                    .geometry
                                                                    .location
                                                                    .lat,
                                                                lng: selectedPlace
                                                                    .geometry
                                                                    .location
                                                                    .lng);

                                                        query = '';
                                                      });
                                                    else
                                                      setState(() {
                                                        _toController.text =
                                                            selectedPlace
                                                                .formattedAddress;
                                                        toLocationModel =
                                                            LocationDetail(
                                                                formattedAddress:
                                                                    selectedPlace
                                                                        .formattedAddress,
                                                                placeId:
                                                                    selectedPlace
                                                                        .placeId,
                                                                geometry:
                                                                    Geometry());

                                                        toLocationModel.geometry
                                                                .location =
                                                            LocationModel(
                                                                lat: selectedPlace
                                                                    .geometry
                                                                    .location
                                                                    .lat,
                                                                lng: selectedPlace
                                                                    .geometry
                                                                    .location
                                                                    .lng);
                                                        query = '';
                                                      });

                                                    Navigator.pop(context);
                                                    _navigateToProceed();
                                                  },
                                                ),
                                        );
                                },
                              ),
                            ));
                      },
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  _navigateToProceed() {
    if (fromLocationModel.geometry != null && toLocationModel.geometry != null)
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => RouteScreen(
                  sourceDetail: fromLocationModel,
                  destinationDetail: toLocationModel)));
  }
}
