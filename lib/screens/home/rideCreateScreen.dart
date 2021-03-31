import 'package:flutter/material.dart';
import 'package:rideon/config/appConfig.dart';
import 'package:rideon/maps/google_maps_place_picker.dart';
import 'package:rideon/maps/web_service/places.dart';
import 'package:rideon/models/googleModel/GeocodingModel.dart';
import 'package:rideon/models/savedAddress/savedAddressModel.dart';
import 'package:rideon/screens/finalMap/routeScreen.dart';
import 'package:rideon/screens/widgets/circleIcon.dart';
import 'package:rideon/services/google/placeService.dart';
import 'package:rideon/config/constant.dart';
import 'package:rideon/services/helper/savedAddressService.dart';

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
  bool _fromCLear;
  bool _toClear = false;
  List<SavedAddressModel> _saveAddress =
      SavedAddressService().getOtherAddress();
  @override
  void initState() {
    super.initState();
    _fromController =
        TextEditingController(text: fromLocationModel.formattedAddress ?? '');
    apiClient = PlaceApiProvider(UniqueKey());
    _fromCLear = _fromController.text == '' ? false : true;
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
                          autofocus: fromLocationModel.formattedAddress == null
                              ? true
                              : false,
                          onChanged: (x) async {
                            setState(() {
                              query = x;
                            });
                            if (!_fromCLear &&
                                _fromController.text.trim().length > 1)
                              setState(() {
                                _fromCLear = true;
                              });
                            currentLocation = CurrentLocation.fromLocation;
                          },
                          textAlign: TextAlign.start,
                          maxLines: 3,
                          minLines: 1,
                          decoration: InputDecoration(
                              hintText: "From Address",
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: _fromCLear
                                    ? Icon(Icons.clear, color: Colors.black54)
                                    : Icon(Icons.search, color: Colors.black12),
                                onPressed: () => setState(() {
                                  query = '';
                                  _fromController.clear();
                                  _fromCLear = false;
                                  fromLocationModel = LocationDetail();
                                }),
                              ),
                              contentPadding: EdgeInsets.all(8)),
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
                          autofocus: fromLocationModel.formattedAddress == null
                              ? false
                              : true,
                          onChanged: (x) {
                            setState(() {
                              query = x;
                            });
                            if (!_toClear && x.trim().length > 0)
                              setState(() {
                                _toClear = true;
                              });
                            currentLocation = CurrentLocation.toLocation;
                          },
                          maxLines: 3,
                          minLines: 1,
                          decoration: InputDecoration(
                            hintText: "Your destination?",
                            suffixIcon: IconButton(
                              icon: _toClear
                                  ? Icon(Icons.clear, color: Colors.black54)
                                  : Icon(Icons.search, color: Colors.black12),
                              onPressed: () => setState(() {
                                query = '';
                                _toController.clear();
                                _toClear = false;
                                toLocationModel = LocationDetail();
                              }),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(8.0),
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
                            ? ListView.separated(
                                itemCount: _saveAddress.length,
                                physics: ClampingScrollPhysics(),
                                shrinkWrap: true,
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        Divider(height: 1),
                                itemBuilder: (BuildContext context, int x) {
                                  return ListTile(
                                    leading:
                                        CircularIcon(icon: Icon(Icons.star)),
                                    title: Text(
                                      _saveAddress[x].detail ?? '',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    subtitle: Text(
                                      _saveAddress[x].locationName ?? '',
                                    ),
                                    onTap: () async {
                                      final placeDetails =
                                          await PlaceApiProvider(UniqueKey())
                                              .getPlaceDetailFromId(
                                                  _saveAddress[x].placeId);
                                      if (currentLocation ==
                                              CurrentLocation.toLocation ||
                                          fromLocationModel.formattedAddress !=
                                              null) {
                                        setState(() {
                                          _toController.text =
                                              _saveAddress[x].locationName;
                                          toLocationModel = placeDetails;
                                          query = '';
                                        });
                                      } else {
                                        setState(() {
                                          _fromController.text =
                                              _saveAddress[x].locationName;
                                          fromLocationModel = placeDetails;
                                          query = '';
                                        });
                                      }

                                      _navigateToProceed();
                                    },
                                  );
                                },
                              )
                            : snapshot.hasData
                                ? ListView.separated(
                                    separatorBuilder: (context, index) {
                                      return Divider();
                                    },
                                    physics: ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) => ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      leading: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: CircularIcon(
                                          icon: Icon(
                                            Icons.location_on,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      title: Transform.translate(
                                        offset: Offset(-10, 0),
                                        child: Text(
                                            (snapshot.data[index] as Suggestion)
                                                .description),
                                      ),
                                      onTap: () async {
                                        if (snapshot.data[index] != null) {
                                          var result = snapshot.data[index]
                                              as Suggestion;
                                          final placeDetails =
                                              await PlaceApiProvider(
                                                      UniqueKey())
                                                  .getPlaceDetailFromId(
                                                      result.placeId);
                                          if (currentLocation ==
                                              CurrentLocation.fromLocation) {
                                            setState(() {
                                              _fromController.text =
                                                  result.description;
                                              fromLocationModel = placeDetails;
                                              query = '';
                                            });
                                          } else {
                                            setState(() {
                                              _toController.text =
                                                  result.description;
                                              toLocationModel = placeDetails;
                                              query = '';
                                            });
                                          }
                                        }
                                        _navigateToProceed();
                                      },
                                    ),
                                    itemCount: snapshot.data.length,
                                  )
                                : Text('Loading')),
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
                                //autocompleteComponents: [Component('country', 'np')],
                                usePlaceDetailSearch: true,
                                initialPosition: SOURCE_LOCATION,
                                useCurrentLocation:
                                    false, //todo:make it true white real test
                                onPlacePicked: (PickResult selectedPlace) {
                                  if (currentLocation == null &&
                                          fromLocationModel.formattedAddress ==
                                              null ||
                                      currentLocation ==
                                          CurrentLocation.fromLocation)
                                    setState(() {
                                      _fromController.text =
                                          selectedPlace.formattedAddress;
                                      fromLocationModel =
                                          LocationDetail.fromPickResult(
                                              selectedPlace);

                                      query = '';
                                    });
                                  else
                                    setState(() {
                                      _toController.text = selectedPlace.name;
                                      toLocationModel =
                                          LocationDetail.fromPickResult(
                                              selectedPlace);
                                      var xyz =
                                          GoogleMapsPlaces(apiKey: googleAPIKey)
                                              .getDetailsByPlaceId(
                                                  selectedPlace.placeId);
                                      print(xyz);
                                      query = '';
                                    });

                                  Navigator.pop(context);
                                  _navigateToProceed();
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
