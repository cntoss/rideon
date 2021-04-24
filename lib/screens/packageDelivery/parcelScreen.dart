import 'package:flutter/material.dart';
import 'package:rideon/config/appConfig.dart';
import 'package:rideon/config/constant.dart';
import 'package:rideon/maps/google_maps_place_picker.dart';
import 'package:rideon/maps/web_service/distance.dart';
import 'package:rideon/models/driver/driverModel.dart';
import 'package:rideon/models/enum_mode/transport_type.dart';
import 'package:rideon/models/googleModel/GeocodingModel.dart';
import 'package:rideon/screens/finalMap/packageDeliveryRouteScreen.dart';
import 'package:rideon/widgets/loader.dart';

class ParcelScreen extends StatefulWidget {
  @override
  _ParcelScreenState createState() => _ParcelScreenState();
}

class _ParcelScreenState extends State<ParcelScreen> {
  var _formKey = GlobalKey<FormState>();
  //cosysapps@cosys.com.np
  LocationDetail _toAddress = LocationDetail();
  LocationDetail _fromAddress = LocationDetail();

  TextEditingController _toController;
  TextEditingController _fromController;

  TextEditingController _note = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _phone = TextEditingController();

  TextStyle textTitle = TextStyle();
  bool _isLoading = false;

  bool _showConfirmation = false;
  DistanceResponse distanceResponse;
  @override
  void initState() {
    super.initState();
    _toController =
        TextEditingController(text: _toAddress.formattedAddress ?? '');
    _fromController =
        TextEditingController(text: _fromAddress.formattedAddress ?? '');
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = EdgeInsets.symmetric(vertical: 8);
    TextStyle _textStyle = TextStyle(fontSize: 16);
    return Scaffold(
      appBar: AppBar(title: Text('Request Delivery')),
      resizeToAvoidBottomPadding: true,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Card(
                elevation: 0,
                color: cardColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: !_showConfirmation
                        ? Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Pickup Location"),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PlacePicker(
                                                        usePlaceDetailSearch:
                                                            true,
                                                        initialPosition:
                                                            SOURCE_LOCATION,
                                                        useCurrentLocation:
                                                            true,
                                                        onPlacePicked: (r) {
                                                          Navigator.pop(
                                                              context);
                                                          setState(() {
                                                            _fromController
                                                                    .text =
                                                                r.formattedAddress;
                                                          });
                                                          _fromAddress =
                                                              LocationDetail
                                                                  .fromPickResult(
                                                                      r);
                                                        })));
                                      },
                                      child: TextFormField(
                                        enabled: false,
                                        maxLines: 3,
                                        minLines: 1,
                                        controller: _fromController,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Pick loction must not be empty';
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration(
                                          hintText: "Pickup Location",
                                          errorStyle: TextStyle(
                                            color: Theme.of(context)
                                                .errorColor, // or any other color
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Text("Drop Location"),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PlacePicker(
                                                        usePlaceDetailSearch:
                                                            true,
                                                        initialPosition:
                                                            SOURCE_LOCATION,
                                                        useCurrentLocation:
                                                            true,
                                                        onPlacePicked: (r) {
                                                          Navigator.pop(
                                                              context);
                                                          setState(() {
                                                            _toController.text =
                                                                r.formattedAddress;
                                                          });
                                                          _toAddress =
                                                              LocationDetail
                                                                  .fromPickResult(
                                                                      r);
                                                        })));
                                      },
                                      child: TextFormField(
                                        enabled: false,
                                        maxLines: 3,
                                        minLines: 1,
                                        keyboardType:
                                            TextInputType.streetAddress,
                                        controller: _toController,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Drop location must not be empty';
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration(
                                          hintText: "Dropof Location",
                                          errorStyle: TextStyle(
                                            color: Theme.of(context)
                                                .errorColor, // or any other color
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Text("Receiver Name"),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TextFormField(
                                    controller: _name,
                                    onFieldSubmitted: (v) {
                                      // _noteFocus.requestFocus();
                                    },
                                    style: TextStyle(fontSize: 15),
                                    decoration: InputDecoration(
                                      hintText: 'Name',
                                      //focusedBorder: Constant.inputBorder,
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Name must not be empty';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                                Text("Receiver Contact No", style: textTitle),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TextFormField(
                                    controller: _phone,
                                    keyboardType: TextInputType.phone,
                                    maxLength: 10,
                                    onFieldSubmitted: (v) {
                                      //  _noteFocus.requestFocus();
                                    },
                                    style: TextStyle(fontSize: 15),
                                    decoration: InputDecoration(
                                        hintText: 'Contact No.',
                                        counterText: ''
                                       ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Contact no must not be empty';
                                      } else if (value.length < 7) {
                                        return 'Enter valid contact no.';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                                Text('Notes', style: textTitle),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TextFormField(
                                    maxLines: null,
                                    minLines: 3,
                                    // focusNode: _noteFocus,
                                    keyboardType: TextInputType.multiline,
                                    controller: _note,
                                    style: TextStyle(fontSize: 15),
                                    decoration: InputDecoration(
                                      counterText: "",
                                      labelText: 'Delivery details',
                                      // focusedBorder: Constant.inputBorder,
                                      //errorStyle: TextStyle(fontSize: 15),
                                    ),
                                    /* validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Note must not be empty';
                                      } else {
                                        return null;
                                      }
                                    }, */
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton(
                                      child: Padding(
                                        padding: bottonPadding,
                                        child: Text('Continue',
                                            style: bottonStyle),
                                      ),
                                      onPressed: _continueToDelivery),
                                )
                              ],
                            ))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                                Text("Delivery Information", style: _textStyle),
                                Row(
                                  children: [
                                    Padding(
                                      padding: padding,
                                      child: Text("Package fit inside showcase",
                                          style: _textStyle),
                                    ),
                                    Checkbox(value: true, onChanged: null),
                                  ],
                                ),

                                //Text('Block'),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                          text: 'Estimated Price!   ',
                                          style: _textStyle),
                                      TextSpan(
                                        text: 'Rs ##.##',
                                        style: _textStyle.copyWith(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: padding,
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                            text: 'Estimated Distance   ',
                                            style: _textStyle),
                                        TextSpan(
                                          text:
                                              '${distanceResponse.results.first.elements.first.distance.text}',
                                          style: _textStyle.copyWith(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                /*  Text(
                                    "Estimated Distance ${distanceResponse.results.first.elements.first.distance.text}"),
                               */

                                Center(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: ElevatedButton(
                                        child: Padding(
                                          padding: bottonPadding,
                                          child: Text(
                                            'Request a driver',
                                            style: bottonStyle,
                                          ),
                                        ),
                                        onPressed: _confirmToDelivery),
                                  ),
                                )
                              ])),
              ),
            ),
          ),
          if (_isLoading) Loader()
        ],
      ),
    );
  }

  _continueToDelivery() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      distanceResponse = await GoogleDistanceMatrix(apiKey: googleAPIKey)
          .distanceWithLocation(
              [_fromAddress.geometry.location], [_toAddress.geometry.location]);
      if (distanceResponse != null) {
        setState(() {
          _showConfirmation = true;
        });
      }
    }
  }

  //
  _confirmToDelivery() async {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = true;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PackageDeliveryRouteScreen(
                  sourceDetail: _fromAddress,
                  destinationDetail: _toAddress,
                  driverDetail: DriverModel(
                      displayName: "Baby Driver",
                      rating: 3.5,
                      vehicle: Vehicle(
                          name: "White BMW",
                          vehicleid: 'Bagmati B AA 7706',
                          type: TranportType.Car)))));
    });
  }
}
